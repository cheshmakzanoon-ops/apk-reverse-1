#!/usr/bin/env python3
"""Install and test only the isolated recovery preview on an Android emulator.

The exact multi-ABI APK being delivered is installed; no game service is contacted.
Source-pose, scene-roundtrip, programmatic control, real adb touch, and lifecycle
checks are separate evidence. Never label emulator execution physical-device QA.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import math
from pathlib import Path
import re
import shlex
import subprocess
import time
import uuid

PACKAGE = 'org.apk_recovery.asset_preview'
ACTIVITY = PACKAGE + '/com.godot.game.GodotApp'


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def verify_pose_report(report, expected):
    require(report.get('passed') is True and report.get('errors') == [], 'native pose gate failed')
    require(report.get('runtime_os') == 'Android' and report.get('android_runtime_executed') is True,
            'report was not produced in Android')
    require(report.get('input_sha256') == expected['input_sha256'], 'wrong model hash')
    require(report.get('fixture_only') is False, 'fixture cannot count as recovered game data')
    count = sum(len(c['samples']) for clip in expected['clips'] for c in clip['channels'])
    require(count > 0, 'empty pose oracle')
    for key in ('samples', 'reloaded_samples'):
        samples = report.get(key, [])
        require(len(samples) == count, 'incomplete ' + key)
        # Compare identities and expected values as well as counts, not just a success flag.
        identities = [(clip['name'], int(c['node_index']), c['path'], s['time'], s['value'])
                      for clip in expected['clips'] for c in clip['channels'] for s in c['samples']]
        for sample, wanted in zip(samples, identities):
            actual = (sample['animation'], int(sample['node_index']), sample['property'], sample['time'], sample['expected'])
            require(actual[:3] == wanted[:3] and abs(actual[3] - wanted[3]) < 1e-6,
                    'pose oracle identity mismatch')
            require(len(actual[4]) == len(wanted[4]) and all(abs(x-y) <= 1e-10*max(1,abs(y))
                    for x,y in zip(actual[4], wanted[4])), 'pose oracle expected values changed')
            tolerance = expected['angle_tolerance'] if sample['property'] == 'rotation' else expected['vector_tolerance']
            require(sample['tolerance'] == tolerance and 0 <= sample['error'] <= tolerance,
                    'pose tolerance failed or changed')
            values = sample['actual']; goal = wanted[4]
            require(len(values) == len(goal) and all(math.isfinite(x) for x in values), 'invalid actual pose')
            if sample['property'] == 'rotation':
                na = math.sqrt(sum(x*x for x in values)); nb = math.sqrt(sum(x*x for x in goal))
                require(na > 0 and nb > 0, 'zero quaternion')
                delta = 2*math.acos(min(1,abs(sum(x*y for x,y in zip(values,goal))/(na*nb))))
            else:
                delta = max(abs(x-y) for x,y in zip(values,goal))
            require(delta <= tolerance, 'independent Android pose comparison failed')
    return count


class Device:
    def __init__(self, serial, out):
        require(re.fullmatch(r'emulator-\d+', serial) is not None, 'explicit emulator serial required')
        self.prefix = ['adb', '-s', serial]
        self.out = out
        self.commands = []

    def adb(self, *args, check=True, timeout=30):
        result = subprocess.run(self.prefix + list(args), capture_output=True, timeout=timeout)
        self.commands.append({'args': list(args), 'returncode': result.returncode})
        if check and result.returncode:
            raise RuntimeError('adb failed: ' + ' '.join(args) + ': ' + result.stderr.decode(errors='replace')[-1000:])
        return result.stdout

    def shell(self, *args, **kwargs):
        return self.adb('shell', shlex.join(args), **kwargs).decode(errors='replace').strip()

    def read(self, relative):
        require(re.fullmatch(r'[a-zA-Z0-9_./-]+', relative) is not None and '..' not in relative,
                'unsafe probe output path')
        return self.adb('exec-out', 'run-as', PACKAGE, 'cat', 'files/' + relative, check=False)

    def wait_json(self, relative, predicate=lambda _: True, seconds=180):
        end = time.monotonic() + seconds
        while time.monotonic() < end:
            try:
                value = json.loads(self.read(relative))
                if predicate(value):
                    return value
            except (ValueError, UnicodeDecodeError):
                pass
            time.sleep(0.35)
        raise RuntimeError('timed out waiting for ' + relative)

    def launch(self, script, args):
        self.shell('am', 'force-stop', PACKAGE)
        params = ['--script', 'res://' + script, '--', *args]
        require(not any(',' in x for x in params), 'comma in command-line argument')
        self.shell('am', 'start', '-W', '-n', ACTIVITY, '--esa', 'command_line_params', ','.join(params))

    def tap(self, point):
        self.shell('input', 'tap', str(round(point[0])), str(round(point[1])))


def run(apk, expected_path, out, serial):
    require(apk.is_file() and not apk.is_symlink(), 'missing APK')
    require(not out.exists(), 'evidence directory already exists; do not reuse stale reports')
    expected = json.loads(expected_path.read_text())
    require(len(expected['clips']) == 8, 'eight-clip oracle required')
    out.mkdir(parents=True)
    device = Device(serial, out)
    report = {'passed': False, 'target': 'Android emulator', 'physical_device_tested': False,
              'gameplay_port_complete': False, 'apk_sha256': hashlib.sha256(apk.read_bytes()).hexdigest()}
    try:
        require(device.shell('getprop', 'ro.kernel.qemu') == '1', 'target is not an emulator')
        report['device'] = {k: device.shell('getprop', k) for k in
                            ('ro.build.version.sdk', 'ro.product.cpu.abi', 'ro.build.fingerprint')}
        device.adb('install', '-r', str(apk), timeout=90)
        # All removals are limited to this debug inspector's own prior test reports.
        device.shell('run-as', PACKAGE, 'rm', '-rf', 'files/animation.json', 'files/viewer', 'files/runtime-state.json')
        device.launch('scripts/verify_animation.gd',
                      ['res://runtime_probe/model.bin', 'res://runtime_probe/expected.json', 'user://animation.json'])
        poses = device.wait_json('animation.json', seconds=240)
        (out/'animation.json').write_text(json.dumps(poses))
        report['pose_samples_per_pass'] = verify_pose_report(poses, expected)
        device.launch('asset_viewer/verify_viewer.gd', ['user://viewer', '8'])
        viewer = device.wait_json('viewer/viewer.json', seconds=180)
        (out/'viewer.json').write_text(json.dumps(viewer, indent=2))
        require(viewer.get('passed') is True and viewer.get('errors') == [] and len(viewer.get('clips', [])) == 8,
                'eight-clip viewer checks failed')
        require(viewer.get('runtime_os') == 'Android', 'viewer report is not Android')
        require({c['name'] for c in viewer['clips']} == {c['name'] for c in expected['clips']},
                'viewer clip identities differ from source oracle')
        for i in range(8):
            png = device.read(f'viewer/clip-{i:02d}.png')
            require(png.startswith(b'\x89PNG\r\n\x1a\n'), 'missing rendered clip screenshot')
            (out/f'clip-{i:02d}.png').write_bytes(png)
        nonce = 'probe_' + uuid.uuid4().hex
        device.launch('asset_viewer/android_probe.gd', [nonce])
        state = device.wait_json('runtime-state.json', lambda s: s.get('nonce') == nonce)
        require(state['runtime_os'] == 'Android' and state['clips'] == 8, 'wrong probe runtime/content')
        require(not state['playing'], 'touch probe did not begin paused')
        records = []

        def next_state(old, condition=lambda _: True):
            return device.wait_json('runtime-state.json', lambda s: s.get('nonce') == nonce and
                                    s['ticks'] > old['ticks'] and condition(s), seconds=15)

        for key, smaller in [('zoom_in', True), ('zoom_out', False)]:
            before = state; device.tap(state[key])
            state = next_state(before, lambda s: s['radius'] < before['radius'] if smaller else s['radius'] > before['radius'])
            records.append({'action': key, 'before': before, 'after': state})
        before = state; device.tap(state['scrub'])
        state = next_state(before, lambda s: abs(s['position'] - before['position']) > 0.05)
        require(not state['playing'] and .5 < state['position']/state['length'] < .8, 'touch scrub failed')
        records.append({'action': 'touch_scrub', 'before': before, 'after': state})
        # Physical screen coordinates; choose the uncovered lower part of the surface.
        size_text = device.shell('wm', 'size')
        sizes = re.findall(r'(\d+)x(\d+)', size_text); require(sizes, 'screen size unavailable')
        width, height = map(int, sizes[-1])
        before = state
        device.shell('input', 'swipe', str(width//3), str(height*4//5), str(width*2//3), str(height*4//5), '500')
        state = next_state(before, lambda s: abs(s['yaw'] - before['yaw']) > .01)
        records.append({'action': 'touch_orbit', 'before': before, 'after': state})
        for playing in (False, True):
            if playing:
                before = state; device.tap(state['restart_button'])
                state = next_state(before, lambda s: s['playing'])
            before = state
            device.shell('input', 'keyevent', 'KEYCODE_HOME'); time.sleep(1.0)
            device.shell('am', 'start', '-W', '-n', ACTIVITY)
            state = next_state(before, lambda s: s['lifecycle']['resumed'] > before['lifecycle']['resumed'])
            require(state['pid'] == before['pid'] and state['clip'] == before['clip'], 'activity recreated or lost clip')
            require(state['playing'] == playing, 'pause/play state not preserved across background')
            life = state['lifecycle']
            require(life['paused'] > before['lifecycle']['paused'] and life['was_playing'] == playing,
                    'Android pause notification not handled')
            require(abs(life['resume_time'] - life['suspend_time']) < .002, 'resume changed stored animation position')
            if not playing:
                require(abs(state['position']-before['position']) < .002, 'paused clip advanced in background')
            records.append({'action': 'background_resume_playing' if playing else 'background_resume_paused',
                            'before': before, 'after': state})
        before = state; device.tap(state['paused_button'])
        state = next_state(before, lambda s: not s['playing'])
        records.append({'action': 'touch_pause', 'before': before, 'after': state})
        (out/'touch-and-lifecycle.json').write_text(json.dumps(records, indent=2))
        (out/'android-screen.png').write_bytes(device.adb('exec-out', 'screencap', '-p'))
        report.update(passed=True, clips=8, touch_and_lifecycle_operations=len(records),
                      source_pose_roundtrip=True, android_runtime_executed=True)
    except Exception as exc:
        report['error'] = str(exc)
        raise
    finally:
        (out/'commands.json').write_text(json.dumps(device.commands, indent=2))
        (out/'android-runtime.json').write_text(json.dumps(report, indent=2))
        (out/'logcat.txt').write_bytes(device.adb('logcat', '-d', check=False))
    return report


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--apk', type=Path, required=True); p.add_argument('--expected', type=Path, required=True)
    p.add_argument('--out', type=Path, required=True); p.add_argument('--serial', default='emulator-5554')
    a = p.parse_args()
    print(json.dumps(run(a.apk, a.expected, a.out, a.serial), indent=2))
