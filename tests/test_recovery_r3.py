"""R3 model tests: generated data only, with independent maths and Unity fixtures."""
import copy
import importlib.util
import io
import json
from pathlib import Path
import struct
import sys
import tempfile
import unittest
from types import SimpleNamespace as NS
from unittest.mock import patch

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
import gltf_model as gltf
import recovery_model as adapter
from recovery_core import Catalog, RecoveryError, digest
from model_fixtures import model, actual_export
from test_recovery_r2 import GraphFixture, model_items, ptr


def repack(doc,binary):
    js=json.dumps(doc,separators=(',',':')).encode(); js+=b' '*(-len(js)%4)
    binary+=bytes(-len(binary)%4)
    return struct.pack('<III',0x46546c67,2,28+len(js)+len(binary))+struct.pack('<I4s',len(js),b'JSON')+js+struct.pack('<I4s',len(binary),b'BIN\0')+binary


class MathTests(unittest.TestCase):
    def test_trs_conjugation_matches_matrix_math(self):
        q=[.2,.3,.4,(1-.29)**.5]
        t=[3,-4,5]; s=[2,.5,3]
        original=gltf.trs(t,q,s)
        converted=gltf.trs([-3,-4,5],[q[0],-q[1],-q[2],q[3]],s)
        self.assertEqual(gltf.convert_matrix(original),converted)

    def test_inverse_and_column_major_bind_serialization(self):
        m=gltf.trs([3,4,5],[0,0,0,1],[2,3,4])
        for a,b in zip(gltf.multiply(m,gltf.inverse(m)),gltf.IDENTITY): self.assertAlmostEqual(a,b)
        src=model(True); blob=gltf.make_glb(src); doc,buf=gltf.unpack_glb(blob)
        aid=doc['skins'][0]['inverseBindMatrices']; binds=gltf.read_accessor(doc,buf,aid)
        self.assertEqual(binds[0][12:15],[-2,0,0])
        self.assertEqual(binds[1][12:15],[-2,-1,0])

    def test_cpu_skinning_preserves_pose_after_basis_change(self):
        import numpy as np
        src=model(True); doc,buf=gltf.unpack_glb(gltf.make_glb(src))
        attrs=doc['meshes'][0]['primitives'][0]['attributes']
        pos=np.array(gltf.read_accessor(doc,buf,attrs['POSITION']))
        binds=[np.array(x).reshape(4,4).T for x in gltf.read_accessor(doc,buf,doc['skins'][0]['inverseBindMatrices'])]
        C=np.diag([-1,1,1,1]); geo=src['renderers'][0]['geometry']
        J=[np.array(gltf.trs([1,2,3],[0,0,0,1],[1,1,1])).reshape(4,4),
           np.array(gltf.trs([1,4,3],[0,0,.6,.8],[1,1,1])).reshape(4,4)]
        original_binds=[np.array(x).reshape(4,4) for x in src['renderers'][0]['skin']['inverse_bind_matrices']]
        for i,p in enumerate(geo['positions']):
            expected=sum(w*(J[j]@original_binds[j]@np.r_[p,1]) for j,w in zip(geo['joints'][i],geo['weights'][i]))
            actual=sum(w*(C@J[j]@C@binds[j]@np.r_[pos[i],1]) for j,w in zip(geo['joints'][i],geo['weights'][i]))
            np.testing.assert_allclose(actual,C@expected,atol=1e-6)

    def test_uv_and_tangent_conversion(self):
        attrs,idx=gltf.normalized_geometry(model()['renderers'][0]['geometry'])
        self.assertEqual(attrs['TEXCOORD_0'],[[0,1],[1,1],[0,0]])
        self.assertEqual(attrs['TANGENT'][0],[-1,0,0,1])
        self.assertEqual(idx,[[0,2,1]])

    def test_singular_and_nonaffine_binds_rejected(self):
        for m in ([0]*16,gltf.IDENTITY[:12]+[1,0,0,1]):
            with self.assertRaises(RecoveryError): gltf.convert_matrix(m)


class ModelTests(unittest.TestCase):
    def test_static_roundtrip_and_independent_trimesh_load(self):
        import trimesh
        data=gltf.make_glb(model()); result=gltf.validate_glb(data)
        scene=trimesh.load(io.BytesIO(data),file_type='glb',force='scene')
        self.assertEqual(sum(len(g.faces) for g in scene.geometry.values()),1)
        self.assertEqual(result['triangles'],1); self.assertFalse(result['gameplay_port_complete'])

    def test_skinned_counts_and_provenance(self):
        data=gltf.make_glb(model(True)); doc,_=gltf.unpack_glb(data)
        self.assertEqual(gltf.validate_glb(data)['skinned_instances'],1)
        self.assertEqual(len(doc['skins'][0]['joints']),2)
        self.assertEqual(doc['extras']['recovery']['animation_clips_exported'],0)
        self.assertFalse(doc['extras']['recovery']['material_shader_equivalence'])

    def test_deterministic_bytes(self):
        self.assertEqual(gltf.make_glb(model(True,True)),gltf.make_glb(model(True,True)))

    def test_inputs_not_mutated(self):
        m=model(True,True); old=copy.deepcopy(m); gltf.make_glb(m); self.assertEqual(old,m)

    def test_embedded_png_no_external_paths(self):
        data=gltf.make_glb(model(textured=True)); doc,buf=gltf.unpack_glb(data)
        self.assertEqual(gltf.validate_glb(data)['images'],1)
        self.assertNotIn('uri',doc['images'][0]); self.assertNotIn('uri',doc['buffers'][0])

    def test_nonfinite_and_wrong_dimensions_rejected(self):
        for value in ([1,2],[float('nan'),0,0],[1e39,0,0],[True,0,0]):
            m=model(); m['renderers'][0]['geometry']['positions'][0]=value
            with self.subTest(value=value),self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_attribute_count_and_normals_rejected(self):
        for val in ([[0,0,1]],[[0,0,0]]*3,[[0,0,2]]*3):
            m=model(); m['renderers'][0]['geometry']['normals']=val
            with self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_empty_and_invalid_submeshes_rejected(self):
        for val in ([],[[]],[[[0,1,99]]],[[[0,1,1]]],[[[0,1]]],[[[False,1,2]]]):
            m=model(); m['renderers'][0]['geometry']['submeshes']=val
            with self.subTest(value=val),self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_skin_array_defects_rejected(self):
        for key,value in [('weights',None),('joints',None),('weights',[[1,0,0,0]]),
            ('weights',[[.5,0,0,0]]*3),('weights',[[2,-1,0,0]]*3),('joints',[[2,0,0,0]]*3),('joints',[[True,0,0,0]]*3)]:
            m=model(True); m['renderers'][0]['geometry'][key]=value
            with self.subTest(key=key,value=value),self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_unbound_skin_rejected(self):
        m=model(True); del m['renderers'][0]['skin']
        with self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_bone_ids_bind_counts_and_root_checked(self):
        for field,value in [('joints',['bone0','missing']),('joints',['bone0','bone0']),('inverse_bind_matrices',[]),('root','bone1')]:
            m=model(True); m['renderers'][0]['skin'][field]=value
            with self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_hierarchy_cycles_orphans_and_duplicates_rejected(self):
        for mutate in (lambda m:m['nodes'][0]['children'].append('root'),
                       lambda m:m['nodes'][0]['children'].pop(),
                       lambda m:m['nodes'][0]['children'].append('mesh'),
                       lambda m:m['nodes'].append(copy.deepcopy(m['nodes'][0]))):
            m=model(); mutate(m)
            with self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_invalid_transform_rejected(self):
        for field,value in [('rotation',[0,0,0,2]),('scale',[1,0,1]),('translation',[float('inf'),0,0])]:
            m=model(); m['nodes'][0][field]=value
            with self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_material_count_and_color_checked(self):
        m=model(); m['renderers'][0]['materials']=[]
        with self.assertRaises(RecoveryError): gltf.make_glb(m)
        m=model(); m['renderers'][0]['materials'][0]['color']=[2,0,0,1]
        with self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_texture_requires_uv_and_valid_png(self):
        m=model(textured=True); del m['renderers'][0]['geometry']['uv']
        with self.assertRaises(RecoveryError): gltf.make_glb(m)
        m=model(textured=True); m['renderers'][0]['materials'][0]['png']=b'not a PNG'
        with self.assertRaises(Exception): gltf.make_glb(m)

    def test_multiple_renderer_and_no_renderer_rejected(self):
        m=model(); m['renderers'].append(copy.deepcopy(m['renderers'][0]))
        with self.assertRaises(RecoveryError): gltf.make_glb(m)
        m=model(); m['renderers']=[]
        with self.assertRaises(RecoveryError): gltf.make_glb(m)

    def test_corrupt_header_chunk_and_external_buffer_rejected(self):
        data=gltf.make_glb(model())
        for raw in (data[:-1],b'FAIL'+data[4:],data+b'xxxx'):
            with self.assertRaises(RecoveryError): gltf.validate_glb(raw)
        doc,buf=gltf.unpack_glb(data); doc['buffers'][0]['uri']='../../data.bin'
        with self.assertRaises(RecoveryError): gltf.validate_glb(repack(doc,buf))

    def test_changed_bounds_and_indices_detected(self):
        doc,buf=gltf.unpack_glb(gltf.make_glb(model()))
        doc['accessors'][0]['min']=[-99,0,0]
        with self.assertRaises(RecoveryError): gltf.validate_glb(repack(doc,buf))
        doc,buf=gltf.unpack_glb(gltf.make_glb(model()))
        a=doc['accessors'][doc['meshes'][0]['primitives'][0]['indices']]
        off=doc['bufferViews'][a['bufferView']]['byteOffset']; buf=bytearray(buf)
        struct.pack_into('<I',buf,off,999)
        with self.assertRaises(RecoveryError): gltf.validate_glb(repack(doc,buf))

    def test_accessor_range_and_alignment_checked(self):
        for off in (1,999999,-1):
            doc,buf=gltf.unpack_glb(gltf.make_glb(model())); doc['accessors'][0]['byteOffset']=off
            with self.assertRaises(RecoveryError): gltf.validate_glb(repack(doc,buf))

    def test_skin_weight_corruption_detected(self):
        doc,buf=gltf.unpack_glb(gltf.make_glb(model(True)))
        a=doc['accessors'][doc['meshes'][0]['primitives'][0]['attributes']['WEIGHTS_0']]
        off=doc['bufferViews'][a['bufferView']]['byteOffset']; buf=bytearray(buf); struct.pack_into('<f',buf,off,0)
        with self.assertRaises(RecoveryError): gltf.validate_glb(repack(doc,buf))

    def test_reused_names_do_not_merge_identity(self):
        m=model(True)
        for n in m['nodes']: n['name']='same'
        doc,_=gltf.unpack_glb(gltf.make_glb(m))
        self.assertEqual(len({n['extras']['unity_object_id'] for n in doc['nodes']}),4)


class AdapterTests(GraphFixture):
    def items(self):
        items=model_items(); items[0][2]['m_Component'].append({'component':ptr(7)})
        items.extend([(7,'MeshRenderer',{'m_GameObject':ptr(1),'m_Enabled':1,'m_Materials':[ptr(8)]}),
                      (8,'Material',{'m_Name':'Material','m_SavedProperties':{'m_Colors':[['_Color',dict(r=1,g=1,b=1,a=1)]],'m_TexEnvs':[]}})])
        return items

    def collect_fixture(self,items=None):
        root=self.snapshot(self.items() if items is None else items); self.build(); cat=Catalog(root)
        try:
            with patch.object(adapter.Reader,'parsed',return_value=NS()),patch.object(adapter,'read_geometry',return_value=model()['renderers'][0]['geometry']):
                return adapter.collect(cat,self.oid(1))
        finally:cat.close()

    def test_catalog_hierarchy_drives_model(self):
        m=self.collect_fixture(); data=gltf.make_glb(m); self.assertEqual(gltf.validate_glb(data)['triangles'],1)
        self.assertEqual(m['renderers'][0]['mesh_id'],self.oid(6))

    def test_unknown_component_reported_not_executed(self):
        items=self.items(); items[0][2]['m_Component'].append({'component':ptr(9)})
        items.append((9,'MonoBehaviour',{'m_GameObject':ptr(1),'m_Name':'not executed'}))
        m=self.collect_fixture(items); self.assertEqual(m['omitted_components'][0]['type'],'MonoBehaviour')

    def test_disabled_renderer_blocks(self):
        items=self.items(); items[6][2]['m_Enabled']=0
        with self.assertRaises(RecoveryError):self.collect_fixture(items)

    def test_inactive_game_object_blocks(self):
        items=self.items(); items[0][2]['m_IsActive']=0
        with self.assertRaises(RecoveryError):self.collect_fixture(items)

    def test_missing_renderer_material_blocks(self):
        items=self.items(); items[6][2]['m_Materials']=[ptr(999)]
        with self.assertRaises(RecoveryError):self.collect_fixture(items)

    def test_texture_transform_not_silently_lost(self):
        reader=NS(tree=lambda oid:{'m_SavedProperties':{'m_TexEnvs':[['_MainTex',{'m_Scale':dict(x=2,y=1)}]]}})
        with self.assertRaises(RecoveryError):adapter.preview_material(reader,'id')

    def test_duplicate_material_properties_refused(self):
        with self.assertRaises(RecoveryError):adapter.named_values([['a',1],['a',2]],'/props')

    def test_bind_matrix_field_order(self):
        m=NS(**{'e'+str(r)+str(c):r*4+c for r in range(4) for c in range(4)})
        self.assertEqual(adapter.bind_matrix(m),list(range(16)))

    def test_overwrite_refused_before_opening_capture(self):
        target=self.root/'existing'; target.mkdir()
        with self.assertRaises(RecoveryError):adapter.export_snapshot(self.root/'absent','x',target)


@unittest.skipUnless(importlib.util.find_spec('UnityPy'),'UnityPy required in CI')
class ActualModelIntegration(unittest.TestCase):
    def test_unity_static_mesh_to_glb(self):
        with tempfile.TemporaryDirectory() as tmp:
            result=actual_export(Path(tmp),False)
            self.assertEqual(result['counts']['triangles'],1)
            self.assertEqual(result['counts']['skinned_instances'],0)

    def test_unity_skinned_vertex_channels_and_bindings_to_glb(self):
        with tempfile.TemporaryDirectory() as tmp:
            result=actual_export(Path(tmp),True)
            self.assertEqual(result['counts']['triangles'],1)
            self.assertEqual(result['counts']['skinned_instances'],1)
            self.assertFalse(result['gameplay_port_complete'])


if __name__=='__main__':unittest.main()
