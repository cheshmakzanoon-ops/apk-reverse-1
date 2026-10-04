from __future__ import annotations
import copy
import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from lua_table_data import DataError, compact, interpret
from client_semantics import Accessors, CONTRACT, canonical_key, make_oracle, reference_sources, section, truth
from godot_data import columns_and_rows, verify
from verify_client_semantics import BOUNDARY, compare_module

KEY=['i','1']
def field(name): return name.encode().hex()
def access(raw=BOUNDARY): return Accessors(interpret(raw))

def fixture(row=b'1',desc=b'{1,"number",true}',pool=b'{[1]={99}}'):
    return b'local r; r={index={x='+desc+b'},data={[1]={[1]='+row+b'}}'+(b',vExt='+pool if pool else b'')+b'};return r'

class SemanticsTests(unittest.TestCase):
    def test_lua_truth_does_not_use_python_truth(self):
        for t in [None,['b',False]]:self.assertFalse(truth(t))
        for t in [['i','0'],['s',''],['t',0],['b',True],['f','0000000000000080']]:self.assertTrue(truth(t))
    def test_pool_index_zero_and_integral_float(self):
        a=access();v=a.line(KEY,field('linked'))
        self.assertEqual(v[0],'t');self.assertEqual(a.lookup(v[1],['i','1']),['i','17'])
        self.assertEqual(a.raw(KEY,field('linked'))[0],'f')
    def test_only_explicit_link_flag_resolves(self):
        a=access();self.assertEqual(a.line(KEY,field('not_linked')),['i','4'])
    def test_declared_table_is_not_a_link_flag(self):
        a=access(fixture(desc=b'{1,"table"}'));self.assertEqual(a.line(KEY,field('x')),['i','1'])
    def test_numeric_zero_flag_is_true(self):
        a=access();self.assertEqual(a.line(KEY,field('numeric_flag'))[0],'t')
    def test_empty_string_flag_is_true(self):
        self.assertEqual(access().line(KEY,field('empty_flag')),['s','00ff'])
    def test_missing_pool_preserves_raw_per_source(self):
        a=access(fixture(pool=b''));self.assertEqual(a.line(KEY,field('x')),['i','1'])
        self.assertEqual(a.report(columns_and_rows(a.document)[0])['linked_without_pool'],1)
    def test_false_pool_is_not_dereferenced(self):
        self.assertEqual(access(fixture(pool=b'false')).line(KEY,field('x')),['i','1'])
    def test_dangling_pool_link_is_visible(self):
        a=access();self.assertIsNone(a.line(['i','2'],field('linked')))
        self.assertEqual(a.report(columns_and_rows(a.document)[0])['dangling_links'],1)
    def test_false_pool_value_uses_default(self):
        a=access();self.assertEqual(a.line(['i','2'],field('numeric_flag'),['i','7']),['i','7'])
    def test_empty_pool_string_is_not_missing(self):
        self.assertEqual(access().line(['i','2'],field('empty_flag'),['i','7']),['s',''])
    def test_zero_is_not_replaced_by_default(self):
        self.assertEqual(access().line(KEY,field('zero'),['i','7']),['i','0'])
    def test_false_nonstring_with_false_default_returns_false(self):
        a=access();self.assertIsNone(a.line(KEY,field('flag')))
        self.assertEqual(a.line(KEY,field('flag'),['b',False]),['b',False])
    def test_missing_declared_string_defaults_empty(self):
        a=access();self.assertEqual(a.line(KEY,field('missing_string')),['s',''])
        self.assertEqual(a.line(KEY,field('missing_string'),['b',False]),['s',''])
    def test_missing_declared_number_defaults_nil(self):
        self.assertIsNone(access().line(KEY,field('missing_number')))
    def test_unknown_column_differs_from_known_string(self):
        self.assertIsNone(access().line(KEY,field('unknown')))
        self.assertEqual(access().line(KEY,field('unknown'),['b',False]),['b',False])
    def test_absent_row_does_not_get_typed_string_fallback(self):
        self.assertIsNone(access().line(['i','999'],field('missing_string')))
    def test_controller_always_uses_final_string_fallback(self):
        a=access()
        for col in ['unknown','missing_number','flag']:
            self.assertEqual(a.controller(KEY,field(col),['b',False]),['s',''])
    def test_empty_and_zero_defaults_have_lua_truth(self):
        a=access()
        for default in [['s',''],['i','0']]:self.assertEqual(a.controller(KEY,field('unknown'),default),default)
    def test_table_alias_and_cycle_not_copied(self):
        a=access();v=a.line(KEY,field('numeric_flag'));self.assertEqual(a.lookup(v[1],['s',field('self')]),v)
    def test_byte_strings_survive_indirection(self):
        self.assertEqual(access().line(KEY,field('empty_flag')),['s','00ff'])
    def test_key_identity_preserved(self):
        self.assertIsNone(access().line(['s',field('1')],field('zero')))
        self.assertIsNone(access().line(['b',True],field('zero')))
    def test_integral_float_key_coercion(self):
        self.assertEqual(canonical_key(['f','000000000000f03f']),compact(['i','1']))
        self.assertEqual(canonical_key(['f','0000000000000080']),compact(['i','0']))
    def test_reading_does_not_mutate_original_graph(self):
        doc=interpret(BOUNDARY);before=compact(doc);a=Accessors(doc);a.report(columns_and_rows(doc)[0]);self.assertEqual(compact(doc),before)
    def test_deterministic_runtime_digest(self):
        a=access();cols=columns_and_rows(a.document)[0];self.assertEqual(a.report(cols),access().report(cols))
        self.assertGreater(a.report(cols)['changed_cells'],0)
    def test_pool_with_invalid_type_fails(self):
        for raw in [b'1',b'"abc"',b'true']:
            with self.subTest(raw=raw),self.assertRaises(DataError):access(fixture(pool=raw))
    def test_split_manifest_is_not_silently_treated_as_flat(self):
        with self.assertRaises(DataError):access(b'local r;r={index={},data={},link={}};return r')
    def test_ambiguous_method_slice_fails(self):
        with self.assertRaises(DataError):section(b'start start end',b'start',b'end')
        with self.assertRaises(DataError):section(b'end start',b'start',b'end')
    def test_changed_reference_requires_review(self):
        with tempfile.TemporaryDirectory() as t:
            p=Path(t)/'source-app/lua/src/Common/LocalController.lua';p.parent.mkdir(parents=True);p.write_bytes(b'changed')
            with self.assertRaisesRegex(DataError,'review required'):reference_sources(t)
    def test_catalog_semantics_tampering_is_detected(self):
        from data_native_fixtures import make
        with tempfile.TemporaryDirectory() as t:
            p=Path(t)/'package';make(p);c=json.loads((p/'catalog.json').read_text());c['modules'][0]['runtime_access']['changed_cells']+=1
            (p/'catalog.json').write_bytes(compact(c))
            with self.assertRaisesRegex(DataError,'runtime accessor'):verify(p)
    def test_old_package_contract_is_rejected(self):
        from data_native_fixtures import make
        with tempfile.TemporaryDirectory() as t:
            p=Path(t)/'package';make(p);c=json.loads((p/'catalog.json').read_text());c['format']='recovered-client-data-v1'
            (p/'catalog.json').write_bytes(compact(c))
            with self.assertRaisesRegex(DataError,'not ready'):verify(p)

@unittest.skipUnless(importlib.util.find_spec('lupa'),'Lua 5.3 integration required in CI')
class SourceOracleTests(unittest.TestCase):
    def test_recovered_controller_and_rank_class(self):
        bind,refs=make_oracle(Path(__file__).resolve().parents[1]);doc=interpret(BOUNDARY)
        result=compare_module('boundary',BOUNDARY,doc,columns_and_rows(doc)[0],bind,rank=True)
        self.assertTrue(result['source_accessors_match']);self.assertEqual(len(refs),2)
        self.assertGreater(len(result['rank_cases']),0)
    def test_oracle_rejects_general_code_before_execution(self):
        bind,_=make_oracle(Path(__file__).resolve().parents[1])
        with self.assertRaises(DataError):bind(b'while true do end')

if __name__=='__main__':unittest.main()
