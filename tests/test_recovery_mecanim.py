"""Generated regression inputs only; actual game profile is checked separately."""
import copy
import io
import json
from pathlib import Path
import struct
import sys
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch
import zlib
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
import recover
import recovery_mecanim as m
from recovery_core import Catalog, RecoveryError, digest
from recovery_model import expand_skin as expand_skin_channels, common_skin_root
from packed_material import preview_material
from recovery_animation import append_clips, validate_animated_glb
from gltf_model import make_glb, unpack_glb
sys.path.insert(0,str(Path(__file__).resolve().parent))


def words(frames):
    raw=b''.join(struct.pack('<fi',t,len(keys))+b''.join(struct.pack('<i4f',i,*c)for i,c in keys)for t,keys in frames)
    return list(struct.unpack('<'+str(len(raw)//4)+'I',raw))


def clip(kind=1):
    width={1:3,2:4,3:3}[kind]
    data={'m_StreamedClip':{'curveCount':0,'data':words([(float('inf'),[])])},
          'm_DenseClip':{'m_FrameCount':3,'m_CurveCount':width,'m_BeginTime':0.,'m_SampleRate':2.,
                        'm_SampleArray':([0.,0.,0.,1.,2.,3.,2.,4.,6.] if kind==1 else
                         [0.,0.,0.,1.,0.,0.,.3826834324,.9238795325,0.,0.,.7071067812,.7071067812]if kind==2 else
                         [1.,1.,1.,2.,2.,2.,1.,1.,1.])},'m_ConstantClip':{'data':[]}}
    return {'m_Name':'generated','m_Legacy':False,'m_Compressed':False,'m_Events':[],
            'm_MuscleClip':{'m_StartTime':0.,'m_StopTime':1.,'m_Clip':{'data':data}},
            'm_ClipBindingConstant':{'genericBindings':[{'path':0,'attribute':kind,'typeID':4,
                'customType':0,'isPPtrCurve':0,'script':{'m_FileID':0,'m_PathID':0}}], 'pptrCurveMapping':[]}}


MODEL={'root':'root','nodes':[{'id':'root','name':'root','children':[]}]}


def decode(tree,model=None):return m.decode_mecanim(tree,'a'*64,'b'*64,model or MODEL)


class PackedTests(unittest.TestCase):
    def test_dense_linear_values_and_slopes(self):
        c=decode(clip())['channels'][0]
        self.assertEqual(c['times'],[0.,.5,1.]);self.assertEqual(c['values'][1],[1.,2.,3.])
        self.assertEqual(c['out'][0],[2.,4.,6.]);self.assertEqual(c['in'][-1],[2.,4.,6.])
    def test_dense_frame_after_stop_is_not_exported(self):
        t=clip();t['m_MuscleClip']['m_StopTime']=.75;c=decode(t)['channels'][0]
        self.assertEqual(c['times'][-1],.75);self.assertEqual(c['values'][-1],[1.5,3.,4.5])
    def test_dense_bad_layout_and_timing(self):
        for field,value in [('m_FrameCount',4),('m_CurveCount',2),('m_SampleRate',0.),('m_BeginTime',-1.)]:
            t=clip();t['m_MuscleClip']['m_Clip']['data']['m_DenseClip'][field]=value
            with self.subTest(field=field),self.assertRaises(RecoveryError):decode(t)
    def test_dense_nonfinite_samples_rejected(self):
        t=clip();t['m_MuscleClip']['m_Clip']['data']['m_DenseClip']['m_SampleArray'][0]=float('nan')
        with self.assertRaises(RecoveryError):decode(t)
    def test_dense_time_collision_is_rejected(self):
        t=clip();d=t['m_MuscleClip']['m_Clip']['data']['m_DenseClip'];d.update(m_BeginTime=10000.,m_SampleRate=1e9)
        with self.assertRaisesRegex(RecoveryError,'collapse'):decode(t)
    def test_streamed_polynomial_and_tangent(self):
        w=words([(0.,[(0,[2.,-1.,3.,4.])]),(1.,[(0,[0.,0.,0.,8.])]),(float('inf'),[])])
        curves,detail=m.streamed({'curveCount':1,'data':w})
        self.assertEqual(curves[0].at(.5),(5.5,3.5));self.assertEqual(curves[0].at(1.,side='left')[1],7.)
        self.assertEqual(detail['max_endpoint_residual'],0.)
    def test_streamed_sentinel_is_not_a_key(self):
        w=words([(-3.4028234663852886e38,[(0,[0.,0.,0.,99.])]),(0.,[(0,[0.,0.,0.,1.])]),(float('inf'),[])])
        c,_=m.streamed({'curveCount':1,'data':w});self.assertEqual(c[0].times,[0.]);self.assertEqual(c[0].at(.3)[0],1.)
    def test_streamed_sparse_indices(self):
        w=words([(0.,[(0,[0.,0.,1.,0.]),(1,[0.,0.,0.,3.])]),(.5,[(0,[0.,0.,1.,.5])]),
                 (1.,[(0,[0.,0.,0.,1.]),(1,[0.,0.,0.,3.])]),(float('inf'),[])])
        c,_=m.streamed({'curveCount':2,'data':w});self.assertEqual(c[0].at(.75)[0],.75);self.assertEqual(c[1].at(.75)[0],3.)
    def test_stream_duplicate_and_index_escape(self):
        for keys in [[(0,[0.]*4),(0,[0.]*4)],[(2,[0.]*4)]]:
            with self.subTest(keys=keys),self.assertRaises(RecoveryError):m.streamed({'curveCount':2,'data':words([(0.,keys),(float('inf'),[])])})
    def test_stream_truncated_and_terminal_guards(self):
        good=words([(0.,[(0,[0.,0.,0.,1.])]),(float('inf'),[])])
        for w in [good[:-1],good[:-2],good+[0],words([(float('inf'),[(0,[0.]*4)])]),words([(1.,[]),(0.,[])])]:
            with self.subTest(w=w),self.assertRaises(RecoveryError):m.streamed({'curveCount':1,'data':w})
    def test_step_jump_cannot_be_silently_smoothed(self):
        w=words([(0.,[(0,[0.,0.,0.,1.])]),(1.,[(0,[0.,0.,0.,2.])]),(float('inf'),[])])
        with self.assertRaisesRegex(RecoveryError,'discontinuous'):m.streamed({'curveCount':1,'data':w})
    def test_nonfinite_coefficients_rejected(self):
        w=words([(0.,[(0,[float('nan'),0.,0.,1.])]),(float('inf'),[])])
        with self.assertRaises(RecoveryError):m.streamed({'curveCount':1,'data':w})
    def test_boundaries_and_data_not_mutated(self):
        t=clip();original=copy.deepcopy(t);decode(t);self.assertEqual(t,original)
    def test_exact_hashed_binding_and_explicit_root(self):
        model={'root':'top','nodes':[{'id':'top','name':'top','children':['root']},{'id':'root','name':'root','children':['child']},
                                  {'id':'child','name':'café','children':[]}]}
        t=clip();t['m_ClipBindingConstant']['genericBindings'][0]['path']=zlib.crc32('café'.encode())
        with self.assertRaisesRegex(RecoveryError,'path hash'):decode(t,model)
        c=m.decode_mecanim(t,'a'*64,'b'*64,model,'root');self.assertEqual(c['channels'][0]['node'],'child')
    def test_ambiguous_siblings_and_crc_collisions(self):
        model={'root':'root','nodes':[{'id':'root','name':'r','children':['a','b']},{'id':'a','name':'same','children':[]},{'id':'b','name':'same','children':[]}]}
        t=clip();t['m_ClipBindingConstant']['genericBindings'][0]['path']=zlib.crc32(b'same')
        with self.assertRaisesRegex(RecoveryError,'ambiguous'):decode(t,model)
        with patch.object(m.zlib,'crc32',return_value=0),self.assertRaisesRegex(RecoveryError,'ambiguous'):decode(clip(),model)
    def test_unknown_target_and_duplicate_binding(self):
        for change in [{'path':111},{'attribute':4},{'typeID':95},{'isPPtrCurve':1},{'customType':1}]:
            t=clip();t['m_ClipBindingConstant']['genericBindings'][0].update(change)
            with self.subTest(change=change),self.assertRaises(RecoveryError):decode(t)
        t=clip();t['m_ClipBindingConstant']['genericBindings']*=2
        with self.assertRaisesRegex(RecoveryError,'duplicate'):decode(t)
    def test_unbound_tail_rejected(self):
        t=clip();t['m_MuscleClip']['m_Clip']['data']['m_ConstantClip']['data']=[4.]
        with self.assertRaisesRegex(RecoveryError,'unbound'):decode(t)
    def test_events_blends_and_root_motion_rejected(self):
        for key in ['m_Events','m_HasMotionFloatCurves','m_HasGenericRootTransform','m_RotationCurves']:
            t=clip();t[key]=[1]
            with self.subTest(key=key),self.assertRaises(RecoveryError):decode(t)
        t=clip();t['m_MuscleClip']['m_Mirror']=True
        with self.assertRaises(RecoveryError):decode(t)
    def test_scale_zero_crossing_rejected(self):
        t=clip(3);t['m_MuscleClip']['m_Clip']['data']['m_DenseClip']['m_SampleArray'][3]=-2.
        with self.assertRaises(RecoveryError):decode(t)
    def test_quaternion_bake_is_unit_and_has_provenance(self):
        c=decode(clip(2));channel=c['channels'][0];self.assertEqual(channel['interpolation'],'LINEAR')
        self.assertGreaterEqual(len(channel['times']),121)
        self.assertLess(c['max_accepted_rotation_probe_error_radians'],.0001)
        self.assertFalse(c['rotation_continuous_error_bound_proved'])
        self.assertTrue(all(abs(sum(v*v for v in row)-1)<1e-10 for row in channel['values']))
    def test_quaternion_zero_rejected(self):
        t=clip(2);t['m_MuscleClip']['m_Clip']['data']['m_DenseClip']['m_SampleArray'][4:8]=[0.]*4
        with self.assertRaises(RecoveryError):decode(t)


class ModelAdapters(unittest.TestCase):
    def test_one_bone_implicit_weights(self):
        g={'positions':[[0,0,0]],'joints':[[4]]};expand_skin_channels(g)
        self.assertEqual(g['weights'],[[1.,0.,0.,0.]]);self.assertEqual(g['joints'],[[4,0,0,0]])
        self.assertEqual(g['source_skin_influences'],1)
    def test_two_bone_padding(self):
        g={'positions':[[0,0,0]],'joints':[[1,2]],'weights':[[.25,.75]]};expand_skin_channels(g)
        self.assertEqual(g['weights'],[[.25,.75,0.,0.]])
    def test_missing_weights_and_widths_rejected(self):
        for g in [{'positions':[[0,0,0]],'joints':[[1,2]]},{'positions':[[0,0,0]],'joints':[[1]],'weights':[[1,0]]},
                  {'positions':[[0,0,0]],'joints':[[1,2,3]]},{'positions':[],'weights':[[1]]}]:
            with self.subTest(g=g),self.assertRaises(RecoveryError):expand_skin_channels(g)
    def test_pivot_conversion_preserves_joints_and_binds(self):
        skin={'joints':['a','b'],'root':'a','inverse_bind_matrices':[[1],[2]]}
        model={'nodes':[{'id':'r','children':['a','b']},{'id':'a','children':[]},{'id':'b','children':[]}], 'renderers':[{'skin':skin}]}
        self.assertEqual(common_skin_root(model['nodes'],skin['joints']),'r');self.assertEqual(skin['root'],'a')
        self.assertEqual(skin['joints'],['a','b']);self.assertEqual(skin['inverse_bind_matrices'],[[1],[2]])
    def test_no_joint_outside_hierarchy(self):
        with self.assertRaises(RecoveryError):common_skin_root([{'id':'r','children':[]}],['missing'])
    def test_basemap_preview_and_hdr_metadata(self):
        def tree(_):return {'m_Name':'example','m_SavedProperties':{'m_Colors':{'_BaseColor':{'r':4.,'g':2.,'b':1.,'a':1.}},
                          'm_TexEnvs':{'_BaseMap':{'m_Texture':None}}}}
        reader=NS(tree=tree,ref=lambda *a,**k:None)
        out=preview_material(reader,'source');self.assertEqual(out['color'],[1.,.5,.25,1.])
        self.assertEqual(out['source_color'],[4.,2.,1.,1.]);self.assertEqual(out['source_texture_property'],'_BaseMap')


class ResourceLookupTests(unittest.TestCase):
    def test_native_resource_reader_loads_catalog_bytes(self):
        from UnityPy.helpers.ResourceReader import get_resource_data
        with tempfile.TemporaryDirectory()as temp:
            root=Path(temp);store=NS(path=lambda sha:root/sha);raw=b'abcdef012345';sha=digest(raw);(root/sha).write_bytes(raw)
            member={'sha':sha,'size':len(raw)}
            catalog=NS(store=store,resolve=lambda name,owner:('resolved',member) if name=='image.resS' else('unresolved_in_capture',None))
            env=recover.environment(catalog,'owner')
            source=NS(environment=env,load_dependencies=lambda _:self.fail('should find captured stream before filesystem lookup'))
            self.assertEqual(get_resource_data('archive:/image.resS',source,3,5),b'def01')
            self.assertEqual(env.load_file('image.resS').bytes,raw)
    def test_corrupt_resource_is_fatal(self):
        with tempfile.TemporaryDirectory()as temp:
            raw=b'abc';sha=digest(raw);p=Path(temp)/sha;p.write_bytes(b'xyz')
            cat=NS(store=NS(path=lambda _:p),resolve=lambda *_:('resolved',{'sha':sha,'size':3}))
            with self.assertRaisesRegex(RecoveryError,'differ'):recover.environment(cat,'owner').get_cab('x.resS')
    def test_ambiguity_does_not_reuse_cached_basename(self):
        import UnityPy
        env=recover.environment(NS(resolve=lambda *_:('ambiguous',None)),'owner')
        env.register_cab('x.resS',object())
        self.assertIsNone(env.get_cab('x.resS'))
        with self.assertRaisesRegex(FileNotFoundError,'ambiguous'):env.load_file('x.resS')
    def test_host_file_cannot_be_used_as_a_dependency(self):
        with tempfile.NamedTemporaryFile()as f:
            env=recover.environment(NS(resolve=lambda *_:('unresolved_in_capture',None)),'owner')
            with self.assertRaises(FileNotFoundError):env.load_file(f.name)

class ProfileTests(unittest.TestCase):
    def test_committed_profile_ranges(self):
        from real_model_sample import validate_profile
        p=json.loads((Path(__file__).resolve().parents[1]/'docs/inputs/farhad-streamed-model.json').read_text())
        validate_profile(p)
        self.assertEqual(len(p['clips']),8);self.assertEqual(len(p['excluded_clips']),2)
    def test_invalid_profile_ranges_and_hashes(self):
        from real_model_sample import validate_profile
        p=json.loads((Path(__file__).resolve().parents[1]/'docs/inputs/farhad-streamed-model.json').read_text())
        for change in [{'size':0},{'offset':-1},{'sha256':'oops'},{'index':'../file'}]:
            q=copy.deepcopy(p);q['bundles'][0].update(change)
            with self.subTest(change=change),self.assertRaises(RecoveryError):validate_profile(q)
        q=copy.deepcopy(p);q['bundles'][1]['offset']=0
        with self.assertRaises(RecoveryError):validate_profile(q)
    def test_input_mismatch_never_creates_output(self):
        from real_model_sample import build
        with tempfile.TemporaryDirectory()as d:
            root=Path(d);(root/'app.apk').write_bytes(b'bad')
            profile=Path(__file__).resolve().parents[1]/'docs/inputs/farhad-streamed-model.json'
            with self.assertRaisesRegex(RecoveryError,'hash mismatch'):build(root/'app.apk',root/'result',profile)
            self.assertFalse((root/'result').exists());self.assertFalse(list(root.glob('.model-pending*')))
    def test_unapproved_root_object_rejected(self):
        from real_model_sample import selector
        import sqlite3
        db=sqlite3.connect(':memory:');db.row_factory=sqlite3.Row
        db.executescript('CREATE TABLE members(id TEXT,name TEXT);CREATE TABLE objects(id TEXT,member_id TEXT,path_id INTEGER,type TEXT,sha TEXT);')
        with self.assertRaises(RecoveryError):selector(NS(db=db),{'member':'absent','path_id':'1','sha256':'a'*64},'Transform')
        db.close()

class OutputTests(unittest.TestCase):
    def test_packed_rotation_survives_real_glb_serialization(self):
        from model_fixtures import model
        md=model(skinned=True);decoded=decode(clip(2),md)
        blob=append_clips(make_glb(md),[decoded]);counts=validate_animated_glb(blob,allow_linear_rotation=True)
        self.assertEqual(counts['animations'],1)
        document,_=unpack_glb(blob);self.assertEqual(document['animations'][0]['samplers'][0]['interpolation'],'LINEAR')
    def test_reference_detects_changed_values(self):
        from verify_mecanim import gltf_value, rotation_error
        import numpy as np
        q=gltf_value(np.array([0.,1.]),np.array([[0.,0.,0.,1.],[0.,0.,1.,0.]]),'LINEAR',.5)
        self.assertLess(rotation_error(q,[0.,0.,2**-.5,2**-.5]),1e-12)
        self.assertGreater(rotation_error(q,[0.,0.,0.,1.]),1.)

if __name__=='__main__':unittest.main()
