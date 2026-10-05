"""Generated graph fixtures. None is counted as a recovered game asset."""
import copy
import json
from pathlib import Path
import sqlite3
import sys
from types import SimpleNamespace as NS
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
import recovery_scope as scope
import recover
from recovery_core import Catalog,RecoveryError,digest,json_bytes
from test_recovery_r2 import GraphFixture,model_items,member,ptr,real_serialized_scene


class ScopeTests(GraphFixture):
    def prepared(self, extra=()):
        items=model_items()+[(100,'AssetBundle',{'m_Container':[['Assets/stage.prefab',{'asset':ptr(1)}]]})]+list(extra)
        self.loaded=member(items)
        self.capture(entries=[('assets/bin/Data/scene.assets',self.loaded.reader.bytes)],loaded=self.loaded,trees=True)
        self.build()
        cat=Catalog(self.root/'capture')
        obj=dict(cat.db.execute('SELECT * FROM objects WHERE path_id=1').fetchone())
        self.profile={'schema':1,'name':'generated-test','input_sha256':cat.get_meta('input_sha256'),
                      'roots':[{'path':'Assets/stage.prefab','type':'GameObject','object_id':obj['id'],'sha256':obj['sha']}]}
        cat.close()
        return self.root/'capture/catalog.sqlite'
    def selection(self, **kw):
        db=scope.read_db(self.root/'capture/catalog.sqlite')
        try:return scope.plan(db,self.profile,**kw)
        finally:db.close()
    def deliver(self, plan=None):
        p=plan or self.selection()
        with patch.object(recover,'environment',return_value=NS(load_file=lambda *a,**k:self.loaded)):
            scope.extract(self.root/'input.apk',p,self.root/'package')
        return scope.verify(self.root/'package')
    def test_follow_references_not_every_object_in_bundle(self):
        self.prepared([(200,'Mesh',{'m_Name':'unrelated'})]);s=self.selection()
        self.assertEqual(len(s['objects']),6);self.assertEqual(s['summary']['types']['GameObject'],2)
        self.assertTrue(s['summary']['serialized_closure_complete'])
        self.assertFalse(s['summary']['godot_stage_complete'])
    def test_cycles_and_shared_dependencies_visited_once(self):
        self.prepared();s=self.selection()
        self.assertEqual(len(s['objects']),len({o['id'] for o in s['objects']}))
    def test_same_names_do_not_collapse_identities(self):
        self.prepared();s=self.selection();self.assertEqual(len(s['objects']),6)
        self.assertEqual(len({o['name'] for o in s['objects']}),1)
    def test_read_connection_cannot_modify_catalog(self):
        p=self.prepared();db=scope.read_db(p)
        try:
            with self.assertRaises(sqlite3.OperationalError):db.execute('DELETE FROM objects')
        finally:db.close()
    def test_input_hash_pinned(self):
        self.prepared();self.profile['input_sha256']='a'*64
        with self.assertRaises(RecoveryError):self.selection()
    def test_root_hash_pinned(self):
        self.prepared();self.profile['roots'][0]['sha256']='a'*64
        with self.assertRaises(RecoveryError):self.selection()
    def test_duplicate_roots_refused(self):
        self.prepared();self.profile['roots']*=2
        with self.assertRaises(RecoveryError):self.selection()
    def test_wrong_root_path_refused(self):
        self.prepared();self.profile['roots'][0]['path']='other'
        with self.assertRaises(RecoveryError):self.selection()
    def test_nonpositive_or_noninteger_budget_refused(self):
        self.prepared()
        for limit in (0,True,1.5,200001):
            with self.subTest(limit=limit),self.assertRaises(RecoveryError):self.selection(max_objects=limit)
    def test_dependency_budget_does_not_return_partial_success(self):
        self.prepared()
        with self.assertRaises(RecoveryError):self.selection(max_objects=2)
    def test_pending_global_graph_refused(self):
        self.prepared();c=Catalog(self.root/'capture');c.db.execute("UPDATE graph_objects SET status='not_decoded' WHERE object_id=?",(self.oid(6),));c.close()
        with self.assertRaises(RecoveryError):self.selection()
    def test_decoding_failure_is_explicit_blocker(self):
        self.prepared();c=Catalog(self.root/'capture');c.db.execute("UPDATE graph_objects SET status='decode_failed',detail='unknown' WHERE object_id=?",(self.oid(6),));c.close()
        s=self.selection();self.assertFalse(s['summary']['serialized_closure_complete']);self.assertEqual(len(s['blockers']),1)
    def test_dropped_resolved_target_rejected(self):
        self.prepared();s=self.selection();s['objects']=[o for o in s['objects'] if o['path_id']!=6]
        with self.assertRaises(RecoveryError):scope.validate_plan(s)
    def test_false_completion_count_rejected(self):
        self.prepared();s=self.selection();s['summary']['objects']+=1
        with self.assertRaises(RecoveryError):scope.validate_plan(s)
    def test_corrupt_reference_identity_rejected(self):
        self.prepared();s=self.selection();s['references'][0]['id']='a'*64
        with self.assertRaises(RecoveryError):scope.validate_plan(s)
    def test_full_raw_object_and_tree_roundtrip(self):
        self.prepared();r=self.deliver();self.assertTrue(r['verified']);self.assertEqual(r['objects'],6)
    def test_existing_destination_is_preserved(self):
        self.prepared();self.deliver()
        with self.assertRaises(RecoveryError):self.deliver()
    def test_damaged_original_apk_rejected(self):
        self.prepared();(self.root/'input.apk').write_bytes(b'changed')
        with self.assertRaises(RecoveryError):self.deliver()
        self.assertFalse((self.root/'package').exists())
    def test_raw_object_hash_reparsed_not_trusted(self):
        self.prepared();self.loaded.objects[6].raw=b'changed'
        with self.assertRaises(RecoveryError):self.deliver()
        self.assertFalse((self.root/'package').exists())
    def test_changed_source_pointer_cannot_match_graph(self):
        self.prepared();self.loaded.objects[3].tree['m_Mesh']=ptr(5)
        with self.assertRaises(RecoveryError):self.deliver()
    def test_changed_delivered_blob_rejected(self):
        self.prepared();self.deliver();p=next((self.root/'package/blobs').iterdir());p.write_bytes(b'changed')
        with self.assertRaises(RecoveryError):scope.verify(self.root/'package')
    def test_missing_object_receipt_detected(self):
        self.prepared();self.deliver();p=self.root/'package/receipt.json';r=json.loads(p.read_text());r['objects'].pop();p.write_bytes(json_bytes(r))
        with self.assertRaises(RecoveryError):scope.verify(self.root/'package')
    def test_extra_payload_detected(self):
        self.prepared();self.deliver();(self.root/'package/blobs/unlisted').write_bytes(b'x')
        with self.assertRaises(RecoveryError):scope.verify(self.root/'package')
    def test_font_payload_never_exported(self):
        self.prepared();s=self.selection();obj=next(o for o in s['objects'] if o['path_id']==6);obj['type']='Font'
        s['blockers'].append({'object_id':obj['id'],'kind':'font_payload_not_delivered'});s['summary']['serialized_closure_complete']=False
        with self.assertRaisesRegex(RecoveryError,'font'):self.deliver(s)
