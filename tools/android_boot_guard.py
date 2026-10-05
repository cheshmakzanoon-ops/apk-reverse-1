"""Observe emulator boot/configuration stability before starting native checks.

This does not suppress configuration changes, retry a failed app, or certify
activity-recreation support. Actual app errors remain acceptance failures.
"""
from __future__ import annotations
import json
import math
from pathlib import Path
import time


def configuration_key(text):
    lines = [line.removeprefix('config:').strip() for line in text.splitlines()
             if line.startswith('config:')]
    if len(lines) != 1 or not lines[0]:
        raise RuntimeError('Android current configuration is missing or ambiguous')
    return lines[0]


def wait_ready(shell, output, *, stable_seconds=20.0, timeout=120.0,
               clock=time.monotonic, sleep=time.sleep):
    """Require an unchanged current configuration and finished boot animation.

    `am get-config` also lists recent configurations; only its singular current
    `config:` field participates. The bounded observation history is preserved.
    """
    if not (math.isfinite(stable_seconds) and math.isfinite(timeout)
            and 0 < stable_seconds < timeout <= 600):
        raise ValueError('invalid boot stability interval')
    output = Path(output)
    if output.exists():
        raise RuntimeError('boot readiness evidence already exists')
    start = clock(); since = None; previous = None
    report = {'ready': False, 'stable_seconds_required': stable_seconds,
              'timeout_seconds': timeout, 'observations': []}
    try:
        while clock() - start < timeout:
            boot = shell('getprop', 'sys.boot_completed')
            animation = shell('getprop', 'init.svc.bootanim')
            config = configuration_key(shell('am', 'get-config'))
            now = clock()
            ready = boot == '1' and animation == 'stopped'
            if not ready:
                since = None
            elif previous != config or since is None:
                since = now
            previous = config
            elapsed = now - since if since is not None else 0.0
            report['observations'].append({'elapsed_seconds': now-start, 'boot': boot,
                'boot_animation': animation, 'configuration': config, 'stable_seconds': elapsed})
            if ready and elapsed >= stable_seconds:
                report.update(ready=True, observed_stable_seconds=elapsed)
                return report
            sleep(2.0)
        raise RuntimeError('Android boot/configuration did not stabilize within the observation budget')
    except Exception as exc:
        report['error'] = str(exc)
        raise
    finally:
        output.write_text(json.dumps(report, indent=2))
