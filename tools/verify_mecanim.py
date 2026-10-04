#!/usr/bin/env python3
"""Independent numerical checks of generic packed curves and GLB skin deformation.

The reference reads original streamed words with struct and evaluates with numpy
polynomials; it does not use the exporter's curve parser, evaluator or baker.
This checks a decoded-format interpretation, not the original Unity runtime.
"""
from __future__ import annotations
import argparse
import copy
import json
from pathlib import Path
import struct
import numpy as np
from recovery_core import Catalog, digest, json_bytes
from recovery_model import Reader, collect
from gltf_model import require, unpack_glb
from recovery_animation import validate_animated_glb


def source_scalars(tree, time):
    body = tree['m_MuscleClip']['m_Clip']['data']
    stream = body['m_StreamedClip']
    raw = np.asarray(stream['data'], dtype='<u4').tobytes()
    offset = 0
    active = [None] * stream['curveCount']
    while offset < len(raw):
        stamp, count = struct.unpack_from('<fi', raw, offset); offset += 8
        for _ in range(count):
            index, *coeff = struct.unpack_from('<i4f', raw, offset); offset += 20
            if 0 <= stamp <= time:
                active[index] = (stamp, coeff)
    require(all(x is not None for x in active), 'reference stream coverage absent')
    values = [float(np.polyval(coeff, time-stamp)) for stamp,coeff in active]
    dense = body['m_DenseClip']; n = dense['m_CurveCount']
    if n:
        samples = np.array(dense['m_SampleArray'],dtype=np.float64).reshape(dense['m_FrameCount'],n)
        # Independent ideal frame timing, not the exporter's quantized timestamps.
        position = np.clip((time-dense['m_BeginTime'])*dense['m_SampleRate'],0,len(samples)-1)
        left = int(np.floor(position));right = min(left+1,len(samples)-1)
        values.extend((samples[left]+(position-left)*(samples[right]-samples[left])).tolist())
    values.extend(body['m_ConstantClip']['data'])
    return values


def accessor(doc, binary, index):
    acc=doc['accessors'][index];view=doc['bufferViews'][acc['bufferView']]
    width={'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4,'MAT4':16}[acc['type']]
    dtype={5126:'<f4',5125:'<u4',5123:'<u2'}[acc['componentType']]
    offset=view.get('byteOffset',0)+acc.get('byteOffset',0)
    return np.frombuffer(binary,dtype=dtype,count=acc['count']*width,offset=offset).reshape(-1,width).astype(np.float64)


def normalized(q):
    return q / np.linalg.norm(q)


def rotation_error(a,b):
    a=normalized(np.asarray(a));b=normalized(np.asarray(b))
    return float(4*np.arcsin(min(1.,min(np.linalg.norm(a-b),np.linalg.norm(a+b))/2)))


def gltf_value(times, values, mode, time):
    if mode=='CUBICSPLINE':
        values=values.reshape(len(times),3,-1)
    if time <= times[0]: return values[0,1].copy() if mode=='CUBICSPLINE' else values[0].copy()
    if time >= times[-1]:return values[-1,1].copy() if mode=='CUBICSPLINE' else values[-1].copy()
    i=int(np.searchsorted(times,time,side='right')-1);dt=times[i+1]-times[i];u=(time-times[i])/dt
    if mode=='CUBICSPLINE':
        weights=np.array([2*u**3-3*u*u+1,u**3-2*u*u+u,-2*u**3+3*u*u,u**3-u*u])
        return weights @ np.array([values[i,1],dt*values[i,2],values[i+1,1],dt*values[i+1,0]])
    if mode=='STEP':return values[i].copy()
    a,b=normalized(values[i]),normalized(values[i+1]);dot=np.dot(a,b)
    if dot<0:b=-b;dot=-dot
    if dot>.9995:return normalized(a+u*(b-a))
    theta=np.arccos(np.clip(dot,-1,1))
    return (np.sin((1-u)*theta)*a+np.sin(u*theta)*b)/np.sin(theta)


def matrix(node):
    q=normalized(np.asarray(node['rotation'],dtype=float));v=q[:3]
    axes=np.eye(3)
    # Rotate each basis vector via quaternion cross products (not writer matrix code).
    rotation=axes+2*np.cross(v,np.cross(v,axes)+q[3]*axes)
    out=np.eye(4);out[:3,:3]=rotation.T @ np.diag(node['scale']);out[:3,3]=node['translation']
    return out


def world(nodes, root):
    result={};pending=[(root,np.eye(4))]
    while pending:
        node,parent=pending.pop();transform=parent @ matrix(nodes[node]);result[node]=transform
        pending.extend((child,transform)for child in nodes[node].get('children',[]))
    return result


def verify(cat, blob, root_object, *, sample_count=17):
    require(3 <= sample_count <= 1000,'invalid independent sample count')
    counts=validate_animated_glb(blob,allow_linear_rotation=True)
    model=collect(cat,root_object);reader=Reader(cat);doc,binary=unpack_glb(blob)
    source_nodes={n['id']:n for n in model['nodes']}
    native_nodes={i:{**n,'children':n.get('children',[])}for i,n in enumerate(doc['nodes'])}
    mapping={n['extras']['unity_object_id']:i for i,n in native_nodes.items()}
    by_renderer={r['id']:r for r in model['renderers']}
    skin_cases=[]
    for i,node in native_nodes.items():
        if 'skin' not in node:continue
        skin=doc['skins'][node['skin']];mesh=doc['meshes'][node['mesh']]
        original=by_renderer[mesh['extras']['unity_renderer_id']]
        require(len(mesh['primitives'])==1,'verification subset requires one primitive per recovered mesh')
        primitive=mesh['primitives'][0];attr=primitive['attributes']
        p=accessor(doc,binary,attr['POSITION']);j=accessor(doc,binary,attr['JOINTS_0']).astype(int)
        weights=accessor(doc,binary,attr['WEIGHTS_0'])
        binds=accessor(doc,binary,skin['inverseBindMatrices']).reshape(-1,4,4).transpose(0,2,1)
        geometry=original['geometry'];source_p=np.asarray(geometry['positions'])
        require(np.max(np.abs(p-source_p*np.array([-1,1,1])))<1e-5,'position basis mismatch')
        require(np.array_equal(j,np.asarray(geometry['joints'])),'joint indices changed')
        require(np.max(np.abs(weights-np.asarray(geometry['weights'])))<1e-6,'skin weights changed')
        require(skin['joints']==[mapping[x]for x in original['skin']['joints']],'joint ordering changed')
        indices=accessor(doc,binary,primitive['indices']).astype(int).reshape(-1,3)
        require(np.array_equal(indices,np.asarray(geometry['submeshes'][0])[:,[0,2,1]]),'triangle winding mismatch')
        skin_cases.append((original,p,j,weights,binds,skin['joints']))
    report={'schema':1,'counts':counts,'source_joint_count':len({j for r in model['renderers'] if 'skin' in r for j in r['skin']['joints']}),'clips':[],'passed':True,'glb_sha256':digest(blob),
            'native_godot_tested':False,'android_device_tested':False,'unity_runtime_parity_verified':False,
            'reference':'original packed words, ideal dense timing, numpy polynomial and CPU skin evaluation',
            'tolerances':{'vector':.0005,'radians':.002,'deformed_vertex_world_units':.001}}
    expected={'input_sha256':digest(blob),'bake_fps':120,'vector_tolerance':.0005,'angle_tolerance':.002,
              'fixture_only':False,'source_kind':'captured game AnimationClip','clips':[]}
    for animation in doc['animations']:
        info=animation['extras'];oid=info['id'];row=reader.object(oid);reader.parsed(oid)
        require(row['sha']==info['source_sha256'],'animation source hash mismatch')
        tree=reader.tree(oid);start=tree['m_MuscleClip']['m_StartTime'];stop=tree['m_MuscleClip']['m_StopTime']
        # Independent exact path traversal. No suffix or basename lookup.
        pathmap={};pending=[(info['binding_root'],'')]
        import zlib
        while pending:
            node,path=pending.pop();h=zlib.crc32(path.encode());require(h not in pathmap,'reference path hash collision')
            pathmap[h]=node
            pending.extend((ch,(path+'/' if path else '')+source_nodes[ch]['name'])for ch in source_nodes[node]['children'])
        bindings=[];cursor=0
        for b in tree['m_ClipBindingConstant']['genericBindings']:
            kind,width={1:('translation',3),2:('rotation',4),3:('scale',3)}[b['attribute']]
            node=pathmap[b['path']];bindings.append((node,kind,cursor,width));cursor+=width
        tracks={}
        for channel in animation['channels']:
            sampler=animation['samplers'][channel['sampler']]
            tracks[(channel['target']['node'],channel['target']['path'])]=(accessor(doc,binary,sampler['input'])[:,0],
                  accessor(doc,binary,sampler['output']),sampler['interpolation'])
        require(set(tracks)=={(mapping[n],k)for n,k,_,_ in bindings},'exported target set differs')
        # Include authored endpoints and off-grid fractions; not the baker's probes.
        times=sorted(set(np.linspace(0,stop-start,sample_count).tolist()+[(stop-start)*x for x in (.137,.371,.619,.883)]))
        maxima={'vector':0.,'radians':0.,'deformed_vertex_world_units':0.}
        clip_expected={'name':animation['name'],'channels':[{'node_index':mapping[n],'path':k,'samples':[]}for n,k,_,_ in bindings]}
        for t in times:
            values=source_scalars(tree,start+t);a=copy.deepcopy(source_nodes);b=copy.deepcopy(native_nodes)
            require(cursor==len(values),'reference scalar count differs')
            for z,(node,kind,offset,width) in enumerate(bindings):
                raw=np.asarray(values[offset:offset+width]);raw=normalized(raw) if kind=='rotation' else raw
                a[node][kind]=raw;wanted=raw*np.array([1,-1,-1,1] if kind=='rotation' else [-1,1,1] if kind=='translation' else [1,1,1])
                actual=gltf_value(*tracks[(mapping[node],kind)],t);b[mapping[node]][kind]=actual
                error=rotation_error(actual,wanted) if kind=='rotation' else float(np.max(np.abs(actual-wanted)))
                key='radians' if kind=='rotation' else 'vector';maxima[key]=max(maxima[key],error)
                clip_expected['channels'][z]['samples'].append({'time':float(t),'value':wanted.tolist()})
            wa=world(a,model['root']);wb=world(b,mapping[model['root']])
            for original,p,j,weights,binds,joints in skin_cases:
                geom=original['geometry'];source_p=np.c_[geom['positions'],np.ones(len(p))]
                source_j=np.asarray(geom['joints']);source_w=np.asarray(geom['weights'])
                source_binds=np.asarray(original['skin']['inverse_bind_matrices']).reshape(-1,4,4)
                ma=np.array([wa[n] for n in original['skin']['joints']]) @ source_binds
                mb=np.array([wb[n]for n in joints]) @ binds
                va=np.einsum('vwij,vj,vw->vi',ma[source_j],source_p,source_w)
                vb=np.einsum('vwij,vj,vw->vi',mb[j],np.c_[p,np.ones(len(p))],weights)
                error=float(np.max(np.linalg.norm(vb[:,:3]-va[:,:3]*[-1,1,1],axis=1)))
                maxima['deformed_vertex_world_units']=max(maxima['deformed_vertex_world_units'],error)
        passed=all(np.isfinite(v) and v <= report['tolerances'][k]for k,v in maxima.items())
        report['passed'] &= passed
        report['clips'].append({'name':info['original_name'],'source_sha256':row['sha'],'pose_times':len(times),
            'channel_samples':len(times)*len(bindings),'deformed_vertices_checked':len(times)*sum(len(x[1])for x in skin_cases),
            'maximum_errors':maxima,'passed':passed})
        expected['clips'].append(clip_expected)
    return report,expected


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('snapshot',type=Path);p.add_argument('model',type=Path)
    p.add_argument('--root-object',required=True);p.add_argument('--out',type=Path,required=True);args=p.parse_args()
    with_context=Catalog(args.snapshot)
    try:
        report,expected=verify(with_context,args.model.read_bytes(),args.root_object)
    finally:with_context.close()
    args.out.mkdir(parents=True,exist_ok=False)
    (args.out/'numerical.json').write_bytes(json_bytes(report));(args.out/'godot.expected.json').write_bytes(json_bytes(expected))
    print(json.dumps(report,indent=2));return 0 if report['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
