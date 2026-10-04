#!/usr/bin/env python3
"""Acquire the explicitly selected public Drive APK without running its code.

A first-observed SHA-256 identifies the capture; it is NOT publisher authentication.
No credential/cookie export, private Drive access, or game-server access is used.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.metadata
import json
import os
from pathlib import Path
import re
import tempfile
import zipfile

BLOCK = 1024 * 1024
MAX_APK = 2 * 1024**3
MAX_EXPANDED = 12 * 1024**3


def request_file(path: Path) -> dict:
    if path.is_symlink() or not path.is_file() or path.stat().st_size > 16384:
        raise ValueError('request must be a small regular JSON file')
    request = json.loads(path.read_text(encoding='utf-8'))
    if not isinstance(request, dict) or set(request) != {'schema', 'drive_file_id', 'expected_bytes', 'expected_sha256'}:
        raise ValueError('unexpected request fields')
    if type(request['schema']) is not int or request['schema'] != 1:
        raise ValueError('unsupported request schema')
    if not isinstance(request['drive_file_id'], str) or not re.fullmatch(r'[A-Za-z0-9_-]{10,100}', request['drive_file_id']):
        raise ValueError('a Drive file ID is required, not a URL or command')
    if type(request['expected_bytes']) is not int or not 0 < request['expected_bytes'] <= MAX_APK:
        raise ValueError('expected_bytes must be a positive integer within the APK budget')
    sha = request['expected_sha256']
    if sha is not None and (not isinstance(sha, str) or not re.fullmatch(r'[0-9a-f]{64}', sha)):
        raise ValueError('invalid expected SHA-256')
    return request


class BoundedWriter:
    """Stop a downloader before it can write more than the selected input size."""
    def __init__(self, target, limit: int):
        self.target, self.limit, self.count = target, limit, 0

    def write(self, data: bytes) -> int:
        if self.count + len(data) > self.limit:
            raise ValueError('download exceeded expected byte count')
        result = self.target.write(data)
        if result != len(data):
            raise OSError('short download write')
        self.count += result
        return result


def inspect_apk(path: Path, request: dict, *, max_expanded: int = MAX_EXPANDED) -> dict:
    if path.is_symlink() or not path.is_file():
        raise ValueError('APK must be a regular file, not a symlink')
    before = path.stat()
    if before.st_size != request['expected_bytes']:
        raise ValueError('download size does not match selected APK')
    with path.open('rb') as src:
        sha = hashlib.file_digest(src, 'sha256').hexdigest()
    if request['expected_sha256'] is not None and sha != request['expected_sha256']:
        raise ValueError('download SHA-256 differs from the requested input')
    entries = []
    expanded = 0
    with zipfile.ZipFile(path) as archive:
        infos = archive.infolist()
        if not 1 <= len(infos) <= 500000:
            raise ValueError('invalid ZIP entry count')
        names = {info.filename for info in infos}
        if 'AndroidManifest.xml' not in names or 'classes.dex' not in names:
            raise ValueError('ZIP is missing the Android manifest or primary DEX')
        for ordinal, info in enumerate(infos):
            expanded += info.file_size
            if info.flag_bits & 1 or info.file_size > 1024**3 or expanded > max_expanded:
                raise ValueError('encrypted entry or ZIP expansion budget exceeded')
            h, count = hashlib.sha256(), 0
            # Names are metadata only: entries are never extracted to their paths.
            with archive.open(info) as src:
                while block := src.read(BLOCK):
                    count += len(block)
                    if count > info.file_size:
                        raise ValueError('entry exceeds its declared size')
                    h.update(block)
            if count != info.file_size:
                raise ValueError('entry byte count mismatch')
            entries.append({'ordinal': ordinal, 'name': info.filename, 'size': count,
                            'crc32': f'{info.CRC:08x}', 'sha256': h.hexdigest()})
    after = path.stat()
    if (before.st_size, before.st_mtime_ns, before.st_ino) != (after.st_size, after.st_mtime_ns, after.st_ino):
        raise ValueError('input changed while checking it')
    with path.open('rb') as src:
        if hashlib.file_digest(src, 'sha256').hexdigest() != sha:
            raise ValueError('input bytes changed while checking it')
    return {'schema': 1, 'state': 'intake_verified', 'source': 'requester-supplied-public-drive-file',
            'drive_file_id': request['drive_file_id'], 'size': before.st_size, 'sha256': sha,
            'checksum_basis': 'predeclared' if request['expected_sha256'] else 'first_observation',
            'publisher_authenticity_verified': False, 'apk_signature_verified': False,
            'entry_count': len(entries), 'expanded_bytes': expanded, 'entries': entries,
            'game_code_executed': False, 'asset_recovery_complete': False}


def acquire(request_path: Path, output: Path, *, downloader=None) -> dict:
    request = request_file(request_path)
    if output.exists() or output.is_symlink():
        raise ValueError('intake destination already exists')
    if downloader is None:
        if importlib.metadata.version('gdown') != '5.2.0':
            raise ValueError('gdown 5.2.0 is required')
        import gdown
        downloader = gdown.download
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.intake-', dir=output.parent) as temp:
        staging = Path(temp)
        apk = staging / 'app.apk'
        with apk.open('xb') as target:
            sink = BoundedWriter(target, request['expected_bytes'])
            result = downloader(id=request['drive_file_id'], output=sink, quiet=True,
                                use_cookies=False, verify=True, resume=False)
            if result is None:
                raise ValueError('public Drive download failed; no authenticated fallback attempted')
            target.flush()
            os.fsync(target.fileno())
        receipt = inspect_apk(apk, request)
        (staging / 'intake.json').write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
        # mkdir is exclusive; never replace another writer's destination.
        output.mkdir(exist_ok=False)
        try:
            os.link(apk, output / 'app.apk')
            os.link(staging / 'intake.json', output / 'intake.json')
        except BaseException:
            # Only remove this function's newly created output, not the input.
            (output / 'app.apk').unlink(missing_ok=True)
            (output / 'intake.json').unlink(missing_ok=True)
            output.rmdir()
            raise
    return {key: value for key, value in receipt.items() if key != 'entries'}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--request', type=Path, required=True)
    parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args(argv)
    try:
        print(json.dumps(acquire(args.request, args.out), indent=2))
        return 0
    except Exception as exc:
        # A network/access failure remains a failed intake, never an empty capture.
        parser.exit(2, f'APK intake failed: {type(exc).__name__}: {exc}\n')


if __name__ == '__main__':
    raise SystemExit(main())
