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
    def prepared(self, extra=(), root_extra=None):
        items=model_items()+[(100,'AssetBundle',{'m_Container':[['Assets/stage.prefab',{'asset':ptr(1)}]]})]+list(extra)
        if root_extra: items[0][2].update(root_extra)
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

    def test_native_material_tuple_map_preserves_nested_texture_pointers(self):
        self.prepared([(200,'Material',{'m_SavedProperties':{'m_TexEnvs':[
            ('_BaseMap',{'m_Texture':ptr(0)}), ('_Other',{'m_Texture':ptr(6)})]}})],
            root_extra={'m_Material':ptr(200)})
        s=self.selection()
        material=next(o for o in s['objects'] if o['type']=='Material')
        refs=[r for r in s['references'] if r['source_id']==material['id']]
        self.assertEqual(len(refs),2)
        self.assertEqual(self.deliver(s)['objects'],7)

    def test_modified_pointer_inside_native_tuple_map_is_rejected(self):
        self.prepared([(200,'Material',{'m_SavedProperties':{'m_TexEnvs':[
            ('_BaseMap',{'m_Texture':ptr(0)})]}})], root_extra={'m_Material':ptr(200)})
        s=self.selection()
        self.loaded.objects[200].tree['m_SavedProperties']['m_TexEnvs'][0][1]['m_Texture']=ptr(6)
        with self.assertRaises(RecoveryError):self.deliver(s)


class PackedResourceScopeTests(GraphFixture):
    def prepared(self, resource_name='pixels.resS', offset=4, size=7):
        import zlib
        from recovery_core import json_bytes, digest, lossless_tree
        items=model_items()+[(100,'AssetBundle',{'m_Container':[['Assets/stage.prefab',{'asset':ptr(1)}]]}),
                            (200,'Cubemap',{'m_Name':'Generated cubemap',
                                'm_StreamData':{'path':resource_name,'offset':offset,'size':size}})]
        items[0][2]['m_Cube']=ptr(200)
        self.serial=member(items,name='scene.assets')
        self.loaded=NS(files={'scene.assets':self.serial,'pixels.resS':NS(bytes=b'headPAYLOADtail')})
        self.capture(entries=[('assets/bin/Data/test.bundle',b'generated bundle bytes')],loaded=self.loaded,trees=False)
        with patch.object(recover,'environment',return_value=NS(load_file=lambda *a,**k:self.serial)):
            import recovery_graph
            recovery_graph.build(self.root/'capture')
        c=Catalog(self.root/'capture')
        c.db.execute('CREATE TABLE graph_trees(object_id TEXT PRIMARY KEY,sha TEXT,raw_size INTEGER,data BLOB)')
        cube=c.db.execute("SELECT * FROM objects WHERE type='Cubemap'").fetchone()
        raw=json_bytes(lossless_tree(self.serial.objects[200].tree,c))
        c.db.execute('INSERT INTO graph_trees VALUES (?,?,?,?)',(cube['id'],digest(raw),len(raw),zlib.compress(raw)))
        c.db.execute('UPDATE objects SET tree_sha=NULL WHERE id=?',(cube['id'],))
        c.set_meta('graph_scan_schema',1)
        root=c.db.execute('SELECT * FROM objects WHERE path_id=1').fetchone()
        self.profile={'schema':1,'input_sha256':c.get_meta('input_sha256'),'roots':[{'path':'Assets/stage.prefab',
                      'type':'GameObject','object_id':root['id'],'sha256':root['sha']}]}
        self.assertEqual(c.db.execute("SELECT COUNT(*) FROM dependencies WHERE kind='stream'").fetchone()[0],0)
        c.close()
    def selection(self):
        db=scope.read_db(self.root/'capture/catalog.sqlite')
        try:return scope.plan(db,self.profile)
        finally:db.close()
    def extract(self, selection):
        with patch.object(recover,'environment',return_value=NS(load_file=lambda *a,**k:self.loaded)):
            return scope.extract(self.root/'input.apk',selection,self.root/'package')
    def test_cubemap_stream_discovered_even_without_raw_index_row(self):
        self.prepared();s=self.selection()
        self.assertEqual(len(s['streams']),1)
        self.assertTrue(s['summary']['serialized_closure_complete'])
        self.assertEqual((s['streams'][0]['offset'],s['streams'][0]['size']),(4,7))
    def test_original_resource_range_preserved_in_package(self):
        self.prepared();s=self.selection();r=self.extract(s)
        self.assertEqual((self.root/'package/blobs'/r['streams'][0]['sha256']).read_bytes(),b'PAYLOAD')
        self.assertEqual(scope.verify(self.root/'package')['streams'],1)
    def test_missing_resource_not_downgraded_to_complete(self):
        self.prepared(resource_name='missing.resS');s=self.selection()
        self.assertFalse(s['summary']['serialized_closure_complete'])
        self.assertEqual(s['streams'][0]['status'],'unresolved_in_capture')
        r=self.extract(s);self.assertEqual(r['streams'],[])
    def test_bad_resource_range_not_accepted(self):
        self.prepared(size=100);s=self.selection()
        self.assertFalse(s['summary']['serialized_closure_complete'])
        self.assertEqual(s['streams'][0]['status'],'invalid_range')
    def test_corrupt_packed_tree_rejected_before_planning(self):
        self.prepared();c=Catalog(self.root/'capture')
        c.db.execute("UPDATE graph_trees SET data=x'0000'");c.close()
        with self.assertRaises(Exception):self.selection()
    def test_removing_stream_from_plan_fails_original_byte_check(self):
        self.prepared();s=self.selection();s['streams']=[];s['summary']['streams']=0
        with self.assertRaises(RecoveryError):self.extract(s)
    def test_resource_stream_not_allowed_to_escape_range_after_planning(self):
        self.prepared();s=self.selection();s['streams'][0]['offset']=99
        with self.assertRaises(RecoveryError):scope.validate_plan(s)
