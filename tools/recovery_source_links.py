#!/usr/bin/env python3
"""Index literal resource references in committed recovered code, without executing it.

Matches are leads for source review, not a call graph or proof of runtime loading.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
from recovery_core import RecoveryError, file_digest, json_bytes


def build(repo, selection):
    repo=Path(repo).resolve()
    paths=subprocess.check_output(['git','ls-files','-z','--','source-app'],cwd=repo).decode().split('\0')
    terms=sorted({Path(r['path']).stem.casefold() for r in selection['roots']})
    matches=[];scanned=0;skipped=[]
    for rel in paths:
        if not rel or Path(rel).suffix not in ('.cs','.lua'):continue
        p=repo/rel
        if p.is_symlink() or not p.is_file() or p.stat().st_size>4*1024**2:
            skipped.append({'path':rel,'reason':'symlink, missing or larger than 4 MiB'});continue
        raw=p.read_bytes();scanned+=1
        lines=raw.decode('utf-8','surrogateescape').splitlines()
        hits=[{'line':i+1,'text':line,'terms':[t for t in terms if t in line.casefold()]}
              for i,line in enumerate(lines) if any(t in line.casefold() for t in terms)]
        if hits:
            git_blob=hashlib.sha1(b'blob '+str(len(raw)).encode()+b'\0'+raw).hexdigest()
            recorded=subprocess.check_output(['git','rev-parse','HEAD:'+rel],cwd=repo,text=True).strip()
            if git_blob!=recorded:raise RecoveryError('matched source file differs from committed bytes: '+rel)
            matches.append({'path':rel,'sha256':hashlib.sha256(raw).hexdigest(),'git_blob':git_blob,'matches':hits})
    return {'schema':1,'commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=repo,text=True).strip(),
            'scope_input_sha256':selection['input_sha256'],'terms':terms,'source_files_scanned':scanned,
            'matched_files':matches,'skipped_files':skipped,'method':'case-insensitive literal stem occurrence',
            'game_code_executed':False,'source_binary_equivalence_proven':False,
            'dynamic_dependencies_complete':False,'behavior_ported':False}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--repo',type=Path,required=True)
    p.add_argument('--scope',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    data=build(a.repo,json.loads(a.scope.read_text()))
    with a.out.open('xb') as f:f.write(json_bytes(data))
    print(json.dumps({'source_files_scanned':data['source_files_scanned'],'matched_files':len(data['matched_files'])}))
