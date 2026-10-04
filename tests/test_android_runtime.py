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
