#!/usr/bin/env python3
"""Select and preserve exact prefab dependency closures from a verified APK graph.

The catalog is a read-only inspection snapshot. A closure is NOT gameplay parity:
string-loaded assets, code, original shaders and engine behaviors need separate work.
Original object bytes are retained, but font payloads and whole mixed bundles are
never delivered. Paths are metadata; SHA identities alone form output filenames.
"""
from __future__ import annotations
import argparse
from collections import Counter, deque
import hashlib
import io
import json
from pathlib import Path
import re
import sqlite3
import tempfile
import os
import zipfile

from recovery_core import RecoveryError, digest, file_digest, identity, json_bytes, lossless_tree
from recovery_graph import pointers, pointer_values

HEX = re.compile(r'[0-9a-f]{64}')


def require(value, message):
    if not value:
        raise RecoveryError(message)


def read_db(path):
    path = Path(path)
    require(path.is_file() and not path.is_symlink(), 'catalog absent or symlinked')
    db = sqlite3.connect(path.resolve().as_uri() + '?mode=ro', uri=True)
    db.row_factory = sqlite3.Row
    db.execute('PRAGMA query_only=ON')
    db.execute('BEGIN')
    return db


def meta(db, key):
    row = db.execute('SELECT value FROM meta WHERE key=?', (key,)).fetchone()
    return json.loads(row[0]) if row else None


def plan(db, profile, *, max_objects=50000):
    require(type(max_objects) is int and 0 < max_objects <= 200000, 'invalid object budget')
    require(profile.get('schema') == 1 and isinstance(profile.get('roots'), list)
            and 0 < len(profile['roots']) <= 64, 'invalid scope profile')
    require(profile.get('input_sha256') == meta(db, 'input_sha256'), 'wrong APK catalog')
    require(meta(db, 'state') == 'captured' and meta(db, 'graph_state') in ('complete', 'incomplete'),
            'raw capture and graph traversal must have finished')
    require(not db.execute("SELECT 1 FROM graph_objects WHERE status='not_decoded' LIMIT 1").fetchone(),
            'pending graph objects remain')
    require(db.execute('SELECT COUNT(*) FROM graph_objects').fetchone()[0] ==
            db.execute('SELECT COUNT(*) FROM objects').fetchone()[0], 'graph coverage differs from capture')
    roots = []
    for selection in profile['roots']:
        require(set(selection) == {'path', 'type', 'object_id', 'sha256'}, 'unexpected root fields')
        require(all(isinstance(selection[k], str) for k in selection), 'root fields must be strings')
        require(HEX.fullmatch(selection['object_id']) and HEX.fullmatch(selection['sha256']), 'invalid root identity')
        rows = db.execute('''SELECT DISTINCT o.* FROM container_paths p JOIN object_refs r ON r.id=p.ref_id
            JOIN objects o ON o.id=r.target_id WHERE p.original_path=? AND o.type=? AND r.status='resolved' ''',
            (selection['path'], selection['type'])).fetchall()
        matches = [r for r in rows if r['id'] == selection['object_id'] and r['sha'] == selection['sha256']]
        require(len(matches) == 1 and len(rows) == 1, 'root path/type missing, changed or ambiguous: ' + selection['path'])
        require(selection['object_id'] not in [r['object_id'] for r in roots], 'duplicate selected root')
        roots.append(dict(selection))
    pending = deque(r['object_id'] for r in roots)
    seen = set(pending)
    objects, edges, blockers = [], [], []
    while pending:
        oid = pending.popleft()
        row = db.execute('''SELECT o.*,g.status graph_status,g.detail graph_detail FROM objects o
            JOIN graph_objects g ON g.object_id=o.id WHERE o.id=?''', (oid,)).fetchone()
        require(row is not None and row['id'] == identity(row['member_id'], row['path_id']), 'invalid captured object identity')
        obj = dict(row); objects.append(obj)
        require(HEX.fullmatch(obj['sha']), 'invalid original object hash')
        if obj['graph_status'] != 'decoded':
            blockers.append({'object_id':oid,'kind':'decode_failure','detail':obj['graph_detail']})
        if obj['type'] == 'Font':
            blockers.append({'object_id':oid,'kind':'font_payload_not_delivered'})
        refs = db.execute('SELECT * FROM object_refs WHERE source_id=? ORDER BY pointer_path', (oid,)).fetchall()
        for ref in refs:
            ref = dict(ref)
            require(ref['id'] == identity(oid, ref['pointer_path']), 'invalid reference identity')
            edges.append(ref)
            if ref['status'] == 'resolved':
                target = db.execute('SELECT member_id,path_id FROM objects WHERE id=?', (ref['target_id'],)).fetchone()
                require(target is not None and target['path_id'] == ref['path_id'], 'resolved reference has wrong target')
                require(ref['file_id'] != 0 or target['member_id'] == obj['member_id'], 'local pointer escaped source member')
                if ref['target_id'] not in seen:
                    require(len(seen) < max_objects, 'dependency closure exceeds object budget')
                    seen.add(ref['target_id']); pending.append(ref['target_id'])
            elif ref['status'] == 'null':
                require(ref['path_id'] == 0 and ref['target_id'] is None, 'invalid null pointer')
            else:
                blockers.append({'object_id':oid,'kind':'unresolved_reference','reference':ref})
    # Streams are not PPtrs. Include them independently, including failure states.
    dependencies = []
    member_ids = {o['member_id'] for o in objects}
    stream_index = {}
    for d in db.execute("SELECT * FROM dependencies WHERE kind='stream' ORDER BY id"):
        stream_index.setdefault(d['object_id'], []).append(d)
    for obj in objects:
        for row in stream_index.get(obj['id'], []):
            dep = dict(row); dependencies.append(dep)
            if dep['target_id']:
                member_ids.add(dep['target_id'])
            if dep['status'] != 'resolved':
                blockers.append({'object_id':obj['id'],'kind':'unresolved_stream','dependency':dep})
    members = [dict(db.execute('SELECT * FROM members WHERE id=?', (mid,)).fetchone()) for mid in sorted(member_ids)]
    units = [dict(db.execute('''SELECT u.*,e.name entry_name,e.ordinal entry_ordinal,e.size entry_size,e.sha entry_sha256
                             FROM units u JOIN entries e ON e.id=u.entry_id WHERE u.id=?''', (uid,)).fetchone())
             for uid in sorted({m['unit_id'] for m in members})]
    slots = [dict(r) for mid in sorted(member_ids) for r in db.execute('SELECT * FROM external_slots WHERE member_id=? ORDER BY file_id', (mid,))]
    result = {'schema':1,'scope':profile.get('name','selected-prefabs'), 'input_sha256':profile['input_sha256'],
              'profile_sha256':digest(json_bytes(profile)), 'roots':roots,
              'objects':sorted(objects,key=lambda r:r['id']), 'references':sorted(edges,key=lambda r:r['id']),
              'streams':sorted(dependencies,key=lambda r:r['id']), 'members':members,'units':units,'external_slots':slots,
              'blockers':blockers, 'summary':{'objects':len(objects),'references':len(edges),'streams':len(dependencies),
              'units':len(units),'types':dict(sorted(Counter(o['type'] for o in objects).items())),
              'serialized_closure_complete':not blockers,'dynamic_dependencies_audited':False,
              'source_behavior_verified':False,'godot_stage_complete':False}}
    validate_plan(result)
    return result


def validate_plan(s):
    """Recompute closure membership and completeness; do not trust summary booleans."""
    require(s.get('schema') == 1 and HEX.fullmatch(s['input_sha256']), 'invalid scope schema/input')
    indexed = {}
    for key, field in [('objects','id'),('references','id'),('members','id'),('units','id'),('streams','id')]:
        rows = s[key]
        indexed[key] = {r[field]:r for r in rows}
        require(len(indexed[key]) == len(rows), 'duplicate scope '+key)
    objects = indexed['objects']; refs = indexed['references']; members=indexed['members']; units=indexed['units']
    require(objects and s['roots'], 'empty scope')
    outgoing = {oid:[] for oid in objects}
    bad = any(o['graph_status'] != 'decoded' or o['type'] == 'Font' for o in objects.values())
    for oid,o in objects.items():
        require(oid==identity(o['member_id'],o['path_id']) and o['member_id'] in members and HEX.fullmatch(o['sha']), 'invalid selected object')
    for rid,r in refs.items():
        require(r['source_id'] in objects and rid==identity(r['source_id'],r['pointer_path']), 'invalid selected reference')
        if r['status']=='resolved':
            target=objects.get(r['target_id'])
            require(target is not None and target['path_id']==r['path_id'], 'closure missing/wrong resolved target')
            require(r['file_id']!=0 or target['member_id']==objects[r['source_id']]['member_id'], 'local reference escaped member')
            outgoing[r['source_id']].append(r['target_id'])
        elif r['status']=='null':require(r['path_id']==0 and r['target_id'] is None, 'invalid null reference')
        else:bad=True
    roots=[r['object_id'] for r in s['roots']]
    require(len(roots)==len(set(roots)), 'duplicate scope root')
    for root in s['roots']:
        require(root['object_id'] in objects and root['sha256']==objects[root['object_id']]['sha']
                and root['type']==objects[root['object_id']]['type'], 'root differs from captured object')
    reached=set(roots);pending=list(roots)
    while pending:
        for target in outgoing[pending.pop()]:
            if target not in reached:reached.add(target);pending.append(target)
    require(reached==set(objects), 'scope contains unreachable or omitted objects')
    for m in members.values():require(m['unit_id'] in units, 'member source unit missing')
    for u in units.values():
        require(u['entry_id']==identity(s['input_sha256'],u['entry_ordinal'])
                and u['id']==identity(u['entry_id'],u['name'],u['offset']), 'source unit identity differs')
    for d in indexed['streams'].values():
        require(d['object_id'] in objects and d['member_id']==objects[d['object_id']]['member_id'], 'stream source differs')
        if d['status']=='resolved':
            require(d['target_id'] in members and type(d['offset']) is int and type(d['size']) is int
                    and 0<=d['offset'] and 0<d['size'] and d['offset']+d['size']<=members[d['target_id']]['size'], 'invalid stream target/range')
        else:bad=True
    require(s['summary']['objects']==len(objects) and s['summary']['references']==len(refs)
            and s['summary']['streams']==len(s['streams']) and s['summary']['units']==len(units), 'scope summary counts differ')
    require(s['summary']['serialized_closure_complete'] == (not bad) and bool(s['blockers'])==bad, 'false scope completeness')
    return not bad


class Store:
    def __init__(self, root):
        self.root = root; self.bytes = 0
    def blob(self, data):
        sha = digest(data); path = self.root/'blobs'/sha
        if not path.exists():
            require(self.bytes + len(data) <= 512*1024**2, 'scope output exceeds 512 MiB budget')
            path.parent.mkdir(exist_ok=True); path.write_bytes(data); self.bytes += len(data)
        else:
            require(file_digest(path) == sha, 'scope blob corrupted')
        return sha,len(data)


def extract(apk, selection, out):
    """Reparse selected source units and verify every exported object's original hash."""
    import recover
    validate_plan(selection)
    out = Path(out); apk = Path(apk)
    require(apk.is_file() and not apk.is_symlink(), 'APK missing or symlinked')
    require(file_digest(apk) == selection['input_sha256'], 'APK hash differs from scope')
    require(not out.exists() and not out.is_symlink(), 'output already exists')
    require(not any(o['type']=='Font' for o in selection['objects']), 'scope includes font payload; select a different root')
    out.parent.mkdir(parents=True,exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.scope-',dir=out.parent) as temporary:
        work=Path(temporary); sink=Store(work)
        objects={o['id']:o for o in selection['objects']}
        members={m['id']:m for m in selection['members']}
        by_unit={u['id']:[m for m in members.values() if m['unit_id']==u['id']] for u in selection['units']}
        records=[];streams=[]
        refs_by_object={}
        for r in selection['references']:refs_by_object.setdefault(r['source_id'],[]).append(r)
        cached_entry=None; entry_data=None
        with zipfile.ZipFile(apk) as z:
            entries=z.infolist()
            for unit in sorted(selection['units'], key=lambda u:(u['entry_ordinal'],u['offset'])):
                info=entries[unit['entry_ordinal']]
                require(info.filename==unit['entry_name'] and info.file_size==unit['entry_size'], 'APK entry identity changed')
                require(0 <= unit['offset'] and 0 < unit['size'] <= 256*1024**2
                        and unit['offset']+unit['size']<=info.file_size, 'source unit range invalid/unsupported split unit')
                if cached_entry!=unit['entry_ordinal']:
                    require(info.file_size<=1024**3, 'source entry exceeds one GiB')
                    entry_data=z.read(info)
                    require(digest(entry_data)==unit['entry_sha256'], 'entry hash differs from graph')
                    cached_entry=unit['entry_ordinal']
                raw=entry_data[unit['offset']:unit['offset']+unit['size']]
                require(len(raw)==unit['size'] and digest(raw)==unit['sha'], 'source unit bytes changed')
                env=recover.environment(); loaded=env.load_file(io.BytesIO(raw),name=unit['name'])
                leaves={}
                def visit(item, parts):
                    if hasattr(item,'objects') and hasattr(item,'reader'):
                        leaves['/'.join(parts) or str(getattr(item,'name',None) or unit['name'])]=item
                    elif getattr(item,'files',None) is not None:
                        for name,child in item.files.items(): visit(child,parts+[str(name)])
                    else: leaves['/'.join(parts) or unit['name']]=item
                visit(loaded,[])
                for member in by_unit[unit['id']]:
                    require(member['name'] in leaves,'selected serialized/resource member missing')
                    item=leaves[member['name']]; data=bytes(item.reader.bytes if hasattr(item,'objects') else item.bytes)
                    require(len(data)==member['size'] and digest(data)==member['sha'], 'member bytes differ from graph')
                    relevant=[o for o in objects.values() if o['member_id']==member['id']]
                    if relevant:
                        source_slots=[str(e.path) for e in getattr(item,'externals',())]
                        wanted_slots=[r['name'] for r in selection['external_slots'] if r['member_id']==member['id']]
                        require(source_slots==wanted_slots,'source external-file slots changed')
                    for obj in relevant:
                        native=item.objects[obj['path_id']]
                        original=bytes(native.get_raw_data())
                        require(native.type.name==obj['type'] and len(original)==obj['size'] and digest(original)==obj['sha']
                                and int(native.byte_start)==obj['offset'], 'source object differs from selected graph')
                        raw_sha,_=sink.blob(original)
                        row={'object_id':obj['id'],'type':obj['type'],'raw_sha256':raw_sha,'raw_size':len(original)}
                        try: tree=recover.read_tree(native)
                        except Exception as exc:
                            require(obj['graph_status']!='decoded','previously decoded object failed fresh reparse: '+str(exc))
                            row.update(status='decode_failed',error=str(exc))
                        else:
                            require(obj['graph_status']=='decoded','decode outcome changed; scope requires review')
                            observed={p:pointer_values(v) for p,v in pointers(tree)}
                            wanted={r['pointer_path']:(r['file_id'],r['path_id']) for r in refs_by_object.get(obj['id'],[])}
                            require(observed==wanted,'source references differ from selected graph')
                            actual_streams={identity(obj['member_id'],obj['id'],'stream',trail):(name,off,size)
                                for trail,name,off,size in recover.stream_refs(tree)}
                            wanted_streams={d['id']:(d['name'],d['offset'],d['size']) for d in selection['streams'] if d['object_id']==obj['id']}
                            require(actual_streams==wanted_streams, 'source stream references differ from scope')
                            raw_tree=json_bytes(lossless_tree(tree,sink)); tree_sha,_=sink.blob(raw_tree)
                            row.update(status='decoded',tree_sha256=tree_sha)
                        records.append(row)
                    for dep in selection['streams']:
                        if dep['target_id']!=member['id'] or dep['status']!='resolved':continue
                        require(dep['status']=='resolved' and type(dep['offset']) is int and type(dep['size']) is int
                                and 0<=dep['offset'] and 0<dep['size'] and dep['offset']+dep['size']<=len(data),'invalid source stream')
                        payload=data[dep['offset']:dep['offset']+dep['size']]; sha,size=sink.blob(payload)
                        streams.append({'dependency_id':dep['id'],'object_id':dep['object_id'],'sha256':sha,'size':size})
        records.sort(key=lambda r:r['object_id']);streams.sort(key=lambda r:r['dependency_id'])
        require({r['object_id'] for r in records}==set(objects) and len(records)==len(objects),'scope raw-object coverage mismatch')
        require({r['dependency_id'] for r in streams}=={d['id'] for d in selection['streams'] if d['status']=='resolved'},'scope stream coverage mismatch')
        (work/'scope.json').write_bytes(json_bytes(selection))
        report={'schema':1,'input_sha256':selection['input_sha256'],'scope_sha256':file_digest(work/'scope.json'),
                'objects':records,'streams':streams,'stored_blob_bytes':sink.bytes,'raw_objects_verified':True,
                'serialized_closure_complete':selection['summary']['serialized_closure_complete'],
                'font_payloads_included':False,'original_bundles_included':False,'playable_game':False}
        (work/'receipt.json').write_bytes(json_bytes(report)); verify(work)
        require(not out.exists(),'output appeared during extraction');os.rename(work,out)
        return report


def verify(root):
    root=Path(root);r=json.loads((root/'receipt.json').read_text());s=json.loads((root/'scope.json').read_text())
    require(r['scope_sha256']==file_digest(root/'scope.json') and r['input_sha256']==s['input_sha256'],'scope receipt identity mismatch')
    validate_plan(s)
    require(r.get('schema')==1 and r.get('serialized_closure_complete')==s['summary']['serialized_closure_complete']
            and r.get('font_payloads_included') is False and r.get('playable_game') is False, 'receipt scope flags invalid')
    require(not (root/'blobs').is_symlink() and {p.name for p in root.iterdir()}=={'scope.json','receipt.json','blobs'}, 'unaccounted or symlinked package files')
    expected={o['id']:o for o in s['objects']}; seen=set();blobs=set()
    refs_by_object={}
    for e in s['references']:refs_by_object.setdefault(e['source_id'],[]).append(e)
    def check(sha,size=None):
        require(isinstance(sha,str) and HEX.fullmatch(sha),'invalid blob identity')
        p=root/'blobs'/sha
        require(p.is_file() and not p.is_symlink() and file_digest(p)==sha,'missing or changed scope blob')
        if size is not None:require(p.stat().st_size==size,'scope blob size changed')
        blobs.add(sha);return p.read_bytes()
    for obj in r['objects']:
        oid=obj['object_id'];require(oid in expected and oid not in seen,'scope object identity missing/duplicate');seen.add(oid)
        src=expected[oid];require(obj['type']==src['type']!='Font' and obj['raw_sha256']==src['sha'] and obj['raw_size']==src['size'],'raw-object receipt differs')
        check(obj['raw_sha256'],obj['raw_size'])
        if obj['status']=='decoded':
            tree=json.loads(check(obj['tree_sha256']))
            require({p:pointer_values(v) for p,v in pointers(tree)}=={e['pointer_path']:(e['file_id'],e['path_id']) for e in refs_by_object.get(oid,[])},'delivered tree reference mismatch')
            stack=[tree]
            while stack:
                v=stack.pop()
                if isinstance(v,dict):
                    if '$binary' in v:check(v['$binary'],v['size'])
                    else:stack.extend(v.values())
                elif isinstance(v,list):stack.extend(v)
        else:require(obj['status']=='decode_failed' and src['graph_status']=='decode_failed','unreported decoded-object loss')
    require(seen==set(expected),'scope object coverage incomplete')
    deps={d['id']:d for d in s['streams'] if d['status']=='resolved'};seen=set()
    for d in r['streams']:
        require(d['dependency_id'] in deps and d['dependency_id'] not in seen,'stream coverage mismatch');seen.add(d['dependency_id'])
        require(d['object_id']==deps[d['dependency_id']]['object_id'] and d['size']==deps[d['dependency_id']]['size'],'stream identity/size mismatch')
        check(d['sha256'],d['size'])
    require(seen==set(deps),'stream coverage incomplete')
    require({p.name for p in (root/'blobs').iterdir()}==blobs,'unaccounted scope blobs')
    return {'verified':True,'objects':len(expected),'streams':len(deps),'blobs':len(blobs),
            'serialized_closure_complete':s['summary']['serialized_closure_complete'],'playable_game':False}


def main(argv=None):
    p=argparse.ArgumentParser(description=__doc__);sub=p.add_subparsers(dest='command',required=True)
    a=sub.add_parser('plan');a.add_argument('--catalog',type=Path,required=True);a.add_argument('--profile',type=Path,required=True);a.add_argument('--out',type=Path,required=True)
    a=sub.add_parser('extract');a.add_argument('--apk',type=Path,required=True);a.add_argument('--plan',type=Path,required=True);a.add_argument('--out',type=Path,required=True)
    a=sub.add_parser('verify');a.add_argument('root',type=Path)
    args=p.parse_args(argv)
    if args.command=='plan':
        db=read_db(args.catalog)
        try:r=plan(db,json.loads(args.profile.read_text()))
        finally:db.close()
        with args.out.open('xb') as f:f.write(json_bytes(r))
        print(json.dumps(r['summary'],indent=2))
    elif args.command=='extract':
        extract(args.apk,json.loads(args.plan.read_text()),args.out);print(json.dumps(verify(args.out),indent=2))
    else:print(json.dumps(verify(args.root),indent=2))


if __name__=='__main__':main()
