"""Strict, deterministic glTF 2.0/GLB writer for recovered Unity model data.

Input is already decoded geometry, not an OBJ: skin weights/bind matrices survive.
The sole basis change is C=diag(-1,1,1,1). UV V is reversed with top-origin PNGs.
Material conversion is an explicitly labelled preview; no Unity shader is executed.
"""
from __future__ import annotations

import io
import json
import math
import struct

from recovery_core import RecoveryError, digest

MAX_VERTICES = 2_000_000
MAX_NODES = 50_000
MAX_GLB = 512 * 1024 * 1024
IDENTITY = [1., 0., 0., 0., 0., 1., 0., 0., 0., 0., 1., 0., 0., 0., 0., 1.]
BASIS = [-1, 1, 1, 1]


def require(value, message):
    if not value:
        raise RecoveryError(message)


def floats(values, length, label):
    require(isinstance(values, (list, tuple)) and len(values) == length, label + ': wrong dimensions')
    require(all(type(x) in (int, float) and math.isfinite(x) and abs(x) <= 3.4028234e38 for x in values),
            label + ': nonfinite or non-float32 value')
    return [float(x) for x in values]


def unit(values, size, label):
    values = floats(values, size, label)
    norm = math.sqrt(sum(x*x for x in values))
    require(abs(norm - 1) <= .002, label + ': not unit length')
    return [x/norm for x in values]


def multiply(a, b):
    """Row-major internal matrices; glTF serialization transposes to column-major."""
    return [sum(a[r*4+k]*b[k*4+c] for k in range(4)) for r in range(4) for c in range(4)]


def trs(translation, rotation, scale):
    x, y, z, w = rotation
    r = [1-2*y*y-2*z*z, 2*x*y-2*z*w, 2*x*z+2*y*w, translation[0],
         2*x*y+2*z*w, 1-2*x*x-2*z*z, 2*y*z-2*x*w, translation[1],
         2*x*z-2*y*w, 2*y*z+2*x*w, 1-2*x*x-2*y*y, translation[2],
         0, 0, 0, 1]
    return [r[i]*scale[i % 4] if i % 4 < 3 else r[i] for i in range(16)]


def inverse(matrix):
    a = [matrix[i*4:i*4+4] + IDENTITY[i*4:i*4+4] for i in range(4)]
    for c in range(4):
        p = max(range(c, 4), key=lambda i: abs(a[i][c]))
        require(abs(a[p][c]) > 1e-12, 'singular bind matrix')
        a[c], a[p] = a[p], a[c]
        div = a[c][c]
        a[c] = [x/div for x in a[c]]
        for r in range(4):
            if r != c:
                div = a[r][c]
                a[r] = [v-div*x for v, x in zip(a[r], a[c])]
    return [x for row in a for x in row[4:]]


def convert_matrix(values):
    values = floats(values, 16, 'bind matrix')
    require(max(abs(values[12+i]-[0, 0, 0, 1][i]) for i in range(4)) < 1e-6, 'non-affine bind matrix')
    inverse(values)  # Never manufacture identity for absent/singular binds.
    return [values[r*4+c]*BASIS[r]*BASIS[c] for r in range(4) for c in range(4)]


def normalized_geometry(geometry, joint_count=0):
    pos = geometry['positions']
    require(3 <= len(pos) <= MAX_VERTICES, 'mesh vertex count outside supported budget')
    p = [floats(v, 3, 'position') for v in pos]
    out = {'POSITION': [[-x, y, z] for x, y, z in p]}
    for name, semantic, size in [('normals', 'NORMAL', 3), ('uv', 'TEXCOORD_0', 2),
                                  ('colors', 'COLOR_0', 4), ('tangents', 'TANGENT', 4)]:
        rows = geometry.get(name)
        if rows is None:
            continue
        require(len(rows) == len(p), 'mismatched ' + name + ' count')
        rows = [floats(row, size, name) for row in rows]
        if name == 'normals':
            rows = [unit(row, 3, name) for row in rows]
            rows = [[-x, y, z] for x, y, z in rows]
        elif name == 'uv':
            rows = [[u, 1-v] for u, v in rows]
        elif name == 'colors':
            require(all(0 <= x <= 1 for row in rows for x in row), 'color out of range')
        else:
            require('NORMAL' in out, 'tangents require normals')
            require(all(abs(row[3]) == 1 for row in rows), 'tangent W must be +/-1')
            # X reflection flips tangent handedness; V reflection flips it again.
            rows = [[-x, y, z, row[3]] for row in rows for x, y, z in [unit(row[:3], 3, name)]]
        out[semantic] = rows
    submeshes = geometry['submeshes']
    require(submeshes and len(submeshes) <= 4096, 'empty/excessive submesh list')
    indices = []
    for triangles in submeshes:
        require(triangles, 'empty submesh')
        values = []
        for t in triangles:
            require(len(t) == 3 and all(type(i) is int and 0 <= i < len(p) for i in t), 'invalid triangle indices')
            require(len(set(t)) == 3, 'degenerate triangle indices')
            a, b, c = t
            values += [a, c, b]
        indices.append(values)
    if joint_count:
        require(0 < joint_count <= 65535, 'unsupported joint count')
        weights, joints = geometry.get('weights'), geometry.get('joints')
        require(weights is not None and joints is not None and len(weights) == len(p) == len(joints), 'missing/mismatched skin arrays')
        checked_w, checked_j = [], []
        for w, j in zip(weights, joints):
            w = floats(w, 4, 'weights')
            require(min(w) >= 0 and abs(sum(w)-1) <= .002, 'weights must sum to one and be nonnegative')
            require(len(j) == 4 and all(type(x) is int and 0 <= x < joint_count for x in j), 'joint index outside skin')
            checked_w.append([x/sum(w) for x in w]); checked_j.append(list(j))
        out['WEIGHTS_0'], out['JOINTS_0'] = checked_w, checked_j
    elif geometry.get('weights') is not None or geometry.get('joints') is not None:
        raise RecoveryError('skin data without an explicit renderer skin')
    return out, indices


class Builder:
    def __init__(self):
        self.binary = bytearray()
        self.doc = {'asset': {'version': '2.0', 'generator': 'apk-reverse-1 R3'},
                    'scene': 0, 'scenes': [], 'nodes': [], 'meshes': [],
                    'buffers': [], 'bufferViews': [], 'accessors': []}

    def view(self, raw, target=None):
        self.binary.extend(bytes(-len(self.binary) % 4))
        start = len(self.binary)
        require(start + len(raw) <= MAX_GLB, 'GLB binary budget exceeded')
        self.binary.extend(raw)
        item = {'buffer': 0, 'byteOffset': start, 'byteLength': len(raw)}
        if target:
            item['target'] = target
        self.doc['bufferViews'].append(item)
        return len(self.doc['bufferViews'])-1

    def accessor(self, rows, kind, component=5126, target=None, bounds=False):
        width = {'SCALAR': 1, 'VEC2': 2, 'VEC3': 3, 'VEC4': 4, 'MAT4': 16}[kind]
        flat = [v for row in rows for v in (row if isinstance(row, (list, tuple)) else [row])]
        require(len(flat) == len(rows)*width and rows, 'invalid accessor data')
        fmt = {5126: 'f', 5123: 'H', 5125: 'I'}[component]
        raw = struct.pack('<' + str(len(flat)) + fmt, *flat)
        item = {'bufferView': self.view(raw, target), 'componentType': component,
                'count': len(rows), 'type': kind}
        if bounds:
            quantized = struct.unpack('<' + str(len(flat)) + fmt, raw)
            item['min'] = [min(quantized[i::width]) for i in range(width)]
            item['max'] = [max(quantized[i::width]) for i in range(width)]
        self.doc['accessors'].append(item)
        return len(self.doc['accessors'])-1

    def material(self, material):
        color = floats(material.get('color', [1, 1, 1, 1]), 4, 'base color')
        require(all(0 <= x <= 1 for x in color), 'base color out of range')
        item = {'name': material['name'], 'pbrMetallicRoughness': {
            'baseColorFactor': color, 'metallicFactor': 0., 'roughnessFactor': 1.},
            'extras': {'unity_object_id': material['id'], 'fidelity': 'base-color preview, not original shader'}}
        if material.get('png') is not None:
            png = material['png']
            from PIL import Image
            with Image.open(io.BytesIO(png)) as img:
                require(img.format == 'PNG', 'texture must be PNG')
                img.verify()
            image = {'bufferView': self.view(png), 'mimeType': 'image/png',
                     'extras': {'sha256': digest(png)}}
            images = self.doc.setdefault('images', []); images.append(image)
            textures = self.doc.setdefault('textures', [])
            textures.append({'source': len(images)-1})
            item['pbrMetallicRoughness']['baseColorTexture'] = {'index': len(textures)-1}
        materials = self.doc.setdefault('materials', []); materials.append(item)
        return len(materials)-1

    def finish(self):
        require(self.doc['meshes'], 'model has no mesh renderers')
        self.doc['buffers'] = [{'byteLength': len(self.binary)}]
        js = json.dumps(self.doc, sort_keys=True, ensure_ascii=True, separators=(',', ':'), allow_nan=False).encode()
        js += b' ' * (-len(js) % 4)
        self.binary.extend(bytes(-len(self.binary) % 4))
        total = 12 + 8 + len(js) + 8 + len(self.binary)
        require(total <= MAX_GLB, 'GLB size budget exceeded')
        return (struct.pack('<III', 0x46546C67, 2, total) + struct.pack('<I4s', len(js), b'JSON') + js
                + struct.pack('<I4s', len(self.binary), b'BIN\x00') + self.binary)


def make_glb(model):
    nodes = model['nodes']
    require(0 < len(nodes) <= MAX_NODES, 'invalid node count')
    ids = [n['id'] for n in nodes]
    require(len(set(ids)) == len(ids), 'duplicate node identity')
    index = {oid: i for i, oid in enumerate(ids)}
    require(model['root'] in index, 'root absent')
    parents = {}
    for n in nodes:
        require(len(set(n['children'])) == len(n['children']), 'duplicate child')
        for c in n['children']:
            require(c in index and c not in parents and c != model['root'], 'missing/multiply-parented/root child')
            parents[c] = n['id']
    reached, pending = set(), [model['root']]
    while pending:
        n = pending.pop()
        require(n not in reached, 'cycle')
        reached.add(n); pending.extend(nodes[index[n]]['children'])
    require(len(reached) == len(nodes), 'disconnected/cyclic nodes')
    b = Builder()
    for n in nodes:
        t = floats(n['translation'], 3, 'translation')
        q = unit(n['rotation'], 4, 'rotation')
        s = floats(n['scale'], 3, 'scale')
        require(all(abs(x) > 1e-9 for x in s), 'singular node scale')
        dst = {'name': n['name'], 'translation': [-t[0], t[1], t[2]],
               'rotation': [q[0], -q[1], -q[2], q[3]], 'scale': s,
               'extras': {'unity_object_id': n['id']}}
        if n['children']:
            dst['children'] = [index[c] for c in n['children']]
        b.doc['nodes'].append(dst)
    b.doc['scenes'] = [{'nodes': [index[model['root']]], 'name': 'Recovered model (not gameplay)'}]
    material_indices, rendered = {}, set()
    for renderer in model['renderers']:
        nid = index.get(renderer['node'])
        require(nid is not None and nid not in rendered, 'missing node or multiple renderers on one node')
        rendered.add(nid)
        skin = renderer.get('skin')
        if skin:
            joints = skin['joints']
            require(joints and len(set(joints)) == len(joints) and all(j in index for j in joints), 'missing/duplicate/out-of-subtree joints')
            binds = skin['inverse_bind_matrices']
            require(len(joints) == len(binds), 'joint/bind matrix count mismatch')
        attributes, triangles = normalized_geometry(renderer['geometry'], len(skin['joints']) if skin else 0)
        accessors = {}
        for name, rows in attributes.items():
            accessors[name] = b.accessor(rows, {2: 'VEC2', 3: 'VEC3', 4: 'VEC4'}[len(rows[0])],
                                       5123 if name == 'JOINTS_0' else 5126, 34962, name == 'POSITION')
        materials = renderer['materials']
        require(len(materials) == len(triangles), 'material/submesh count mismatch')
        primitives = []
        for indices, material in zip(triangles, materials):
            require(not material.get('png') or 'TEXCOORD_0' in attributes, 'textured material without UV0')
            mid = material['id']
            if mid not in material_indices:
                material_indices[mid] = b.material(material)
            else:
                # Prevent one source identity silently selecting different material bytes.
                prior = next(m for r in model['renderers'] for m in r['materials'] if m['id'] == mid)
                require(prior == material, 'conflicting material identity')
            primitives.append({'attributes': dict(accessors), 'indices': b.accessor(indices, 'SCALAR', 5125, 34963),
                               'material': material_indices[mid], 'mode': 4})
        b.doc['meshes'].append({'name': renderer['name'], 'primitives': primitives,
                               'extras': {'unity_mesh_id': renderer['mesh_id'], 'unity_renderer_id': renderer['id']}})
        b.doc['nodes'][nid]['mesh'] = len(b.doc['meshes'])-1
        if skin:
            converted = [convert_matrix(m) for m in binds]
            column_major = [[m[r*4+c] for c in range(4) for r in range(4)] for m in converted]
            entry = {'joints': [index[j] for j in joints],
                     'inverseBindMatrices': b.accessor(column_major, 'MAT4')}
            if skin.get('root') is not None:
                require(skin['root'] in index, 'skeleton root outside subtree')
                for joint in joints:
                    ancestor = joint
                    while ancestor != skin['root'] and ancestor in parents:
                        ancestor = parents[ancestor]
                    require(ancestor == skin['root'], 'skeleton root is not an ancestor of every joint')
                entry['skeleton'] = index[skin['root']]
            skins = b.doc.setdefault('skins', []); skins.append(entry)
            b.doc['nodes'][nid]['skin'] = len(skins)-1
    b.doc['extras'] = {'recovery': {'input_sha256': model['input_sha256'], 'root_object_id': model['root'],
        'coordinate_conversion': 'X reflection; quaternion (x,-y,-z,w); C*bind*C; V flip; reversed triangles',
        'scope': 'hierarchy, triangle geometry, four-weight bind-pose skin, base-color material preview',
        'omitted_components': model.get('omitted_components', []),
        'animation_clips_exported': 0, 'material_shader_equivalence': False, 'gameplay_port_complete': False}}
    blob = b.finish()
    validate_glb(blob)
    return bytes(blob)


def unpack_glb(blob):
    require(28 <= len(blob) <= MAX_GLB, 'invalid GLB length')
    magic, version, size = struct.unpack_from('<III', blob)
    require(magic == 0x46546C67 and version == 2 and size == len(blob), 'invalid GLB header')
    pos, chunks = 12, []
    while pos < len(blob):
        require(pos+8 <= len(blob), 'short GLB chunk header')
        size, kind = struct.unpack_from('<I4s', blob, pos); pos += 8
        require(size % 4 == 0 and pos+size <= len(blob), 'invalid GLB chunk extent/alignment')
        chunks.append((kind, blob[pos:pos+size])); pos += size
    require(len(chunks) == 2 and [x[0] for x in chunks] == [b'JSON', b'BIN\x00'], 'expected JSON and BIN only')
    doc = json.loads(chunks[0][1])
    require(doc['asset']['version'] == '2.0', 'unsupported glTF version')
    require(len(doc['buffers']) == 1 and 'uri' not in doc['buffers'][0], 'external buffer unsupported')
    n = doc['buffers'][0]['byteLength']
    require(type(n) is int and n > 0 and 0 <= len(chunks[1][1])-n <= 3, 'bad BIN length')
    return doc, chunks[1][1][:n]


def read_accessor(doc, binary, aid):
    require(type(aid) is int and 0 <= aid < len(doc['accessors']), 'invalid accessor index')
    a = doc['accessors'][aid]
    vi = a['bufferView']
    require(type(vi) is int and 0 <= vi < len(doc['bufferViews']), 'invalid view index')
    v = doc['bufferViews'][vi]
    require('sparse' not in a and 'byteStride' not in v, 'unsupported packed accessor layout')
    count = a['count']; component = a['componentType']
    require(type(count) is int and count > 0 and component in (5123, 5125, 5126), 'invalid count/component')
    dims = {'SCALAR': 1, 'VEC2': 2, 'VEC3': 3, 'VEC4': 4, 'MAT4': 16}
    require(a['type'] in dims, 'unsupported accessor type')
    width = dims[a['type']]; size = 2 if component == 5123 else 4
    offset = a.get('byteOffset', 0); start = v.get('byteOffset', 0)
    require(type(offset) is int and offset >= 0 and offset % size == 0 and (offset+start) % 4 == 0, 'invalid accessor offset')
    require(offset+count*width*size <= v['byteLength'] and start+v['byteLength'] <= len(binary), 'accessor outside buffer')
    flat = struct.unpack_from('<' + str(count*width) + {5123:'H',5125:'I',5126:'f'}[component], binary, start+offset)
    require(all(math.isfinite(x) for x in flat), 'nonfinite accessor')
    return [list(flat[i:i+width]) for i in range(0, len(flat), width)]


def validate_glb(blob):
    """Validate the emitted subset; CI additionally runs the Khronos validator."""
    doc, binary = unpack_glb(blob)
    for view in doc['bufferViews']:
        offset, length = view.get('byteOffset', 0), view['byteLength']
        require(view['buffer'] == 0 and type(offset) is int and type(length) is int and
                offset >= 0 and offset % 4 == 0 and length > 0 and offset+length <= len(binary), 'invalid buffer view')
    values = [read_accessor(doc, binary, i) for i in range(len(doc['accessors']))]
    nodes = doc['nodes']
    require(0 < len(nodes) <= MAX_NODES, 'invalid nodes')
    parents, visited = {}, set()
    for i, node in enumerate(nodes):
        floats(node.get('translation', [0,0,0]), 3, 'translation')
        unit(node.get('rotation', [0,0,0,1]), 4, 'rotation')
        floats(node.get('scale', [1,1,1]), 3, 'scale')
        for child in node.get('children', []):
            require(type(child) is int and 0 <= child < len(nodes) and child not in parents, 'invalid child binding')
            parents[child] = i
    roots = doc['scenes'][doc['scene']]['nodes']
    require(roots and len(set(roots)) == len(roots) and all(type(i) is int and 0 <= i < len(nodes) and i not in parents for i in roots), 'invalid scene root')
    stack = list(roots)
    while stack:
        i = stack.pop(); require(i not in visited, 'node cycle'); visited.add(i)
        stack.extend(nodes[i].get('children', []))
    require(len(visited) == len(nodes), 'unreachable nodes')
    vertex_total = triangle_total = skin_count = 0
    for node in nodes:
        if 'mesh' not in node:
            continue
        mi = node['mesh']; require(type(mi) is int and 0 <= mi < len(doc['meshes']), 'invalid mesh reference')
        skin = None
        if 'skin' in node:
            sid = node['skin']; require(type(sid) is int and 0 <= sid < len(doc.get('skins', [])), 'invalid skin reference')
            skin = doc['skins'][sid]; joints = skin['joints']; skin_count += 1
            require(joints and len(set(joints)) == len(joints) and all(type(j) is int and 0 <= j < len(nodes) for j in joints), 'invalid skin joints')
            aid = skin['inverseBindMatrices']
            require(doc['accessors'][aid]['type'] == 'MAT4' and doc['accessors'][aid]['componentType'] == 5126, 'invalid bind accessor')
            require(len(values[aid]) == len(joints), 'bind count mismatch')
            for col in values[aid]:
                convert_matrix([col[c*4+r] for r in range(4) for c in range(4)])
        for primitive in doc['meshes'][mi]['primitives']:
            require(primitive.get('mode', 4) == 4, 'only triangle primitives supported')
            attrs = primitive['attributes']; p = attrs['POSITION']
            require(doc['accessors'][p]['type'] == 'VEC3' and doc['accessors'][p]['componentType'] == 5126, 'invalid POSITION')
            positions = values[p]; require(len(positions) >= 3, 'empty geometry')
            vertex_total += len(positions)
            for key in ('min', 'max'):
                actual = [(min if key == 'min' else max)(row[i] for row in positions) for i in range(3)]
                require(doc['accessors'][p].get(key) == actual, 'position bounds mismatch')
            require(all(len(values[aid]) == len(positions) for aid in attrs.values()), 'attribute count mismatch')
            idx = primitive['indices']; ia = doc['accessors'][idx]
            require(ia['type'] == 'SCALAR' and ia['componentType'] in (5123,5125), 'invalid index accessor')
            indices = [x[0] for x in values[idx]]
            require(indices and len(indices)%3 == 0 and all(0 <= i < len(positions) for i in indices), 'invalid mesh indices')
            triangle_total += len(indices)//3
            require(0 <= primitive['material'] < len(doc.get('materials', [])), 'invalid material')
            for semantic, width in (('NORMAL',3), ('TANGENT',4)):
                if semantic in attrs:
                    for row in values[attrs[semantic]]:
                        require(len(row) == width, 'invalid normal/tangent width')
                        unit(row[:3], 3, semantic)
            if skin:
                require('JOINTS_0' in attrs and 'WEIGHTS_0' in attrs, 'skin attributes missing')
                js, ws = doc['accessors'][attrs['JOINTS_0']], doc['accessors'][attrs['WEIGHTS_0']]
                require(js['componentType'] == 5123 and js['type'] == 'VEC4' and ws['type'] == 'VEC4' and ws['componentType'] == 5126, 'invalid skin attribute types')
                for j, w in zip(values[attrs['JOINTS_0']], values[attrs['WEIGHTS_0']]):
                    require(all(x < len(skin['joints']) for x in j) and min(w) >= 0 and abs(sum(w)-1) < .002, 'invalid skin weights/joints')
    require(triangle_total > 0, 'no triangles')
    for image in doc.get('images', []):
        require('uri' not in image and image['mimeType'] == 'image/png', 'external/non-PNG image')
        v = doc['bufferViews'][image['bufferView']]
        from PIL import Image
        with Image.open(io.BytesIO(binary[v['byteOffset']:v['byteOffset']+v['byteLength']])) as img:
            img.verify()
    return {'nodes': len(nodes), 'mesh_instances': sum('mesh' in n for n in nodes),
            'vertices_across_primitives': vertex_total, 'triangles': triangle_total,
            'skinned_instances': skin_count, 'images': len(doc.get('images', [])),
            'gameplay_port_complete': False}
