#!/usr/bin/env python3
"""Produce a separate Godot-compatible GLB; never overwrite the source spline GLB.

Godot 4.4.1 loses quaternion CUBICSPLINE easing in the native test. Only those
tracks are resampled here. Quality checks use interior probes, not a proof of
maximum error over every real-valued time; the unchanged spline is authoritative.
"""
from __future__ import annotations

import argparse
import json
import math
from pathlib import Path

from gltf_model import Builder, read_accessor, require, unpack_glb
from recovery_animation import MAX_KEYS, evaluate, number, validate_animated_glb
from recovery_core import RecoveryError, digest, json_bytes


def unit(q):
    norm = math.sqrt(sum(v*v for v in q))
    require(math.isfinite(norm) and norm > 1e-9, 'invalid quaternion in compatibility conversion')
    return [v/norm for v in q]


def slerp(a, b, u):
    a, b = unit(a), unit(b)
    dot = sum(x*y for x,y in zip(a,b))
    if dot < 0:
        b = [-v for v in b]; dot = -dot
    dot = min(1., dot)
    if dot > .9995:
        return unit([(1-u)*x+u*y for x,y in zip(a,b)])
    angle = math.acos(dot); denominator = math.sin(angle)
    return [(math.sin((1-u)*angle)*x+math.sin(u*angle)*y)/denominator for x,y in zip(a,b)]


def angular_error(a, b):
    a, b = unit(a), unit(b)
    if sum(x*y for x,y in zip(a,b)) < 0:
        b = [-v for v in b]
    # Stable for tiny errors where acos(dot) loses precision.
    return 4*math.atan2(math.sqrt(sum((x-y)**2 for x,y in zip(a,b))),
                        math.sqrt(sum((x+y)**2 for x,y in zip(a,b))))


def bake_rotation(channel, fps=120., tolerance=0.0001, budget=MAX_KEYS):
    require(type(fps) in (int,float) and math.isfinite(fps) and 1 <= fps <= 1000, 'invalid bake fps')
    require(type(tolerance) in (int,float) and math.isfinite(tolerance) and 1e-7 <= tolerance <= .01,
            'invalid angular tolerance')
    require(type(budget) is int and budget >= 2, 'rotation key budget exhausted')
    times = channel['times']
    def value(t):
        return [number(v,'baked quaternion') for v in evaluate(channel,t)]
    result_times, result_values = [times[0]], [value(times[0])]
    probes = 0; max_error = 0.
    def interval(a, b, qa, qb, depth=0):
        nonlocal probes, max_error
        require(depth <= 20, 'compatibility subdivision limit reached')
        errors = [angular_error(evaluate(channel,a+(b-a)*u), slerp(qa,qb,u)) for u in (.25,.5,.75)]
        probes += 3
        if max(errors) > tolerance:
            mid = number((a+b)/2,'bake time')
            require(a < mid < b, 'float32 time precision cannot meet compatibility tolerance')
            qm=value(mid)
            interval(a,mid,qa,qm,depth+1); interval(mid,b,qm,qb,depth+1)
        else:
            require(len(result_times) < budget, 'rotation key budget exhausted')
            result_times.append(b); result_values.append(qb); max_error=max(max_error,*errors)
    for a,b in zip(times,times[1:]):
        steps=max(1,math.ceil((b-a)*fps))
        require(len(result_times)+steps <= budget, 'rotation key budget exhausted')
        for i in range(1,steps+1):
            t=b if i==steps else number(a+(b-a)*i/steps,'bake time')
            require(t>result_times[-1], 'float32 bake timestamps collide')
            interval(result_times[-1],t,result_values[-1],value(t))
    return result_times,result_values,{'keys':len(result_times),'probes':probes,
        'max_accepted_probe_error_radians':max_error, 'continuous_error_bound_proved':False}


def prepare(blob, fps=120., tolerance=0.0001):
    validate_animated_glb(blob)
    doc,binary=unpack_glb(blob)
    require('godot_rotation_compatibility' not in doc.get('extras',{}), 'input is already a compatibility derivative')
    builder=Builder(); builder.doc=doc; builder.binary=bytearray(binary)
    tracks=[]; budget=MAX_KEYS
    for clip in doc['animations']:
        for entry in clip['channels']:
            sampler=clip['samplers'][entry['sampler']]
            if entry['target']['path']!='rotation' or sampler['interpolation']!='CUBICSPLINE':
                continue
            times=[v[0] for v in read_accessor(doc,binary,sampler['input'])]
            values=read_accessor(doc,binary,sampler['output'])
            channel={'path':'rotation','times':times,'values':values[1::3],'in':values[::3],'out':values[2::3]}
            t,q,report=bake_rotation(channel,fps,tolerance,budget)
            budget-=len(t)
            sampler.update(input=builder.accessor(t,'SCALAR',bounds=True),output=builder.accessor(q,'VEC4'),interpolation='LINEAR')
            tracks.append({'animation':clip['name'],'node':entry['target']['node'],**report})
    provenance={'source_glb_sha256':digest(blob),'target':'Godot 4.4.1','rotation_tracks':tracks,
                'minimum_samples_per_second':fps,'probe_tolerance_radians':tolerance,
                'continuous_error_bound_proved':False,'source_spline_preserved_separately':True}
    doc.setdefault('extras',{})['godot_rotation_compatibility']=provenance
    doc['asset']['generator']='apk-reverse-1 R4 Godot compatibility derivative'
    result=bytes(builder.finish())
    validate_animated_glb(result,allow_linear_rotation=True)
    return result,{**provenance,'output_glb_sha256':digest(result),'output_bytes':len(result)}


def main(argv=None):
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source',type=Path);parser.add_argument('destination',type=Path)
    parser.add_argument('--fps',type=float,default=120.)
    parser.add_argument('--tolerance-radians',type=float,default=.0001)
    args=parser.parse_args(argv)
    report_path=args.destination.with_suffix('.compatibility.json')
    try:
        require(not args.destination.exists() and not args.destination.is_symlink()
                and not report_path.exists() and not report_path.is_symlink(), 'compatibility output already exists')
        blob,report=prepare(args.source.read_bytes(),args.fps,args.tolerance_radians)
        args.destination.parent.mkdir(parents=True,exist_ok=True)
        with args.destination.open('xb') as f:f.write(blob)
        with report_path.open('xb') as f:f.write(json_bytes(report))
        print(json.dumps(report,indent=2));return 0
    except (RecoveryError,OSError,KeyError,TypeError,ValueError) as exc:
        parser.exit(2,'compatibility conversion blocked: '+str(exc)+'\n')


if __name__=='__main__':
    raise SystemExit(main())
