#!/usr/bin/env python3
"""Generate source-derived hero-level traces; research responses are injected inputs.

No original gameplay lifecycle or external service is executed. The complete,
hash-pinned level manager and level template run in Lua 5.3. This validates the
GDScript port against recovered source, not against the original game binary.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import re
import math
import struct
import subprocess
from client_semantics import Accessors, truth
from godot_data import git, sha256, verify
from lua_table_data import DataError, compact, need

SOURCE_DIR = 'source-app/lua/src/DataCenter/HeroData/HeroLevel/'
SOURCES = {
    SOURCE_DIR+'HeroLevelTemplate.lua': 'bdb7ad6a1314362cbbdc842c799b45b57a2d388d',
    SOURCE_DIR+'HeroLevelTemplateManager.lua': 'bbe818a0536b6108eb9ff0ca04554652d83d0906',
}
NUMBERS = ('id', 'level', 'next_exp', 'coins')
RESPONSES = ('no_record', 'record', 'missing_template', 'no_manager')
MAX_LEVEL = 10000
MAX_COST = (1 << 53) - 1


def city_number(token):
    need(isinstance(token, list) and len(token) == 2 and token[0] in ('i','f') and isinstance(token[1],str),
         'invalid city experience token')
    if token[0] == 'i':
        need(len(token[1]) <= 16 and re.fullmatch(r'0|[1-9][0-9]*', token[1]) is not None,
             'invalid city experience integer')
        value=int(token[1])
    else:
        need(re.fullmatch(r'[0-9a-f]{16}', token[1]) is not None, 'invalid city experience float')
        value=struct.unpack('<d',bytes.fromhex(token[1]))[0]
    need(math.isfinite(value) and 0 <= value <= MAX_COST, 'invalid city experience range')
    return value


def validate_records(records):
    need(isinstance(records, list) and len(records) <= MAX_LEVEL, 'invalid record list')
    seen = set()
    for row in records:
        need(isinstance(row, dict) and set(row) == {'key', 'condition_hex', 'city_exp_get', *NUMBERS}, 'invalid level record fields')
        key = row['key']
        need(type(key) is int and 1 <= key <= MAX_LEVEL and key not in seen, 'invalid or duplicate record key')
        seen.add(key)
        for field in NUMBERS:
            maximum = MAX_LEVEL if field in ('id', 'level') else MAX_COST
            need(type(row[field]) is int and 0 <= row[field] <= maximum, 'unsupported level numeric value: '+field)
        city_number(row['city_exp_get'])
        cond = row['condition_hex']
        need(isinstance(cond, str) and re.fullmatch(r'(?:[0-9a-f]{2})*', cond) is not None
             and len(cond) <= 512, 'invalid condition bytes')
    return records


def records_from_graph(document):
    access = Accessors(document)
    records = []
    for key, _ in document['tables'][access.data]:
        need(key[0] == 'i', 'level record keys must be integers')
        row = {'key': int(key[1])}
        for field in NUMBERS:
            value = access.line(key, field.encode().hex())
            if not truth(value): value = ['i', '0']  # InitData's `or 0`.
            need(value[0] == 'i', 'unsupported noninteger '+field)
            row[field] = int(value[1])
        city = access.line(key, b'city_exp_get'.hex())
        row['city_exp_get'] = city if truth(city) else ['i','0']
        condition = access.line(key, b'tech_condition'.hex())
        if not truth(condition): condition = ['s', '']
        need(condition[0] == 's', 'nonstring research condition')
        row['condition_hex'] = condition[1]
        records.append(row)
    return validate_records(sorted(records, key=lambda r: r['key']))


def validate_responses(records, values):
    need(isinstance(values, dict), 'research responses must be a dictionary')
    required = {r['condition_hex'] for r in records if r['condition_hex']}
    need(set(values) == required and all(x in RESPONSES for x in values.values()),
         'every condition requires an explicit research response')
    return values


# Only this trusted adapter provides class construction and dependency responses.
# Source code gets no OS, filesystem, network, debug, Python bridge, or arbitrary
# require capability. The fake science ID is just an adapter-local request token;
# it is NOT asserted to be the game's actual science_id mapping.
LUA = r'''
return function(template_source, manager_source, input_rows)
  local function BaseClass(_)
    local cls={}; cls.__index=cls
    function cls.New() local obj=setmetatable({},cls);if cls.__init then cls.__init(obj) end;return obj end
    return cls
  end
  local owner={}; local responses={}; local active_response=nil
  local function hex(s) return (s:gsub('.',function(c)return string.format('%02x',string.byte(c))end)) end
  local raw={}
  for _,row in ipairs(input_rows) do raw[row.key]=row end
  local function line(key)
    local r=raw[key]; if r==nil then return nil end
    return {getValue=function(_,field) return r[field] end}
  end
  function owner:getLine(_,key) return line(key) end
  function owner:visitTable(_,callback) for _,row in ipairs(input_rows) do callback(row.key,line(row.key)) end end
  local center={}
  center.ScienceTemplateManager={GetScienceTemplate=function(_,condition)
    active_response=assert(responses[hex(condition)],'unsupplied research response')
    if active_response=='missing_template' then return nil end
    if active_response=='no_manager' then center.ScienceDataManager=nil
    else center.ScienceDataManager={GetScienceById=function(_,id)
      assert(id==1,'unexpected adapter request');if active_response=='record' then return {} end;return nil
    end} end
    return {science_id='1'}
  end}
  local env={BaseClass=BaseClass,tonumber=tonumber,
    LocalController={instance=function() return owner end},TableName={LW_Hero_Level='level'},
    DataCenter=center,string={IsNullOrEmpty=function(v)return v==nil or v==''end}}
  local template=assert(load(template_source,'@reviewed-HeroLevelTemplate','t',env))()
  env.require=function(name) assert(name=='DataCenter.HeroData.HeroLevel.HeroLevelTemplate');return template end
  local manager=assert(load(manager_source,'@reviewed-HeroLevelTemplateManager','t',env))()
  local instance=manager.New()
  local function step(next_responses,reset)
    responses=next_responses
    if reset then instance=manager.New() end
    local maximum=instance:GetUnconditionalMaxLv()
    local reachable=instance:GetMaxReachableLevel()
    return maximum,reachable,instance.maxReachableLevel
  end
  local function get_template(key)
    local value=instance:GetTemplate(key);if value==nil then return nil end
    local city=value.city_exp_get
    local encoded=math.type(city)=='integer' and ('["i","'..string.format('%d',city)..'"]')
      or ('["f","'..hex(string.pack('<d',city))..'"]')
    return value.id,value.level,value.next_exp,value.coins,encoded,hex(value.tech_condition)
  end
  return step,get_template
end
'''


def reference_sources(repo):
    root = Path(repo).resolve()
    raws, evidence = [], []
    for path, expected in SOURCES.items():
        p = root/path
        need(not p.is_symlink() and p.resolve().is_relative_to(root), 'unsafe reference source')
        raw = p.read_bytes()
        blob = hashlib.sha1(b'blob '+str(len(raw)).encode()+b'\0'+raw).hexdigest()
        need(blob == expected, 'review required: level reference source changed: '+path)
        raws.append(raw)
        evidence.append({'path': path, 'git_blob': blob, 'sha256': sha256(raw)})
    return raws, evidence


def make_oracle(repo):
    from lupa.lua53 import LuaRuntime
    runtime = LuaRuntime(encoding=None, register_eval=False, register_builtins=False,
                         max_memory=64*1024*1024, unpack_returned_tuples=True)
    need(runtime.eval(b'_VERSION') == b'Lua 5.3', 'Lua 5.3 required')
    raws, evidence = reference_sources(repo)
    guard = runtime.execute(b'''return function(f) return function(...)
      local ticks=0;debug.sethook(function()ticks=ticks+1;if ticks>20000 then error('instruction budget')end end,'',1000)
      local r=table.pack(pcall(f,...));debug.sethook();assert(r[1],r[2]);return table.unpack(r,2,r.n)
    end end''')
    factory = guard(runtime.execute(LUA.encode()))
    def bind(records):
        validate_records(records)
        payload=[]
        for r in records:
            item={k.encode(): v for k,v in r.items() if k not in ('condition_hex','city_exp_get')}
            item[b'city_exp_get']=city_number(r['city_exp_get'])
            item[b'tech_condition']=bytes.fromhex(r['condition_hex'])
            payload.append(item)
        step, get_template = factory(*raws, runtime.table_from(payload, recursive=True))
        step, get_template = guard(step), guard(get_template)
        def run(values, reset=False):
            validate_responses(records, values)
            inp = runtime.table_from({k.encode():v.encode() for k,v in values.items()})
            return list(step(inp, reset))
        def lookup(key):
            result = get_template(key)
            if result is None: return None
            return {'key':key, **dict(zip(NUMBERS,result[:4])), 'city_exp_get':json.loads(result[4]), 'condition_hex':result[5].decode()}
        return run, lookup
    return bind, evidence


def scenario_set(records):
    conditions=sorted({r['condition_hex'] for r in records if r['condition_hex']})
    state=lambda value: {c:value for c in conditions}
    cases=[{'name':value, 'steps':[{'responses':state(value), 'reset':False}]} for value in RESPONSES]
    cases.append({'name':'cache-advance-withdraw-and-reset','steps':[
        {'responses':state(v),'reset':reset} for v,reset in [('no_record',False),('record',False),
        ('no_record',False),('no_record',True),('record',False),('missing_template',True),('no_record',False)]]})
    # Explicit mixed dependency outcomes across multiple gates; up to 6 unique
    # conditions keep exhaustive boundary coverage within a bounded test budget.
    for mask in range(1 << min(6,len(conditions))):
        cases.append({'name':'ownership-mask-'+str(mask),'steps':[{'reset':False,
            'responses':{c:('record' if mask & (1<<i) else 'no_record') for i,c in enumerate(conditions)}}]})
    return cases


def generated_records():
    def row(key, level=None, condition=''):
        return {'key':key,'id':key,'level':key if level is None else level,
                'next_exp':key*17,'coins':key*3,'city_exp_get':['i','0'],'condition_hex':condition.encode().hex()}
    return [
        ('empty', []),
        ('holes', [row(1),row(3,condition='A'),row(5,condition='B')]),
        ('missing-template-does-not-stop-later-unconditional', [row(1,condition='A'),row(2)]),
        ('key-and-authored-level-differ', [row(2,5),row(4,3,condition='A')]),
        ('multiple-research-gates', [row(1,condition='A'),row(2),row(3,condition='B'),row(4,condition='C')]),
        ('zero-authored-maximum', [row(1,0,condition='A')]),
        ('binary-condition', [row(1,condition='\x00\xff')]),
    ]


def trace_dataset(name, records, bind):
    results=[]
    for scenario in scenario_set(records):
        step, lookup = bind(records)
        # Exercise lazy lookup before InitAllTemplate, missing keys, repeated
        # lookup, and then the same records again after stateful cap evaluation.
        keys=[r['key'] for r in records]+[0,MAX_LEVEL+1]
        before=[{'key':k,'expected':lookup(k)} for k in keys]
        traces=[]
        for request in scenario['steps']:
            expected=step(request['responses'],request['reset'])
            traces.append({**request,'expected':expected})
        after=[{'key':k,'expected':lookup(k)} for k in keys]
        results.append({'name':scenario['name'],'before':before,'steps':traces,'after':after})
    return {'name':name,'records':records,'scenarios':results}


def build_report(repo, package, out):
    repo, package, out = Path(repo), Path(package), Path(out)
    need(not out.exists() and not out.is_symlink(), 'report destination already exists')
    verify(package)
    catalog=json.loads((package/'catalog.json').read_bytes())
    need(catalog['source_commit']==git(repo,'rev-parse','HEAD').decode().strip(), 'package commit differs from checkout')
    item=next((m for m in catalog['modules'] if m['name']=='lw_hero_level'),None)
    need(item is not None, 'lw_hero_level is required')
    raw_path=repo/item['source_path']
    need(not raw_path.is_symlink() and raw_path.resolve().is_relative_to(repo.resolve()),'unsafe data source')
    raw=raw_path.read_bytes()
    need(sha256(raw)==item['source_sha256'],'level data source differs from package')
    need(git(repo,'rev-parse','HEAD:'+item['source_path']).decode().strip()==item['source_blob_sha1'],'data source not committed')
    from lua_table_data import interpret
    doc=json.loads((package/'modules'/(item['sha256']+'.json')).read_bytes())
    need(interpret(raw)==doc,'level source graph mismatch')
    bind, references=make_oracle(repo)
    records=records_from_graph(doc)
    real=trace_dataset('committed-lw_hero_level',records,bind)
    generated=[trace_dataset(name,rows,bind) for name,rows in generated_records()]
    report={'format':'hero-level-source-oracle-v1','source_commit':catalog['source_commit'],
        'package_catalog_sha256':sha256((package/'catalog.json').read_bytes()),
        'reference_sources':references,'data_source':item,'real':real,'generated':generated,
        'research_dependency_mode':'injected method responses; not actual account research',
        'source_binary_equivalence_verified':False,'gameplay_port_complete':False}
    # Every expected cap and template result above comes from original Lua methods,
    # not a Python translation of the GDScript algorithm.
    out.mkdir(parents=True,exist_ok=False)
    (out/'hero-level-oracle.json').write_bytes(compact(report))
    summary={'source_commit':catalog['source_commit'],'real_records':len(records),
        'real_conditions':sorted({r['condition_hex'] for r in records if r['condition_hex']}),
        'real_scenarios':len(real['scenarios']),
        'real_steps':sum(len(s['steps']) for s in real['scenarios']),
        'generated_scenarios':sum(len(d['scenarios']) for d in generated),
        'default_scenarios':{s['name']:s['steps'][0]['expected'] for s in real['scenarios'][:4]},
        'reference_sources':references, 'gameplay_port_complete':False}
    (out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    return summary


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--repo',type=Path,default=Path('.'));p.add_argument('--package',type=Path,required=True)
    p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    try: print(json.dumps(build_report(a.repo,a.package,a.out),indent=2))
    except (DataError,OSError,ValueError,KeyError,ImportError,subprocess.CalledProcessError) as e:
        p.exit(2,'hero level verification blocked: '+str(e)+'\n')
if __name__=='__main__': main()
