#!/usr/bin/env python3
"""Reproduce a reviewed, bounded real-model conversion from a hash-pinned APK.

The small ZIP is a derivative capture, never represented as the full APK. Missing
shader/controller references remain visible. No downloaded game code is executed.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
from pathlib import Path
import shutil
import tempfile
import zipfile

import godot_animation
import recover
import recovery_graph as graph
import recovery_model as model_export
from gltf_model import unpack_glb, require
from mecanim_dense import ATTRIBUTES
from recovery_animation import path_index
from recovery_core import Catalog, RecoveryError, digest, json_bytes, walk_fragment


def file_hash(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def make_selection(apk, profile, out):
    require(apk.is_file() and not apk.is_symlink(), 'missing or symlink APK')
    require(apk.stat().st_size == profile['apk_bytes'], 'APK size does not match reviewed profile')
    require(file_hash(apk) == profile['apk_sha256'], 'APK hash does not match reviewed profile')
    indices = profile['bundle_indices']
    require(isinstance(indices, list) and 0 < len(indices) <= 64
            and all(type(i) is int and i >= 0 for i in indices)
            and len(indices) == len(set(indices)), 'invalid bundle selection')
    entries = []
    with zipfile.ZipFile(apk) as original:
        matches = [i for i in original.infolist() if i.filename == profile['fragment']]
        require(len(matches) == 1 and matches[0].file_size <= 1024**3, 'fragment missing/ambiguous/oversized')
        # Spool once, which verifies the original ZIP CRC; do not repeatedly
        # decompress the 522-MB ZIP member to seek individual bundles.
        with tempfile.TemporaryFile() as fragment:
            with original.open(matches[0]) as stream:
                shutil.copyfileobj(stream, fragment)
            fragment.seek(0)
            extents = list(walk_fragment(fragment, matches[0].file_size))
            require(max(indices) < len(extents), 'selected bundle index outside fragment')
            require(sum(extents[i][1] for i in indices) <= 64*1024**2, 'selected bundle byte budget exceeded')
            with zipfile.ZipFile(out, 'w', compression=zipfile.ZIP_STORED) as selection:
                for i in sorted(indices):
                    offset, size = extents[i]; fragment.seek(offset); data = fragment.read(size)
                    require(len(data) == size, 'short original bundle')
                    name = f'assets/bin/Data/bundle-{i:04d}.bundle'
                    info = zipfile.ZipInfo(name, (1980, 1, 1, 0, 0, 0))
                    selection.writestr(info, data)
                    entries.append({'index': i, 'offset': offset, 'bytes': size, 'sha256': digest(data),
                                    'derived_zip_entry': name})
    # Detect ordinary concurrent replacement before claiming the observed hash.
    require(file_hash(apk) == profile['apk_sha256'], 'APK changed during selection')
    return {'source_apk_sha256': profile['apk_sha256'], 'source_apk_bytes': profile['apk_bytes'],
            'source_fragment': profile['fragment'], 'fragment_bundles': len(extents),
            'selection_zip_sha256': file_hash(out), 'selected_bundles': entries,
            'scope': 'selected derivative, not full APK capture', 'publisher_authenticated': False}


def source_key_expectations(blob, source, model, binding_root):
    """Read exact source dense frames independently of the curve decoder/evaluator.

    These checks certify stored pose samples, not Unity's inter-sample behavior.
    """
    import zlib
    doc, _ = unpack_glb(blob)
    node_indices = {n['extras']['unity_object_id']: i for i, n in enumerate(doc['nodes'])}
    paths = path_index(model, binding_root)
    path_hashes = {}
    for path, ids in paths.items():
        path_hashes.setdefault(zlib.crc32(path.encode()), []).extend(ids)
    clips = []
    for oid, tree in source:
        raw = tree['m_MuscleClip']['m_Clip']['data']
        dense, constant = raw['m_DenseClip'], raw['m_ConstantClip']['data']
        n, hz = dense['m_CurveCount'], dense['m_SampleRate']
        frame_ids = sorted(set([0, 1, 5, 14, min(28, dense['m_FrameCount']-1)]))
        frame_ids = [f for f in frame_ids if f/hz <= tree['m_MuscleClip']['m_StopTime']]
        channels = []; cursor = 0
        for binding in tree['m_ClipBindingConstant']['genericBindings']:
            kind, width = ATTRIBUTES[binding['attribute']]
            matches = path_hashes[binding['path']]; require(len(matches) == 1, 'expectation binding ambiguity')
            samples = []
            for frame in frame_ids:
                values = (dense['m_SampleArray'][frame*n+cursor:frame*n+cursor+width]
                          if cursor < n else constant[cursor-n:cursor-n+width])
                require(len(values) == width, 'source expectation read outside sample payload')
                if kind == 'rotation':
                    length = math.sqrt(sum(x*x for x in values)); values = [x/length for x in values]
                    values = [values[0], -values[1], -values[2], values[3]]
                elif kind == 'translation':
                    values = [-values[0], values[1], values[2]]
                samples.append({'time': frame/hz, 'source_frame': frame, 'value': values})
            channels.append({'node_index': node_indices[matches[0]], 'path': kind, 'samples': samples})
            cursor += width
        clips.append({'name': 'Recovered_'+oid, 'original_name': tree['m_Name'], 'channels': channels})
    return {'fixture_only': False, 'expectation_scope': 'exact stored dense/constant poses only',
            'input_sha256': digest(blob), 'bake_fps': 120., 'vector_tolerance': .0005,
            'angle_tolerance': .002, 'clips': clips}


def run(apk, out, profile_path):
    apk, out = Path(apk), Path(out)
    require(not out.exists() and not out.is_symlink(), 'output exists; use a new destination')
    profile = json.loads(Path(profile_path).read_text())
    require(profile.get('schema') == 1, 'unsupported sample profile')
    out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.real-model-', dir=out.parent) as tmp:
        work = Path(tmp); delivery = work/'delivery'; delivery.mkdir()
        receipt = make_selection(apk, profile, delivery/'selected-bundles.zip')
        capture = work/'capture'; recover.capture(delivery/'selected-bundles.zip', capture)
        cat = Catalog(capture)
        try:
            require(not cat.verify(), 'selected capture verification failed')
        finally:
            cat.close()
        graph_report = graph.build(capture)
        cat = Catalog(capture)
        try:
            roots = cat.db.execute('''SELECT DISTINCT r.target_id FROM container_paths p
                JOIN object_refs r ON r.id=p.ref_id JOIN objects o ON o.id=r.target_id
                WHERE p.original_path=? AND o.type='GameObject' AND r.status='resolved' ''',
                (profile['prefab_path'],)).fetchall()
            require(len(roots) == 1, 'prefab path absent/ambiguous')
            model = model_export.collect(cat, roots[0][0])
            candidates = path_index(model, model['root']).get(profile['binding_root_path'], [])
            require(len(candidates) == 1, 'binding root absent/ambiguous')
            binding_root = candidates[0]
            reader = model_export.Reader(cat); source = []
            for name in profile['clips']:
                rows = cat.db.execute("SELECT * FROM objects WHERE type='AnimationClip' AND name=?", (name,)).fetchall()
                require(len(rows) == 1, 'clip name absent/ambiguous')
                row = rows[0]; reader.parsed(row['id'])
                source.append((row['id'], reader.tree(row['id'])))
            inventory = []
            for row in cat.db.execute("SELECT id,name FROM objects WHERE type='AnimationClip' ORDER BY name"):
                t = reader.tree(row['id']); payload = t.get('m_MuscleClip', {}).get('m_Clip', {}).get('data', {})
                inventory.append({'name': row['name'], 'id': row['id'],
                    'selected': row['name'] in profile['clips'],
                    'streamed_scalars': payload.get('m_StreamedClip', {}).get('curveCount'),
                    'has_generic_root_transform': t.get('m_HasGenericRootTransform')})
            root = roots[0][0]
            renderers = [{'name': r['name'], 'source_mesh_id': r['mesh_id'],
                         'source_influences': r['geometry'].get('source_skin_influences'),
                         'source_root_bone': r['skin'].get('source_root'), 'gltf_root': r['skin']['root'],
                         'joint_count': len(r['skin']['joints']),
                         'materials': [{k:v for k,v in m.items() if k != 'png'} for m in r['materials']]}
                        for r in model['renderers']]
        finally:
            cat.close()
        exported = model_export.export_snapshot(capture, root, delivery/'export',
                           clip_ids=[oid for oid,_ in source], animation_root=binding_root)
        original = (delivery/'export/model.glb').read_bytes()
        native, compatibility = godot_animation.prepare(original)
        (delivery/'export/model.native.glb').write_bytes(native)
        (delivery/'export/compatibility.json').write_bytes(json_bytes(compatibility))
        expected = source_key_expectations(native, source, model, binding_root)
        expected['source_spline_sha256'] = digest(original)
        (delivery/'export/animation.expected.json').write_bytes(json_bytes(expected))
        counts = {k:exported['counts'][k] for k in ('mesh_instances','triangles','skinned_instances')}
        counts['min_bones'] = len(set(j for r in model['renderers'] for j in r['skin']['joints']))
        (delivery/'export/model.expected.json').write_bytes(json_bytes(counts))
        report = {'schema': 1, 'source': receipt, 'profile_sha256': file_hash(profile_path),
                  'selection_graph': graph_report, 'export': exported, 'renderers': renderers,
                  'clip_inventory': inventory, 'full_game_assets_complete': False,
                  'source_runtime_equivalence_verified': False, 'android_device_tested': False}
        (delivery/'real-model-report.json').write_bytes(json_bytes(report))
        (delivery/'display-clips.json').write_bytes(json_bytes({c['name']: c['original_name'] for c in expected['clips']}))
        os.rename(delivery, out)
    return report


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--apk', type=Path, required=True); p.add_argument('--out', type=Path, required=True)
    p.add_argument('--profile', type=Path, default=Path('docs/inputs/farhad-model.json'))
    args = p.parse_args()
    try:
        result = run(args.apk, args.out, args.profile)
        print(json.dumps({'counts': result['export']['counts'], 'scope': result['source']['scope']}, indent=2))
    except (RecoveryError, OSError, ValueError, KeyError, TypeError) as exc:
        p.exit(2, 'real-model conversion blocked: '+str(exc)+'\n')


if __name__ == '__main__':
    main()
