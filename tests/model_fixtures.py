"""Generated test models; none of these vertices/objects come from the game APK."""
from __future__ import annotations

import io
import json
from pathlib import Path
import struct
import sys
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from gltf_model import IDENTITY, make_glb, inverse, multiply, trs
from recovery_core import Catalog


def model(skinned=False, textured=False):
    nodes = [dict(id='root', name='FixtureRoot', children=['mesh','bone0'], translation=[1,2,3], rotation=[0,0,0,1], scale=[1,1,1]),
             dict(id='mesh', name='FixtureMesh', children=[], translation=[2,0,0], rotation=[0,0,0,1], scale=[1,1,1]),
             dict(id='bone0', name='FixtureBone0', children=['bone1'], translation=[0,0,0], rotation=[0,0,0,1], scale=[1,1,1]),
             dict(id='bone1', name='FixtureBone1', children=[], translation=[0,1,0], rotation=[0,0,0,1], scale=[1,1,1])]
    geometry = {'positions': [[0,0,0],[1,0,0],[0,1,0]], 'normals': [[0,0,1]]*3,
                'uv': [[0,0],[1,0],[0,1]], 'submeshes': [[[0,1,2]]],
                'tangents': [[1,0,0,1]]*3}
    material = {'id':'material', 'name':'FixtureMaterial', 'color':[1,1,1,1]}
    if textured:
        from PIL import Image
        image = Image.new('RGB',(2,2)); image.putdata([(255,0,0),(0,255,0),(0,0,255),(255,255,0)])
        stream=io.BytesIO(); image.save(stream,format='PNG'); material['png']=stream.getvalue()
    renderer = {'id':'renderer', 'node':'mesh', 'name':'FixtureMesh', 'mesh_id':'geometry',
                'geometry':geometry, 'materials':[material]}
    if skinned:
        geometry['joints'] = [[0,0,0,0],[1,0,0,0],[0,1,0,0]]
        geometry['weights'] = [[1,0,0,0],[1,0,0,0],[.25,.75,0,0]]
        renderer['skin'] = {'joints':['bone0','bone1'], 'root':'bone0',
            'inverse_bind_matrices':[trs([2,0,0],[0,0,0,1],[1,1,1]), trs([2,-1,0],[0,0,0,1],[1,1,1])]}
    return {'input_sha256':'0'*64, 'root':'root', 'nodes':nodes, 'renderers':[renderer],
            'omitted_components':[]}


def unity_scene(skinned=False):
    """Build real Unity 2019 serialized objects using UnityPy's release type writer.

    This fixture exercises actual vertex channels, MeshHandler, PPtrs, and GLB
    conversion, rather than feeding a mocked mesh exporter to the integration test.
    """
    from UnityPy.helpers.Tpk import get_typetree_node
    from UnityPy.helpers.UnityVersion import UnityVersion
    from UnityPy.helpers.TypeTreeHelper import write_typetree
    from UnityPy.streams import EndianBinaryWriter
    ver = UnityVersion.from_str('2019.4.41f1')
    def default(node):
        typ, children = node.m_Type, node.m_Children
        if typ == 'string': return ''
        if typ == 'TypelessData': return b''
        if children and children[0].m_Type == 'Array': return []
        if children: return {c.m_Name: default(c) for c in children}
        if typ == 'bool': return False
        if typ in ('float','double'): return 0.0
        if typ in ('int','SInt8','UInt8','SInt16','UInt16','SInt32','UInt32','SInt64','UInt64','unsigned int','unsigned short','short','char','unsigned char','long long','unsigned long long','FileSize'): return 0
        raise ValueError('unhandled fixture primitive '+typ)
    def blank(cid): return default(get_typetree_node(cid, ver))
    def element(cid, name):
        node = next(n for n in get_typetree_node(cid,ver).m_Children if n.m_Name == name)
        return default(node.m_Children[0].m_Children[1])
    def p(pid): return dict(m_FileID=0,m_PathID=pid)
    go=blank(1); go.update(m_Name='ActualFixture',m_IsActive=True,m_Component=[{'component':p(2)},{'component':p(3)}])
    tr=blank(4); tr.update(m_GameObject=p(1),m_LocalRotation=dict(x=0.,y=0.,z=0.,w=1.),
                         m_LocalScale=dict(x=1.,y=1.,z=1.),m_Children=[])
    mesh=blank(43); mesh['m_Name']='ActualTriangle'; mesh['m_IndexFormat']=0
    mesh['m_IndexBuffer']=struct.pack('<3H',0,1,2)
    sub=element(43,'m_SubMeshes'); sub.update(firstByte=0,indexCount=3,topology=0,baseVertex=0,firstVertex=0,vertexCount=3)
    mesh['m_SubMeshes']=[sub]
    vd=mesh['m_VertexData']; vd['m_VertexCount']=3
    channels=[dict(stream=0,offset=0,format=0,dimension=0) for _ in range(14)]
    channels[0]=dict(stream=0,offset=0,format=0,dimension=3)
    channels[1]=dict(stream=0,offset=12,format=0,dimension=3)
    channels[4]=dict(stream=0,offset=24,format=0,dimension=2)
    data=b''
    geom=model(skinned)['renderers'][0]['geometry']
    for i in range(3):
        data+=struct.pack('<8f',*(geom['positions'][i]+geom['normals'][i]+geom['uv'][i]))
        if skinned:
            # One bone, three unit-weight vertices. Mesh channel formats are real.
            data+=struct.pack('<4f4I',1,0,0,0,0,0,0,0)
    if skinned:
        channels[12]=dict(stream=0,offset=32,format=0,dimension=4)
        channels[13]=dict(stream=0,offset=48,format=10,dimension=4)
        mesh['m_BindPose']=[{'e'+str(r)+str(c):float(r==c) for r in range(4) for c in range(4)}]
    vd['m_Channels']=channels; vd['m_DataSize']=data
    mat=blank(21); mat['m_Name']='ActualMaterial'
    mat['m_SavedProperties']['m_Colors']=[('_Color',dict(r=1.,g=1.,b=1.,a=1.))]
    if skinned:
        renderer=blank(137); renderer.update(m_GameObject=p(1),m_Enabled=True,m_Mesh=p(4),m_Materials=[p(5)],m_Bones=[p(7)],m_RootBone=p(7))
        tr['m_Children']=[p(7)]
        bonego=blank(1); bonego.update(m_Name='ActualBone',m_IsActive=True,m_Component=[{'component':p(7)}])
        bone=blank(4); bone.update(m_GameObject=p(6),m_Father=p(2),m_LocalRotation=dict(x=0.,y=0.,z=0.,w=1.),m_LocalScale=dict(x=1.,y=1.,z=1.))
        items=[(1,1,go),(2,4,tr),(3,137,renderer),(4,43,mesh),(5,21,mat),(6,1,bonego),(7,4,bone)]
    else:
        renderer=blank(23); renderer.update(m_GameObject=p(1),m_Enabled=True,m_Materials=[p(5)])
        mf=blank(33); mf.update(m_GameObject=p(1),m_Mesh=p(4))
        go['m_Component'].append({'component':p(6)})
        items=[(1,1,go),(2,4,tr),(3,23,renderer),(4,43,mesh),(5,21,mat),(6,33,mf)]
    classes=list(dict.fromkeys(cid for _,cid,_ in items))
    meta=b'2019.4.41f1\0'+struct.pack('<i?i',13,False,len(classes))
    for cid in classes: meta+=struct.pack('<i?h',cid,False,-1)+bytes(16)
    meta+=struct.pack('<i',len(items)); meta+=bytes(-(20+len(meta))%4)
    raw=b''
    for pid,cid,tree in items:
        writer=EndianBinaryWriter(endian='<'); write_typetree(tree,get_typetree_node(cid,ver),writer)
        payload=writer.bytes; raw+=bytes(-len(raw)%8)
        meta+=struct.pack('<qIIi',pid,len(raw),len(payload),classes.index(cid)); raw+=payload
    meta+=struct.pack('<ii',0,0)+b'\0'
    offset=(20+len(meta)+15)//16*16
    return struct.pack('>IIII',len(meta),offset+len(raw),17,offset)+bytes(4)+meta+bytes(offset-20-len(meta))+raw


def actual_export(destination, skinned=False):
    import recover
    import recovery_graph
    from recovery_model import export_snapshot
    destination.mkdir(parents=True,exist_ok=True)
    apk=destination/'generated-fixture.apk'
    with zipfile.ZipFile(apk,'w') as z:
        z.writestr('AndroidManifest.xml',b'fixture, not a runnable app')
        z.writestr('assets/bin/Data/model.assets',unity_scene(skinned))
    snapshot=destination/'capture'; recover.capture(apk,snapshot)
    report=recovery_graph.build(snapshot)
    assert report['graph_complete'], report
    cat=Catalog(snapshot)
    root=cat.db.execute('SELECT id FROM objects WHERE path_id=1').fetchone()[0]; cat.close()
    return export_snapshot(snapshot,root,destination/'export')


if __name__=='__main__':
    out=Path(sys.argv[1]); out.mkdir(parents=True,exist_ok=True)
    for skin in (False,True):
        name='skinned' if skin else 'static'
        (out/(name+'.glb')).write_bytes(make_glb(model(skin,True)))
        expected={'mesh_instances':1,'triangles':1,'min_bones':2 if skin else 0,'skinned_instances':int(skin)}
        (out/(name+'.expected.json')).write_text(json.dumps(expected))
        if '--unity' in sys.argv:
            actual_export(out/('actual-'+name),skin)
            actual=out/('actual-'+name)/'export'
            (actual/'model.expected.json').write_text(json.dumps({**expected,'min_bones':1 if skin else 0}))
