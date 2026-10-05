"""Generated export/delivery boundary tests, not measurements of the game's assets."""
import copy
import io
import json
from pathlib import Path
import struct
import sys
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch
import wave
import zipfile
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
import recover
import recovery_bulk as bulk
import recovery_delivery as delivery
from recovery_audio import convert_audio,validate_wav
from recovery_core import Catalog,RecoveryError,digest
from test_recovery import Fixture,serial


def wav(frames=32,channels=1,rate=22050):
    data=io.BytesIO()
    with wave.open(data,'wb') as output:
        output.setnchannels(channels);output.setsampwidth(2);output.setframerate(rate)
        output.writeframes(struct.pack('<h',1000)*frames*channels)
    return data.getvalue()


def audio(data=None):
    return NS(m_Channels=1,m_Frequency=22050,m_Length=32/22050,
              m_CompressionFormat=1,m_SubsoundIndex=0,samples={'unsafe/../display.wav':data or wav()})


class AudioTests(unittest.TestCase):
    def test_pcm_is_validated_and_metadata_preserved(self):
        ext, data, detail=convert_audio(audio())
        self.assertEqual(ext,'wav');self.assertEqual(data,wav());self.assertEqual(detail['frames'],32)
        self.assertEqual(detail['source_sample_name'],'unsafe/../display.wav')
    def test_recover_dispatches_audio(self):
        self.assertEqual(recover.convert(NS(parse_as_object=lambda:audio()),'AudioClip')[0],'wav')
    def test_truncation_and_trailing_bytes_refused(self):
        for data in (wav()[:-1],wav()+b'garbage',b'RIFF',b'OggS'+bytes(90)):
            with self.subTest(data=data[:8]),self.assertRaises(RecoveryError):validate_wav(data)
    def test_duplicate_stream_refused(self):
        data=bytearray(wav()+b'data'+struct.pack('<I',2)+b'xx');struct.pack_into('<I',data,4,len(data)-8)
        with self.assertRaises(RecoveryError):validate_wav(bytes(data))
    def test_declared_truncated_chunk_refused(self):
        data=bytearray(wav());struct.pack_into('<I',data,40,999)
        with self.assertRaises(RecoveryError):validate_wav(bytes(data))
    def test_empty_pcm_refused(self):
        with self.assertRaises(RecoveryError):validate_wav(wav(0))
    def test_multiple_subsounds_not_silently_dropped(self):
        item=audio();item.samples['other.wav']=wav()
        with self.assertRaises(RecoveryError):convert_audio(item)
    def test_empty_sample_map_refused(self):
        item=audio();item.samples={}
        with self.assertRaises(RecoveryError):convert_audio(item)
    def test_rate_and_channels_checked_against_source(self):
        for data in (wav(channels=2),wav(rate=44100)):
            with self.assertRaises(RecoveryError):convert_audio(audio(data))
    def test_invalid_source_metadata_refused(self):
        for field,value in [('m_Channels',0),('m_Channels',True),('m_Frequency',-1),
                            ('m_Length',float('nan')),('m_Length',float('inf')),('m_Length',-1)]:
            item=audio();setattr(item,field,value)
            with self.subTest(field=field,value=value),self.assertRaises(RecoveryError):convert_audio(item)
    def test_unreasonable_decoded_size_refused_before_decoder(self):
        item=audio();item.m_Length=10000
        with self.assertRaises(RecoveryError):convert_audio(item)
    def test_partial_sample_frame_is_not_truncated_silently(self):
        data=bytearray(wav()+b'x\0');struct.pack_into('<I',data,4,len(data)-8);struct.pack_into('<I',data,40,65)
        with self.assertRaises(RecoveryError):validate_wav(bytes(data))


class DeliveryTests(Fixture):
    def setup_capture(self,kinds=('Mesh','Mesh','Mesh'),failed=False):
        self.loaded=serial(kinds);self.capture(loaded=self.loaded);self.capture_root=self.root/'capture'
        with patch.object(recover,'environment',return_value=NS(load_file=lambda *a,**k:self.loaded)):
            if failed:
                with patch.object(recover,'convert',side_effect=ValueError('unsupported source type')):
                    bulk.run(self.capture_root,kinds=list(set(kinds)))
            else:bulk.run(self.capture_root,kinds=list(set(kinds)))
        return self.capture_root
    def package(self,**kw):
        return delivery.pack(self.capture_root,self.root/'package',kinds=['Mesh'],**kw)
    def read_manifest(self):
        return [json.loads(s) for s in (self.root/'package/objects.jsonl').read_text().splitlines()]
    def rewrite_manifest(self,rows):
        path=self.root/'package/objects.jsonl';path.write_text(''.join(json.dumps(r)+'\n' for r in rows))
        p=self.root/'package/delivery.json';r=json.loads(p.read_text());r['manifest'].update(size=path.stat().st_size,sha256=delivery.file_hash(path));p.write_text(json.dumps(r))
    def test_all_duplicate_names_keep_distinct_object_paths(self):
        self.setup_capture();self.package()
        result=delivery.verify(self.root/'package');self.assertEqual(result['exported'],3)
        rows=self.read_manifest();self.assertEqual(len({r['entry'] for r in rows}),3)
        self.assertTrue(all('..' not in r['entry'] for r in rows))
        self.assertEqual(len({r['name'] for r in rows}),1)
    def test_deterministic_archives_and_manifest(self):
        self.setup_capture();a=self.package();b=delivery.pack(self.capture_root,self.root/'second',kinds=['Mesh'])
        self.assertEqual(a,b)
    def test_exact_size_bounded_archives(self):
        self.setup_capture(('Mesh',)*12);r=self.package(max_archive_bytes=1024)
        self.assertGreater(len(r['archives']),1)
        self.assertTrue(all(x['size']<=1024 for x in r['archives']))
    def test_failure_manifest_is_complete_but_not_complete_export(self):
        self.setup_capture(failed=True);r=self.package();v=delivery.verify(self.root/'package')
        self.assertTrue(r['all_selected_objects_attempted']);self.assertFalse(r['all_selected_objects_exported'])
        self.assertEqual((v['failed'],v['archives']),(3,0))
    def test_unattempted_objects_block_publication(self):
        self.loaded=serial(('Mesh',));self.capture(loaded=self.loaded);self.capture_root=self.root/'capture'
        with self.assertRaises(RecoveryError):self.package()
        self.assertFalse((self.root/'package').exists())
    def test_existing_output_not_replaced(self):
        self.setup_capture();self.package()
        with self.assertRaises(RecoveryError):self.package()
    def test_corrupt_output_blob_blocked(self):
        self.setup_capture();c=Catalog(self.capture_root)
        sha=c.db.execute('SELECT sha FROM exports LIMIT 1').fetchone()[0];c.store.path(sha).write_bytes(b'corrupt');c.close()
        with self.assertRaises(RecoveryError):self.package()
        self.assertFalse((self.root/'package').exists())
    def test_corrupt_archive_rejected(self):
        self.setup_capture();r=self.package();p=self.root/'package'/r['archives'][0]['name'];p.write_bytes(b'corrupt')
        with self.assertRaises(RecoveryError):delivery.verify(self.root/'package')
    def test_unlisted_file_rejected(self):
        self.setup_capture();self.package();(self.root/'package/unlisted').write_text('x')
        with self.assertRaises(RecoveryError):delivery.verify(self.root/'package')
    def test_missing_archive_rejected(self):
        self.setup_capture();r=self.package();(self.root/'package'/r['archives'][0]['name']).unlink()
        with self.assertRaises((RecoveryError,OSError)):delivery.verify(self.root/'package')
    def test_duplicate_manifest_identity_rejected(self):
        self.setup_capture();self.package();rows=self.read_manifest();rows[1]=rows[0];self.rewrite_manifest(rows)
        with self.assertRaises(RecoveryError):delivery.verify(self.root/'package')
    def test_unsafe_manifest_path_rejected_even_if_rehashed(self):
        self.setup_capture();self.package();rows=self.read_manifest();rows[0]['entry']='../../outside.obj';self.rewrite_manifest(rows)
        with self.assertRaises(RecoveryError):delivery.verify(self.root/'package')
    def test_false_completeness_flag_rejected(self):
        self.setup_capture(failed=True);self.package();p=self.root/'package/delivery.json';r=json.loads(p.read_text());r['all_selected_objects_exported']=True;p.write_text(json.dumps(r))
        with self.assertRaises(RecoveryError):delivery.verify(self.root/'package')
    def test_source_identity_retained(self):
        self.setup_capture();self.package();c=Catalog(self.capture_root)
        try:
            for row in self.read_manifest():
                original=c.db.execute('SELECT * FROM objects WHERE id=?',(row['id'],)).fetchone()
                self.assertEqual(row['source_sha256'],original['sha']);self.assertEqual(row['path_id'],original['path_id'])
        finally:c.close()
    def test_wav_is_checked_by_catalog_and_delivery(self):
        self.loaded=serial(('AudioClip',));self.loaded.objects[1].parse_as_object=lambda:audio()
        self.capture(loaded=self.loaded);self.capture_root=self.root/'capture'
        with patch.object(recover,'environment',return_value=NS(load_file=lambda *a,**k:self.loaded)):
            bulk.run(self.capture_root,kinds=['AudioClip'])
        r=delivery.pack(self.capture_root,self.root/'package',kinds=['AudioClip'])
        self.assertEqual(delivery.verify(self.root/'package')['exported'],1)
    def test_archive_limit_types_and_bounds(self):
        self.setup_capture()
        for n in (True,0,1023,201*1024**2):
            with self.subTest(n=n),self.assertRaises(RecoveryError):self.package(max_archive_bytes=n)


class BoundedBulkTests(Fixture):
    def setup_capture(self):
        self.loaded=serial(('Mesh',)*3);self.capture(loaded=self.loaded);return self.root/'capture'
    def run_bulk(self,**kw):
        with patch.object(recover,'environment',return_value=NS(load_file=lambda *a,**k:self.loaded)):
            return bulk.run(self.root/'capture',kinds=['Mesh'],**kw)
    def test_stop_and_resume_does_not_repeat_work(self):
        self.setup_capture();r=self.run_bulk(limit=1);self.assertEqual(r['attempted_this_invocation'],1)
        self.assertFalse(r['all_selected_objects_attempted']);self.assertEqual(r['stop_reason'],'object_budget')
        r=self.run_bulk();self.assertEqual(r['attempted_this_invocation'],2);self.assertTrue(r['all_selected_objects_exported'])
        self.assertEqual(self.run_bulk()['attempted_this_invocation'],0)
    def test_cooperative_stop_leaves_explicit_pending(self):
        self.setup_capture();r=self.run_bulk(stop=lambda:True)
        self.assertEqual(r['attempted_this_invocation'],0);self.assertEqual(r['stop_reason'],'requested_stop')
    def test_invalid_budgets_refused(self):
        self.setup_capture()
        for kw in ({'max_seconds':True},{'max_seconds':-1},{'batch_size':0},{'batch_size':True},{'limit':.5}):
            with self.subTest(kw=kw),self.assertRaises(RecoveryError):self.run_bulk(**kw)
    def test_failed_conversion_requires_explicit_retry(self):
        self.setup_capture()
        with patch.object(recover,'convert',side_effect=ValueError('unsupported')):self.run_bulk(limit=1)
        r=self.run_bulk();self.assertFalse(r['all_selected_objects_exported']);self.assertEqual(r['attempted_this_invocation'],2)
        self.assertTrue(self.run_bulk(retry_failed=True)['all_selected_objects_exported'])
    def test_storage_failure_is_not_treated_as_unsupported(self):
        self.setup_capture()
        with patch.object(Catalog,'blob',side_effect=OSError('disk failed')):
            with self.assertRaises(OSError):self.run_bulk()
        c=Catalog(self.root/'capture')
        try:self.assertEqual(c.db.execute('SELECT COUNT(*) FROM exports').fetchone()[0],0)
        finally:c.close()
    def test_no_objects_is_not_vacuous_recovery_success(self):
        self.setup_capture();r=bulk.run(self.root/'capture',kinds=['AudioClip'])
        self.assertFalse(r['all_selected_objects_exported']);self.assertFalse(r['all_selected_objects_attempted'])


if __name__=='__main__':unittest.main()
