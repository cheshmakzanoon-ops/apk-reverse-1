#!/usr/bin/env python3
"""Package a verified real model into a standalone Godot development viewer.

This prepares source/resources only. Native import, Android build, rendering and
device execution are separate validation gates, never asserted by this command.
"""
from __future__ import annotations
import argparse
import json
from pathlib import Path
import shutil
from recovery_core import file_digest
from gltf_model import require


def prepare(model_dir, out, *, runtime_checks=False):
    model_dir,out=Path(model_dir),Path(out)
    require(not out.exists() and not out.is_symlink(),'viewer destination exists')
    receipt=json.loads((model_dir/'receipt.json').read_text())
    result=json.loads((model_dir/'numerical.json').read_text())
    expected=json.loads((model_dir/'godot.expected.json').read_text())
    sha=file_digest(model_dir/'export/model.glb')
    require(result.get('passed') is True and sha==receipt['export_sha256']==result['glb_sha256']==expected['input_sha256'],
            'model/provenance/numerical verification mismatch')
    base=Path(__file__).resolve().parents[1]/'godot'
    out.mkdir(parents=True)
    shutil.copytree(base/'asset_viewer',out/'asset_viewer')
    (out/'scripts').mkdir()
    for name in ('verify_animation.gd', 'verify_model.gd'):
        shutil.copy2(base/'scripts'/name,out/'scripts'/name)
    project=(base/'project.godot').read_text().replace('Recovered Client Data Inspector','Recovered Farhad Asset Preview')
    project=project.replace('res://data_inspector/main.tscn','res://asset_viewer/main.tscn')
    (out/'project.godot').write_text(project)
    preset=(base/'export_presets.cfg').read_text().replace('Android Data Inspector','Android Asset Preview')
    preset=preset.replace('org.apk_recovery.data_inspector','org.apk_recovery.asset_preview').replace('Recovered Data Inspector','Recovered Farhad Preview')
    preset=preset.replace('client-data-inspector.apk','farhad-asset-preview.apk').replace('0.1-r5','0.1-real-model')
    (out/'export_presets.cfg').write_text(preset)
    assets=out/'recovered_models/farhad';assets.mkdir(parents=True)
    shutil.copy2(model_dir/'export/model.glb',assets/'model.glb')
    shutil.copy2(model_dir/'export/report.json',assets/'report.json')
    shutil.copy2(model_dir/'receipt.json',assets/'receipt.json')
    if runtime_checks:
        # Keep test oracles and exact GLB bytes separate from the imported scene.
        probe = out/'runtime_probe'; probe.mkdir()
        shutil.copy2(model_dir/'export/model.glb', probe/'model.bin')
        shutil.copy2(model_dir/'godot.expected.json', probe/'expected.json')
        (out/'export_presets.cfg').write_text(preset.replace('include_filter="*.json"', 'include_filter="*.json,*.bin"')
            .replace('architectures/x86_64=false', 'architectures/x86_64=true'))
    (out/'README.txt').write_text('Development asset preview, NOT the reconstructed game.\n'
        'Open project.godot in Godot 4.4.1, let it import, then run.\n'
        'Eight recovered clips, base-color material previews, no source controller or game logic.\n'
        'Native Godot/Android validation is not established by this source package.\n')
    return {'project':str(out/'project.godot'),'model_sha256':sha,'native_tested':False,'android_tested':False}

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('model_dir',type=Path);p.add_argument('out',type=Path)
    p.add_argument('--runtime-checks', action='store_true', help='Include exact model/oracle and x86_64 alongside ARM64 for Android runtime tests')
    a=p.parse_args();print(json.dumps(prepare(a.model_dir,a.out,runtime_checks=a.runtime_checks),indent=2))
