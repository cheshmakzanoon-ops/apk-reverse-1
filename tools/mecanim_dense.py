"""Decode the explicit generic dense/constant TRS subset of Unity Mecanim clips.

Hashed paths are matched against the selected subtree with collision detection.
Streamed curves, humanoid/root-motion payloads and events remain hard blockers.
The export preserves dense samples; Unity runtime/controller equivalence is not
claimed. Inter-sample component interpolation is an explicit conversion contract.
"""
from __future__ import annotations

import math
import re
import zlib

from gltf_model import require
from recovery_animation import check_channel, number, path_index

ATTRIBUTES = {1: ('translation', 3), 2: ('rotation', 4), 3: ('scale', 3)}
MAX_SAMPLES = 2_000_000


def hashed_paths(model, binding_root, hash_fn=None):
    hash_fn = hash_fn or (lambda text: zlib.crc32(text.encode('utf-8')))
    result = {}
    for path, nodes in path_index(model, binding_root).items():
        result.setdefault(hash_fn(path), []).extend((path, node) for node in nodes)
    return result


def integer(value, label, maximum=MAX_SAMPLES):
    require(type(value) is int and 0 <= value <= maximum, label + ': invalid count')
    return value


def clip_payload(tree):
    require(tree.get('m_Legacy') is False, 'expected non-legacy generic clip')
    require(tree.get('m_Compressed') is False, 'compressed rotation unsupported')
    for key in ('m_RotationCurves', 'm_CompressedRotationCurves', 'm_EulerCurves',
                'm_PositionCurves', 'm_ScaleCurves', 'm_FloatCurves', 'm_PPtrCurves', 'm_Events'):
        require(not tree.get(key), key + ': additional curve/event data unsupported')
    require(not tree.get('m_HasGenericRootTransform') and not tree.get('m_HasMotionFloatCurves'),
            'root-motion/motion-float data unsupported')
    muscle = tree.get('m_MuscleClip')
    require(isinstance(muscle, dict), 'missing muscle clip container')
    require(not muscle.get('m_Mirror') and muscle.get('m_CycleOffset', 0) == 0,
            'mirrored/offset animation unsupported')
    start = number(muscle.get('m_StartTime'), 'clip start')
    stop = number(muscle.get('m_StopTime'), 'clip stop')
    require(start == 0 and 0 < stop <= 86400, 'unsupported clip time interval')
    payload = muscle.get('m_Clip', {}).get('data')
    require(isinstance(payload, dict), 'missing generic curve payload')
    stream = payload.get('m_StreamedClip', {})
    require(stream.get('curveCount') == 0 and stream.get('data') == [0x7f800000, 0],
            'streamed curves require a separate decoder')
    dense = payload.get('m_DenseClip'); constant = payload.get('m_ConstantClip', {}).get('data')
    require(isinstance(dense, dict) and isinstance(constant, list), 'missing dense/constant payload')
    frames = integer(dense.get('m_FrameCount'), 'dense frames')
    count = integer(dense.get('m_CurveCount'), 'dense curves', 16384)
    samples = dense.get('m_SampleArray')
    require(isinstance(samples, list) and frames * count == len(samples) <= MAX_SAMPLES,
            'dense frame/curve product differs from sample count')
    require(len(constant) <= 16384, 'constant curve budget exceeded')
    samples = [number(x, 'dense sample') for x in samples]
    constant = [number(x, 'constant sample') for x in constant]
    rate = number(dense.get('m_SampleRate'), 'sample rate')
    begin = number(dense.get('m_BeginTime'), 'dense begin')
    require(0 < rate <= 1000 and begin == 0 and frames >= 2, 'unsupported dense sample timing')
    require((frames-1)/rate >= stop-1e-6, 'dense samples do not cover clip duration')
    bindings = tree.get('m_ClipBindingConstant', {})
    require(not bindings.get('pptrCurveMapping'), 'PPtr bindings unsupported')
    bindings = bindings.get('genericBindings')
    require(isinstance(bindings, list) and 0 < len(bindings) <= 4096, 'invalid binding table')
    return stop, rate, frames, count, samples, constant, bindings


def decode_dense(tree, clip_id, raw_sha, model, binding_root=None):
    require(isinstance(tree, dict), 'missing clip typetree')
    require(re.fullmatch('[0-9a-f]{64}', clip_id or '') and re.fullmatch('[0-9a-f]{64}', raw_sha or ''),
            'clip identity and byte hash are required')
    stop, rate, frames, dense_count, samples, constant, bindings = clip_payload(tree)
    binding_root = binding_root or model['root']
    paths = hashed_paths(model, binding_root)
    channels = []; cursor = 0; used = set()
    for binding in bindings:
        require(isinstance(binding, dict) and binding.get('typeID') == 4
                and binding.get('customType') == 0 and binding.get('isPPtrCurve') == 0
                and binding.get('script', {}).get('m_PathID', 0) == 0,
                'only non-script Transform bindings are supported')
        attribute = binding.get('attribute')
        require(type(attribute) is int and attribute in ATTRIBUTES, 'non-TRS Transform attribute unsupported')
        kind, width = ATTRIBUTES[attribute]
        path_hash = binding.get('path')
        require(type(path_hash) is int and 0 <= path_hash <= 0xffffffff, 'invalid path hash')
        matches = paths.get(path_hash, [])
        require(len(matches) == 1, 'missing or colliding hashed animation path: ' + str(path_hash))
        path, node = matches[0]
        require((node, kind) not in used, 'duplicate generic animation target')
        used.add((node, kind))
        channel = {'node': node, 'path': kind, 'unity_path': path, 'unity_path_crc32': path_hash}
        if cursor < dense_count:
            require(cursor+width <= dense_count, 'binding crosses dense/constant boundary')
            times = [number(i/rate, 'dense time') for i in range(frames) if i/rate < stop]
            if not times or times[-1] != stop:
                times.append(stop)
            def sample(t):
                position = t*rate; lo = min(int(position), frames-1)
                hi = min(lo+1, frames-1); u = position-lo
                return [(1-u)*samples[lo*dense_count+cursor+j]+u*samples[hi*dense_count+cursor+j]
                        for j in range(width)]
            values = [sample(t) for t in times]
        else:
            offset = cursor-dense_count
            require(offset+width <= len(constant), 'constant binding outside payload')
            times, values = [0.0], [constant[offset:offset+width]]
        if kind == 'rotation':
            for i, q in enumerate(values):
                norm = math.sqrt(sum(x*x for x in q))
                require(abs(norm-1) <= .002, 'dense quaternion is not near unit length')
                values[i] = [number(x/norm, 'quaternion') for x in q]
        incoming = [[0.0]*width for _ in times]; outgoing = [[0.0]*width for _ in times]
        for i in range(len(times)-1):
            dt = times[i+1]-times[i]
            require(dt > 0, 'float32 sample timestamps collided')
            slope = [(b-a)/dt for a,b in zip(values[i],values[i+1])]
            outgoing[i] = slope; incoming[i+1] = slope
        channel.update(times=times, values=values, **{'in': incoming, 'out': outgoing})
        check_channel(channel); channels.append(channel); cursor += width
    require(cursor == dense_count+len(constant), 'unbound scalar curves remain in payload')
    return {'id': clip_id, 'name': 'Recovered_'+clip_id, 'original_name': tree.get('m_Name', ''),
            'source_sha256': raw_sha, 'binding_root': binding_root, 'channels': channels,
            'source_sample_rate': rate, 'source_frame_count': frames, 'duration': stop,
            'dense_scalars': dense_count, 'constant_scalars': len(constant),
            'scope': 'generic dense/constant local TRS; no streamed curves, events, root motion or controller',
            'interpolation_contract': 'component-linear between dense keys; normalized quaternion values',
            'animation_runtime_equivalence_verified': False}
