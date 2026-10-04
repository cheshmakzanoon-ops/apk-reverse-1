"""Animation recovery regressions; all Unity data here is explicitly generated."""
import copy
import importlib.util
import json
from pathlib import Path
import struct
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
import recovery_animation as animation
import recovery_model
from recovery_core import RecoveryError, digest
from gltf_model import make_glb, unpack_glb, read_accessor
from test_recovery_r3 import repack
from model_fixtures import model
from animation_fixtures import clip_tree, independent_sample, actual_export


class CurveTests(unittest.TestCase):
    def decode(self, tree=None, src=None, **kw):
        return animation.decode_clip(tree or clip_tree(), 'a'*64, 'b'*64, src or model(), **kw)

    def test_three_channels_and_provenance(self):
        c=self.decode(); self.assertEqual(len(c['channels']),3)
        self.assertEqual(c['source_sha256'],'b'*64); self.assertEqual(c['binding_root'],'root')
        self.assertEqual(c['original_name'],'GeneratedMotion')

    def test_independent_hermite_basis_and_normalization(self):
        for c in self.decode()['channels']:
            for t in [-.1,0,.17,.53,1.1,1.93,2,3]:
                expected=independent_sample(c,t)
                got=animation.convert(animation.evaluate(c,t),c['path'])
                for a,b in zip(expected,got): self.assertAlmostEqual(a,b,places=6)

    def test_tangents_not_normalized(self):
        t=clip_tree(); t['m_PositionCurves'][0]['curve']['m_Curve'][0]['outSlope']['x']=4.0
        c=self.decode(t)['channels'][0]
        self.assertEqual(animation.convert(c['out'][0],'translation'),[-4.,0.,.25])

    def test_time_float32_collision_rejected(self):
        t=clip_tree(); keys=t['m_PositionCurves'][0]['curve']['m_Curve']
        keys[0]['time']=1.; keys[1]['time']=1.+1e-9
        with self.assertRaisesRegex(RecoveryError,'increasing'): self.decode(t)

    def test_nonincreasing_negative_nonfinite_times(self):
        for a,b in [(2,1),(1,1),(-1,1),(0,float('nan')),(0,float('inf')),(0,86401)]:
            t=clip_tree(); keys=t['m_PositionCurves'][0]['curve']['m_Curve']; keys[0]['time']=a;keys[1]['time']=b
            with self.subTest(a=a,b=b),self.assertRaises(RecoveryError): self.decode(t)

    def test_weighted_and_nonfinite_tangents_rejected(self):
        for field,value in [('weightedMode',1),('inSlope',dict(x=float('inf'),y=0,z=0)),('outSlope',dict(x=0,y=float('nan'),z=0))]:
            t=clip_tree();t['m_PositionCurves'][0]['curve']['m_Curve'][0][field]=value
            with self.subTest(field=field),self.assertRaises(RecoveryError): self.decode(t)

    def test_unsupported_formats_and_events_fail_closed(self):
        for field,value in [('m_Legacy',False),('m_Compressed',True),('m_MuscleClipSize',4),
                            ('m_CompressedRotationCurves',[{}]),('m_EulerCurves',[{}]),
                            ('m_FloatCurves',[{}]),('m_PPtrCurves',[{}]),('m_Events',[{'functionName':'NeverExecute'}])]:
            t=clip_tree();t[field]=value
            with self.subTest(field=field),self.assertRaises(RecoveryError): self.decode(t)

    def test_curve_wrap_modes_rejected_but_clip_wrap_preserved(self):
        t=clip_tree();t['m_WrapMode']=2
        self.assertEqual(self.decode(t)['source_wrap_mode'],2)
        t['m_PositionCurves'][0]['curve']['m_PostInfinity']=4
        with self.assertRaisesRegex(RecoveryError,'infinity'): self.decode(t)

    def test_empty_keys_and_empty_clip_rejected(self):
        t=clip_tree();t['m_PositionCurves'][0]['curve']['m_Curve']=[]
        with self.assertRaises(RecoveryError): self.decode(t)
        for k in animation.FIELDS:t[k]=[]
        with self.assertRaises(RecoveryError): self.decode(t)

    def test_path_resolution_exact_and_unicode(self):
        src=model();src['nodes'][1]['name']='测试模型'
        self.assertEqual(self.decode(clip_tree('测试模型'),src)['channels'][0]['node'],'mesh')
        with self.assertRaises(RecoveryError): self.decode(clip_tree('fixturemesh'))

    def test_missing_duplicate_and_unsafe_paths_rejected(self):
        for path in ['Unknown','../FixtureMesh','/FixtureMesh','FixtureMesh/','FixtureRoot/FixtureMesh']:
            with self.subTest(path=path),self.assertRaises(RecoveryError):self.decode(clip_tree(path))
        src=model();src['nodes'][2]['name']='FixtureMesh'
        with self.assertRaisesRegex(RecoveryError,'ambiguous'):self.decode(src=src)
        src=model();src['nodes'][1]['name']='bad/name'
        with self.assertRaisesRegex(RecoveryError,'component'):self.decode(src=src)

    def test_binding_root_is_explicit(self):
        self.assertEqual(self.decode(clip_tree(''),binding_root='mesh')['channels'][0]['node'],'mesh')
        with self.assertRaises(RecoveryError):self.decode(binding_root='absent')
        with self.assertRaises(RecoveryError):self.decode(binding_root='bone0')

    def test_duplicate_targets_rejected(self):
        t=clip_tree();t['m_PositionCurves']*=2
        with self.assertRaisesRegex(RecoveryError,'duplicate'):self.decode(t)

    def test_budget_limits(self):
        with patch.object(animation,'MAX_KEYS',1),self.assertRaises(RecoveryError):self.decode()
        with patch.object(animation,'MAX_CHANNELS',1),self.assertRaises(RecoveryError):self.decode()

    def test_quaternion_zero_and_hemisphere_guards(self):
        for q in [dict(x=0,y=0,z=0,w=0),dict(x=0,y=0,z=0,w=-1)]:
            t=clip_tree();t['m_RotationCurves'][0]['curve']['m_Curve'][1]['value']=q
            with self.subTest(q=q),self.assertRaises(RecoveryError):self.decode(t)
        t=clip_tree();t['m_RotationCurves'][0]['curve']['m_Curve'][0]['outSlope']['w']=-100
        with self.assertRaises(RecoveryError):self.decode(t)

    def test_scale_zero_crossing_guard(self):
        t=clip_tree();t['m_ScaleCurves'][0]['curve']['m_Curve'][0]['outSlope']['x']=-100
        with self.assertRaisesRegex(RecoveryError,'scale'):self.decode(t)

    def test_source_inputs_not_mutated(self):
        src=model();t=clip_tree();before=copy.deepcopy((src,t));self.decode(t,src)
        self.assertEqual((src,t),before)

    def test_single_key_channel_clamps(self):
        t=clip_tree();t['m_ScaleCurves'][0]['curve']['m_Curve']=t['m_ScaleCurves'][0]['curve']['m_Curve'][:1]
        c=self.decode(t)['channels'][2]
        self.assertEqual(animation.evaluate(c,100),[1,1,1])


class AnimatedGLBTests(unittest.TestCase):
    def blob(self):
        src=model(True,True)
        clip=animation.decode_clip(clip_tree('FixtureBone0/FixtureBone1'),'a'*64,'b'*64,src)
        return animation.append_clips(make_glb(src),[clip])

    def test_skinned_animation_counts(self):
        result=animation.validate_animated_glb(self.blob())
        self.assertEqual((result['animations'],result['animation_channels'],result['animation_keys']),(1,3,6))
        self.assertEqual(result['skinned_instances'],1)

    def test_original_geometry_and_material_preserved(self):
        static=make_glb(model(True,True));before,old=unpack_glb(static);after,new=unpack_glb(self.blob())
        self.assertEqual(old,new[:len(old)])
        for key in ['nodes','meshes','skins','materials','images']:
            self.assertEqual(before[key],after[key])

    def test_glb_source_tangents_and_times_preserved(self):
        doc,buf=unpack_glb(self.blob());s=doc['animations'][0]['samplers'][0]
        self.assertEqual(read_accessor(doc,buf,s['input']),[[0.],[2.]])
        values=read_accessor(doc,buf,s['output'])
        self.assertEqual(values[2],[-.5,0,.25]);self.assertEqual(values[3],[0,1,.5])

    def test_determinism(self):self.assertEqual(self.blob(),self.blob())

    def test_existing_animation_not_replaced(self):
        c=animation.decode_clip(clip_tree(),'a'*64,'b'*64,model())
        with self.assertRaisesRegex(RecoveryError,'replace'):animation.append_clips(self.blob(),[c])

    def test_duplicate_clip_rejected(self):
        c=animation.decode_clip(clip_tree(),'a'*64,'b'*64,model())
        with self.assertRaises(RecoveryError):animation.append_clips(make_glb(model()),[c,c])

    def test_single_key_emits_step(self):
        t=clip_tree();t['m_ScaleCurves'][0]['curve']['m_Curve']=t['m_ScaleCurves'][0]['curve']['m_Curve'][:1]
        c=animation.decode_clip(t,'a'*64,'b'*64,model())
        doc,_=unpack_glb(animation.append_clips(make_glb(model()),[c]))
        self.assertEqual(doc['animations'][0]['samplers'][2]['interpolation'],'STEP')

    def test_corrupt_bindings_and_accessor_metadata_rejected(self):
        mutations=[lambda d:d['animations'][0]['channels'][0]['target'].update(node=500),
                   lambda d:d['animations'][0]['channels'][0].update(sampler=-1),
                   lambda d:d['animations'][0]['samplers'][0].update(interpolation='LINEAR'),
                   lambda d:d['animations'][0]['channels'][1].update(target=d['animations'][0]['channels'][0]['target']),
                   lambda d:d['accessors'][d['animations'][0]['samplers'][0]['input']].update(min=[999]),
                   lambda d:d['animations'][0]['samplers'][0].update(output=d['animations'][0]['samplers'][0]['input'])]
        for change in mutations:
            doc,buf=unpack_glb(self.blob());change(doc)
            with self.subTest(change=change),self.assertRaises(RecoveryError):animation.validate_animated_glb(repack(doc,buf))

    def test_changed_quaternion_key_rejected(self):
        doc,buf=unpack_glb(self.blob());s=doc['animations'][0]['samplers'][1]
        a=doc['accessors'][s['output']];start=doc['bufferViews'][a['bufferView']]['byteOffset']
        data=bytearray(buf);struct.pack_into('<4f',data,start+16,0,0,0,0)
        with self.assertRaises(RecoveryError):animation.validate_animated_glb(repack(doc,bytes(data)))

    def test_model_export_overwrite_guard_unchanged(self):
        with tempfile.TemporaryDirectory() as tmp,self.assertRaises(RecoveryError):
            recovery_model.export_snapshot('absent','absent',tmp,clip_ids=['a'*64])


@unittest.skipUnless(importlib.util.find_spec('UnityPy'),'actual UnityPy required in CI')
class ActualAnimatedIntegration(unittest.TestCase):
    def test_real_unity_static_clip_capture_to_glb(self):
        with tempfile.TemporaryDirectory() as tmp:
            result=actual_export(Path(tmp)/'fixture',False)
            self.assertEqual(result['animations_exported'],1)
            self.assertEqual(result['counts']['animation_channels'],3)
            self.assertFalse(result['animation_runtime_equivalence_verified'])

    def test_real_unity_skinned_clip_capture_to_glb(self):
        with tempfile.TemporaryDirectory() as tmp:
            result=actual_export(Path(tmp)/'fixture',True)
            self.assertEqual(result['animations_exported'],1)
            self.assertEqual(result['counts']['skinned_instances'],1)
