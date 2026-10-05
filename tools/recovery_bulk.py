#!/usr/bin/env python3
"""Bounded, resumable neutral exports; models retain their rigs in original bytes.

Capture integrity, attempt coverage, successful conversions and delivery are
separate gates. Object identities, never display names, identify exported files.
"""
from __future__ import annotations
import argparse
import io
import json
import os
from pathlib import Path
import signal
import sys
import time

import recover
from recovery_core import Catalog, RecoveryError, digest, json_bytes
from recovery_scan import writer_lock

SUPPORTED = ('Mesh','Texture2D','Sprite','TextAsset','AudioClip')


def selected_types(kinds):
    if not kinds or len(kinds)!=len(set(kinds)) or any(k not in SUPPORTED for k in kinds):
        raise RecoveryError('unsupported or duplicate export type')
    return list(kinds)


def summary(cat, kinds, attempted=0, reason=None):
    slots=','.join('?' for _ in kinds)
    outcomes=[dict(r) for r in cat.db.execute(f'''SELECT o.type,e.status,COUNT(*) count
        FROM objects o LEFT JOIN exports e ON e.object_id=o.id AND e.format=o.type
        WHERE o.type IN ({slots}) GROUP BY o.type,e.status ORDER BY o.type,e.status''',kinds)]
    total=sum(r['count'] for r in outcomes)
    return {'schema':2,'input_sha256':cat.get_meta('input_sha256'),
        'attempted_this_invocation':attempted,'types':list(kinds),'objects_selected':total,
        'outcomes':outcomes,'stop_reason':reason,
        'all_selected_objects_attempted':total>0 and not any(r['status'] is None for r in outcomes),
        'all_selected_objects_exported':total>0 and all(r['status']=='exported' for r in outcomes),
        'rigged_prefabs_reconstructed':False,'gameplay_port_complete':False}


def publish_summary(cat, kinds, attempted, reason):
    cat.db.commit()
    report=summary(cat,kinds,attempted,reason)
    temporary=cat.root/'bulk-summary.tmp'
    with temporary.open('wb') as output:
        output.write(json_bytes(report));output.flush();os.fsync(output.fileno())
    os.replace(temporary,cat.root/'bulk-summary.json')
    return report


def run(root, *, kinds=SUPPORTED, limit=0, retry_failed=False, max_seconds=0,
        batch_size=100, stop=None, native_mesh=False):
    root=Path(root);kinds=selected_types(kinds)
    if (any(type(n) is not int or n < 0 for n in (limit,max_seconds))
            or type(batch_size) is not int or not 1 <= batch_size <= 10000):
        raise RecoveryError('invalid export budget')
    stop=stop or (lambda:False);started=time.monotonic();attempted=0
    with writer_lock(root):
        cat=Catalog(root)
        try:
            errors=cat.verify()
            if errors: raise RecoveryError('capture verification failed: '+'; '.join(errors[:3]))
            cat.db.execute('CREATE INDEX IF NOT EXISTS members_units ON members(unit_id,basename)')
            cat.db.commit()
            placeholders=','.join('?' for _ in kinds)
            exclusion="AND e.status='exported'" if retry_failed else ''
            query=f'''SELECT o.* FROM objects o WHERE o.type IN ({placeholders})
                AND NOT EXISTS (SELECT 1 FROM exports e WHERE e.object_id=o.id AND e.format=o.type {exclusion})
                ORDER BY o.member_id,o.path_id'''
            rows=cat.db.execute(query,kinds).fetchall()
            current=None;loaded=None;load_error=None;reason=None
            for row in rows:
                if stop(): reason='requested_stop';break
                if max_seconds and time.monotonic()-started >= max_seconds: reason='time_budget';break
                if limit and attempted>=limit: reason='object_budget';break
                if current != row['member_id']:
                    current=row['member_id']
                    member=cat.db.execute('SELECT * FROM members WHERE id=?',(current,)).fetchone()
                    raw=cat.store.path(member['sha']).read_bytes()
                    if len(raw)!=member['size'] or digest(raw)!=member['sha']:
                        raise RecoveryError('member bytes changed during export')
                    try:
                        env=recover.environment(cat,current)
                        loaded=env.load_file(io.BytesIO(raw),name=member['name']);load_error=None
                    except Exception as exc:loaded=None;load_error=str(exc)
                try:
                    if loaded is None:raise RecoveryError(load_error)
                    obj=loaded.objects[row['path_id']]
                    if digest(obj.get_raw_data())!=row['sha'] or obj.type.name!=row['type']:
                        raise RecoveryError('object bytes/type changed during export')
                    if native_mesh and row['type']=='Mesh':
                        from recovery_mesh import convert_mesh
                        extension,data,detail=convert_mesh(obj.parse_as_object())
                    else:
                        extension,data,detail=recover.convert(obj,row['type'])
                except Exception as exc:
                    cat.db.execute('INSERT OR REPLACE INTO exports VALUES (?,?,?,?,?,?)',
                        (row['id'],row['type'],None,None,'failed',str(exc)))
                else:
                    # Storage failures are fatal, not mislabeled unsupported media.
                    sha,size=cat.blob(data)
                    cat.db.execute('INSERT OR REPLACE INTO exports VALUES (?,?,?,?,?,?)',
                        (row['id'],row['type'],sha,size,'exported',json.dumps({'extension':extension,**detail})))
                attempted+=1
                if attempted%batch_size==0:
                    cat.db.commit();print(f'neutral export attempts: {attempted}/{len(rows)}',flush=True)
            report=publish_summary(cat,kinds,attempted,reason);cat.write_summary()
            return report
        except BaseException:
            # Catalog.close commits: explicitly roll back an unexpected failure.
            cat.db.rollback()
            raise
        finally:cat.close()


def main(argv=None):
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('root',type=Path)
    p.add_argument('--types',nargs='+',default=list(SUPPORTED));p.add_argument('--limit',type=int,default=0)
    p.add_argument('--max-seconds',type=int,default=0);p.add_argument('--batch-size',type=int,default=100)
    p.add_argument('--retry-failed',action='store_true');p.add_argument('--native-mesh',action='store_true');a=p.parse_args(argv)
    stopping=[];previous={s:signal.signal(s,lambda *_:stopping.append(True)) for s in (signal.SIGINT,signal.SIGTERM)}
    try:
        r=run(a.root,kinds=a.types,limit=a.limit,retry_failed=a.retry_failed,max_seconds=a.max_seconds,
              batch_size=a.batch_size,stop=lambda:bool(stopping),native_mesh=a.native_mesh)
        print(json.dumps(r,indent=2))
        return (0 if r['all_selected_objects_exported'] else 1) if r['all_selected_objects_attempted'] else 3
    except (RecoveryError,OSError,ValueError) as exc:
        print('bulk export failed: '+str(exc),file=sys.stderr);return 2
    finally:
        for s,h in previous.items():signal.signal(s,h)


if __name__=='__main__':raise SystemExit(main())
