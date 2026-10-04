#!/usr/bin/env python3
"""Compare native-package access against hash-pinned recovered client Lua methods."""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import struct
import subprocess
from client_semantics import Accessors, CONTRACT, make_oracle
from godot_data import cell_digest, columns_and_rows, git, sha256, verify
from lua_table_data import DataError, compact, interpret, need

# This fixture is separately labelled; it is never counted as recovered game data.
BOUNDARY = br'''local r,p,a,b,d
r={};p={};a={};b={};d={};p[0]={17};p[1]=false;p[2]="";p[3]={};p[3].self=p[3];p[4]="\000\255"
r.index={id={1,"number"},linked={2,"table",true},zero={3,"number"},blank={4,"string"},flag={5,"boolean"},missing_string={6,"string"},missing_number={7,"number"},numeric_flag={8,"table",0},empty_flag={9,"table",""},not_linked={10,"number",false},attr_add={11,"table",true},attr_ratio={12,"number"}}
a[1]=1;a[2]=0.0;a[3]=0;a[4]="";a[5]=false;a[8]=3;a[9]=4;a[10]=4;a[11]=5;a[12]=1.25
p[5]={[101]=2.75,[102]=-2.75,[103]=0};b[1]=2;b[2]=999;b[4]=false;b[8]=1;b[9]=2;b[11]=5
r.index.star_show={13,"table",true};a[13]=6;p[6]={0,5}
d[1]=a;d[2]=b;r.data=d;r.vExt=p;return r'''


def native(token):
    if token is None: return None
    kind, value = token
    if kind == 'i': return int(value)
    if kind == 'f': return struct.unpack('<d', bytes.fromhex(value))[0]
    if kind == 's': return bytes.fromhex(value)
    if kind == 'b': return value
    raise DataError('oracle arguments must be scalars')


def compare_module(name, raw, doc, columns, bind, *, rank=False):
    need(interpret(raw) == doc, 'package graph differs from its source: ' + name)
    query, rank_query = bind(raw)
    access = Accessors(doc)
    line_hash = hashlib.sha256(); controller_hash = hashlib.sha256()
    count = 0
    for key, _ in doc['tables'][access.data]:
        for col in columns:
            field = bytes.fromhex(col['name_hex'])
            for mode in (False, True):
                result = query(native(key), field, None, mode)
                expected = access.controller(key, col['name_hex']) if mode else access.line(key, col['name_hex'])
                need(result == compact(expected), 'source accessor mismatch: '+name+':'+str(key)+':'+str(field))
                h = controller_hash if mode else line_hash
                h.update(compact(key)+b'\n'+col['name_hex'].encode()+b'\n'+result+b'\n')
            count += 1
    need(line_hash.hexdigest() == access.report(columns)['resolved_cell_sha256'], 'source digest mismatch')
    queries = []
    keys = [key for key, _ in doc['tables'][access.data]][:2] + [['s', b'__missing_record__'.hex()]]
    fields = [c['name_hex'] for c in columns] + [b'__missing_field__'.hex()]
    for key in keys:
        for field in fields:
            for default in (None, ['b',False], ['i','0'], ['s',''], ['s',b'fallback'.hex()]):
                for mode in (False,True):
                    encoded = query(native(key), bytes.fromhex(field), native(default), mode)
                    expected = access.controller(key,field,default) if mode else access.line(key,field,default)
                    need(encoded == compact(expected), 'source default mismatch: '+name)
                    queries.append({'key':key,'field_hex':field,'default':default,'controller':mode,'expected':json.loads(encoded)})
    rank_cases = []
    if rank:
        for key, _ in doc['tables'][access.data]:
            attrs = access.line(key,b'attr_add'.hex())
            effect_keys = ([k for k,_ in doc['tables'][attrs[1]]] if attrs and attrs[0]=='t' else [])
            for effect in effect_keys + [['i','-1']]:
                need(effect[0] == 'i', 'unsupported effect key in rank profile')
                rank_cases.append({'key':key,'effect':effect,'expected':json.loads(rank_query(native(key),native(effect)))})
    return {'name':name, 'cells':count, 'line_cell_sha256':line_hash.hexdigest(),
            'controller_cell_sha256':controller_hash.hexdigest(), 'queries':queries,
            'rank_cases':rank_cases,'source_accessors_match':True}


def build_report(repo, package, out):
    repo, package, out = Path(repo), Path(package), Path(out)
    need(not out.exists() and not out.is_symlink(), 'report destination already exists')
    verify(package)
    catalog = json.loads((package/'catalog.json').read_bytes())
    need(catalog['source_commit'] == git(repo,'rev-parse','HEAD').decode().strip(), 'package commit differs from checkout')
    bind, references = make_oracle(repo)
    modules = []
    for item in catalog['modules']:
        relative = item['source_path']; target = repo/relative
        need(not target.is_symlink() and target.resolve().is_relative_to((repo/'source-app/data-tables-lua').resolve()), 'unsafe data source')
        raw = target.read_bytes()
        need(sha256(raw) == item['source_sha256'], 'data source hash mismatch')
        need(git(repo,'rev-parse','HEAD:'+relative).decode().strip()==item['source_blob_sha1'], 'data source is not committed')
        doc = json.loads((package/'modules'/(item['sha256']+'.json')).read_bytes())
        result = compare_module(item['name'],raw,doc,item['columns'],bind,rank=item['name']=='lw_hero_rank')
        modules.append(result)
        print(item['name']+': '+str(result['cells'])+' runtime cells matched',flush=True)
    fixture_doc=interpret(BOUNDARY); columns,rows=columns_and_rows(fixture_doc)
    fixture_result=compare_module('generated_runtime_fixture',BOUNDARY,fixture_doc,columns,bind,rank=True)
    payload=compact(fixture_doc); digest=sha256(payload)
    fixture_item={'name':'generated_runtime_fixture','sha256':digest,'bytes':len(payload),'row_count':rows,
                  'table_count':len(fixture_doc['tables']),'entry_count':sum(map(len,fixture_doc['tables'])),
                  'columns':columns,'cell_sha256':cell_digest(fixture_doc,columns),
                  'runtime_access':Accessors(fixture_doc).report(columns)}
    fixture_catalog={'format':'recovered-client-data-v2','accessor_contract':CONTRACT,'state':'ready',
                     'source_commit':'0'*40,'source_tree':'0'*40,'selected_modules':1,'rows':rows,'modules':[fixture_item]}
    report={'format':'client-runtime-oracle-v1','passed':True,'accessor_contract':CONTRACT,
            'source_commit':catalog['source_commit'],'package_catalog_sha256':sha256((package/'catalog.json').read_bytes()),
            'reference_sources':references,'modules':modules,'generated_fixture':fixture_result,
            'real_cells':sum(m['cells'] for m in modules),'real_rank_cases':sum(len(m['rank_cases']) for m in modules),
            'binary_runtime_parity_verified':False,'original_apk_verified':False}
    # Do not publish evidence unless every source comparison has succeeded.
    out.mkdir(parents=True,exist_ok=False)
    fixture=out/'boundary';(fixture/'modules').mkdir(parents=True)
    (fixture/'modules'/(digest+'.json')).write_bytes(payload)
    (fixture/'catalog.json').write_bytes(compact(fixture_catalog));verify(fixture)
    (out/'semantic-oracle.json').write_bytes(compact(report))
    (out/'boundary-source.lua').write_bytes(BOUNDARY)
    summary={k:report[k] for k in ['passed','real_cells','real_rank_cases','source_commit','package_catalog_sha256','reference_sources']}
    (out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    return summary


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--repo',type=Path,default=Path('.'));p.add_argument('--package',type=Path,required=True);p.add_argument('--out',type=Path,required=True)
    a=p.parse_args()
    try:print(json.dumps(build_report(a.repo,a.package,a.out),indent=2))
    except (DataError,OSError,ValueError,KeyError,ImportError,subprocess.CalledProcessError) as e:p.exit(2,'runtime semantics blocked: '+str(e)+'\n')
if __name__=='__main__':main()
