#!/usr/bin/env python3
"""Checkpointed full-capture graph traversal; incomplete recovery stays explicit.

Decoded trees are compressed SQLite records, not one fsynced file per object.
Original APK/member/object bytes and the legacy graph interface remain unchanged.
Use a fresh raw capture or resume this scanner's own checkpoints, never two writers.
"""
from __future__ import annotations
import argparse
from contextlib import contextmanager
import hashlib
import io
import json
import os
from pathlib import Path
import signal
import sqlite3
import sys
import time
import zlib

import recover
import recovery_graph as graph
from recovery_core import Catalog, RecoveryError, digest, identity, json_bytes, lossless_tree

SCANNER = 1
MAX_TREE = 128 * 1024**2
DDL = """
CREATE TABLE IF NOT EXISTS graph_trees(
 object_id TEXT PRIMARY KEY REFERENCES objects,
 sha TEXT NOT NULL, raw_size INTEGER NOT NULL, data BLOB NOT NULL);
CREATE TABLE IF NOT EXISTS graph_members(
 member_id TEXT PRIMARY KEY REFERENCES members, status TEXT NOT NULL, detail TEXT);
CREATE INDEX IF NOT EXISTS container_sources ON container_paths(source_id);
CREATE INDEX IF NOT EXISTS graph_status ON graph_objects(status,object_id);
CREATE INDEX IF NOT EXISTS members_units ON members(unit_id,basename);
CREATE INDEX IF NOT EXISTS dependency_members ON dependencies(member_id,kind);
"""


def compact(value):
    return json.dumps(value, ensure_ascii=True, sort_keys=True,
                      separators=(',', ':'), allow_nan=False).encode()


def input_key(cat):
    """Bind resumption to the immutable capture metadata, not a success flag."""
    h = hashlib.sha256(compact([SCANNER, cat.get_meta('input_sha256'), cat.get_meta('tool')]))
    queries = [
        'SELECT id,unit_id,name,sha,size,kind,expected_objects FROM members ORDER BY id',
        'SELECT id,member_id,path_id,type,offset,size,sha FROM objects ORDER BY id']
    for q in queries:
        for row in cat.db.execute(q):
            h.update(compact(list(row))); h.update(b'\n')
    return h.hexdigest()


@contextmanager
def writer_lock(root):
    """Kernel-released on process exit; never remove a shared lock-file inode."""
    path = Path(root)/'.graph-writer.lock'
    if path.is_symlink():
        raise RecoveryError('graph lock must not be a symlink')
    stream = path.open('a+b')
    try:
        if os.name == 'nt':
            import msvcrt
            if path.stat().st_size == 0: stream.write(b'0'); stream.flush()
            stream.seek(0)
            try: msvcrt.locking(stream.fileno(), msvcrt.LK_NBLCK, 1)
            except OSError as exc: raise RecoveryError('another graph writer is active') from exc
        else:
            import fcntl
            try: fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError as exc: raise RecoveryError('another graph writer is active') from exc
        yield
    finally:
        stream.close()


def initialize(cat):
    if cat.get_meta('graph_schema') and cat.get_meta('graph_scan_schema') != SCANNER:
        raise RecoveryError('legacy graph exists; use a fresh raw capture, not an implicit destructive rebuild')
    cat.db.commit()
    if cat.db.execute('PRAGMA journal_mode=WAL').fetchone()[0] != 'wal':
        raise RecoveryError('checkpointed scan requires local SQLite WAL support')
    cat.db.execute('PRAGMA synchronous=FULL')
    cat.db.execute('PRAGMA cache_size=-65536')
    cat.db.executescript(graph.DDL + DDL)
    stamp = input_key(cat)
    previous = cat.get_meta('graph_scan_input')
    if previous is not None and stamp != previous:
        raise RecoveryError('capture identities changed since checkpoint')
    cat.set_meta('graph_schema', 1)
    cat.set_meta('graph_scan_schema', SCANNER)
    cat.set_meta('graph_scan_input', stamp)
    cat.db.execute("INSERT OR IGNORE INTO graph_objects SELECT id,'not_decoded','pending' FROM objects")
    cat.db.commit()


def status(cat):
    result = graph.summary(cat)
    pending = cat.db.execute("SELECT COUNT(*) FROM graph_objects WHERE status='not_decoded'").fetchone()[0]
    members = dict(cat.db.execute('SELECT status,COUNT(*) FROM graph_members GROUP BY status'))
    member_total = cat.db.execute("SELECT COUNT(*) FROM members WHERE kind='serialized'").fetchone()[0]
    finished = (pending == 0 and sum(members.values()) == member_total
                and sum(result['objects'].values()) == result['objects_expected'])
    result.update(scan_schema=SCANNER, scan_finished=finished,
                  pending_objects=pending, member_statuses=members,
                  compressed_trees=cat.db.execute('SELECT COUNT(*) FROM graph_trees').fetchone()[0])
    return result


def checkpoint(cat, state):
    cat.set_meta('graph_state', state)
    cat.db.commit()
    report = status(cat)
    tmp = cat.root/'graph-summary.tmp'
    with tmp.open('wb') as f:
        f.write(json_bytes(report)); f.flush(); os.fsync(f.fileno())
    os.replace(tmp, cat.root/'graph-summary.json')
    return report


def load_member(cat, member):
    raw = cat.store.path(member['sha']).read_bytes()
    if len(raw) != member['size'] or digest(raw) != member['sha']:
        raise RecoveryError('serialized member bytes differ from capture')
    env = recover.environment()
    loaded = env.load_file(io.BytesIO(raw), name=member['name'])
    ids = {r[0] for r in cat.db.execute('SELECT path_id FROM objects WHERE member_id=?', (member['id'],))}
    if not hasattr(loaded, 'objects') or set(loaded.objects) != ids:
        raise RecoveryError('reparsed object identities differ from capture')
    if cat.get_meta('graph_scan_schema') == SCANNER:
        expected = [str(e.path) for e in getattr(loaded,'externals',())]
        actual = [r[0] for r in cat.db.execute(
            'SELECT name FROM external_slots WHERE member_id=? ORDER BY file_id', (member['id'],))]
        if expected != actual:
            raise RecoveryError('external file slots differ from serialized source')
    return loaded


def store_tree(cat, obj, loaded):
    parsed = loaded.objects[obj['path_id']]
    if digest(parsed.get_raw_data()) != obj['sha']:
        raise RecoveryError('reparsed object bytes differ from capture')
    tree = lossless_tree(recover.read_tree(parsed), cat)
    raw = compact(tree)
    if len(raw) > MAX_TREE:
        raise RecoveryError('decoded tree exceeds 128-MiB budget; original bytes retained')
    cat.db.execute('INSERT OR REPLACE INTO graph_trees VALUES (?,?,?,?)',
                   (obj['id'], digest(raw), len(raw), zlib.compress(raw, 1)))
    return tree


def run(root, *, max_objects=0, max_seconds=0, batch_size=500, stop=None):
    root = Path(root)
    if any(type(n) is not int or n < 0 for n in (max_objects,max_seconds)) or not 1 <= batch_size <= 10000:
        raise RecoveryError('invalid scan budget')
    if not (root/'catalog.sqlite').is_file():
        raise RecoveryError('capture catalog is missing')
    stop = stop or (lambda: False)
    started = time.monotonic(); attempted = 0; since_commit = 0
    with writer_lock(root):
        cat = Catalog(root)
        try:
            errors = cat.verify()
            if errors: raise RecoveryError('invalid capture: ' + '; '.join(errors[:3]))
            initialize(cat)
            # A completed scan is verified rather than silently accepting damaged checkpoints.
            if cat.get_meta('graph_state') in ('complete','incomplete'):
                errors = graph.verify_graph(cat)
                if errors: raise RecoveryError('invalid graph checkpoint: ' + '; '.join(errors[:3]))
                return status(cat)
            checkpoint(cat, 'building')
            def expired():
                return stop() or (max_seconds and time.monotonic()-started >= max_seconds)
            members = cat.db.execute("SELECT * FROM members WHERE kind='serialized' ORDER BY id").fetchall()
            # ALL file-ID tables must exist before any cross-file edge is resolved.
            for i, member in enumerate(members):
                if cat.db.execute('SELECT 1 FROM graph_members WHERE member_id=?', (member['id'],)).fetchone():
                    continue
                if expired(): return checkpoint(cat, 'paused')
                deps = {r['id']: r for r in cat.db.execute(
                    "SELECT * FROM dependencies WHERE member_id=? AND kind='external'", (member['id'],))}
                # Capture IDs encode the zero-based slot ordinal. Recover that exact
                # ordering without reparsing every million-object member twice.
                slots = []
                for n in range(len(deps)):
                    dep = deps.get(identity(member['id'], None, 'external', n))
                    if dep is None or dep['object_id'] is not None:
                        raise RecoveryError('external dependency slot identities differ from capture')
                    slots.append((member['id'], n+1, dep['name']))
                cat.db.executemany('INSERT INTO external_slots VALUES (?,?,?)', slots)
                cat.db.execute("INSERT INTO graph_members VALUES (?,'indexed',NULL)", (member['id'],))
                if i % 100 == 0:
                    cat.db.commit(); print(f'external slots {i+1}/{len(members)}',flush=True)
            checkpoint(cat, 'building')
            for member in members:
                rows = cat.db.execute("SELECT o.* FROM objects o CROSS JOIN graph_objects g ON o.id=g.object_id WHERE o.member_id=? AND g.status='not_decoded' ORDER BY o.path_id", (member['id'],)).fetchall()
                if not rows: continue
                if expired() or (max_objects and attempted >= max_objects): return checkpoint(cat,'paused')
                loaded = None
                # Cached per member/slot, scoped to this scan only; no names or IDs guessed.
                old_resolve = cat.resolve
                cache = {}
                def cached_resolve(name, owner=None):
                    k = (name,owner)
                    if k not in cache: cache[k] = old_resolve(name,owner)
                    return cache[k]
                cat.resolve = cached_resolve
                try:
                    for obj in rows:
                        if expired() or (max_objects and attempted >= max_objects): return checkpoint(cat,'paused')
                        attempted += 1
                        try:
                            if obj['tree_sha']:
                                tree = graph.tree_for(cat,obj)
                            else:
                                if loaded is None: loaded = load_member(cat,member)
                                tree = store_tree(cat,obj,loaded)
                        except Exception as exc:
                            cat.db.execute("UPDATE graph_objects SET status='decode_failed',detail=? WHERE object_id=?", (str(exc),obj['id']))
                        else:
                            # Source tree and all edges form one transaction. Status is written last.
                            graph.populate_references(cat,obj,tree)
                            cat.db.execute("UPDATE graph_objects SET status='decoded',detail=NULL WHERE object_id=?", (obj['id'],))
                        since_commit += 1
                        if since_commit >= batch_size:
                            cat.db.commit(); since_commit = 0
                        if attempted % 10000 == 0:
                            cat.db.commit();print(f'objects visited this invocation: {attempted}',flush=True)
                finally:
                    cat.resolve = old_resolve
                cat.db.commit()
            report = status(cat)
            state = ('complete' if report['graph_complete'] else 'incomplete') if report['scan_finished'] else 'paused'
            return checkpoint(cat,state)
        except BaseException:
            # Keep previously committed batches. The incomplete transaction is not accepted.
            cat.db.rollback()
            if cat.get_meta('graph_scan_schema') == SCANNER:
                checkpoint(cat,'failed')
            raise
        finally:
            cat.close()


def backup(root, destination, seconds=120):
    """Bounded consistent database snapshot, also while a WAL writer is active."""
    destination = Path(destination); db = Path(root)/'catalog.sqlite'
    if destination.exists() or destination.is_symlink() or not db.is_file() or db.is_symlink():
        raise RecoveryError('invalid backup source or existing destination')
    destination.parent.mkdir(parents=True,exist_ok=True)
    tmp = destination.with_name(destination.name+'.pending')
    if tmp.exists() or tmp.is_symlink(): raise RecoveryError('backup temporary path exists')
    start = time.monotonic()
    def progress(_code, _left, _total):
        if time.monotonic()-start > seconds: raise RecoveryError('database backup time budget exceeded')
    source = sqlite3.connect(db.resolve().as_uri()+'?mode=ro',uri=True,timeout=1)
    target = sqlite3.connect(tmp)
    try:
        # Pin one WAL read snapshot so commits cannot repeatedly restart a large backup.
        source.execute('BEGIN')
        source.execute('SELECT COUNT(*) FROM sqlite_master').fetchone()
        source.backup(target,pages=1024,progress=progress,sleep=.05)
        if target.execute('PRAGMA integrity_check').fetchone()[0] != 'ok':
            raise RecoveryError('backup SQLite integrity failed')
        target.close(); source.close()
        os.replace(tmp,destination)
    except BaseException:
        target.close(); source.close(); tmp.unlink(missing_ok=True); raise


def inventory(cat, out):
    """All original asset-container paths, with exact target identity and status."""
    out = Path(out)
    if out.exists(): raise RecoveryError('inventory output already exists')
    report = status(cat)
    if not report['scan_finished']: raise RecoveryError('inventory requires a finished scan')
    query = '''SELECT p.original_path,p.source_id,r.status,r.target_id,o.type,o.name,o.member_id,o.path_id,o.sha
        FROM container_paths p JOIN object_refs r ON r.id=p.ref_id
        LEFT JOIN objects o ON o.id=r.target_id ORDER BY p.original_path,p.id'''
    with out.open('x',encoding='utf-8') as f:
        for row in cat.db.execute(query): f.write(compact(dict(row)).decode()+'\n')


def main(argv=None):
    p=argparse.ArgumentParser(description=__doc__); sub=p.add_subparsers(dest='command',required=True)
    b=sub.add_parser('build');b.add_argument('root',type=Path)
    b.add_argument('--max-objects',type=int,default=0);b.add_argument('--max-seconds',type=int,default=0)
    b.add_argument('--batch-size',type=int,default=500)
    for name in ('verify','inventory','backup'):
        b=sub.add_parser(name);b.add_argument('root',type=Path)
        if name != 'verify': b.add_argument('--out',type=Path,required=True)
    a=p.parse_args(argv);cat=None
    try:
        if a.command=='build':
            stopping=[]
            previous={s:signal.signal(s,lambda *_:stopping.append(True)) for s in (signal.SIGINT,signal.SIGTERM)}
            try: result=run(a.root,max_objects=a.max_objects,max_seconds=a.max_seconds,batch_size=a.batch_size,stop=lambda:bool(stopping))
            finally:
                for s,h in previous.items():signal.signal(s,h)
            # 3 means resumable pause, not a successful full scan.
            code=0 if result['scan_finished'] else 3
        elif a.command=='backup':
            backup(a.root.resolve(),a.out);result={'catalog_backup':str(a.out),'raw_blobs_included':False};code=0
        else:
            cat=Catalog(a.root)
            errors=cat.verify()+graph.verify_graph(cat)
            result={'errors':errors,'summary':status(cat)}
            if a.command=='inventory':
                if errors: raise RecoveryError('invalid graph: '+'; '.join(errors[:3]))
                inventory(cat,a.out)
            code=0 if not errors and result['summary']['scan_finished'] else 1
        print(json.dumps(result,indent=2));return code
    except (RecoveryError,OSError,sqlite3.Error,ValueError) as exc:
        print('scan failed: '+str(exc),file=sys.stderr);return 2
    finally:
        if cat:cat.close()


if __name__=='__main__':raise SystemExit(main())
