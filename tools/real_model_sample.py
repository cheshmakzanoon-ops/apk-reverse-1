#!/usr/bin/env python3
"""Reproduce one hash-pinned, actual animated model from the supplied APK.

This is a declared bundle subset, not a full-APK recovery claim. Original bundle
bytes, both explicitly excluded clips, source identities and material limitations
are retained. No downloaded code is executed and no network request is made.
"""
from __future__ import annotations
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import tempfile
import zipfile
import recover
import recovery_graph
from recovery_core import Catalog, RecoveryError, digest, file_digest, json_bytes
from recovery_model import Reader, export_snapshot
from gltf_model import require
from verify_mecanim import verify


def selector(cat, item, kind):
    require(isinstance(item,dict) and re.fullmatch(r'-?\d{1,19}',str(item.get('path_id',''))),'invalid profile object identity')
    require(-2**63 <= int(item['path_id']) < 2**63, 'profile path ID outside signed int64')
    rows=cat.db.execute('SELECT o.* FROM objects o JOIN members m ON o.member_id=m.id WHERE m.name=? AND o.path_id=?',
                        (item['member'],int(item['path_id']))).fetchall()
    require(len(rows)==1 and rows[0]['type']==kind and rows[0]['sha']==item['sha256'],
            'profile object absent, ambiguous, wrong class or changed bytes')
    return rows[0]['id']


def validate_profile(profile):
    require(profile.get('schema')==1 and 0 < profile.get('apk_size',0) <= 4*1024**3,'invalid APK profile')
    require(re.fullmatch('[0-9a-f]{64}',profile.get('apk_sha256','')),'profile needs original APK hash')
    require(isinstance(profile.get('fragment_entry'),str) and 0 < profile.get('fragment_size',0) <= 2*1024**3,'invalid fragment')
    bundles=profile.get('bundles');require(isinstance(bundles,list) and 0 < len(bundles) <= 100,'invalid subset count')
    last=0;seen=set()
    for item in bundles:
        i,offset,size=item.get('index'),item.get('offset'),item.get('size')
        require(type(i)is int and 0 <= i <= 100000 and i not in seen,'invalid/repeated bundle index');seen.add(i)
        require(type(offset)is int and type(size)is int and offset >= last and 0 < size <= 32*1024**2
                and offset+size <= profile['fragment_size'],'invalid/overlapping bundle range')
        require(re.fullmatch('[0-9a-f]{64}',item.get('sha256','')),'missing bundle hash');last=offset+size
    require(isinstance(profile.get('clips'),list) and 0 < len(profile['clips']) <= 128,'invalid selected clips')


def build(apk, out, profile_path):
    apk,out,profile_path=Path(apk),Path(out),Path(profile_path)
    require(apk.is_file() and not apk.is_symlink(),'APK must be a regular, nonsymlink file')
    require(not out.exists() and not out.is_symlink(),'output already exists; refusing overwrite')
    profile=json.loads(profile_path.read_text());validate_profile(profile)
    require(apk.stat().st_size==profile['apk_size'] and file_digest(apk)==profile['apk_sha256'],'original APK size/hash mismatch')
    out.parent.mkdir(parents=True,exist_ok=True)
    staging=Path(tempfile.mkdtemp(prefix='.model-pending-',dir=out.parent))
    try:
        sources=staging/'source_bundles';sources.mkdir()
        with zipfile.ZipFile(apk) as original,zipfile.ZipFile(staging/'selected-bundles.zip','x') as derived:
            entries=[x for x in original.infolist()if x.filename==profile['fragment_entry']]
            require(len(entries)==1 and entries[0].file_size==profile['fragment_size'],'fragment missing/ambiguous/changed')
            with original.open(entries[0]) as stream:
                for item in profile['bundles']:
                    stream.seek(item['offset']);raw=stream.read(item['size'])
                    require(len(raw)==item['size'] and digest(raw)==item['sha256'] and raw.startswith(b'UnityFS\0'),
                            'selected bundle size/hash/header mismatch')
                    (sources/f'{item["index"]:05d}.bundle').write_bytes(raw)
                    entry=zipfile.ZipInfo(f'assets/bin/Data/bundle-{item["index"]}',date_time=(1980,1,1,0,0,0))
                    entry.external_attr=0o100644 << 16;entry.create_system=3
                    derived.writestr(entry,raw)
        snapshot=staging/'snapshot'
        recover.capture(staging/'selected-bundles.zip',snapshot,max_units=0,max_bytes=512*1024**2)
        cat=Catalog(snapshot)
        try:require(not cat.verify(),'subset original-byte coverage failed')
        finally:cat.close()
        recovery_graph.build(snapshot,max_objects=0)
        cat=Catalog(snapshot)
        try:
            root=selector(cat,profile['root'],'Transform');binding=selector(cat,profile['animation_root'],'Transform')
            clips=[selector(cat,x,'AnimationClip')for x in profile['clips']]
            require(len(clips)==len(set(clips)),'duplicate selected animation')
            reader=Reader(cat)
            for item,oid in zip(profile['clips'],clips):
                require(reader.tree(oid)['m_Name']==item['name'],'selected clip name/hash association changed')
            excluded=[{**x,'object_id':selector(cat,x,'AnimationClip')}for x in profile['excluded_clips']]
            # Every captured clip is selected or explicitly excluded; never disappear.
            require(not set(clips)&{x['object_id']for x in excluded},'selected/excluded clips overlap')
            actual={r[0]for r in cat.db.execute("SELECT id FROM objects WHERE type='AnimationClip'")}
            require(actual==set(clips)|{x['object_id']for x in excluded},'clip accounting mismatch')
        finally:cat.close()
        report=export_snapshot(snapshot,root,staging/'export',clip_ids=clips,animation_root=binding,packed_mecanim=True)
        cat=Catalog(snapshot)
        try:numerical,expected=verify(cat,(staging/'export/model.glb').read_bytes(),root)
        finally:cat.close()
        require(numerical['passed'],'independent numeric/skin verification failed')
        (staging/'numerical.json').write_bytes(json_bytes(numerical))
        (staging/'godot.expected.json').write_bytes(json_bytes(expected))
        (staging/'profile.json').write_bytes(json_bytes(profile))
        (staging/'model.expected.json').write_bytes(json_bytes({
          **{k:report['counts'][k] for k in ('mesh_instances','triangles','skinned_instances')},
          'min_bones':numerical['source_joint_count']}))
        receipt={'schema':1,'scope':'one explicitly selected actual model; not complete recovery',
          'original_apk_sha256':profile['apk_sha256'],'original_apk_size':profile['apk_size'],
          'profile_sha256':file_digest(profile_path),'derived_subset_sha256':file_digest(staging/'selected-bundles.zip'),
          'export_sha256':report['model_sha256'],'root_object_id':root,'animation_root_id':binding,
          'selected_clips':profile['clips'],'excluded_clips':excluded,
          'parser_version':'UnityPy '+recover.UNITYPY_VERSION,'fallback_unity_version':recover.UNITY_VERSION,
          'fallback_reason':'original serialized headers report 0.0.0; pinned typetree fallback used',
          'tool_sha256':{p.name:file_digest(p)for p in Path(__file__).parent.glob('*.py')},
          'native_godot_tested':False,'android_device_tested':False,'shader_equivalence_verified':False,
          'gameplay_port_complete':False}
        (staging/'receipt.json').write_bytes(json_bytes(receipt))
        require(apk.stat().st_size==profile['apk_size'] and file_digest(apk)==profile['apk_sha256'],
                'original APK changed during conversion')
        require(not out.exists(),'output appeared during conversion')
        os.rename(staging,out)
        return {'path':str(out),'counts':report['counts'],'original_apk_sha256':profile['apk_sha256'],'numerical_passed':True}
    finally:
        if staging.exists():shutil.rmtree(staging)


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--apk',type=Path,required=True)
    p.add_argument('--out',type=Path,required=True);p.add_argument('--profile',type=Path,
        default=Path(__file__).resolve().parents[1]/'docs/inputs/farhad-streamed-model.json');args=p.parse_args()
    try:print(json.dumps(build(args.apk,args.out,args.profile),indent=2));return 0
    except (RecoveryError,OSError,ValueError,KeyError)as e:print('real model conversion blocked: '+str(e));return 2
if __name__=='__main__':raise SystemExit(main())
