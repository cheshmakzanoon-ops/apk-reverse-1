"""Generated animation fixtures and independent de Casteljau pose expectations.

These are tests of the conversion, NOT recovered game animation or game code.
"""
from __future__ import annotations

import json
import math
from pathlib import Path
import sys
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from model_fixtures import model, unity_scene
from recovery_core import Catalog, digest
from gltf_model import make_glb, unpack_glb
from recovery_animation import decode_clip, append_clips


def clip_tree(path='FixtureMesh'):
    def key(time, value, incoming=None, outgoing=None):
        axes = 'xyzw'[:len(value)]
        v = lambda row: dict(zip(axes, row))
        return {'time': float(time), 'value': v(value), 'inSlope': v(incoming or [0]*len(value)),
                'outSlope': v(outgoing or [0]*len(value)), 'weightedMode': 0,
                'inWeight': v([1/3]*len(value)), 'outWeight': v([1/3]*len(value))}
    def curve(keys):
        return [{'path': path, 'curve': {'m_Curve': keys, 'm_PreInfinity': 2, 'm_PostInfinity': 2,
                                        'm_RotationOrder': 4}}]
    return {'m_Name': 'GeneratedMotion', 'm_Legacy': True, 'm_Compressed': False,
            'm_UseHighQualityCurve': True, 'm_MuscleClipSize': 0, 'm_SampleRate': 30., 'm_WrapMode': 1,
            'm_PositionCurves': curve([key(0,[0,0,0],outgoing=[.5,0,.25]), key(2,[2,1,-1],incoming=[0,1,.5])]),
            'm_RotationCurves': curve([key(0,[0,0,0,1]), key(2,[0,0,.5,math.sqrt(.75)])]),
            'm_ScaleCurves': curve([key(0,[1,1,1]), key(2,[1.2,1.4,.9])]),
            'm_CompressedRotationCurves': [], 'm_EulerCurves': [], 'm_FloatCurves': [],
            'm_PPtrCurves': [], 'm_Events': []}


def independent_sample(channel, t):
    """Evaluate Bezier control points, not the exporter's Hermite evaluator."""
    times = channel['times']
    if t <= times[0]:
        result = list(channel['values'][0])
    elif t >= times[-1]:
        result = list(channel['values'][-1])
    else:
        i = next(i for i in range(len(times)-1) if times[i] <= t < times[i+1])
        dt = times[i+1]-times[i]; u=(t-times[i])/dt
        points = [list(channel['values'][i]),
                  [a+dt*b/3 for a,b in zip(channel['values'][i],channel['out'][i])],
                  [a-dt*b/3 for a,b in zip(channel['values'][i+1],channel['in'][i+1])],
                  list(channel['values'][i+1])]
        for _ in range(3):
            points = [[(1-u)*a+u*b for a,b in zip(left,right)] for left,right in zip(points,points[1:])]
        result=points[0]
    if channel['path']=='rotation':
        norm=math.sqrt(sum(x*x for x in result)); result=[x/norm for x in result]
        result=[result[0],-result[1],-result[2],result[3]]
    elif channel['path']=='translation':
        result[0]=-result[0]
    return result


def expectations(blob, clip):
    doc,_=unpack_glb(blob)
    nodes={n['extras']['unity_object_id']:i for i,n in enumerate(doc['nodes'])}
    # Includes off-key, off-bake-grid samples to detect timing/interpolation errors.
    return {'fixture_only': True, 'input_sha256': digest(blob), 'bake_fps': 120.,
            'vector_tolerance': .0005, 'angle_tolerance': .002,
            'clips': [{'name': clip['name'], 'channels': [
                {'node_index': nodes[c['node']], 'path': c['path'],
                 'samples': [{'time': t, 'value': independent_sample(c,t)}
                             for t in [0., .017, .37, .913, 1.41, 1.983, 2.]]}
                for c in clip['channels']]}]}


def actual_export(out, skinned=False):
    import recover
    import recovery_graph as graph
    from recovery_model import collect, export_snapshot, Reader
    out.mkdir(parents=True,exist_ok=False)
    tree=clip_tree('ActualBone' if skinned else '')
    apk=out/'generated-animation-fixture.apk'
    with zipfile.ZipFile(apk,'w') as z:
        z.writestr('AndroidManifest.xml',b'generated, not a runnable Android application')
        z.writestr('assets/bin/Data/model.assets',unity_scene(skinned,tree))
    capture=out/'capture'; recover.capture(apk,capture)
    report=graph.build(capture)
    assert report['graph_complete'],report
    cat=Catalog(capture)
    try:
        root=cat.db.execute('SELECT id FROM objects WHERE path_id=1').fetchone()[0]
        row=cat.db.execute('SELECT * FROM objects WHERE path_id=8').fetchone()
        src=collect(cat,root)
        clip=decode_clip(Reader(cat).tree(row['id']),row['id'],row['sha'],src)
        clip_id=row['id']
    finally:
        cat.close()
    report=export_snapshot(capture,root,out/'export',clip_ids=[clip_id])
    blob=(out/'export/model.glb').read_bytes()
    (out/'export/model.animation.expected.json').write_text(json.dumps(expectations(blob,clip),indent=2))
    return report


def generate(out, with_unity=False):
    out.mkdir(parents=True,exist_ok=True)
    for skinned in (False,True):
        name='skinned' if skinned else 'static'
        src=model(skinned,True)
        tree=clip_tree('FixtureBone0/FixtureBone1' if skinned else 'FixtureMesh')
        clip=decode_clip(tree,digest(name.encode()),digest(json.dumps(tree).encode()),src)
        blob=append_clips(make_glb(src),[clip])
        (out/(name+'.glb')).write_bytes(blob)
        (out/(name+'.animation.expected.json')).write_text(json.dumps(expectations(blob,clip),indent=2))
        if with_unity:
            actual_export(out/('actual-'+name),skinned)


if __name__=='__main__':
    generate(Path(sys.argv[1]),'--unity' in sys.argv)
