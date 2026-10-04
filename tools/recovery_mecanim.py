"""Decode the generic Transform subset of Unity's packed non-legacy clips.

Preserve dense samples, constant values and streamed cubic coefficients. Bind only
CRC32s of exact paths relative to an explicitly selected Transform. Humanoid,
Euler, property, event and root-motion tracks are deliberately not guessed.
Quaternion output is a measured LINEAR/slerp derivative of normalized component
curves, not a claim of equivalence to Unity's Animator/controller runtime.
"""
from __future__ import annotations

import bisect
import math
import re
import struct
import zlib
from dataclasses import dataclass

from gltf_model import require
from recovery_animation import MAX_CHANNELS, MAX_KEYS, number, path_index, check_channel, controls

MAX_WORDS = 5_000_000
MAX_SAMPLES = 5_000_000
KINDS = {1: ('translation', 3), 2: ('rotation', 4), 3: ('scale', 3)}


def uint(value, label, maximum=2**32-1):
    require(type(value) is int and 0 <= value <= maximum, label + ': invalid unsigned integer')
    return value


def finite(value, label):
    require(type(value) in (float, int) and math.isfinite(value), label + ': nonfinite number')
    require(abs(value) <= 3.4028234663852886e38, label + ': outside float32')
    return float(value)


@dataclass
class Scalar:
    times: list[float]
    values: list[float]
    mode: str
    coefficients: list[list[float]] | None = None

    def at(self, t, *, side='right'):
        """Return a value and the one-sided derivative in source coordinates."""
        if len(self.times) == 1 or t < self.times[0] or t > self.times[-1]:
            return (self.values[0] if t <= self.times[0] else self.values[-1]), 0.
        if self.mode == 'constant':
            return self.values[0], 0.
        choose = bisect.bisect_left if side == 'left' else bisect.bisect_right
        i = choose(self.times, t)-1
        if i < 0:
            return self.values[0], 0.
        if i >= len(self.times)-1:
            return self.values[-1], 0.
        dt = t-self.times[i]
        if self.mode == 'dense':
            slope = (self.values[i+1]-self.values[i])/(self.times[i+1]-self.times[i])
            return self.values[i]+dt*slope, slope
        a, b, c, d = self.coefficients[i]
        return ((a*dt+b)*dt+c)*dt+d, (3*a*dt+2*b)*dt+c


def streamed(value):
    """Read every word; sentinel frames are metadata, never animation key times."""
    require(isinstance(value, dict), 'streamed clip absent')
    count = uint(value.get('curveCount'), 'stream curve count', MAX_CHANNELS*4)
    words = value.get('data')
    require(isinstance(words, list) and len(words) <= MAX_WORDS, 'stream word budget exceeded')
    for word in words:
        uint(word, 'stream word')
    raw = struct.pack('<' + str(len(words)) + 'I', *words)
    offset, last, terminal, frames = 0, -math.inf, False, 0
    keys = [[] for _ in range(count)]
    while offset < len(raw):
        require(len(raw)-offset >= 8, 'truncated streamed frame')
        time, n = struct.unpack_from('<fi', raw, offset); offset += 8
        require(not terminal and not math.isnan(time) and time > last, 'unordered streamed frames')
        require(0 <= n <= count and n*20 <= len(raw)-offset, 'invalid streamed key count')
        sentinel = time == -3.4028234663852886e38
        terminal = time == math.inf
        require(time != -math.inf and (time >= 0 or sentinel and frames == 0), 'invalid streamed sentinel/time')
        require(not terminal or n == 0 and offset == len(raw), 'invalid terminal streamed frame')
        seen = set()
        for _ in range(n):
            index, a, b, c, d = struct.unpack_from('<i4f', raw, offset); offset += 20
            require(0 <= index < count and index not in seen, 'duplicate/out-of-range streamed key index')
            seen.add(index)
            coeff = [finite(x, 'stream coefficient') for x in (a,b,c,d)]
            if not sentinel:
                keys[index].append((time, coeff))
        last = time; frames += 1
    require(terminal or not words and count == 0, 'stream is missing terminal sentinel')
    result, maximum_jump = [], 0.
    for track in keys:
        require(track and len(track) <= MAX_KEYS, 'streamed scalar has no finite keys or exceeds budget')
        for (left, coeff), (right, rhs) in zip(track, track[1:]):
            dt = right-left
            expected = ((coeff[0]*dt+coeff[1])*dt+coeff[2])*dt+coeff[3]
            jump = abs(expected-rhs[3]); maximum_jump = max(maximum_jump, jump)
            # Discontinuous/stepped channels cannot be silently smoothed in glTF.
            require(jump <= 1e-5*max(1., abs(expected), abs(rhs[3])), 'discontinuous streamed segment is unsupported')
        result.append(Scalar([t for t,_ in track], [c[3] for _,c in track],
                             'streamed', [c for _,c in track]))
    return result, {'frames': frames, 'curves': count, 'max_endpoint_residual': maximum_jump}


def scalar_tracks(body):
    require(isinstance(body, dict), 'packed clip body absent')
    expected = {'m_StreamedClip', 'm_DenseClip', 'm_ConstantClip', 'm_Binding'}
    require(not set(body)-expected, 'unsupported packed clip field')
    require(not body.get('m_Binding'), 'alternate packed binding map unsupported')
    result, detail = streamed(body.get('m_StreamedClip'))
    dense = body.get('m_DenseClip')
    require(isinstance(dense, dict), 'dense clip absent')
    count = uint(dense.get('m_CurveCount'), 'dense curve count', MAX_CHANNELS*4)
    frames = uint(dense.get('m_FrameCount'), 'dense frame count', MAX_SAMPLES)
    samples = dense.get('m_SampleArray')
    require(isinstance(samples, list) and len(samples) == frames*count <= MAX_SAMPLES,
            'dense sample layout/count mismatch')
    begin = finite(dense.get('m_BeginTime'), 'dense begin')
    rate = finite(dense.get('m_SampleRate'), 'dense sample rate')
    require(begin >= 0 and (count == 0 or frames > 0 and rate > 0), 'invalid dense timing')
    for x in samples:
        finite(x, 'dense sample')
    if count:
        ideal_times = [begin+i/rate for i in range(frames)]
        times = [number(t, 'dense key time') for t in ideal_times]
        require(all(a < b for a,b in zip(times,times[1:])), 'dense times collapse at float32 precision')
        detail['max_dense_timestamp_quantization_seconds'] = max(abs(a-b) for a,b in zip(times,ideal_times))
        require(times[-1] <= 86400, 'dense duration budget exceeded')
        result.extend(Scalar(times, samples[j::count], 'dense') for j in range(count))
    constant = body.get('m_ConstantClip')
    require(isinstance(constant, dict) and isinstance(constant.get('data'), list), 'constant clip absent')
    require(len(constant['data']) <= MAX_CHANNELS*4, 'constant budget exceeded')
    result.extend(Scalar([0.], [finite(x, 'constant sample')], 'constant') for x in constant['data'])
    detail.update(dense_curves=count, dense_frames=frames, constant_curves=len(constant['data']))
    return result, detail


def quaternion(values):
    norm = math.sqrt(sum(x*x for x in values))
    require(.25 <= norm <= 4., 'zero or implausibly scaled packed quaternion')
    return [x/norm for x in values]


def slerp(a, b, u):
    dot = sum(x*y for x,y in zip(a,b))
    if dot < 0:
        b = [-x for x in b]; dot = -dot
    if dot > .9995:
        return quaternion([x+(y-x)*u for x,y in zip(a,b)])
    angle = math.acos(max(-1., min(1., dot)))
    return [(math.sin((1-u)*angle)*x+math.sin(u*angle)*y)/math.sin(angle) for x,y in zip(a,b)]


def angular_error(a, b):
    # Chord formulation is stable for the small errors measured by the baker.
    distance = min(math.sqrt(sum((x-y)**2 for x,y in zip(a,b))),
                   math.sqrt(sum((x+y)**2 for x,y in zip(a,b))))
    return 4*math.asin(min(1., distance/2))


def bake_rotation(parts, start, stop, boundaries, *, rate=120, tolerance=1e-4):
    require(type(rate) is int and 1 <= rate <= 480 and 0 < tolerance <= .01, 'invalid rotation bake settings')
    evaluate = lambda t: quaternion([s.at(t)[0] for s in parts])
    n = math.ceil((stop-start)*rate)
    require(n+len(boundaries)+1 <= MAX_KEYS, 'rotation bake budget exceeded')
    times = sorted({number(t-start, 'baked time') for t in boundaries} |
                   {number((stop-start)*i/max(1,n), 'baked time') for i in range(n+1)})
    require(times[0] == 0 and times[-1] > 0, 'invalid baked interval')
    output, errors = [(times[0],evaluate(start))], []
    def interval(a, qa, b, qb, depth=0):
        probes = [a+(b-a)*u for u in (.25,.5,.75)]
        worst = max(angular_error(evaluate(start+t), slerp(qa,qb,(t-a)/(b-a))) for t in probes)
        if worst > tolerance:
            mid = number((a+b)/2, 'adaptive time')
            require(depth < 16 and a < mid < b, 'adaptive bake precision/depth exhausted')
            qm = evaluate(start+mid)
            interval(a,qa,mid,qm,depth+1); interval(mid,qm,b,qb,depth+1)
        else:
            require(len(output) < MAX_KEYS, 'rotation key budget exceeded')
            errors.append(worst);output.append((b,qb))
    for a,b in zip(times,times[1:]):
        interval(a,evaluate(start+a),b,evaluate(start+b))
    return [p[0] for p in output], [p[1] for p in output], max(errors,default=0.)


def decode_mecanim(tree, clip_id, raw_sha, model, binding_root=None):
    require(isinstance(tree, dict) and tree.get('m_Legacy') is False, 'expected a non-legacy AnimationClip')
    require(re.fullmatch('[0-9a-f]{64}',clip_id or '') and re.fullmatch('[0-9a-f]{64}',raw_sha or ''), 'clip hashes required')
    require(tree.get('m_Compressed') is False, 'compressed rotation container unsupported')
    for field in ('m_RotationCurves','m_CompressedRotationCurves','m_PositionCurves','m_ScaleCurves',
                  'm_EulerCurves','m_FloatCurves','m_PPtrCurves','m_Events'):
        require(not tree.get(field), field + ': refusing a partial packed clip')
    require(not tree.get('m_HasGenericRootTransform') and not tree.get('m_HasMotionFloatCurves'),
            'root-motion/motion curves require separate recovery')
    muscle = tree.get('m_MuscleClip')
    require(isinstance(muscle, dict), 'muscle clip unavailable')
    require(not any(muscle.get(x) for x in ('m_Mirror','m_LoopBlend','m_LoopBlendOrientation',
                'm_LoopBlendPositionY','m_LoopBlendPositionXZ')), 'mirrored/blended clip unsupported')
    start, stop = finite(muscle.get('m_StartTime'),'clip start'),finite(muscle.get('m_StopTime'),'clip stop')
    require(0 <= start < stop <= 86400, 'invalid source clip interval')
    packed = muscle.get('m_Clip')
    require(isinstance(packed,dict) and set(packed) == {'data'}, 'unsupported clip wrapper')
    scalars, layout = scalar_tracks(packed['data'])
    binding = tree.get('m_ClipBindingConstant')
    require(isinstance(binding,dict) and not binding.get('pptrCurveMapping'), 'object-reference curve mapping unsupported')
    bindings = binding.get('genericBindings')
    require(isinstance(bindings,list) and 0 < len(bindings) <= MAX_CHANNELS, 'invalid generic binding count')
    binding_root = binding_root or model['root']
    hashed = {}
    for path, nodes in path_index(model,binding_root).items():
        for node in nodes:
            hashed.setdefault(zlib.crc32(path.encode('utf-8')),[]).append((path,node))
    channels, used, cursor, bake_error = [], set(), 0, 0.
    for b in bindings:
        require(isinstance(b,dict) and b.get('typeID') == 4 and b.get('attribute') in KINDS,
                'non-Transform, humanoid, Euler or property binding unsupported')
        require(b.get('customType') == 0 and b.get('isPPtrCurve') == 0 and not b.get('isIntCurve')
                and b.get('script') == {'m_FileID':0,'m_PathID':0}, 'custom/script/PPtr binding unsupported')
        h = uint(b.get('path'),'binding path hash');matches = hashed.get(h,[])
        require(len(matches) == 1, f'missing/ambiguous exact animation path hash {h}')
        path, node = matches[0];kind,width = KINDS[b['attribute']]
        require((node,kind) not in used,'duplicate generic animation target');used.add((node,kind))
        require(cursor+width <= len(scalars),'generic bindings exceed curve payload')
        parts = scalars[cursor:cursor+width];cursor += width
        for scalar in parts:
            require(scalar.mode == 'constant' or scalar.times[0] <= start+1e-6 and scalar.times[-1] >= stop-1e-6,
                    'curve does not cover the source clip interval')
        boundaries = sorted({start,stop} | {t for scalar in parts for t in scalar.times if start < t < stop})
        channel = {'node':node,'path':kind,'unity_path':path,'path_hash':h,'times':[],
                   'values':[],'in':[],'out':[]}
        for t in boundaries:
            channel['times'].append(number(t-start,'key time'))
            channel['values'].append([scalar.at(t)[0] for scalar in parts])
            channel['in'].append([scalar.at(t,side='left')[1] for scalar in parts])
            channel['out'].append([scalar.at(t)[1] for scalar in parts])
        require(all(a < b for a,b in zip(channel['times'],channel['times'][1:])), 'float32 key-time collision')
        if all(s.mode == 'constant' for s in parts):
            channel['times'] = [0.];channel['values'] = channel['values'][:1]
            channel['in'] = channel['out'] = [[0.]*width]
            if kind == 'rotation':channel['values'] = [quaternion(channel['values'][0])]
        elif kind == 'rotation':
            for i in range(len(boundaries)-1):
                pts = controls(channel,i);anchor = [a+b for a,b in zip(pts[0],pts[-1])]
                require(all(sum(a*b for a,b in zip(point,anchor)) > 1e-6 for point in pts),
                        'quaternion control hull may cross zero; unsupported')
            times, values, error = bake_rotation(parts,start,stop,boundaries)
            channel.update(times=times, values=values, **{'in':[[0.]*4 for _ in times], 'out':[[0.]*4 for _ in times]})
            channel['interpolation'] = 'LINEAR';bake_error = max(bake_error,error)
        check_channel(channel);channels.append(channel)
    require(cursor == len(scalars), 'unbound scalar payload would be lost')
    require(sum(len(c['times']) for c in channels) <= MAX_KEYS,'clip key budget exceeded')
    return {'id':clip_id, 'name':'Recovered_'+clip_id,'original_name':tree.get('m_Name',''),
            'source_sha256':raw_sha,'binding_root':binding_root,'channels':channels,
            'source_start_time':start,'source_stop_time':stop,'source_loop_time':bool(muscle.get('m_LoopTime')),
            'source_sample_rate':tree.get('m_SampleRate'),'layout':layout,
            'rotation_mode':'normalized component curves -> adaptive LINEAR/slerp derivative',
            'max_accepted_rotation_probe_error_radians':bake_error,
            'rotation_continuous_error_bound_proved':False,
            'scope':'generic Transform curves; one cycle; controller/root motion/shader/runtime parity not established'}
