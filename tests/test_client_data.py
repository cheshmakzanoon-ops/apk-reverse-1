from __future__ import annotations
import copy
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'tools'))
from lua_table_data import DataError, Parser, compact, decode, encode, get, interpret, numeral
import godot_data

DATA = b'local r,c,d,a; r={}; c={}; d={}; a={}; c.id={1,"number"}; c.name={2,"string"}; r.index=c; r.data=d; a[1]=9007199254740993; a[2]="actual name"; d[9007199254740993]=a; return r'

class StaticDataTests(unittest.TestCase):
    def run_data(self, source): return decode(interpret(source))
    def test_schema_large_integer_and_canonical_roundtrip(self):
        doc=interpret(DATA); root=decode(doc)
        self.assertEqual(get(get(root,b'data'),9007199254740993).entries[(int,1)],9007199254740993)
        self.assertEqual(encode(root),doc)
        self.assertEqual(godot_data.columns_and_rows(doc)[1],1)
    def test_aliases_cycles_and_unused_tables(self):
        doc=interpret(b'local r,a,dead; r={}; a={}; dead={}; r.a=a; r.b=a; a.self=r; return r')
        root=decode(doc)
        self.assertIs(get(root,b'a'),get(root,b'b'))
        self.assertIs(get(get(root,b'a'),b'self'),root)
        self.assertEqual(len(doc['tables']),2)
    def test_assignment_nil_and_missing_field(self):
        root=self.run_data(b'local r; r={}; r.x=1; r.x=2; r.x=nil; r.y=r.absent; return r')
        self.assertEqual(root.entries,{})
    def test_parallel_assignment_uses_old_targets(self):
        root=self.run_data(b'local r,i; r={}; i=1; i,r[i]=2,3; r.i=i; return r')
        self.assertEqual(get(root,1),3); self.assertEqual(get(root,b'i'),2)
    def test_boolean_integer_string_and_float_keys(self):
        r=self.run_data(b'local r; r={}; r[true]=1; r[1]=2; r["1"]=3; r[1.0]=4; r[1.5]=5; return r')
        self.assertEqual(len(r.entries),4)
        self.assertEqual(get(r,True),1); self.assertEqual(get(r,1),4); self.assertEqual(get(r,b'1'),3)
    def test_numeric_semantics(self):
        self.assertEqual(numeral(b'0xffffffffffffffff'),-1)
        self.assertEqual(numeral(b'0x10000000000000001'),1)
        self.assertIs(type(numeral(b'9223372036854775808')),float)
        self.assertEqual(numeral(b'0x1.8p1'),3.0)
        r=self.run_data(b'local r; r={-0.0, -0x8000000000000000, -9223372036854775808}; return r')
        self.assertEqual(encode(r)['tables'][0][0][1],['f','0000000000000080'])
        self.assertEqual(get(r,2),-(1<<63)); self.assertIs(type(get(r,3)),float)
    def test_strings_comments_and_binary(self):
        r=self.run_data(br'''-- comment
local r; r={}; r.a="\000\255\x41\u{1f600}\z  \n"; r.b=[==[
long
text]==]; --[=[ ignored ]=]
return r''')
        self.assertEqual(get(r,b'a'),b'\0\xffA'+chr(0x1f600).encode()+b'\n')
        self.assertEqual(get(r,b'b'),b'long\ntext')
    def test_bom_and_escaped_newline(self):
        r=self.run_data(b'\xef\xbb\xbflocal r; r={"one\\\r\ntwo"}; return r')
        self.assertEqual(get(r,1),b'one\ntwo')
    def test_calls_control_flow_globals_and_binary_ops_rejected(self):
        for s in [b'return os.execute("x")',b'local r; r=require("x"); return r',b'while true do end',
                  b'local r; r={}; function r.x() end; return r',b'local r; r={1+2}; return r',
                  b'local r; r={}; goto x; return r',b'global={}; return global',b'local r; r={}; r(); return r']:
            with self.subTest(s=s),self.assertRaises(DataError):interpret(s)
    def test_malformed_escaping_and_numbers_rejected(self):
        for s in [b'local r; r={"\\q"}; return r',b'local r; r={"\\999"}; return r',
                  b'local r; r={1e999}; return r',b'local r; r={12oops}; return r',b'local r; r={[nil]=1}; return r']:
            with self.subTest(s=s),self.assertRaises(DataError):interpret(s)
    def test_constructor_duplicate_rejected(self):
        with self.assertRaises(DataError):interpret(b'local r; r={1,[1]=2}; return r')
    def test_return_and_trailing_statements_rejected(self):
        for s in [b'local r; r={}',b'return 1',b'local r; r={}; return r; r.x=2',b'local r; r={}; return r,r']:
            with self.subTest(s=s),self.assertRaises(DataError):interpret(s)
    def test_budget_guards(self):
        with self.assertRaises(DataError):interpret(DATA,max_tokens=5)
        with self.assertRaises(DataError):interpret(DATA,max_tables=1)
        with self.assertRaises(DataError):interpret(b'local r; r={'+b'{'*110+b'}'*110+b'}; return r')
    def test_noncanonical_corrupt_graph_rejected(self):
        doc=interpret(DATA)
        for change in ['unreachable','ref','float','duplicate','integer']:
            bad=copy.deepcopy(doc)
            if change=='unreachable':bad['tables'].append([])
            if change=='ref':bad['tables'][0][0][1]=['t',1000000]
            if change=='float':bad['tables'][0][0][1]=['f','000000000000f07f']
            if change=='duplicate':bad['tables'][0].append(bad['tables'][0][0])
            if change=='integer':bad['tables'][0][0][1]=['i','9223372036854775808']
            with self.subTest(change=change),self.assertRaises(DataError):decode(bad)
    def test_local_redeclaration_reads_previous_binding(self):
        r=self.run_data(b'local a; a={1}; local a=a; return a')
        self.assertEqual(get(r,1),1)
    def test_index_assignment_reads_nil_without_creating_keys(self):
        r=self.run_data(b'local r,a; r={}; a={}; r.a=a; r.a.x=1; r.z=r.a.q; return r')
        self.assertEqual(len(r.entries),1);self.assertEqual(get(get(r,b'a'),b'x'),1)

class PackageTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.root=Path(self.tmp.name);self.repo=self.root/'repo';self.repo.mkdir()
        self.source=self.repo/godot_data.SCOPE/'fixture.lua';self.source.parent.mkdir(parents=True);self.source.write_bytes(DATA)
        self.git('init','-q');self.git('config','user.name','Test');self.git('config','user.email','test@example.invalid')
        self.git('add','.');self.git('commit','-qm','fixture')
        self.out=self.root/'out'
    def tearDown(self):self.tmp.cleanup()
    def git(self,*args):return subprocess.check_output(['git','-C',str(self.repo),*args],stderr=subprocess.STDOUT)
    def test_package_hashes_cells_and_provenance(self):
        c=godot_data.build(self.repo,self.out,['fixture'])
        self.assertEqual(c['rows'],1);self.assertFalse(c['apk_verified']);self.assertFalse(c['gameplay_port_complete'])
        self.assertEqual(godot_data.verify(self.out)['modules'],1)
        self.assertEqual(c['modules'][0]['source_sha256'],hashlib.sha256(DATA).hexdigest())
    def test_source_dirty_rejected_and_output_not_published(self):
        self.source.write_bytes(DATA+b'\n')
        with self.assertRaises(DataError):godot_data.build(self.repo,self.out,['fixture'])
        self.assertFalse(self.out.exists());self.assertEqual(list(self.root.glob('.data-*')),[])
    def test_missing_and_path_injection_selection(self):
        for names in [['missing'],['../fixture'],['fixture','fixture'],[]]:
            with self.subTest(names=names),self.assertRaises(DataError):godot_data.build(self.repo,self.out,names)
        self.assertFalse(self.out.exists())
    def test_overwrite_refused(self):
        godot_data.build(self.repo,self.out,['fixture'])
        with self.assertRaises(DataError):godot_data.build(self.repo,self.out,['fixture'])
    def test_corruption_rejected(self):
        c=godot_data.build(self.repo,self.out,['fixture']);p=self.out/'modules'/(c['modules'][0]['sha256']+'.json')
        p.write_bytes(p.read_bytes()+b' ')
        with self.assertRaises(DataError):godot_data.verify(self.out)
    def test_unexpected_file_rejected(self):
        godot_data.build(self.repo,self.out,['fixture']);(self.out/'unaccounted').write_bytes(b'1')
        with self.assertRaises(DataError):godot_data.verify(self.out)
    def test_bad_schema_and_uncommitted_source_rejected(self):
        self.source.write_bytes(b'local r; r={}; return r');self.git('add','.');self.git('commit','-qm','bad schema')
        with self.assertRaises(DataError):godot_data.build(self.repo,self.out,['fixture'])
    def test_source_symlink_rejected(self):
        self.source.unlink();self.source.symlink_to(self.root/'elsewhere')
        with self.assertRaises(DataError):godot_data.build(self.repo,self.out,['fixture'])

@unittest.skipUnless(importlib.util.find_spec('lupa'),'Lua oracle required by CI')
class OracleTests(unittest.TestCase):
    def test_independent_lua53_matches_entire_graph(self):
        from lupa.lua53 import LuaRuntime
        run=LuaRuntime(encoding=None,register_eval=False,register_builtins=False).execute(godot_data.ORACLE.encode())
        samples=[DATA,b'local r,a; r={}; a={}; r.a=a; r.b=a; a.r=r; return r',
                 b'local r; r={0xffffffffffffffff,9223372036854775808,-0.0,-0x8000000000000000,0x1.8p1}; return r',
                 br'local r; r={"\000\255\x41\u{1f600}"}; return r',
                 b'local r,i; r={};i=1;i,r[i]=2,3;r[true]=1;r[1.0]=4;return r']
        for source in samples:
            with self.subTest(source=source):self.assertEqual(run(source),compact(interpret(source)))

if __name__=='__main__':unittest.main()
