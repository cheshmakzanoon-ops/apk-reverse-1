#!/usr/bin/env python3
"""Export a verified R1/R2 model subtree as GLB, without executing game code.

Materials are deliberately base-color previews. Explicit --clip selections support
the R4 legacy and selected generic dense/constant TRS subsets; other animations,
custom shaders and gameplay remain
unimplemented. No runtime controller or missing curve is fabricated.
"""
from __future__ import annotations

import argparse
import io
import json
from pathlib import Path
import sys

import recover
import recovery_graph as graph
from recovery_core import Catalog, RecoveryError, digest, json_bytes
from gltf_model import make_glb, require, validate_glb


class Reader:
    """One member at a time, catalog-scoped, with original object hash checks."""
    def __init__(self, cat):
        self.cat = cat
        self.current = None
        self.loaded = None
        self.env = None

    def object(self, oid):
        row = self.cat.db.execute('SELECT * FROM objects WHERE id=?', (oid,)).fetchone()
        require(row is not None, 'unknown object ' + str(oid))
        return row

    def tree(self, oid):
        row = self.object(oid)
        state = self.cat.db.execute('SELECT status FROM graph_objects WHERE object_id=?', (oid,)).fetchone()
        require(state is not None and state[0] == 'decoded', 'undecoded object ' + oid)
        return graph.tree_for(self.cat, row)

    def parsed(self, oid):
        row = self.object(oid)
        if row['member_id'] != self.current:
            member = self.cat.db.execute('SELECT * FROM members WHERE id=?', (row['member_id'],)).fetchone()
            raw = self.cat.store.path(member['sha']).read_bytes()
            require(digest(raw) == member['sha'], 'serialized member hash mismatch')
            self.env = recover.environment(self.cat, row['member_id'])
            self.loaded = self.env.load_file(io.BytesIO(raw), name=member['name'])
            self.current = row['member_id']
        obj = self.loaded.objects[row['path_id']]
        require(digest(obj.get_raw_data()) == row['sha'], 'reparsed object differs from capture')
        require(obj.type.name == row['type'], 'reparsed class differs from capture')
        return obj.parse_as_object()

    def ref(self, oid, path, expected=None, nullable=False):
        r = self.cat.db.execute('SELECT * FROM object_refs WHERE source_id=? AND pointer_path=?', (oid, path)).fetchone()
        require(r is not None, 'missing reference ' + path + ' in ' + oid)
        if nullable and r['status'] == 'null':
            return None
        require(r['status'] == 'resolved', 'unresolved reference ' + path + ': ' + r['status'])
        row = self.object(r['target_id'])
        require(expected is None or row['type'] in expected, 'wrong target class for ' + path)
        return row['id']


def variable_skin_present(value):
    """Unity 2019 wraps the optional weight stream in a structure, even if empty."""
    if value is None:
        return False
    data = value if isinstance(value, (list, tuple, bytes, bytearray)) else getattr(value, 'm_Data', None)
    require(isinstance(data, (list, tuple, bytes, bytearray)), 'unknown variable-weight container')
    return len(data) != 0



def expand_skin(geometry):
    """Expand Unity OneBone/TwoBones layouts into four glTF influence slots.

    A single index with no weight channel has implicit weight 1 (SkinWeights.OneBone).
    Missing multi-index weights are not inferred; original sums remain validated.
    """
    joints = geometry.get('joints')
    weights = geometry.get('weights')
    if not joints:
        require(not weights, 'weights without bone indices')
        return
    require(len(joints) == len(geometry['positions']), 'bone-index vertex count mismatch')
    width = len(joints[0])
    require(width in (1, 2, 4) and all(len(j) == width for j in joints), 'unsupported skin influence layout')
    if not weights:
        require(width == 1, 'missing weights for multi-bone skin')
        weights = [[1.0] for _ in joints]
    require(len(weights) == len(joints) and all(len(w) == width for w in weights), 'skin channel dimensions differ')
    geometry['weights'] = [list(w) + [0.0] * (4-width) for w in weights]
    geometry['joints'] = [list(j) + [0] * (4-width) for j in joints]
    geometry['source_skin_influences'] = width


def read_geometry(mesh):
    """Decode raw vertex channels; never use OBJ as the skin recovery source."""
    from UnityPy.helpers.MeshHelper import MeshHandler
    shapes = getattr(mesh, 'm_Shapes', None)
    require(not shapes or not getattr(shapes, 'channels', None), 'blend shapes need a separate morph exporter')
    require(not variable_skin_present(getattr(mesh, 'm_VariableBoneCountWeights', None)), 'variable-weight skin unsupported')
    handler = MeshHandler(mesh)
    handler.process()
    # MeshHelper's triangles do not apply baseVertex. Do it explicitly from the
    # decoded index buffer, validating byte alignment/count before touching it.
    width = 2 if handler.m_Use16BitIndices else 4
    raw_indices = handler.m_IndexBuffer
    require(raw_indices is not None, 'mesh has no decoded indices')
    submeshes = []
    for sub in mesh.m_SubMeshes:
        require(int(sub.topology) == 0, 'only explicit triangle topology supported')
        start, count = sub.firstByte, sub.indexCount
        require(type(start) is int and type(count) is int and start >= 0 and start % width == 0 and count > 0 and count % 3 == 0,
                'invalid submesh index byte range/count')
        start //= width
        require(start+count <= len(raw_indices), 'submesh outside index buffer')
        base = getattr(sub, 'baseVertex', 0) or 0
        require(type(base) is int and base >= 0, 'invalid baseVertex')
        submeshes.append([[int(i)+base for i in raw_indices[j:j+3]] for j in range(start, start+count, 3)])
    result = {'positions': handler.m_Vertices, 'submeshes': submeshes}
    for key, field in [('normals', 'm_Normals'), ('uv', 'm_UV0'), ('tangents', 'm_Tangents'),
                       ('colors', 'm_Colors'), ('weights', 'm_BoneWeights'), ('joints', 'm_BoneIndices')]:
        rows = getattr(handler, field, None)
        if rows:
            # Some Unity normals have an unused fourth component.
            result[key] = [list(row[:3] if key == 'normals' else row) for row in rows]
    require(result['positions'] is not None, 'mesh positions unavailable')
    result['positions'] = [list(v) for v in result['positions']]
    expand_skin(result)
    return result


def named_values(value, path):
    if isinstance(value, dict):
        return {k: (v, path + '/' + graph.escape(k)) for k, v in value.items()}
    require(isinstance(value, list), 'invalid material property map')
    out = {}
    for i, pair in enumerate(value):
        require(isinstance(pair, list) and len(pair) == 2 and isinstance(pair[0], str) and pair[0] not in out,
                'ambiguous material property')
        out[pair[0]] = (pair[1], path + f'/{i}/1')
    return out


def preview_material(reader, oid):
    tree = reader.tree(oid)
    saved = tree.get('m_SavedProperties', {})
    colors = named_values(saved.get('m_Colors', []), '/m_SavedProperties/m_Colors')
    textures = named_values(saved.get('m_TexEnvs', []), '/m_SavedProperties/m_TexEnvs')
    color = colors.get('_Color', ({'r': 1, 'g': 1, 'b': 1, 'a': 1}, ''))[0]
    result = {'id': oid, 'name': tree.get('m_Name', oid), 'color': [color[k] for k in 'rgba']}
    # Preview only: prefer an explicitly bound SRP base map over a legacy main map.
    # Null properties are not textures. Retain the selected property as provenance.
    for prop in ('_BaseMap', '_MainTex'):
        if prop in textures:
            env = textures[prop][0]
            require(env.get('m_Scale', {'x':1,'y':1}) == {'x':1,'y':1} and
                    env.get('m_Offset', {'x':0,'y':0}) == {'x':0,'y':0},
                    'nonidentity texture transform needs KHR_texture_transform conversion')
    candidates = [k for k in ('_BaseMap', '_MainTex') if k in textures
                  and textures[k][0].get('m_Texture', {}).get('m_PathID', 0)]
    if candidates:
        prop = candidates[0]
        env, trail = textures[prop]
        require(env.get('m_Scale', {'x':1,'y':1}) == {'x':1,'y':1} and
                env.get('m_Offset', {'x':0,'y':0}) == {'x':0,'y':0},
                'nonidentity texture transform needs KHR_texture_transform conversion')
        texture_id = reader.ref(oid, trail + '/m_Texture', {'Texture2D'})
        tex = reader.parsed(texture_id)
        recover.texture_data(tex)
        image = tex.image
        require(image is not None, 'base texture decoder returned no image')
        stream = io.BytesIO(); image.save(stream, format='PNG')
        result['png'] = stream.getvalue()
        result['source_texture_property'] = prop
        result['source_texture_id'] = texture_id
    return result


def bind_matrix(value):
    # Unity Matrix4x4f fields are row/column names e00..e33, not flat storage order.
    return [getattr(value, 'e'+str(r)+str(c)) for r in range(4) for c in range(4)]



def common_skin_root(nodes, joints):
    """glTF skeleton must be a common ancestor; Unity rootBone need not be."""
    parents = {child: n['id'] for n in nodes for child in n['children']}
    ids = {n['id'] for n in nodes}
    chains = []
    for joint in joints:
        require(joint in ids, 'skin joint outside model')
        chain = []
        while joint is not None:
            require(joint not in chain, 'cyclic skin hierarchy')
            chain.append(joint); joint = parents.get(joint)
        chains.append(chain)
    require(chains, 'empty skin')
    for candidate in chains[0]:
        if all(candidate in chain for chain in chains[1:]):
            return candidate
    raise RecoveryError('skin joints have no common ancestor')


def collect(cat, root_object, reader=None, max_nodes=50000, material_preview=None):
    hierarchy = graph.scene(cat, root_object, max_nodes)
    require(hierarchy['hierarchy_complete'], 'hierarchy blocked: ' + json.dumps(hierarchy['blockers'][:3]))
    reader = reader or Reader(cat)
    material_preview = material_preview or preview_material
    model = {'input_sha256': hierarchy['input_sha256'], 'root': hierarchy['root'],
             'nodes': [], 'renderers': [], 'omitted_components': []}
    for n in hierarchy['nodes']:
        t = n['local_transform']
        model['nodes'].append({'id': n['transform_id'], 'name': n['name'] or n['transform_id'],
            'children': n['children'], 'translation': t['m_LocalPosition'],
            'rotation': t['m_LocalRotation'], 'scale': t['m_LocalScale']})
        go_tree = reader.tree(n['game_object_id'])
        require(go_tree.get('m_IsActive', True), 'inactive GameObject visibility is not supported in this glTF subset')
        renderers = [c for c in n['components'] if c['type'] in ('MeshRenderer','SkinnedMeshRenderer')]
        require(len(renderers) <= 1, 'multiple renderers on one node require separate primitive bindings')
        for c in n['components']:
            if c['type'] not in ('Transform','MeshFilter','MeshRenderer','SkinnedMeshRenderer'):
                model['omitted_components'].append({'object_id': c['object_id'], 'type': c['type'],
                                                   'reason': 'not represented by model conversion'})
        for c in renderers:
            rid = c['object_id']; rt = reader.tree(rid)
            require(rt.get('m_Enabled', True), 'disabled renderer visibility not supported')
            if c['type'] == 'SkinnedMeshRenderer':
                mesh_id = reader.ref(rid, '/m_Mesh', {'Mesh'})
            else:
                filters = [x for x in n['components'] if x['type'] == 'MeshFilter']
                require(len(filters) == 1, 'renderer requires exactly one MeshFilter')
                mesh_id = reader.ref(filters[0]['object_id'], '/m_Mesh', {'Mesh'})
            mesh = reader.parsed(mesh_id)
            geometry = read_geometry(mesh)
            renderer = {'id': rid, 'node': n['transform_id'], 'name': n['name'] or rid,
                        'mesh_id': mesh_id, 'geometry': geometry, 'materials': []}
            material_refs = rt.get('m_Materials')
            require(isinstance(material_refs, list), 'renderer materials unavailable')
            for i in range(len(material_refs)):
                mid = reader.ref(rid, f'/m_Materials/{i}', {'Material'})
                renderer['materials'].append(material_preview(reader, mid))
            if c['type'] == 'SkinnedMeshRenderer':
                require(not any(rt.get('m_BlendShapeWeights', [])), 'nonzero blend-shape weights need morph conversion')
                bone_refs = rt.get('m_Bones')
                require(isinstance(bone_refs, list) and bone_refs, 'skin bone array unavailable')
                bones = [reader.ref(rid, f'/m_Bones/{i}', {'Transform'}) for i in range(len(bone_refs))]
                binds = getattr(mesh, 'm_BindPose', None)
                require(binds is not None and len(binds) == len(bones), 'mesh bind-pose count does not match renderer bones')
                renderer['skin'] = {'joints': bones, 'inverse_bind_matrices': [bind_matrix(m) for m in binds],
                                     'root': None,
                                     'source_root': reader.ref(rid, '/m_RootBone', {'Transform'}, nullable=True)}
            model['renderers'].append(renderer)
    for renderer in model['renderers']:
        if 'skin' in renderer:
            renderer['skin']['root'] = common_skin_root(model['nodes'], renderer['skin']['joints'])
    require(model['renderers'], 'selected subtree contains no supported mesh renderer')
    return model


def export_snapshot(root, root_object, out, *, max_nodes=50000, clip_ids=(), animation_root=None, packed_mecanim=False):
    out = Path(out)
    require(not out.exists() and not out.is_symlink(), 'output already exists; snapshots are never overwritten')
    cat = Catalog(root)
    try:
        preview = None
        if packed_mecanim:
            from packed_material import preview_material as preview
        model = collect(cat, root_object, max_nodes=max_nodes, material_preview=preview)
        blob = make_glb(model)
        clips = []
        require(not animation_root or clip_ids, '--animation-root requires an explicit --clip')
        if clip_ids:
            from recovery_animation import MAX_CLIPS, decode_clip, append_clips, validate_animated_glb
            require(len(clip_ids) <= MAX_CLIPS and len(set(clip_ids)) == len(clip_ids), 'invalid or duplicate clip selection')
            reader = Reader(cat)
            for oid in clip_ids:
                row = reader.object(oid)
                require(row['type'] == 'AnimationClip', 'selected clip is not an AnimationClip')
                # Verify the original clip bytes even when a decoded tree is cached.
                reader.parsed(oid)
                tree = reader.tree(oid)
                if tree.get('m_Legacy') is False:
                    # Keep the existing dense/spline path stable unless opted in.
                    if packed_mecanim:
                        from recovery_mecanim import decode_mecanim
                        clips.append(decode_mecanim(tree, oid, row['sha'], model, animation_root))
                    else:
                        from mecanim_dense import decode_dense
                        clips.append(decode_dense(tree, oid, row['sha'], model, animation_root))
                else:
                    clips.append(decode_clip(tree, oid, row['sha'], model, animation_root))
            blob = append_clips(blob, clips)
            counts = validate_animated_glb(blob, allow_linear_rotation=packed_mecanim)
        else:
            counts = validate_glb(blob)
        report = {'schema': 1, 'input_sha256': model['input_sha256'], 'root_object_id': model['root'],
            'model_sha256': digest(blob), 'model_bytes': len(blob), 'counts': counts,
            'status': 'model_exported', 'material_mode': 'base-color preview',
            'animations_exported': len(clips), 'packed_mecanim': packed_mecanim, 'shader_equivalence_verified': False,
            'animation_runtime_equivalence_verified': False,
            'animation_clips': [{k:v for k,v in c.items() if k != 'channels'} for c in clips],
            'gameplay_port_complete': False, 'omitted_components': model['omitted_components']}
        # Complete conversion/validation precedes output creation. Files are exclusive.
        out.mkdir(parents=True, exist_ok=False)
        with (out/'model.glb').open('xb') as f:
            f.write(blob)
        with (out/'report.json').open('xb') as f:
            f.write(json_bytes(report))
        return report
    finally:
        cat.close()


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('snapshot', type=Path)
    parser.add_argument('--root-object', required=True)
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--max-nodes', type=int, default=50000)
    parser.add_argument('--clip', action='append', default=[], help='Captured AnimationClip object ID; repeat for multiple clips')
    parser.add_argument('--animation-root', help='Transform ID used as the clip path root (default: selected model root)')
    parser.add_argument('--packed-mecanim', action='store_true', help='Opt in to bounded generic streamed/dense/constant TRS and source-color previews')
    args = parser.parse_args(argv)
    try:
        print(json.dumps(export_snapshot(args.snapshot, args.root_object, args.out, max_nodes=args.max_nodes, clip_ids=args.clip, animation_root=args.animation_root, packed_mecanim=args.packed_mecanim), indent=2))
        return 0
    except (RecoveryError, OSError, KeyError, TypeError, ImportError, ValueError) as exc:
        print('model conversion blocked: ' + str(exc), file=sys.stderr)
        return 2


if __name__ == '__main__':
    raise SystemExit(main())
