"""Boundary-only generated data fixture; never labelled recovered game content."""
import hashlib
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from lua_table_data import compact, interpret
from godot_data import cell_digest, columns_and_rows, verify
from client_semantics import Accessors, CONTRACT


def make(out):
    source=br'''local r,c,d,a,shared
r={};c={};d={};a={};shared={};shared.self=shared
c.id={1,"number"};c.max={2,"number"};c.min={3,"number"};c.float={4,"number"};c.negzero={5,"number"};c.bytes={6,"string"};c.flag={7,"boolean"};c.alias_a={8,"table"};c.alias_b={9,"table"};c.absent={10,"string"}
a[1]=9007199254740993;a[2]=9223372036854775807;a[3]=0x8000000000000000;a[4]=1.5;a[5]=-0.0;a[6]="\000\255\x41";a[7]=false;a[8]=shared;a[9]=shared
d[9007199254740993]=a;r.index=c;r.data=d;return r'''
    doc=interpret(source);encoded=compact(doc);sha=hashlib.sha256(encoded).hexdigest();columns,count=columns_and_rows(doc)
    out=Path(out);(out/'modules').mkdir(parents=True,exist_ok=False)
    (out/'modules'/(sha+'.json')).write_bytes(encoded)
    item={'name':'generated_boundary_fixture','sha256':sha,'bytes':len(encoded),'row_count':count,'table_count':len(doc['tables']),
          'entry_count':sum(map(len,doc['tables'])),'columns':columns,'cell_sha256':cell_digest(doc,columns),'runtime_access':Accessors(doc).report(columns)}
    catalog={'format':'recovered-client-data-v2','accessor_contract':CONTRACT,'state':'ready','source_commit':'0'*40,'source_tree':'0'*40,'selected_modules':1,'rows':count,'modules':[item]}
    (out/'catalog.json').write_bytes(compact(catalog));verify(out)

if __name__=='__main__':make(sys.argv[1])
