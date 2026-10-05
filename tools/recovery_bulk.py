#!/usr/bin/env python3
"""Resumable neutral exports from preserved objects, not complete prefab recovery.

Names are metadata. Files are named by captured object identity. Mesh OBJ exports
are geometry only; original rigs/materials/animations remain in captured bytes.
"""
from __future__ import annotations
import argparse
import io
import json
from pathlib import Path
import sys

import recover
from recovery_core import Catalog, RecoveryError, digest, json_bytes
from recovery_scan import writer_lock

SUPPORTED = ('Mesh','Texture2D','Sprite','TextAsset','AudioClip')


def run(root, *, kinds=SUPPORTED, limit=0, retry_failed=False):
    root=Path(root)
    if not kinds or len(kinds)!=len(set(kinds)) or any(k not in SUPPORTED for k in kinds):
        raise RecoveryError('unsupported or duplicate export type')
    if type(limit) is not int or limit < 0: raise RecoveryError('invalid export limit')
    with writer_lock(root):
        cat=Catalog(root)
        try:
            errors=cat.verify()
            if errors: raise RecoveryError('capture verification failed: '+'; '.join(errors[:3]))
            placeholders=','.join('?' for _ in kinds)
            exclusion="AND e.status='exported'" if retry_failed else ''
            query=f'''SELECT o.* FROM objects o WHERE o.type IN ({placeholders})
                AND NOT EXISTS (SELECT 1 FROM exports e WHERE e.object_id=o.id AND e.format=o.type {exclusion})
                ORDER BY o.member_id,o.path_id'''
            # Fixed selection avoids a changing cursor as export rows are committed.
            rows=cat.db.execute(query,kinds).fetchall()
            if limit:rows=rows[:limit]
            current=None;loaded=None;load_error=None;attempted=0
            for row in rows:
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
                    extension,data,detail=recover.convert(obj,row['type'])
                    sha,size=cat.blob(data)
                    cat.db.execute('INSERT OR REPLACE INTO exports VALUES (?,?,?,?,?,?)',
                        (row['id'],row['type'],sha,size,'exported',json.dumps({'extension':extension,**detail})))
                except Exception as exc:
                    cat.db.execute('INSERT OR REPLACE INTO exports VALUES (?,?,?,?,?,?)',
                        (row['id'],row['type'],None,None,'failed',str(exc)))
                attempted+=1
                if attempted%100==0:
                    cat.db.commit();print(f'neutral export attempts: {attempted}/{len(rows)}',flush=True)
            cat.db.commit()
            outcomes=[dict(r) for r in cat.db.execute(f'''SELECT o.type,e.status,COUNT(*) count
                FROM objects o LEFT JOIN exports e ON e.object_id=o.id AND e.format=o.type
                WHERE o.type IN ({placeholders}) GROUP BY o.type,e.status ORDER BY o.type,e.status''',kinds)]
            report={'schema':1,'input_sha256':cat.get_meta('input_sha256'),
                    'attempted_this_invocation':attempted,'types':list(kinds),'outcomes':outcomes,
                    'all_selected_objects_attempted':not any(r['status'] is None for r in outcomes),
                    'all_selected_objects_exported':all(r['status']=='exported' for r in outcomes),
                    'rigged_prefabs_reconstructed':False,'gameplay_port_complete':False}
            (root/'bulk-summary.json').write_bytes(json_bytes(report));cat.write_summary()
            return report
        finally:cat.close()


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('root',type=Path)
    p.add_argument('--types',nargs='+',default=list(SUPPORTED));p.add_argument('--limit',type=int,default=0)
    p.add_argument('--retry-failed',action='store_true');a=p.parse_args()
    try:
        r=run(a.root,kinds=a.types,limit=a.limit,retry_failed=a.retry_failed)
        print(json.dumps(r,indent=2));return 0 if r['all_selected_objects_exported'] else 1
    except (RecoveryError,OSError,ValueError) as exc:
        print('bulk export failed: '+str(exc),file=sys.stderr);return 2


if __name__=='__main__':raise SystemExit(main())
