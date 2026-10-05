"""Generated checkpoint/packed-tree regressions; no fixture is game recovery."""
import copy
import json
from pathlib import Path
import sqlite3
import subprocess
import sys
import tempfile
import unittest
import zlib
from types import SimpleNamespace as NS
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
import recovery_scan as scan
import recovery_graph as graph
import recover
from recovery_core import Catalog, RecoveryError, digest
from test_recovery_r2 import GraphFixture, model_items, ptr, member, real_serialized_scene
from test_recovery import Fixture


class ScanTests(GraphFixture):
    def build_scan(self, **kw):
        with patch.object(recover,'environment',return_value=NS(load_file=lambda *a,**k:self.loaded)):
            return scan.run(self.root/'capture',**kw)

    def uncached(self, items=None):
        root=self.snapshot(items)
        cat=Catalog(root);cat.db.execute('UPDATE objects SET tree_sha=NULL');cat.close()
        return root

    def test_complete_compressed_graph_works_with_existing_scene_reader(self):
        root=self.uncached();result=self.build_scan(batch_size=2)
        self.assertTrue(result['scan_finished']);self.assertTrue(result['graph_complete'])
        self.assertEqual(result['compressed_trees'],6)
        cat=Catalog(root)
        try:
            self.assertEqual(cat.verify(),[]);self.assertEqual(graph.verify_graph(cat),[])
            self.assertTrue(graph.scene(cat,self.oid(1))['hierarchy_complete'])
        finally:cat.close()

    def test_paused_scan_resumes_without_redecoding_completed_objects(self):
        self.uncached();partial=self.build_scan(max_objects=2)
        self.assertFalse(partial['scan_finished']);self.assertEqual(partial['pending_objects'],4)
        self.assertEqual(partial['state'],'paused')
        # These first two objects would now throw; a resume must not parse them again.
        keys=sorted(self.loaded.objects)
        for key in keys[:2]:self.loaded.objects[key].tree=ValueError('must not revisit')
        result=self.build_scan(max_objects=3)
        self.assertEqual(result['pending_objects'],1)
        self.assertTrue(self.build_scan()['graph_complete'])

    def test_checkpointed_and_legacy_edges_equal(self):
        self.snapshot();legacy=self.build();cat=Catalog(self.root/'capture')
        before=[tuple(r) for r in cat.db.execute('SELECT * FROM object_refs ORDER BY id')];cat.close()
        # Distinct fresh snapshot with identical source identity.
        import shutil
        shutil.rmtree(self.root/'capture');self.uncached();self.build_scan()
        cat=Catalog(self.root/'capture')
        try:self.assertEqual(before,[tuple(r) for r in cat.db.execute('SELECT * FROM object_refs ORDER BY id')])
        finally:cat.close()

    def test_no_resolved_claim_for_missing_reference(self):
        self.uncached([(1,'MeshFilter',{'m_Mesh':ptr(77)})])
        r=self.build_scan();self.assertTrue(r['scan_finished']);self.assertFalse(r['graph_complete'])
        self.assertEqual(r['references'],{'missing_object':1})

    def test_decode_failure_preserves_raw_capture(self):
        root=self.uncached();self.loaded.objects[1].tree=ValueError('unsupported')
        r=self.build_scan();self.assertTrue(r['scan_finished']);self.assertFalse(r['all_objects_decoded'])
        self.assertEqual(r['objects']['decode_failed'],1)
        cat=Catalog(root)
        try:self.assertEqual(cat.verify(),[]);self.assertEqual(graph.verify_graph(cat),[])
        finally:cat.close()

    def test_stop_before_work_is_resumable(self):
        self.uncached();r=self.build_scan(stop=lambda:True)
        self.assertFalse(r['scan_finished']);self.assertEqual(r['compressed_trees'],0)
        self.assertTrue(self.build_scan()['graph_complete'])

    def test_signal_stop_between_objects_preserves_complete_batches(self):
        self.uncached();calls=[]
        original=scan.store_tree
        def store(*args):
            calls.append(1);return original(*args)
        with patch.object(scan,'store_tree',side_effect=store):r=self.build_scan(stop=lambda:len(calls)>=3,batch_size=2)
        self.assertEqual(r['compressed_trees'],3);self.assertEqual(r['pending_objects'],3)
        self.assertTrue(self.build_scan()['graph_complete'])

    def test_exception_does_not_commit_partial_edges_or_tree(self):
        root=self.uncached()
        original=graph.populate_references;calls=[]
        def fail(cat,obj,tree):
            original(cat,obj,tree);calls.append(obj['id'])
            if len(calls)==3:raise RuntimeError('injected transaction failure')
        with patch.object(graph,'populate_references',side_effect=fail):
            with self.assertRaises(RuntimeError):self.build_scan(batch_size=2)
        cat=Catalog(root)
        try:
            self.assertEqual(cat.get_meta('graph_state'),'failed')
            self.assertEqual(cat.db.execute('SELECT COUNT(*) FROM graph_trees').fetchone()[0],2)
            self.assertEqual(cat.db.execute('SELECT COUNT(*) FROM object_refs WHERE source_id=?',(calls[2],)).fetchone()[0],0)
        finally:cat.close()
        self.assertTrue(self.build_scan()['graph_complete'])

    def test_finished_resume_validates_instead_of_rewriting(self):
        root=self.uncached();first=self.build_scan()
        with patch.object(scan,'load_member',side_effect=AssertionError('must not reload')):second=self.build_scan()
        self.assertEqual(first,second)
        cat=Catalog(root);cat.db.execute("UPDATE object_refs SET target_id=NULL WHERE status='resolved'");cat.close()
        with self.assertRaisesRegex(RecoveryError,'invalid graph checkpoint'):self.build_scan()

    def test_changed_capture_metadata_refuses_resume(self):
        root=self.uncached();self.build_scan(max_objects=2)
        cat=Catalog(root);cat.db.execute("UPDATE objects SET type='Other' WHERE path_id=6");cat.close()
        with self.assertRaisesRegex(RecoveryError,'identities changed'):self.build_scan()

    def test_existing_legacy_graph_not_silently_destroyed(self):
        self.snapshot();self.build()
        with self.assertRaisesRegex(RecoveryError,'legacy graph exists'):self.build_scan()

    def test_legacy_build_cannot_destroy_packed_graph(self):
        self.uncached();self.build_scan()
        with self.assertRaisesRegex(RecoveryError,'checkpointed graph exists'):self.build()

    def test_missing_packed_tree_detected(self):
        root=self.uncached();self.build_scan();cat=Catalog(root)
        try:
            cat.db.execute('DELETE FROM graph_trees WHERE object_id=?',(self.oid(2),))
            self.assertTrue(any('missing or oversized' in x for x in graph.verify_graph(cat)))
        finally:cat.close()

    def test_modified_compressed_bytes_rejected(self):
        root=self.uncached();self.build_scan();cat=Catalog(root)
        try:
            cat.db.execute('UPDATE graph_trees SET data=? WHERE object_id=?',(zlib.compress(b'{}'),self.oid(2)))
            self.assertTrue(any('mismatch' in x for x in graph.verify_graph(cat)))
        finally:cat.close()

    def test_trailing_zlib_data_rejected(self):
        root=self.uncached();self.build_scan();cat=Catalog(root)
        try:
            oid=self.oid(2);row=cat.db.execute('SELECT data FROM graph_trees WHERE object_id=?',(oid,)).fetchone()
            cat.db.execute('UPDATE graph_trees SET data=? WHERE object_id=?',(row[0]+b'x',oid))
            self.assertTrue(any('mismatch' in x for x in graph.verify_graph(cat)))
        finally:cat.close()

    def test_oversized_declared_tree_refused(self):
        root=self.uncached();self.build_scan();cat=Catalog(root)
        try:
            cat.db.execute('UPDATE graph_trees SET raw_size=?',(scan.MAX_TREE+1,))
            self.assertTrue(any('oversized' in x for x in graph.verify_graph(cat)))
        finally:cat.close()

    def test_missing_status_is_not_scan_complete(self):
        root=self.uncached();self.build_scan();cat=Catalog(root)
        try:
            cat.db.execute('DELETE FROM graph_objects WHERE object_id=?',(self.oid(2),))
            self.assertIn('graph object coverage mismatch',graph.verify_graph(cat))
        finally:cat.close()

    def test_unknown_external_remains_explicit(self):
        self.snapshot([(1,'MeshFilter',{'m_Mesh':ptr(1,1)})],externals=('absent',))
        r=self.build_scan();self.assertEqual(r['references'],{'unresolved_in_capture':1})

    def test_writer_lock_rejects_second_writer(self):
        self.uncached()
        with scan.writer_lock(self.root/'capture'):
            with self.assertRaisesRegex(RecoveryError,'writer is active'):self.build_scan()

    def test_backup_is_consistent_readable_database(self):
        root=self.uncached();self.build_scan(max_objects=2)
        out=self.root/'backup.sqlite';scan.backup(root,out)
        with sqlite3.connect(out) as db:
            self.assertEqual(db.execute('PRAGMA integrity_check').fetchone()[0],'ok')
            self.assertEqual(db.execute('SELECT COUNT(*) FROM graph_trees').fetchone()[0],2)
        with self.assertRaises(RecoveryError):scan.backup(root,out)

    def test_backup_during_uncommitted_wal_write(self):
        root=self.uncached();self.build_scan(max_objects=2);cat=Catalog(root)
        try:
            cat.set_meta('uncommitted','must not leak')
            out=self.root/'backup.sqlite';scan.backup(root,out)
            with sqlite3.connect(out) as db:self.assertIsNone(db.execute("SELECT * FROM meta WHERE key='uncommitted'").fetchone())
        finally:cat.db.rollback();cat.close()

    def test_asset_inventory_keeps_original_path_as_metadata(self):
        root=self.uncached([(1,'AssetBundle',{'m_Container':[['../../model.prefab',{'asset':ptr(2)}]]}),(2,'GameObject',{})])
        self.build_scan();cat=Catalog(root)
        try:
            out=self.root/'assets.jsonl';scan.inventory(cat,out)
            item=json.loads(out.read_text());self.assertEqual(item['original_path'],'../../model.prefab')
            self.assertEqual(item['target_id'],self.oid(2));self.assertEqual(item['status'],'resolved')
        finally:cat.close()

    def test_invalid_limits_refused(self):
        self.uncached()
        for kw in ({'max_objects':-1},{'max_seconds':-1},{'batch_size':0},{'batch_size':10001}):
            with self.subTest(kw=kw),self.assertRaises(RecoveryError):self.build_scan(**kw)

    def test_raw_input_not_changed_by_graph_scan(self):
        root=self.uncached();cat=Catalog(root)
        try: before=[tuple(r) for r in cat.db.execute('SELECT id,member_id,path_id,type,offset,size,sha FROM objects ORDER BY id')]
        finally:cat.close()
        self.build_scan();cat=Catalog(root)
        try:self.assertEqual(before,[tuple(r) for r in cat.db.execute('SELECT id,member_id,path_id,type,offset,size,sha FROM objects ORDER BY id')])
        finally:cat.close()


class NativeParserScanTests(Fixture):
    def test_actual_unity_bytes_resume_and_scene_roundtrip(self):
        apk=self.apk([('assets/bin/Data/scene.assets',real_serialized_scene())])
        root=self.root/'real-parser';recover.capture(apk,root)
        first=scan.run(root,max_objects=1);self.assertFalse(first['scan_finished'])
        self.assertEqual(first['compressed_trees'],1)
        self.assertTrue(scan.run(root)['graph_complete'])
        cat=Catalog(root)
        try:
            self.assertEqual(cat.verify(),[]);self.assertEqual(graph.verify_graph(cat),[])
            oid=cat.db.execute('SELECT id FROM objects WHERE path_id=1').fetchone()[0]
            self.assertEqual(len(graph.scene(cat,oid)['nodes']),2)
        finally:cat.close()


if __name__=='__main__':unittest.main()
