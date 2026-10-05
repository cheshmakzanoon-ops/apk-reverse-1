"""Generated native geometry/numeric-texture cases; originals are tested separately."""
import copy
import math
from pathlib import Path
import struct
import sys
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from recovery_core import RecoveryError,validate_obj
from recovery_mesh import geometry_obj,convert_mesh
from recovery_numeric_texture import convert_numeric_texture,validate_numeric_texture,layout
import recovery_delivery as delivery
import recover


class NumericTextureTests(unittest.TestCase):
    def texture(self):
        # All signed values and IEEE half patterns must survive, not become PNG.
        data=struct.pack('<8H',0x3c00,0xbc00,0x0000,0x8000,0x7c00,0xfc00,0x7e01,0x3555)
        return NS(m_TextureFormat=17,m_Width=2,m_Height=1,m_MipCount=1,m_ImageCount=1,get_image_data=lambda:data)
    def test_exact_half_bits_including_nan_payload_survive(self):
        t=self.texture();ext,data,detail=convert_numeric_texture(t)
        self.assertEqual(ext,'bin');self.assertEqual(data,t.get_image_data())
        self.assertTrue(validate_numeric_texture(data,detail)['bit_exact_payload'])
        self.assertFalse(detail['display_color_conversion_performed'])
    def test_dispatch_skips_display_image_conversion(self):
        t=self.texture();ext,data,d=recover.convert(NS(parse_as_object=lambda:t),'Texture2D')
        self.assertEqual(ext,'bin');delivery.check_data('Texture2D',data,d)
    def test_all_mip_offsets_accounted(self):
        levels,size=layout(4,2,3,17)
        self.assertEqual([r['size'] for r in levels],[64,16,8]);self.assertEqual(size,88)
        self.assertEqual([r['offset'] for r in levels],[0,64,80])
    def test_all_six_component_layouts(self):
        for fmt,count in [(15,2),(16,4),(17,8),(18,4),(19,8),(20,16)]:
            with self.subTest(fmt=fmt):self.assertEqual(layout(1,1,1,fmt)[1],count)
    def test_truncated_and_extra_payload_rejected(self):
        for raw in (b'\0'*15,b'\0'*17):
            t=self.texture();t.get_image_data=lambda:raw
            with self.assertRaises(RecoveryError):convert_numeric_texture(t)
    def test_invalid_mips_or_dimensions(self):
        for args in [(0,1,1,17),(True,1,1,17),(2,1,3,17),(2,1,1,99)]:
            with self.subTest(args=args),self.assertRaises(RecoveryError):layout(*args)
    def test_array_texture_not_flattened(self):
        t=self.texture();t.m_ImageCount=2
        with self.assertRaises(RecoveryError):convert_numeric_texture(t)
    def test_changed_numeric_payload_rejected(self):
        _,data,d=convert_numeric_texture(self.texture())
        with self.assertRaises(RecoveryError):validate_numeric_texture(b'x'+data[1:],d)
    def test_changed_mip_mapping_rejected(self):
        _,data,d=convert_numeric_texture(self.texture());d['levels'][0]['offset']=8
        with self.assertRaises(RecoveryError):validate_numeric_texture(data,d)
    def test_color_conversion_claim_rejected(self):
        _,data,d=convert_numeric_texture(self.texture());d['display_color_conversion_performed']=True
        with self.assertRaises(RecoveryError):validate_numeric_texture(data,d)


class NativeGeometryTests(unittest.TestCase):
    positions=[[0,0,0],[1,0,0],[0,1,0]]
    faces=[[[0,1,2]]]
    normals=[[0,0,1]]*3
    uv=[[0,0],[1,0],[0,1]]
    def test_missing_both_attributes_has_only_position_indices(self):
        _,data,d=geometry_obj(self.positions,self.faces)
        self.assertIn(b'f 3 2 1\n',data);self.assertFalse(d['uv_present']);self.assertFalse(d['normals_present'])
    def test_missing_uv_has_normal_only_face_tokens(self):
        _,data,d=geometry_obj(self.positions,self.faces,self.normals)
        self.assertIn(b'f 3//3 2//2 1//1\n',data);self.assertEqual(validate_obj(data.decode())['faces'],1)
    def test_missing_normals_has_uv_only_face_tokens(self):
        _,data,_=geometry_obj(self.positions,self.faces,uv=self.uv)
        self.assertIn(b'f 3/3 2/2 1/1\n',data)
    def test_both_attributes_have_all_indices(self):
        _,data,_=geometry_obj(self.positions,self.faces,self.normals,self.uv)
        self.assertIn(b'f 3/3/3 2/2/2 1/1/1\n',data)
    def test_handedness_and_winding_are_paired(self):
        _,data,_=geometry_obj(self.positions,self.faces)
        self.assertIn(b'v -1 0 0\n',data);self.assertIn(b'f 3 2 1',data)
    def test_nonfinite_positions_not_silently_replaced(self):
        for v in (float('nan'),float('inf')):
            p=copy.deepcopy(self.positions);p[0][0]=v
            with self.assertRaises(RecoveryError):geometry_obj(p,self.faces)
    def test_invalid_triangle_indices_fail(self):
        for index in (-1,3,1.0,True):
            with self.subTest(index=index),self.assertRaises(RecoveryError):geometry_obj(self.positions,[[[0,1,index]]])
    def test_partial_channels_not_silently_dropped(self):
        with self.assertRaises(RecoveryError):geometry_obj(self.positions,self.faces,[[0,0,1]])
    def test_base_vertex_applied_to_declared_index_range(self):
        mesh=NS(m_SubMeshes=[NS(topology=0,firstByte=0,indexCount=3,baseVertex=1)])
        handler=NS(process=lambda:None,m_Use16BitIndices=True,m_IndexBuffer=[0,1,2],
                   m_Vertices=[[9,9,9]]+self.positions,m_Normals=None,m_UV0=None)
        with patch('UnityPy.helpers.MeshHelper.MeshHandler',return_value=handler):
            _,data,_=convert_mesh(mesh)
        self.assertIn(b'f 4 3 2\n',data)
    def test_other_topology_needs_explicit_adapter(self):
        mesh=NS(m_SubMeshes=[NS(topology=1,firstByte=0,indexCount=3,baseVertex=0)])
        handler=NS(process=lambda:None,m_Use16BitIndices=True,m_IndexBuffer=[0,1,2])
        with patch('UnityPy.helpers.MeshHelper.MeshHandler',return_value=handler):
            with self.assertRaises(RecoveryError):convert_mesh(mesh)


if __name__=='__main__':unittest.main()
