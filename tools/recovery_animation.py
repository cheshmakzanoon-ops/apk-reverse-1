"""Conservative Unity legacy TRS-curve to glTF animation conversion.

Only explicit, uncompressed, unweighted component-Hermite curves are accepted.
This never executes scripts/events, guesses hashed bindings, or samples a missing
curve. A selected clip/root association is explicit, not proof of runtime use.
"""
from __future__ import annotations

import bisect
import math
import re
import struct

from gltf_model import Builder, floats, require, unpack_glb, read_accessor, validate_glb

MAX_CLIPS = 128
MAX_CHANNELS = 4096
MAX_KEYS = 250_000
FIELDS = {'m_PositionCurves': ('translation', 'xyz'),
          'm_RotationCurves': ('rotation', 'xyzw'),
          'm_ScaleCurves': ('scale', 'xyz')}


def number(value, label):
    require(type(value) in (int, float) and math.isfinite(value), label + ': invalid number')
    require(abs(value) <= 3.4028234e38, label + ': outside float32')
    return struct.unpack('<f', struct.pack('<f', value))[0]


def vector(value, axes, label):
    require(isinstance(value, dict) and set(value) == set(axes), label + ': invalid vector')
    return [number(value[a], label) for a in axes]


def path_index(model, binding_root):
    """Relative Unity transform paths, without global-basename guesses."""
    nodes = {n['id']: n for n in model['nodes']}
    require(binding_root in nodes, 'animation root is outside exported hierarchy')
    paths, seen, pending = {}, set(), [(binding_root, '')]
    while pending:
        oid, path = pending.pop()
        require(oid not in seen, 'animation hierarchy contains a cycle or shared child')
        seen.add(oid)
        paths.setdefault(path, []).append(oid)
        for child in reversed(nodes[oid]['children']):
            require(child in nodes, 'animation hierarchy child is missing')
            name = nodes[child]['name']
            require(isinstance(name, str) and name and '/' not in name and '\\' not in name
                    and name not in ('.', '..'), 'ambiguous Unity transform path component')
            pending.append((child, path + '/' + name if path else name))
    return paths


def controls(channel, i):
    dt = channel['times'][i+1] - channel['times'][i]
    a, b = channel['values'][i:i+2]
    return [a, [v+dt*m/3 for v, m in zip(a, channel['out'][i])],
            [v-dt*m/3 for v, m in zip(b, channel['in'][i+1])], b]


def check_channel(channel):
    kind = channel['path']
    require(kind in ('translation', 'rotation', 'scale'), 'unsupported animation target')
    width = 4 if kind == 'rotation' else 3
    times = channel['times']
    require(0 < len(times) <= MAX_KEYS, 'empty or oversized animation curve')
    require(all(type(t) in (int, float) and math.isfinite(t) and 0 <= t <= 86400 for t in times),
            'animation time outside supported one-day range')
    require(all(a < b for a, b in zip(times, times[1:])), 'animation times must be strictly increasing')
    for key in ('values', 'in', 'out'):
        require(len(channel[key]) == len(times), 'animation key/tangent count mismatch')
        for row in channel[key]:
            floats(row, width, 'animation ' + key)
    if kind == 'rotation':
        require(all(abs(sum(x*x for x in q)-1) <= .0001 for q in channel['values']),
                'rotation key is not a unit quaternion')
    for i in range(len(times)-1):
        points = controls(channel, i)
        require(all(math.isfinite(v) and abs(v) <= 3.4028234e38 for p in points for v in p),
                'animation curve control hull exceeds numeric range')
        if kind == 'rotation':
            # A common positive separating direction for the Bezier control hull
            # proves that the entire Hermite quaternion segment avoids zero.
            anchor = [a+b for a,b in zip(points[0], points[-1])]
            require(all(sum(a*b for a,b in zip(p,anchor)) > 1e-6 for p in points),
                    'quaternion segment may reach zero or cross hemispheres; unsupported')
        elif kind == 'scale':
            require(all(all(p[j] > 1e-9 for p in points) or all(p[j] < -1e-9 for p in points)
                        for j in range(3)), 'scale curve may cross zero; unsupported')
    if kind == 'scale':
        require(all(abs(v) > 1e-9 for row in channel['values'] for v in row), 'singular animation scale')


def decode_clip(tree, clip_id, raw_sha, model, binding_root=None):
    require(isinstance(tree, dict), 'clip typetree is unavailable')
    require(re.fullmatch('[0-9a-f]{64}', clip_id or '') and re.fullmatch('[0-9a-f]{64}', raw_sha or ''),
            'clip identity and source hash are required')
    require(tree.get('m_Legacy') is True, 'Mecanim/humanoid/hashed animation bindings are not supported')
    require(tree.get('m_Compressed') is False, 'compressed animation is not supported')
    require(tree.get('m_MuscleClipSize', 0) == 0, 'muscle/streamed clip payload is not supported')
    for field in ('m_CompressedRotationCurves', 'm_EulerCurves', 'm_FloatCurves', 'm_PPtrCurves', 'm_Events'):
        require(not tree.get(field), field + ' is unsupported; refusing a partial animation')
    binding_root = binding_root or model['root']
    paths = path_index(model, binding_root)
    channels, targets, key_count = [], set(), 0
    for field, (kind, axes) in FIELDS.items():
        curves = tree.get(field, [])
        require(isinstance(curves, list), 'invalid ' + field)
        require(len(channels)+len(curves) <= MAX_CHANNELS, 'animation channel budget exceeded')
        for item in curves:
            require(isinstance(item, dict), 'invalid curve entry')
            path = item.get('path')
            require(isinstance(path, str), 'curve path is not a string')
            matches = paths.get(path, [])
            require(len(matches) == 1, 'missing or ambiguous animation path: ' + repr(path))
            node = matches[0]
            require((node, kind) not in targets, 'duplicate animation target')
            targets.add((node, kind))
            curve = item.get('curve')
            require(isinstance(curve, dict), 'missing animation curve')
            require(curve.get('m_PreInfinity') == 2 and curve.get('m_PostInfinity') == 2,
                    'non-clamped curve infinity modes are unsupported')
            keys = curve.get('m_Curve')
            require(isinstance(keys, list) and keys, 'empty animation key array')
            key_count += len(keys)
            require(key_count <= MAX_KEYS, 'animation key budget exceeded')
            channel = dict(node=node, path=kind, unity_path=path, times=[], values=[], **{'in': [], 'out': []})
            for key in keys:
                require(isinstance(key, dict) and type(key.get('weightedMode', 0)) is int
                        and key.get('weightedMode', 0) == 0, 'weighted animation tangents are unsupported')
                channel['times'].append(number(key.get('time'), 'key time'))
                for target, source in (('values','value'), ('in','inSlope'), ('out','outSlope')):
                    channel[target].append(vector(key.get(source), axes, source))
            check_channel(channel)
            channels.append(channel)
    require(channels and max(c['times'][-1] for c in channels) > 0, 'clip has no positive-duration supported curves')
    return {'id': clip_id, 'name': 'Recovered_' + clip_id, 'original_name': tree.get('m_Name', ''),
            'source_sha256': raw_sha, 'binding_root': binding_root, 'channels': channels,
            'source_wrap_mode': tree.get('m_WrapMode'), 'source_sample_rate': tree.get('m_SampleRate'),
            'scope': 'one cycle; explicit legacy TRS curves; source events rejected; runtime controller not reconstructed'}


def evaluate(channel, time):
    """Component Hermite interpolation in Unity coordinates, normalized for rotation."""
    times = channel['times']
    if time <= times[0]:
        value = list(channel['values'][0])
    elif time >= times[-1]:
        value = list(channel['values'][-1])
    else:
        i = bisect.bisect_right(times, time)-1
        dt = times[i+1]-times[i]; u = (time-times[i])/dt
        h00, h10, h01, h11 = 2*u**3-3*u*u+1, u**3-2*u*u+u, -2*u**3+3*u*u, u**3-u*u
        value = [h00*a+h10*dt*x+h01*b+h11*dt*y for a,x,b,y in
                 zip(channel['values'][i], channel['out'][i], channel['values'][i+1], channel['in'][i+1])]
    if channel['path'] == 'rotation':
        n = math.sqrt(sum(x*x for x in value))
        require(n > 1e-8, 'zero interpolated quaternion')
        value = [x/n for x in value]
    return value


def convert(row, kind):
    # Tangents use the same *linear* basis map; never normalize tangents.
    signs = [1,-1,-1,1] if kind == 'rotation' else [-1,1,1] if kind == 'translation' else [1,1,1]
    return [x*s for x,s in zip(row, signs)]


def append_clips(blob, clips):
    validate_glb(blob)
    require(isinstance(clips, list) and 0 < len(clips) <= MAX_CLIPS, 'invalid clip count')
    doc, binary = unpack_glb(blob)
    require(not doc.get('animations'), 'refusing to replace existing animations')
    ids = [c['id'] for c in clips]
    require(len(set(ids)) == len(ids), 'duplicate clip identity')
    index = {n['extras']['unity_object_id']: i for i,n in enumerate(doc['nodes'])}
    builder = Builder(); builder.doc = doc; builder.binary = bytearray(binary)
    doc['animations'] = []
    total_keys = 0
    for clip in clips:
        animation = {'name': clip['name'], 'channels': [], 'samplers': [],
                     'extras': {k:v for k,v in clip.items() if k != 'channels'}}
        require(0 < len(clip['channels']) <= MAX_CHANNELS, 'invalid animation channel count')
        targets = set()
        for channel in clip['channels']:
            check_channel(channel)
            total_keys += len(channel['times'])
            require(total_keys <= MAX_KEYS, 'combined animation key budget exceeded')
            node, kind = channel['node'], channel['path']
            require(node in index and (node,kind) not in targets, 'invalid or duplicate animation target')
            targets.add((node,kind))
            interpolation = channel.get('interpolation', 'CUBICSPLINE' if len(channel['times']) > 1 else 'STEP')
            require(interpolation != 'LINEAR' or kind == 'rotation', 'only rotation uses a sampled derivative')
            rows = [convert(row,kind) for i in range(len(channel['times']))
                    for row in ([channel['in'][i], channel['values'][i], channel['out'][i]]
                                if interpolation == 'CUBICSPLINE' else [channel['values'][i]])]
            sampler = {'input': builder.accessor(channel['times'], 'SCALAR', bounds=True),
                       'output': builder.accessor(rows, 'VEC4' if kind == 'rotation' else 'VEC3'),
                       'interpolation': interpolation}
            animation['channels'].append({'sampler': len(animation['samplers']),
                'target': {'node': index[node], 'path': kind}, 'extras': {'unity_path': channel['unity_path']}})
            animation['samplers'].append(sampler)
        doc['animations'].append(animation)
    doc['asset']['generator'] = 'apk-reverse-1 verified animation bridge'
    doc['extras']['recovery']['animation_clips_exported'] = len(clips)
    doc['extras']['recovery']['animation_runtime_equivalence_verified'] = False
    result = bytes(builder.finish())
    validate_animated_glb(result, allow_linear_rotation=True)
    return result


def validate_animated_glb(blob, *, allow_linear_rotation=False):
    """Validate the emitted animation subset independently of the source collector."""
    counts = validate_glb(blob)
    doc, binary = unpack_glb(blob)
    clips = doc.get('animations', [])
    require(0 < len(clips) <= MAX_CLIPS, 'missing or excessive animations')
    names, channel_count, total_keys = set(), 0, 0
    for clip in clips:
        require(clip.get('name') and clip['name'] not in names, 'duplicate or empty animation name')
        names.add(clip['name'])
        channels, samplers = clip['channels'], clip['samplers']
        require(0 < len(channels) <= MAX_CHANNELS and len(samplers) == len(channels), 'invalid animation channel/sampler count')
        targets, used = set(), set()
        for entry in channels:
            sid = entry['sampler']
            require(type(sid) is int and 0 <= sid < len(samplers) and sid not in used, 'invalid animation sampler index')
            used.add(sid)
            target = entry['target']; node, kind = target['node'], target['path']
            require(type(node) is int and 0 <= node < len(doc['nodes']) and 'matrix' not in doc['nodes'][node], 'invalid animation node')
            require(kind in ('translation','rotation','scale') and (node,kind) not in targets, 'invalid/duplicate animation target')
            targets.add((node,kind)); sampler = samplers[sid]
            times = read_accessor(doc,binary,sampler['input'])
            output = read_accessor(doc,binary,sampler['output'])
            ai, ao = doc['accessors'][sampler['input']], doc['accessors'][sampler['output']]
            require(ai['componentType'] == ao['componentType'] == 5126 and ai['type'] == 'SCALAR'
                    and ao['type'] == ('VEC4' if kind == 'rotation' else 'VEC3'), 'invalid animation accessor type')
            require(not ai.get('normalized') and not ao.get('normalized'), 'normalized float animation accessor')
            require('target' not in doc['bufferViews'][ai['bufferView']] and
                    'target' not in doc['bufferViews'][ao['bufferView']], 'animation data cannot be a vertex/index buffer')
            times = [v[0] for v in times]
            require(ai.get('min') == [min(times)] and ai.get('max') == [max(times)], 'animation time bounds mismatch')
            interpolation = sampler['interpolation']
            require(interpolation in ('CUBICSPLINE','STEP') or
                    (allow_linear_rotation and kind == 'rotation' and interpolation == 'LINEAR'), 'unsupported emitted interpolation')
            if interpolation == 'CUBICSPLINE':
                require(len(times) >= 2 and len(output) == 3*len(times), 'invalid cubic output count')
                incoming, values, outgoing = output[::3], output[1::3], output[2::3]
            elif interpolation == 'LINEAR':
                require(len(times) == len(output) and len(times) >= 2, 'invalid baked rotation key count')
                values = output; incoming = outgoing = [[0]*4 for _ in times]
            else:
                require(len(times) == len(output) == 1, 'STEP is reserved for single-key constant channels')
                values = output; incoming = outgoing = [[0]*len(output[0])]
            check_channel(dict(path=kind,times=times,values=values,**{'in':incoming,'out':outgoing}))
            channel_count += 1; total_keys += len(times)
            require(total_keys <= MAX_KEYS, 'animation key budget exceeded')
    return {**counts, 'animations': len(clips), 'animation_channels': channel_count, 'animation_keys': total_keys}
