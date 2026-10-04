from __future__ import annotations
import copy
import struct
import importlib.util
from pathlib import Path
import sys
import tempfile
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'tools'))
from hero_level_oracle import (DataError, MAX_COST, MAX_LEVEL, RESPONSES,
    generated_records, make_oracle, records_from_graph, reference_sources,
    scenario_set, trace_dataset, validate_records, validate_responses)
from lua_table_data import interpret


def row(key=1, level=1, condition=''):
    return dict(key=key,id=key,level=level,next_exp=20,coins=3,city_exp_get=["i","0"],
                condition_hex=condition.encode().hex())


class LevelInputTests(unittest.TestCase):
    def test_actual_style_defaults_and_linked_fields(self):
        doc=interpret(b'''local r={};r.index={id={1,"number"},level={2,"number"},next_exp={3,"number"},coins={4,"number"},city_exp_get={5,"number"},tech_condition={6,"string",true}};r.data={[2]={2,3,40,false,0,1}};r.vExt={[1]="Research"};return r''')
        self.assertEqual(records_from_graph(doc),[dict(key=2,id=2,level=3,next_exp=40,coins=0,
            city_exp_get=["i","0"],condition_hex=b'Research'.hex())])

    def test_fractional_city_experience_is_not_truncated(self):
        doc=interpret(b'local r={index={id={1,"number"},level={2,"number"},city_exp_get={3,"number"}},data={[1]={1,1,0.3}}};return r')
        token=records_from_graph(doc)[0]['city_exp_get']
        self.assertEqual(token,['f',struct.pack('<d',0.3).hex()])

    def test_integral_float_city_keeps_float_type(self):
        value=['f',struct.pack('<d',1.0).hex()]
        self.assertEqual(validate_records([{**row(),'city_exp_get':value}])[0]['city_exp_get'],value)

    def test_city_negative_zero_bits_are_preserved(self):
        value=['f',struct.pack('<d',-0.0).hex()]
        self.assertEqual(validate_records([{**row(),'city_exp_get':value}])[0]['city_exp_get'],value)

    def test_city_nonfinite_negative_and_out_of_range_rejected(self):
        for value in [float('nan'),float('inf'),float('-inf'),-0.3,float(MAX_COST+1)]:
            token=['f',struct.pack('<d',value).hex()]
            with self.subTest(value=value),self.assertRaises(DataError):
                validate_records([{**row(),'city_exp_get':token}])

    def test_city_integer_encoding_and_size_budget(self):
        for value in ['','00','+1','-1','1.0',str(MAX_COST+1),'9'*5000]:
            with self.subTest(value=value[:30]),self.assertRaises(DataError):
                validate_records([{**row(),'city_exp_get':['i',value]}])

    def test_city_token_schema_is_strict(self):
        for value in [['f','00'],['f','GG'*8],['s','00'],['i',1],['f',0.3],['i','0',0],None]:
            with self.subTest(value=value),self.assertRaises(DataError):
                validate_records([{**row(),'city_exp_get':value}])

    def test_empty_rows_valid(self): self.assertEqual(validate_records([]),[])
    def test_duplicate_key_rejected(self):
        with self.assertRaises(DataError):validate_records([row(),row()])
    def test_boolean_is_not_integer(self):
        for field in ['key','id','level','coins','next_exp','city_exp_get']:
            with self.subTest(field=field),self.assertRaises(DataError):validate_records([{**row(),field:True}])
    def test_numeric_limits(self):
        for field,value in [('key',0),('key',MAX_LEVEL+1),('level',-1),('level',MAX_LEVEL+1),('coins',MAX_COST+1),('next_exp',-1)]:
            with self.subTest(field=field,value=value),self.assertRaises(DataError):validate_records([{**row(),field:value}])
    def test_float_nan_and_infinity_rejected(self):
        for value in [1.0,float('nan'),float('inf')]:
            with self.subTest(value=value),self.assertRaises(DataError):validate_records([{**row(),'level':value}])
    def test_unknown_missing_fields_rejected(self):
        for value in [{**row(),'extra':0},{k:v for k,v in row().items() if k!='coins'}]:
            with self.assertRaises(DataError):validate_records([value])
    def test_hex_must_be_exact_lowercase_bytes(self):
        for value in ['A0','0','zz',12,'00'*257]:
            with self.subTest(value=value),self.assertRaises(DataError):validate_records([{**row(),'condition_hex':value}])
    def test_binary_condition_preserved(self):
        self.assertEqual(validate_records([{**row(),'condition_hex':'00ff'}])[0]['condition_hex'],'00ff')
    def test_explicit_replies_required(self):
        data=[row(condition='A')]
        for values in [{},{'41':'unknown'},{'41':'record','42':'record'},[]]:
            with self.subTest(values=values),self.assertRaises(DataError):validate_responses(data,values)
    def test_all_response_tags_supported(self):
        for value in RESPONSES:self.assertEqual(validate_responses([row(condition='A')],{'41':value}),{'41':value})
    def test_shared_gate_needs_only_one_reply(self):
        self.assertEqual(validate_responses([row(1,1,'A'),row(2,2,'A')],{'41':'record'}),{'41':'record'})
    def test_inputs_are_not_mutated(self):
        data=[row()];original=copy.deepcopy(data);validate_records(data);self.assertEqual(data,original)
    def test_key_is_not_authored_level(self): self.assertEqual(validate_records([row(2,5)])[0]['key'],2)
    def test_generated_scenarios_all_have_complete_replies(self):
        for _,rows in generated_records():
            validate_records(rows)
            for scenario in scenario_set(rows):
                for step in scenario['steps']:validate_responses(rows,step['responses'])
    def test_source_hash_change_is_fatal(self):
        with tempfile.TemporaryDirectory() as td:
            from hero_level_oracle import SOURCES
            for name in SOURCES:
                p=Path(td)/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_text('return {}\n')
            with self.assertRaisesRegex(DataError,'reference source changed'):reference_sources(td)
    def test_bad_condition_type_from_graph(self):
        doc=interpret(b'local r={index={id={1,"number"},level={2,"number"},tech_condition={3,"number"}},data={[1]={1,1,99}}};return r')
        with self.assertRaisesRegex(DataError,'nonstring'):records_from_graph(doc)
    def test_graph_float_numeric_fields_not_silently_cast(self):
        doc=interpret(b'local r={index={id={1,"number"},level={2,"number"}},data={[1]={1,1.5}}};return r')
        with self.assertRaisesRegex(DataError,'noninteger'):records_from_graph(doc)


@unittest.skipUnless(importlib.util.find_spec('lupa'), 'Lua 5.3 dependency required in CI')
class OriginalSourceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.bind,_=make_oracle(Path(__file__).resolve().parents[1])
    def bind_rows(self, rows): return type(self).bind(rows)
    def test_source_fractional_and_integral_float_city_bits(self):
        for value in [0.3,1.0,-0.0]:
            record={**row(),'city_exp_get':['f',struct.pack('<d',value).hex()]}
            _,lookup=self.bind_rows([record]);self.assertEqual(lookup(1),record)
    def test_source_empty_fallback_is_not_reachable_cap(self):
        step,_=self.bind_rows([]);self.assertEqual(step({}),[100,1,0])
    def test_source_missing_template_does_not_stop_later_rows(self):
        step,_=self.bind_rows([row(1,1,'A'),row(2,2)])
        self.assertEqual(step({'41':'missing_template'}),[3,3,2])
    def test_source_forward_only_cache_and_explicit_reset(self):
        step,_=self.bind_rows([row(1,1,'A'),row(2,2)])
        self.assertEqual(step({'41':'no_record'}),[3,1,0])
        self.assertEqual(step({'41':'record'}),[3,3,2])
        self.assertEqual(step({'41':'no_record'}),[3,3,2])
        self.assertEqual(step({'41':'no_record'},True),[3,1,0])
    def test_source_record_identity_and_lazy_lookup(self):
        _,lookup=self.bind_rows([row(2,5)])
        self.assertEqual(lookup(2),row(2,5));self.assertIsNone(lookup(5))
    def test_source_missing_manager_blocks(self):
        step,_=self.bind_rows([row(1,1,'A')]);self.assertEqual(step({'41':'no_manager'}),[2,1,0])
    def test_generated_trace_all_variants(self):
        for name,rows in generated_records():
            result=trace_dataset(name,rows,type(self).bind)
            self.assertTrue(result['scenarios'])
            for scenario in result['scenarios']:
                self.assertEqual(len(scenario['before']),len(rows)+2)

if __name__=='__main__':unittest.main()
