from __future__ import annotations
import hashlib
import io
import json
from pathlib import Path
import sys
import tempfile
import unittest
import zipfile
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from apk_intake import acquire, inspect_apk, request_file, BoundedWriter


class IntakeTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        stream = io.BytesIO()
        with zipfile.ZipFile(stream, 'w') as archive:
            archive.writestr('AndroidManifest.xml', b'generated fixture manifest')
            archive.writestr('classes.dex', b'generated fixture DEX; not executable')
            archive.writestr('../not-extracted', b'path stays metadata')
        self.payload = stream.getvalue()
        self.req = {'schema': 1, 'drive_file_id': 'fixture_drive_id',
                    'expected_bytes': len(self.payload), 'expected_sha256': None}
        self.request = self.root / 'request.json'
        self.write_request()

    def write_request(self):
        self.request.write_text(json.dumps(self.req))

    def downloader(self, **kwargs):
        self.assertFalse(kwargs['use_cookies'])
        self.assertTrue(kwargs['verify'])
        self.assertFalse(kwargs['resume'])
        kwargs['output'].write(self.payload)
        return kwargs['output']

    def test_complete_intake_preserves_every_entry_and_bytes(self):
        out = self.root / 'capture'
        result = acquire(self.request, out, downloader=self.downloader)
        self.assertEqual(result['entry_count'], 3)
        self.assertEqual((out / 'app.apk').read_bytes(), self.payload)
        receipt = json.loads((out / 'intake.json').read_text())
        self.assertEqual(receipt['entries'][2]['name'], '../not-extracted')
        self.assertFalse((self.root / 'not-extracted').exists())
        self.assertEqual(receipt['sha256'], hashlib.sha256(self.payload).hexdigest())
        self.assertEqual(receipt['checksum_basis'], 'first_observation')
        self.assertFalse(receipt['publisher_authenticity_verified'])
        self.assertFalse(receipt['game_code_executed'])

    def test_predeclared_hash_checked(self):
        self.req['expected_sha256'] = hashlib.sha256(self.payload).hexdigest()
        self.write_request()
        self.assertEqual(acquire(self.request, self.root/'out', downloader=self.downloader)['checksum_basis'], 'predeclared')

    def test_hash_mismatch_leaves_no_output(self):
        self.req['expected_sha256'] = '0' * 64; self.write_request()
        with self.assertRaisesRegex(ValueError, 'SHA-256'):
            acquire(self.request, self.root/'out', downloader=self.downloader)
        self.assertFalse((self.root/'out').exists())
        self.assertEqual(list(self.root.glob('.intake-*')), [])

    def test_short_download_rejected(self):
        self.req['expected_bytes'] += 1; self.write_request()
        with self.assertRaisesRegex(ValueError, 'size'):
            acquire(self.request, self.root/'out', downloader=self.downloader)
        self.assertFalse((self.root/'out').exists())

    def test_long_download_stops_before_writing_extra_bytes(self):
        target=io.BytesIO(); writer=BoundedWriter(target, 3)
        writer.write(b'12')
        with self.assertRaises(ValueError): writer.write(b'34')
        self.assertEqual(target.getvalue(), b'12')

    def test_html_response_not_accepted(self):
        self.payload = b'<html>login required</html>'
        self.req['expected_bytes'] = len(self.payload); self.write_request()
        with self.assertRaises(zipfile.BadZipFile):
            acquire(self.request, self.root/'out', downloader=self.downloader)
        self.assertFalse((self.root/'out').exists())

    def test_public_access_failure_not_retried_with_credentials(self):
        calls=[]
        def fail(**kwargs): calls.append(kwargs); return None
        with self.assertRaisesRegex(ValueError, 'authenticated fallback'):
            acquire(self.request, self.root/'out', downloader=fail)
        self.assertEqual(len(calls), 1)
        self.assertFalse((self.root/'out').exists())

    def test_network_error_cleanup(self):
        def fail(**kwargs): kwargs['output'].write(b'ab'); raise OSError('network failed')
        with self.assertRaises(OSError): acquire(self.request, self.root/'out', downloader=fail)
        self.assertEqual(list(self.root.glob('.intake-*')), [])

    def test_existing_output_unchanged(self):
        out=self.root/'out'; out.mkdir(); (out/'keep').write_text('keep')
        with self.assertRaises(ValueError): acquire(self.request, out, downloader=self.downloader)
        self.assertEqual((out/'keep').read_text(), 'keep')

    def test_invalid_request_values(self):
        for key, value in [('drive_file_id', 'https://other.example/a'), ('expected_bytes', True),
                           ('expected_bytes', -1), ('expected_bytes', 2**32), ('expected_sha256', 'bad'),
                           ('schema', True), ('schema', 2), ('drive_file_id', None)]:
            with self.subTest(key=key, value=value):
                req=dict(self.req);req[key]=value;self.request.write_text(json.dumps(req))
                with self.assertRaises(ValueError): request_file(self.request)

    def test_unknown_request_field_rejected(self):
        self.req['url']='https://other.example'; self.write_request()
        with self.assertRaises(ValueError): request_file(self.request)

    def test_request_symlink_rejected(self):
        link=self.root/'alias.json';link.symlink_to(self.request)
        with self.assertRaises(ValueError): request_file(link)

    def test_apk_symlink_rejected(self):
        apk=self.root/'source';apk.write_bytes(self.payload)
        alias=self.root/'alias';alias.symlink_to(apk)
        with self.assertRaises(ValueError): inspect_apk(alias, self.req)

    def test_non_apk_zip_rejected(self):
        data=io.BytesIO()
        with zipfile.ZipFile(data,'w') as z: z.writestr('some.txt', 'not an apk')
        self.payload=data.getvalue();self.req['expected_bytes']=len(self.payload);self.write_request()
        with self.assertRaisesRegex(ValueError, 'manifest'):
            acquire(self.request,self.root/'out',downloader=self.downloader)

    def test_crc_corruption_rejected(self):
        data=bytearray(self.payload);pos=data.index(b'generated fixture DEX');data[pos]^=1
        self.payload=bytes(data)
        with self.assertRaisesRegex(zipfile.BadZipFile, 'CRC'):
            acquire(self.request,self.root/'out',downloader=self.downloader)

    def test_expansion_budget(self):
        apk=self.root/'app.apk';apk.write_bytes(self.payload)
        with self.assertRaisesRegex(ValueError, 'budget'):
            inspect_apk(apk,self.req,max_expanded=1)


if __name__ == '__main__': unittest.main()
