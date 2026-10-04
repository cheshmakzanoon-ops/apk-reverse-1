"""Regression for the measured Godot 4.4.1 cubic-quaternion import discrepancy."""
import bisect
import hashlib
from pathlib import Path
import struct
import sys
import tempfile
import unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
import godot_animation as compat
from recovery_animation import append_clips, decode_clip, validate_animated_glb
from gltf_model import make_glb, unpack_glb, read_accessor
from recovery_core import RecoveryError
from model_fixtures import model
from animation_fixtures import clip_tree, independent_sample


class GodotCompatibilityTests(unittest.TestCase):
    def source(self):
        src=model(True,True)
        clip=decode_clip(clip_tree('FixtureBone0/FixtureBone1'),'a'*64,'b'*64,src)
        return append_clips(make_glb(src),[clip]),clip

    def test_independent_off_grid_rotation_matches(self):
        source,clip=self.source();blob,report=compat.prepare(source)
        doc,binary=unpack_glb(blob);sampler=doc['animations'][0]['samplers'][1]
        t=[v[0] for v in read_accessor(doc,binary,sampler['input'])];q=read_accessor(doc,binary,sampler['output'])
        self.assertEqual(sampler['interpolation'],'LINEAR')
        for i in range(997):
            time=2*i/997;j=min(len(t)-2,max(0,bisect.bisect_right(t,time)-1))
            got=compat.slerp(q[j],q[j+1],(time-t[j])/(t[j+1]-t[j]))
            want=independent_sample(clip['channels'][1],time)
            self.assertLess(compat.angular_error(got,want),.0001)
        self.assertGreater(report['rotation_tracks'][0]['keys'],2)
        self.assertFalse(report['continuous_error_bound_proved'])

    def test_original_geometry_and_vector_splines_unchanged(self):
        source,_=self.source();blob,_=compat.prepare(source)
        before,old=unpack_glb(source);after,new=unpack_glb(blob)
        self.assertEqual(old,new[:len(old)])
        for key in ('nodes','meshes','materials','skins','images'):
            self.assertEqual(before[key],after[key])
        for index in (0,2):
            self.assertEqual(before['animations'][0]['samplers'][index],after['animations'][0]['samplers'][index])

    def test_source_and_derivative_are_distinguished(self):
        source,_=self.source();blob,report=compat.prepare(source)
        self.assertEqual(report['source_glb_sha256'],hashlib.sha256(source).hexdigest())
        self.assertEqual(report['output_glb_sha256'],hashlib.sha256(blob).hexdigest())
        self.assertNotEqual(source,blob)
        validate_animated_glb(source)
        with self.assertRaises(RecoveryError):validate_animated_glb(blob)
        validate_animated_glb(blob,allow_linear_rotation=True)
        with self.assertRaises(RecoveryError):compat.prepare(blob)

    def test_deterministic_bake(self):
        source,_=self.source();self.assertEqual(compat.prepare(source),compat.prepare(source))

    def test_shortest_rotation_sign_and_identity(self):
        self.assertLess(compat.angular_error([0,0,0,1],[0,0,0,-1]),1e-12)
        self.assertEqual(compat.slerp([0,0,0,1],[0,0,0,-1],.3),[0.,0.,0.,1.])

    def test_invalid_bake_settings_and_key_budget(self):
        _,clip=self.source();c=clip['channels'][1]
        for fps in (0,-1,1001,float('nan'),float('inf')):
            with self.subTest(fps=fps),self.assertRaises(RecoveryError):compat.bake_rotation(c,fps=fps)
        with self.assertRaises(RecoveryError):compat.bake_rotation(c,budget=2)
        with self.assertRaises(RecoveryError):compat.bake_rotation(c,tolerance=0)

    def test_adaptive_subdivision_meets_checked_tolerance(self):
        _,clip=self.source();t,q,report=compat.bake_rotation(clip['channels'][1],fps=1,tolerance=.00001)
        self.assertGreater(len(t),3)
        self.assertLessEqual(report['max_accepted_probe_error_radians'],.00001)
        self.assertEqual((t[0],t[-1]),(0.,2.))

    def test_cli_does_not_overwrite_source_or_report(self):
        source,_=self.source()
        with tempfile.TemporaryDirectory() as tmp:
            p=Path(tmp);(p/'source.glb').write_bytes(source)
            with self.assertRaises(SystemExit):compat.main([str(p/'source.glb'),str(p/'source.glb')])
            self.assertEqual((p/'source.glb').read_bytes(),source)
            (p/'out.compatibility.json').write_text('keep')
            with self.assertRaises(SystemExit):compat.main([str(p/'source.glb'),str(p/'out.glb')])
            self.assertFalse((p/'out.glb').exists())
