"""Generated regression cases for the real dense/constant conversion path."""
from __future__ import annotations
import copy
import io
import json
import math
from pathlib import Path
import struct
import sys
import tempfile
import unittest
import zipfile
import zlib
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from recovery_core import RecoveryError, digest
from mecanim_dense import decode_dense, hashed_paths
from recovery_model import expand_skin, common_skin_root
from real_asset_sample import make_selection
from model_fixtures import model


def clip():
    path = zlib.crc32(b'FixtureBone0')
    return {'m_Name':'GeneratedDense','m_Legacy':False,'m_Compressed':False,
      'm_MuscleClip':{'m_StartTime':0.,'m_StopTime':1.,'m_Clip':{'data':{
        'm_StreamedClip':{'data':[0x7f800000,0],'curveCount':0},
        'm_DenseClip':{'m_FrameCount':3,'m_CurveCount':3,'m_SampleRate':2.,
          'm_BeginTime':0.,'m_SampleArray':[0.,1.,2., 1.,2.,3., 2.,3.,4.]},
        'm_ConstantClip':{'data':[0.,0.,0.,1.,1.,1.,1.]}}}},
      'm_ClipBindingConstant':{'genericBindings':[
        {'path':path,'attribute':a,'typeID':4,'customType':0,'isPPtrCurve':0,
         'script':{'m_FileID':0,'m_PathID':0}} for a in (1,2,3)]}}


def decode(tree):
    return decode_dense(tree, '1'*64, '2'*64, model(True))


class DenseClipTests(unittest.TestCase):
    def test_dense_frame_major_and_constants(self):
        result=decode(clip()); pos,rot,scale=result['channels']
        self.assertEqual(pos['times'],[0.,.5,1.])
        self.assertEqual(pos['values'],[[0.,1.,2.],[1.,2.,3.],[2.,3.,4.]])
        self.assertEqual(pos['out'][0],[2.,2.,2.])
        self.assertEqual(rot['values'],[[0.,0.,0.,1.]])
        self.assertEqual(scale['values'],[[1.,1.,1.]])
        self.assertFalse(result['animation_runtime_equivalence_verified'])
    def test_fractional_stop_endpoint(self):
        tree=clip();tree['m_MuscleClip']['m_StopTime']=.75
        self.assertEqual(decode(tree)['channels'][0]['values'][-1],[1.5,2.5,3.5])
    def test_dense_quaternion_normalization(self):
        tree=clip();tree['m_MuscleClip']['m_Clip']['data']['m_ConstantClip']['data'][3]=1.0005
        self.assertEqual(decode(tree)['channels'][1]['values'][0],[0.,0.,0.,1.])
    def test_identity_hash_required(self):
        with self.assertRaises(RecoveryError):decode_dense(clip(),'name','2'*64,model())
    def test_path_collision_is_not_first_match(self):
        paths=hashed_paths(model(), 'root', lambda _:1)
        self.assertEqual(len(paths[1]),4)
        with patch('mecanim_dense.hashed_paths',return_value={zlib.crc32(b'FixtureBone0'):[('a','bone0'),('b','bone1')]}):
            with self.assertRaises(RecoveryError):decode(clip())
    def test_duplicate_siblings_are_ambiguous(self):
        m=model();m['nodes'][1]['name']='FixtureBone0'
        with self.assertRaises(RecoveryError):decode_dense(clip(),'1'*64,'2'*64,m)
    def test_binding_order_is_not_guessed(self):
        tree=clip();tree['m_ClipBindingConstant']['genericBindings'][0]['attribute']=2
        with self.assertRaises(RecoveryError):decode(tree)
    def test_unconsumed_scalars_rejected(self):
        tree=clip();tree['m_MuscleClip']['m_Clip']['data']['m_ConstantClip']['data'].append(1.)
        with self.assertRaises(RecoveryError):decode(tree)
    def test_source_tree_unchanged(self):
        tree=clip(); before=copy.deepcopy(tree);decode(tree);self.assertEqual(tree,before)
    def test_guards(self):
        mutations=[
          lambda t:t.update(m_Legacy=True),
          lambda t:t.update(m_Compressed=True),
          lambda t:t.update(m_HasGenericRootTransform=True),
          lambda t:t.update(m_Events=[{}]),
          lambda t:t['m_MuscleClip'].update(m_Mirror=True),
          lambda t:t['m_MuscleClip'].update(m_StartTime=1.),
          lambda t:t['m_MuscleClip'].update(m_StopTime=2.),
          lambda t:t['m_MuscleClip']['m_Clip']['data']['m_StreamedClip'].update(curveCount=1),
          lambda t:t['m_MuscleClip']['m_Clip']['data']['m_DenseClip'].update(m_FrameCount=4),
          lambda t:t['m_MuscleClip']['m_Clip']['data']['m_DenseClip'].update(m_SampleRate=0),
          lambda t:t['m_MuscleClip']['m_Clip']['data']['m_DenseClip']['m_SampleArray'].__setitem__(0,float('nan')),
          lambda t:t['m_ClipBindingConstant']['genericBindings'][0].update(path=123),
          lambda t:t['m_ClipBindingConstant']['genericBindings'][0].update(typeID=95),
          lambda t:t['m_ClipBindingConstant']['genericBindings'][0].update(customType=1),
          lambda t:t['m_ClipBindingConstant']['genericBindings'][0].update(isPPtrCurve=1),
          lambda t:t['m_MuscleClip']['m_Clip']['data']['m_ConstantClip']['data'].__setitem__(3,2.),
          lambda t:t['m_MuscleClip']['m_Clip']['data']['m_ConstantClip']['data'].__setitem__(4,0.),
        ]
        for mutate in mutations:
            with self.subTest(mutation=mutations.index(mutate)):
                t=clip();mutate(t)
                with self.assertRaises(RecoveryError):decode(t)


class RealSkinTests(unittest.TestCase):
    def test_implicit_one_bone(self):
        g={'positions':[[0,0,0]],'joints':[[4]],'weights':[]};expand_skin(g)
        self.assertEqual(g['weights'],[[1.,0.,0.,0.]])
        self.assertEqual(g['joints'],[[4,0,0,0]])
    def test_two_bones_no_normalization(self):
        g={'positions':[[0,0,0]],'joints':[[1,2]],'weights':[[.3,.7]]};expand_skin(g)
        self.assertEqual(g['weights'],[[.3,.7,0.,0.]])
    def test_unsupported_layouts(self):
        for joints,weights in [([[1,2]],[]),([[1,2,3]],[[.2,.3,.5]]),([[1],[1,2]],[[1],[1,0]])]:
            with self.subTest(joints=joints):
                with self.assertRaises(RecoveryError):expand_skin({'positions':[[0,0,0]]*len(joints),'joints':joints,'weights':weights})
    def test_common_ancestor_can_differ_from_culling_root(self):
        self.assertEqual(common_skin_root(model()['nodes'],['mesh','bone1']),'root')
        self.assertEqual(common_skin_root(model()['nodes'],['bone0','bone1']),'bone0')
    def test_missing_joint_rejected(self):
        with self.assertRaises(RecoveryError):common_skin_root(model()['nodes'],['missing'])


class SelectionTests(unittest.TestCase):
    def setup_input(self,root):
        apk=root/'input.apk'
        with zipfile.ZipFile(apk,'w') as z:z.writestr('fragment',b'ABCD')
        return apk,{'apk_bytes':apk.stat().st_size,'apk_sha256':digest(apk.read_bytes()),'fragment':'fragment','bundle_indices':[0,1]}
    def test_selection_determinism_and_exact_bytes(self):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp);apk,profile=self.setup_input(root)
            with patch('real_asset_sample.walk_fragment',return_value=[(0,2),(2,2)]):
                a=make_selection(apk,profile,root/'a.zip');b=make_selection(apk,profile,root/'b.zip')
            self.assertEqual(a,b)
            with zipfile.ZipFile(root/'a.zip') as z:
                self.assertEqual(z.read('assets/bin/Data/bundle-0000.bundle'),b'AB')
            self.assertFalse(a['publisher_authenticated'])
    def test_profile_hash_mismatch(self):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp);apk,p=self.setup_input(root);p['apk_sha256']='0'*64
            with self.assertRaises(RecoveryError):make_selection(apk,p,root/'a.zip')
    def test_duplicate_selection_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp);apk,p=self.setup_input(root);p['bundle_indices']=[0,0]
            with self.assertRaises(RecoveryError):make_selection(apk,p,root/'a.zip')
    def test_absent_fragment_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp);apk,p=self.setup_input(root);p['fragment']='absent'
            with self.assertRaises(RecoveryError):make_selection(apk,p,root/'a.zip')
