#!/usr/bin/env python3
"""Build verified, size-bounded asset archives with a complete outcome manifest.

No original asset names become filesystem paths. Failed conversions remain in the
manifest. Raw bundles and prefab relationships are not replaced by neutral exports.
"""
from __future__ import annotations
import argparse
from collections import Counter
import hashlib
import io
import json
import os
from pathlib import Path
import re
import tempfile
import zipfile

from recovery_bulk import SUPPORTED, selected_types, summary
from recovery_core import Catalog, RecoveryError, digest, json_bytes, validate_obj
from recovery_scan import writer_lock

FORMATS = {'Mesh':'obj','Texture2D':'png','Sprite':'png','TextAsset':'bin','AudioClip':'wav'}
HEX = re.compile(r'[0-9a-f]{64}')


def require(condition, message):
    if not condition: raise RecoveryError(message)


def check_data(kind, data, detail=None):
    if kind == 'Mesh': validate_obj(data.decode('utf-8'))
    elif kind == 'Texture2D' and (detail or {}).get('storage') == 'unity_float_texture_v1':
        from recovery_numeric_texture import validate_numeric_texture
        validate_numeric_texture(data,detail)
    elif kind in ('Texture2D','Sprite'):
        from PIL import Image
        with Image.open(io.BytesIO(data)) as image: image.verify()
    elif kind == 'AudioClip':
        from recovery_audio import validate_wav
        validate_wav(data)
    elif kind != 'TextAsset': raise RecoveryError('unsupported delivery type')


def extension_for(kind,detail):
    if kind == 'Texture2D' and detail.get('storage') == 'unity_float_texture_v1':return 'bin'
    return FORMATS[kind]


def file_hash(path):
    with Path(path).open('rb') as stream:
        h=hashlib.sha256()
        for block in iter(lambda:stream.read(1024**2), b''):h.update(block)
        return h.hexdigest()


def pack(root, out, *, kinds=SUPPORTED, max_archive_bytes=200*1024**2):
    root=Path(root);out=Path(out);kinds=selected_types(kinds)
    require(type(max_archive_bytes) is int and 1024 <= max_archive_bytes <= 200*1024**2,
            'archive limit must be between 1 KiB and 200 MiB')
    require(not out.exists() and not out.is_symlink(), 'delivery destination already exists')
    out.parent.mkdir(parents=True,exist_ok=True)
    with writer_lock(root), tempfile.TemporaryDirectory(prefix='.asset-delivery-',dir=out.parent) as temporary:
        work=Path(temporary);cat=Catalog(root);archive=None
        try:
            errors=cat.verify()
            require(not errors,'capture/export integrity failed: '+'; '.join(errors[:3]))
            report=summary(cat,kinds)
            require(report['all_selected_objects_attempted'],'every selected object must have a recorded outcome')
            rows=cat.db.execute(f'''SELECT o.id,o.type,o.name,o.member_id,o.path_id,o.sha source_sha256,
                e.sha export_sha256,e.size,e.status,e.detail FROM objects o
                JOIN exports e ON o.id=e.object_id AND e.format=o.type
                WHERE o.type IN ({','.join('?' for _ in kinds)}) ORDER BY o.type,o.id''',kinds)
            archives=[];inventory=work/'objects.jsonl';projected=22;count=0
            def finish():
                nonlocal archive
                if archive is not None:
                    filename=Path(archive.filename);archive.close();archive=None
                    size=filename.stat().st_size
                    require(size<=max_archive_bytes,'archive exceeded exact ZIP size budget')
                    archives.append({'name':filename.name,'size':size,'sha256':file_hash(filename)})
            with inventory.open('x',encoding='utf-8',newline='\n') as manifest:
                for row in rows:
                    record=dict(row);count+=1
                    require(HEX.fullmatch(record['id']) is not None,'invalid object identity')
                    if row['status']=='exported':
                        detail=json.loads(row['detail']);extension=extension_for(row['type'],detail)
                        require(detail.get('extension')==extension,'extension does not match selected type')
                        data=cat.store.path(row['export_sha256']).read_bytes()
                        require(len(data)==row['size'] and digest(data)==row['export_sha256'],'export bytes changed')
                        check_data(row['type'],data,detail)
                        name=row['type']+'/'+row['id']+'.'+extension
                        required=len(data)+76+2*len(name.encode())
                        require(required+22<=max_archive_bytes,'one export cannot fit archive size budget')
                        if archive is not None and projected+required>max_archive_bytes:finish()
                        if archive is None:
                            archive=zipfile.ZipFile(work/f'assets-{len(archives):05}.zip','x',compression=zipfile.ZIP_STORED,allowZip64=False)
                            projected=22
                        info=zipfile.ZipInfo(name,(1980,1,1,0,0,0));info.external_attr=0o100644<<16
                        archive.writestr(info,data);projected+=required
                        record.update(archive=Path(archive.filename).name,entry=name,detail=detail)
                    else:
                        require(row['status']=='failed','unknown export outcome')
                        require(row['export_sha256'] is None and row['size'] is None,'failed export has output bytes')
                    manifest.write(json.dumps(record,ensure_ascii=True,sort_keys=True,separators=(',',':'))+'\n')
            finish()
            require(count==report['objects_selected'],'delivery object coverage differs from capture')
            report.update(schema=1,manifest={'name':'objects.jsonl','size':inventory.stat().st_size,
                'sha256':file_hash(inventory)},archives=archives,max_archive_bytes=max_archive_bytes,
                source_scope='neutral derivatives of selected captured object types, not a full project',
                original_encoded_objects_included=False,shader_equivalence_verified=False,
                source_code_reconstructed=False)
            (work/'delivery.json').write_bytes(json_bytes(report))
            verify(work)
            # Only a fully checked delivery is published; existing outputs are never replaced.
            require(not out.exists() and not out.is_symlink(),'delivery destination appeared during packaging')
            os.rename(work,out)
            return report
        finally:
            if archive is not None:archive.close()
            cat.close()


def verify(out):
    out=Path(out);report=json.loads((out/'delivery.json').read_text())
    require(report.get('schema')==1,'unsupported delivery schema')
    kinds=selected_types(report['types']);manifest=report['manifest']
    require(manifest['name']=='objects.jsonl','invalid manifest filename')
    path=out/'objects.jsonl'
    require(not path.is_symlink() and path.stat().st_size==manifest['size']
            and file_hash(path)==manifest['sha256'],'manifest hash/size mismatch')
    archives={};allowed={'delivery.json','objects.jsonl'}
    for i,entry in enumerate(report['archives']):
        name=f'assets-{i:05}.zip';require(entry['name']==name,'archive sequence/name mismatch')
        p=out/name;allowed.add(name)
        require(not p.is_symlink() and p.stat().st_size==entry['size']<=report['max_archive_bytes']
                and file_hash(p)==entry['sha256'],'archive hash/size mismatch')
        archives[name]={}
    require({p.name for p in out.iterdir()}==allowed,'unaccounted delivery files')
    counts=Counter();ids=set()
    with path.open() as stream:
        for line in stream:
            record=json.loads(line);oid=record['id'];kind=record['type'];state=record['status']
            require(isinstance(oid,str) and HEX.fullmatch(oid) and oid not in ids,'duplicate/invalid object identity')
            ids.add(oid);require(kind in kinds and state in ('exported','failed'),'invalid type/status')
            require(isinstance(record['source_sha256'],str) and HEX.fullmatch(record['source_sha256']), 'invalid original hash')
            counts[(kind,state)]+=1
            if state=='exported':
                expected=kind+'/'+oid+'.'+extension_for(kind,record['detail'])
                require(record['entry']==expected and record['archive'] in archives,'unsafe or mismatched export path')
                require(record['detail']['extension']==extension_for(kind,record['detail']),'manifest export format mismatch')
                archives[record['archive']][expected]=record
            else:
                require(record.get('export_sha256') is None and record.get('size') is None
                        and 'entry' not in record and 'archive' not in record,'failed item has derivative payload')
    require(len(ids)==report['objects_selected']>0,'object coverage mismatch')
    expected_counts=Counter({(r['type'],r['status']):r['count'] for r in report['outcomes']})
    require(counts==expected_counts,'outcome coverage mismatch')
    require(report['all_selected_objects_attempted'] is True,'delivery has unattempted objects')
    require(report['all_selected_objects_exported']==all(state=='exported' for _,state in counts),
            'export completeness flag contradicts outcomes')
    for name,expected in archives.items():
        with zipfile.ZipFile(out/name) as archive:
            names=archive.namelist()
            require(len(names)==len(set(names)) and set(names)==set(expected),'archive entry coverage mismatch')
            for member in archive.infolist():
                row=expected[member.filename]
                require(member.file_size==row['size']<=200*1024**2 and not member.is_dir(), 'invalid archive entry size/type')
                data=archive.read(member)
                require(digest(data)==row['export_sha256'],'archive item hash mismatch')
                check_data(row['type'],data,row['detail'])
    return {'verified':True,'objects':len(ids),'exported':sum(n for (k,s),n in counts.items() if s=='exported'),
            'failed':sum(n for (k,s),n in counts.items() if s=='failed'), 'archives':len(archives),
            'input_sha256':report['input_sha256'],'rigged_prefabs_reconstructed':False}


def main(argv=None):
    p=argparse.ArgumentParser(description=__doc__);sub=p.add_subparsers(dest='command',required=True)
    b=sub.add_parser('pack');b.add_argument('root',type=Path);b.add_argument('--out',type=Path,required=True)
    b.add_argument('--types',nargs='+',default=list(SUPPORTED));b.add_argument('--max-mib',type=int,default=200)
    b=sub.add_parser('verify');b.add_argument('out',type=Path);a=p.parse_args(argv)
    try:
        r=verify(a.out) if a.command=='verify' else pack(a.root,a.out,kinds=a.types,max_archive_bytes=a.max_mib*1024**2)
        print(json.dumps(r,indent=2));return 0
    except (RecoveryError,OSError,ValueError,KeyError,zipfile.BadZipFile) as exc:
        p.exit(2,'asset delivery failed: '+str(exc)+'\n')


if __name__=='__main__':main()
