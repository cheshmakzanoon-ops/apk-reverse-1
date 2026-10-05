#!/usr/bin/env python3
"""Index literal resource references in committed recovered code, without executing it.

Matches are leads for source review, not a call graph or proof of runtime loading.
All inspected files must match HEAD, including files without a resource-name hit.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import subprocess
from recovery_core import RecoveryError, json_bytes


def build(repo, selection):
    repo = Path(repo).resolve()
    roots = selection.get('roots', [])
    if not roots or not all(isinstance(r.get('path'), str) and PurePosixPath(r['path']).stem for r in roots):
        raise RecoveryError('source trace requires explicit nonempty asset paths')
    terms = sorted({PurePosixPath(r['path']).stem.casefold() for r in roots})
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=repo, text=True).strip()
    listing = subprocess.check_output(['git', 'ls-tree', '-r', '-z', head, '--', 'source-app'], cwd=repo)
    matches = []; scanned = 0; skipped = []
    for entry in listing.split(b'\0'):
        if not entry:
            continue
        header, name = entry.split(b'\t', 1)
        mode, kind, recorded = header.decode('ascii').split()
        rel = name.decode('utf-8', 'surrogateescape')
        if PurePosixPath(rel).suffix not in ('.cs', '.lua'):
            continue
        p = repo / rel
        if (kind != 'blob' or mode not in ('100644', '100755') or p.is_symlink()
                or not p.is_file() or p.stat().st_size > 4 * 1024**2):
            skipped.append({'path': rel, 'reason': 'nonregular, symlink, missing or larger than 4 MiB'})
            continue
        if any(parent.is_symlink() for parent in p.parents if parent != repo and repo in parent.parents):
            raise RecoveryError('source parent directory is a symlink: ' + rel)
        raw = p.read_bytes()
        git_blob = hashlib.sha1(b'blob ' + str(len(raw)).encode() + b'\0' + raw).hexdigest()
        if git_blob != recorded:
            raise RecoveryError('source file differs from committed bytes: ' + rel)
        scanned += 1
        hits = []
        for i, line in enumerate(raw.decode('utf-8', 'surrogateescape').splitlines(), 1):
            found = [t for t in terms if t in line.casefold()]
            if found:
                hits.append({'line': i, 'text': line, 'terms': found})
        if hits:
            matches.append({'path': rel, 'sha256': hashlib.sha256(raw).hexdigest(),
                            'git_blob': git_blob, 'matches': hits})
    if subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=repo, text=True).strip() != head:
        raise RecoveryError('repository HEAD changed while tracing sources')
    return {'schema': 1, 'commit': head, 'scope_input_sha256': selection['input_sha256'],
            'terms': terms, 'source_files_scanned': scanned, 'matched_files': matches,
            'skipped_files': skipped, 'all_inspected_files_match_head': True,
            'method': 'case-insensitive literal stem occurrence', 'game_code_executed': False,
            'source_binary_equivalence_proven': False, 'dynamic_dependencies_complete': False,
            'behavior_ported': False}


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--repo', type=Path, required=True)
    p.add_argument('--scope', type=Path, required=True)
    p.add_argument('--out', type=Path, required=True)
    a = p.parse_args()
    data = build(a.repo, json.loads(a.scope.read_text()))
    with a.out.open('xb') as f:
        f.write(json_bytes(data))
    print(json.dumps({'source_files_scanned': data['source_files_scanned'],
                      'matched_files': len(data['matched_files'])}))
