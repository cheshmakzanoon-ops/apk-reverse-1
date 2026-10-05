"""Synthetic export/resume regressions, never reported as recovered game assets."""
from pathlib import Path
import sys
from types import SimpleNamespace as NS
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
import recovery_bulk as bulk
import recover
from recovery_core import Catalog,RecoveryError
from test_recovery import Fixture,serial


class BulkTests(Fixture):
    def setup_capture(self):
        self.loaded=serial(('Mesh','Mesh','Mesh'))
        self.capture(loaded=self.loaded)
        return self.root/'capture'
    def run_bulk(self,**kw):
        with patch.object(recover,'environment',return_value=NS(load_file=lambda *a,**k:self.loaded)):
            return bulk.run(self.root/'capture',kinds=['Mesh'],**kw)
    def test_resume_does_not_repeat_successful_exports(self):
        self.setup_capture();r=self.run_bulk(limit=1)
        self.assertEqual(r['attempted_this_invocation'],1);self.assertFalse(r['all_selected_objects_attempted'])
        r=self.run_bulk();self.assertEqual(r['attempted_this_invocation'],2)
        self.assertTrue(r['all_selected_objects_exported']);self.assertFalse(r['rigged_prefabs_reconstructed'])
        self.assertEqual(self.run_bulk()['attempted_this_invocation'],0)
    def test_failed_export_remains_explicit_until_requested_retry(self):
        self.setup_capture()
        with patch.object(recover,'convert',side_effect=ValueError('unsupported')):r=self.run_bulk(limit=1)
        self.assertFalse(r['all_selected_objects_exported'])
        self.assertEqual(self.run_bulk()['attempted_this_invocation'],2)
        self.assertTrue(self.run_bulk(retry_failed=True)['all_selected_objects_exported'])
    def test_hash_mismatch_cannot_be_reported_exported(self):
        self.setup_capture();self.loaded.objects[1].raw=b'changed'
        r=self.run_bulk();self.assertTrue(r['all_selected_objects_attempted'])
        self.assertFalse(r['all_selected_objects_exported'])
        self.assertIn({'type':'Mesh','status':'failed','count':1},r['outcomes'])
    def test_parser_failure_is_a_failed_attempt_not_success(self):
        root=self.setup_capture()
        with patch.object(recover,'environment',side_effect=ValueError('parse failed')):r=bulk.run(root,kinds=['Mesh'])
        self.assertEqual(r['outcomes'],[{'type':'Mesh','status':'failed','count':3}])
    def test_placeholder_geometry_rejected(self):
        self.setup_capture();self.loaded.objects[1].parse_as_object=lambda:NS(export=lambda:'v \n')
        r=self.run_bulk();self.assertFalse(r['all_selected_objects_exported'])
    def test_existing_export_corruption_is_not_skipped_as_success(self):
        root=self.setup_capture();self.run_bulk(limit=1);cat=Catalog(root)
        sha=cat.db.execute("SELECT sha FROM exports WHERE status='exported'").fetchone()[0]
        cat.store.path(sha).write_bytes(b'corrupt');cat.close()
        with self.assertRaises(RecoveryError):self.run_bulk()
    def test_original_bytes_and_ids_stay_unchanged(self):
        root=self.setup_capture();cat=Catalog(root)
        before=[tuple(r) for r in cat.db.execute('SELECT id,sha FROM objects ORDER BY id')];cat.close()
        self.run_bulk();cat=Catalog(root)
        try:
            self.assertEqual(before,[tuple(r) for r in cat.db.execute('SELECT id,sha FROM objects ORDER BY id')])
            self.assertEqual(cat.verify(),[])
        finally:cat.close()
    def test_unknown_duplicate_and_empty_types_refused(self):
        root=self.setup_capture()
        for types in ([],['Mesh','Mesh'],['Unknown']):
            with self.assertRaises(RecoveryError):bulk.run(root,kinds=types)
    def test_invalid_limit_refused(self):
        self.setup_capture()
        for value in (-1,True,2.5):
            with self.assertRaises(RecoveryError):self.run_bulk(limit=value)
