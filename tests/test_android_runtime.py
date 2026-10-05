"""Regression tests for fail-closed Android runtime evidence and build packaging."""
import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'tools'))
from android_runtime_check import Device, verify_pose_report
from make_model_viewer import prepare
from recovery_core import file_digest, RecoveryError


def pair():
    expected={'input_sha256':'a'*64,'vector_tolerance':.0005,'angle_tolerance':.002,
              'clips':[{'name':'real', 'channels':[{'node_index':3,'path':'translation',
                        'samples':[{'time':.5,'value':[1.,2.,3.]}]}]}]}
    s={'animation':'real','node_index':3,'property':'translation','time':.5,
       'actual':[1.,2.,3.],'expected':[1.,2.,3.],'error':0.,'tolerance':.0005}
    report={'passed':True,'errors':[],'runtime_os':'Android','android_runtime_executed':True,
            'input_sha256':'a'*64,'fixture_only':False,'samples':[s],'reloaded_samples':[copy.deepcopy(s)]}
    return report,expected


class AndroidEvidenceTests(unittest.TestCase):
    def test_complete_report(self):
        self.assertEqual(verify_pose_report(*pair()),1)
    def test_non_android_refused(self):
        r,e=pair();r['runtime_os']='Linux'
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_failed_gate_refused(self):
        r,e=pair();r['passed']=False
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_wrong_hash_refused(self):
        r,e=pair();r['input_sha256']='b'*64
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_fixture_refused(self):
        r,e=pair();r['fixture_only']=True
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_dropped_samples_refused(self):
        r,e=pair();r['reloaded_samples']=[]
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_identity_swap_refused(self):
        r,e=pair();r['samples'][0]['node_index']=4
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_changed_expected_refused(self):
        r,e=pair();r['samples'][0]['expected'][0]=9
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_relaxed_tolerance_refused(self):
        r,e=pair();r['samples'][0]['tolerance']=5
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_self_reported_zero_error_not_trusted(self):
        r,e=pair();r['samples'][0]['actual'][0]=10
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_nan_actual_refused(self):
        r,e=pair();r['samples'][0]['actual'][0]=float('nan')
        with self.assertRaises(RuntimeError):verify_pose_report(r,e)
    def test_json_last_digit_rounding_allowed(self):
        r,e=pair();r['samples'][0]['expected'][0]+=1e-14
        self.assertEqual(verify_pose_report(r,e),1)
    def test_quaternion_sign_equivalence(self):
        r,e=pair();c=e['clips'][0]['channels'][0];c['path']='rotation';c['samples'][0]['value']=[0,0,0,1]
        for k in ('samples','reloaded_samples'):
            r[k][0].update(property='rotation',expected=[0,0,0,1],actual=[0,0,0,-1],tolerance=.002)
        self.assertEqual(verify_pose_report(r,e),1)
    def test_device_must_be_explicit_emulator(self):
        for serial in ('phone-serial','','emulator-5554;ls','emulator-'):
            with self.assertRaises(RuntimeError):Device(serial,Path('.'))
    def test_read_cannot_escape_own_sandbox(self):
        d=Device('emulator-5554',Path('.'))
        for path in ('../secret','x;cmd','../../data','a b'):
            with self.assertRaises(RuntimeError):d.read(path)


class RuntimePackageTests(unittest.TestCase):
    def fixture(self, root):
        model=root/'model';(model/'export').mkdir(parents=True)
        (model/'export/model.glb').write_bytes(b'package fixture only')
        sha=file_digest(model/'export/model.glb')
        for n,data in [('receipt.json',{'export_sha256':sha}),('numerical.json',{'passed':True,'glb_sha256':sha}),
                       ('godot.expected.json',{'input_sha256':sha}),('export/report.json',{})]:
            (model/n).write_text(json.dumps(data))
        return model
    def test_opt_in_keeps_raw_bytes_and_oracle(self):
        with tempfile.TemporaryDirectory() as t:
            root=Path(t);model=self.fixture(root);out=root/'viewer';prepare(model,out,runtime_checks=True)
            self.assertEqual((out/'runtime_probe/model.bin').read_bytes(),(model/'export/model.glb').read_bytes())
            self.assertEqual((out/'runtime_probe/expected.json').read_bytes(),(model/'godot.expected.json').read_bytes())
            config=(out/'export_presets.cfg').read_text()
            self.assertIn('architectures/x86_64=true',config);self.assertIn('*.bin',config)
            self.assertIn('permissions/internet=false',config)
            self.assertIn('textures/vram_compression/compress_with_gpu=false', (out/'project.godot').read_text())
    def test_normal_package_stays_arm64_without_probe_payload(self):
        with tempfile.TemporaryDirectory() as t:
            root=Path(t);prepare(self.fixture(root),root/'viewer')
            self.assertFalse((root/'viewer/runtime_probe').exists())
            self.assertIn('architectures/x86_64=false',(root/'viewer/export_presets.cfg').read_text())
    def test_changed_input_rejected_before_publication(self):
        with tempfile.TemporaryDirectory() as t:
            root=Path(t);model=self.fixture(root);(model/'export/model.glb').write_bytes(b'changed')
            with self.assertRaises(RecoveryError):prepare(model,root/'viewer',runtime_checks=True)
            self.assertFalse((root/'viewer').exists())
    def test_existing_destination_refused(self):
        with tempfile.TemporaryDirectory() as t:
            root=Path(t);model=self.fixture(root);prepare(model,root/'viewer')
            with self.assertRaises(RecoveryError):prepare(model,root/'viewer',runtime_checks=True)

class AndroidRenderingTests(unittest.TestCase):
    def png(self, draw_model=False, draw_ui=False):
        import io
        from PIL import Image, ImageDraw
        img=Image.new('RGB',(320,480),(30,31,34)); draw=ImageDraw.Draw(img)
        if draw_ui: draw.rectangle((10,10,180,80),fill=(240,240,240))
        if draw_model:
            for i in range(100): draw.line((70+i,210,70+i,330),fill=(i*2,i,200-i))
        data=io.BytesIO();img.save(data,format='PNG');return data.getvalue()
    def test_blank_frame_is_not_a_render_pass(self):
        from android_runtime_check import verify_rendered_png
        with self.assertRaises(RuntimeError):verify_rendered_png(self.png())
    def test_controls_without_model_are_rejected(self):
        from android_runtime_check import verify_rendered_png
        with self.assertRaises(RuntimeError):verify_rendered_png(self.png(draw_ui=True))
    def test_model_region_is_nonblank(self):
        from android_runtime_check import verify_rendered_png
        self.assertGreater(verify_rendered_png(self.png(draw_model=True))['variance'],64)
    def test_renderer_errors_fail_even_if_other_checks_pass(self):
        from android_runtime_check import verify_engine_log
        with self.assertRaises(RuntimeError):verify_engine_log('10-05 00:00:00 123 124 E godot : ERROR: shader link failed')
    def test_unrelated_system_errors_not_game_errors(self):
        from android_runtime_check import verify_engine_log
        verify_engine_log('10-05 00:00:00 123 124 E unrelated : ERROR: bluetooth not connected')

class PhysicalTouchTests(unittest.TestCase):
    def test_observed_surface_origin_added_once(self):
        from android_runtime_check import physical_point
        self.assertEqual(physical_point([154.5,375],{'coordinate_space':'android_surface_pixels',
                            'surface_size':[1080,2272]},[0,128,1080,2400]),[154.5,503])
    def test_surface_size_mismatch_refused(self):
        from android_runtime_check import physical_point
        with self.assertRaises(RuntimeError):physical_point([1,2],{'coordinate_space':'android_surface_pixels',
                                               'surface_size':[720,1100]},[0,128,1080,2400])
    def test_outside_target_refused(self):
        from android_runtime_check import physical_point
        with self.assertRaises(RuntimeError):physical_point([2000,2],{'coordinate_space':'android_surface_pixels',
                                                'surface_size':[1080,2272]},[0,128,1080,2400])
    def test_surface_bounds_from_android_tree(self):
        from android_runtime_check import surface_bounds,PACKAGE
        xml='<hierarchy><node package="'+PACKAGE+'" class="android.view.SurfaceView" bounds="[0,128][1080,2400]"/></hierarchy>'
        self.assertEqual(surface_bounds(xml),[0,128,1080,2400])
    def test_other_package_and_ambiguous_surfaces_refused(self):
        from android_runtime_check import surface_bounds,PACKAGE
        with self.assertRaises(RuntimeError):surface_bounds('<hierarchy><node package="other" class="SurfaceView" bounds="[0,0][50,50]"/></hierarchy>')
        a='<node package="'+PACKAGE+'" class="SurfaceView" bounds="[0,0][50,50]"/>'
        b=a.replace('[50,50]','[60,60]')
        with self.assertRaises(RuntimeError):surface_bounds('<hierarchy>'+a+b+'</hierarchy>')
