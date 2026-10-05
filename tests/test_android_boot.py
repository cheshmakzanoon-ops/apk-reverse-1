"""Generated readiness/error fixtures; these do not count as Android executions."""
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'tools'))
from android_boot_guard import configuration_key, wait_ready
from android_runtime_check import Device


class Clock:
    def __init__(self): self.now = 0.0
    def read(self): return self.now
    def sleep(self, seconds): self.now += seconds


class BootReadinessTests(unittest.TestCase):
    def run_guard(self, timeline, **kwargs):
        clock = Clock()
        with tempfile.TemporaryDirectory() as tmp:
            output = Path(tmp)/'boot.json'
            def shell(*args):
                boot, animation, config = timeline(clock.now)
                return {('getprop','sys.boot_completed'): boot,
                        ('getprop','init.svc.bootanim'): animation,
                        ('am','get-config'): config}[args]
            try:
                result = wait_ready(shell,output,clock=clock.read,sleep=clock.sleep,
                                    stable_seconds=4,timeout=16,**kwargs)
            finally:
                self.evidence = json.loads(output.read_text())
            self.assertEqual(result,self.evidence)
            return result
    def test_current_config_not_recent_history(self):
        self.assertEqual(configuration_key('config: current\nabi: x86_64\nrecentConfigs:\n config: old'),'current')
    def test_ambiguous_missing_current_rejected(self):
        for value in ('','config:','abi: x86_64','config: a\nconfig: b'):
            with self.subTest(value=value),self.assertRaises(RuntimeError): configuration_key(value)
    def test_ready_only_after_stable_window(self):
        r=self.run_guard(lambda _:('1','stopped','config: portrait'))
        self.assertEqual(r['observed_stable_seconds'],4)
        self.assertEqual(len(r['observations']),3)
    def test_change_resets_stable_window(self):
        r=self.run_guard(lambda t:('1','stopped','config: '+('old' if t<4 else 'new')))
        self.assertEqual(r['observations'][-1]['elapsed_seconds'],8)
    def test_incomplete_boot_does_not_accumulate_stability(self):
        r=self.run_guard(lambda t:('0' if t<4 else '1','stopped','config: ready'))
        self.assertEqual(r['observations'][-1]['elapsed_seconds'],8)
    def test_boot_animation_must_finish(self):
        r=self.run_guard(lambda t:('1','running' if t<4 else 'stopped','config: ready'))
        self.assertEqual(r['observations'][-1]['elapsed_seconds'],8)
    def test_unstable_configuration_fails_and_preserves_history(self):
        with self.assertRaises(RuntimeError):self.run_guard(lambda t:('1','stopped',f'config: {t}'))
        self.assertFalse(self.evidence['ready']);self.assertEqual(len(self.evidence['observations']),8)
        self.assertIn('error',self.evidence)
    def test_boot_never_complete_fails(self):
        with self.assertRaises(RuntimeError):self.run_guard(lambda _:('0','running','config: ready'))
        self.assertFalse(self.evidence['ready'])
    def test_malformed_config_fails_without_claiming_readiness(self):
        with self.assertRaises(RuntimeError):self.run_guard(lambda _:('1','stopped','bad output'))
        self.assertFalse(self.evidence['ready'])
    def test_existing_evidence_not_overwritten(self):
        with tempfile.TemporaryDirectory() as tmp:
            p=Path(tmp)/'boot.json';p.write_text('original')
            with self.assertRaises(RuntimeError): wait_ready(lambda *_:'',p)
            self.assertEqual(p.read_text(),'original')
    def test_invalid_budget_rejected(self):
        for window,budget in [(0,1),(4,4),(4,601),(float('nan'),10),(4,float('inf'))]:
            with self.subTest(window=window), self.assertRaises(ValueError):
                wait_ready(lambda *_:'',Path('unused'),stable_seconds=window,timeout=budget)
    def test_engine_failure_aborts_report_wait(self):
        with tempfile.TemporaryDirectory() as tmp:
            device=Device('emulator-5554',Path(tmp))
            with patch.object(device,'adb',return_value=b'10-05 01:06:00 3141 3141 E godot : ERROR: native setup failed'),\
                 patch.object(device,'read',return_value=b'{}') as read,\
                 patch('android_runtime_check.time.monotonic',return_value=3.0):
                with self.assertRaisesRegex(RuntimeError,'native setup failed'):device.wait_json('animation.json')
                read.assert_not_called()


if __name__=='__main__': unittest.main()
