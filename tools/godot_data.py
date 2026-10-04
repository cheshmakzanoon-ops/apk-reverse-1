#!/usr/bin/env python3
"""Convert tracked client configuration tables to a typed, hash-linked Godot package.

The default profile contains 16 real client modules; it is not whole-game recovery.
Only statically accepted data statements can reach the optional Lua 5.3 oracle.
"""
from __future__ import annotations
import argparse
from client_semantics import Accessors, CONTRACT
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
from lua_table_data import DataError, Table, compact, decode, get, interpret, need

PROFILE = ('APS_global', 'APS_arms', 'APS_hero_color', 'aps_hero_levelup',
           'aps_heroes_quality', 'aps_heroes_rank', 'aps_heroes_rankLv',
           'lw_hero', 'lw_hero_level', 'lw_hero_rank', 'lw_hero_para',
           'lw_hero_tag', 'lw_opening_hero', 'lw_hero_unlock_skill',
           'lw_battleskill', 'skill')
SCOPE = 'source-app/data-tables-lua'

# This encoder is independent of the Python parser/serializer. The empty script
# environment has no libraries, require, OS, Python, or filesystem capabilities.
ORACLE = r'''
local function hex(s) return (s:gsub('.', function(c) return string.format('%02x', string.byte(c)) end)) end
local function scalar(v)
  local t=type(v)
  if t=='string' then return '["s","'..hex(v)..'"]' end
  if t=='boolean' then return '["b",'..tostring(v)..']' end
  if t=='number' then
    if math.type(v)=='integer' then return '["i","'..string.format('%d',v)..'"]' end
    return '["f","'..hex(string.pack('<d',v))..'"]'
  end
  error('unsupported oracle scalar '..t)
end
return function(source)
  local f,err=load(source, '@recovered-data', 't', {})
  assert(f,err)
  local ticks=0
  debug.sethook(function() ticks=ticks+1; if ticks>5000 then error('instruction budget') end end,'',1000)
  local ok,root=pcall(f)
  debug.sethook()
  assert(ok,root); assert(type(root)=='table')
  local ids={[root]=0}; local queue={root}; local encoded={}; local at=1
  while at<=#queue do
    local sorted={}
    for k,v in pairs(queue[at]) do sorted[#sorted+1]={key=scalar(k),value=v} end
    table.sort(sorted,function(a,b) return a.key<b.key end)
    local entries={}
    for _,pair in ipairs(sorted) do
      local v=pair.value; local text
      if type(v)=='table' then
        if ids[v]==nil then ids[v]=#queue; queue[#queue+1]=v end
        text='["t",'..ids[v]..']'
      else text=scalar(v) end
      entries[#entries+1]='['..pair.key..','..text..']'
    end
    encoded[#encoded+1]='['..table.concat(entries,',')..']'; at=at+1
  end
  return '{"format":"lua-table-graph-v1","root":0,"tables":['..table.concat(encoded,',')..']}'
end
'''


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def git(repo, *args):
    return subprocess.check_output(['git', '-C', str(repo), *args])


def tracked(repo):
    result = {}
    for record in git(repo, 'ls-tree', '-rz', 'HEAD', '--', SCOPE).split(b'\0'):
        if not record: continue
        meta, path = record.split(b'\t', 1)
        mode, kind, sha = meta.decode().split()
        path = path.decode('utf-8')
        if path.endswith('.lua'):
            need(mode == '100644' and kind == 'blob', 'nonregular tracked source: ' + path)
            result[path] = sha
    need(result, 'no committed Lua data tables in HEAD')
    return result


def columns_and_rows(document):
    root = decode(document)
    index, data = get(root, b'index'), get(root, b'data')
    need(isinstance(index, Table) and isinstance(data, Table), 'module requires index/data tables')
    columns = []; positions = set()
    for (_, name), desc in index.entries.items():
        need(type(name) is bytes and isinstance(desc, Table), 'invalid column metadata')
        slot, datatype = get(desc, 1), get(desc, 2)
        need(type(slot) is int and slot > 0 and slot not in positions and type(datatype) is bytes, 'invalid/duplicate column slot')
        positions.add(slot)
        columns.append({'name_hex': name.hex(), 'slot': slot, 'declared_type_hex': datatype.hex()})
    columns.sort(key=lambda c: c['slot'])
    for (_, rowkey), row in data.entries.items():
        need(type(rowkey) in (bytes, int, float, bool) and isinstance(row, Table), 'record is not a table')
    return columns, len(data.entries)



def cell_digest(document, columns):
    tables = [{compact(k): v for k, v in entries} for entries in document['tables']]
    data_id = tables[0][compact(['s', b'data'.hex()])][1]
    h = hashlib.sha256()
    for record_key, record in tables[data_id].items():
        row = tables[record[1]]
        for column in columns:
            token = row.get(compact(['i', str(column['slot'])]))
            h.update(record_key+b'\n'+column['name_hex'].encode()+b'\n'+compact(token)+b'\n')
    return h.hexdigest()


def build(repo, out, names=None, lua53=False):
    repo, out = Path(repo).resolve(), Path(out)
    need(not out.exists() and not out.is_symlink(), 'output exists; use a new package directory')
    inventory = tracked(repo)
    selected = list(PROFILE if names is None else names)
    need(selected and len(selected) == len(set(selected)), 'empty/duplicate module selection')
    need(all(re.fullmatch(r'[A-Za-z_0-9-]+', n) for n in selected), 'invalid module name')
    commit = git(repo, 'rev-parse', 'HEAD').decode().strip()
    tree = git(repo, 'rev-parse', 'HEAD:'+SCOPE).decode().strip()
    oracle = None
    if lua53:
        from lupa.lua53 import LuaRuntime
        runtime = LuaRuntime(encoding=None, register_eval=False, register_builtins=False, max_memory=256*1024*1024)
        need(runtime.eval(b'_VERSION') == b'Lua 5.3', 'wrong Lua runtime')
        oracle = runtime.execute(ORACLE.encode('ascii'))
    records = []
    out.parent.mkdir(parents=True, exist_ok=True)
    staging = Path(tempfile.mkdtemp(prefix='.data-', dir=out.parent))
    try:
        (staging/'modules').mkdir()
        for name in selected:
            path = SCOPE+'/'+name+'.lua'
            need(path in inventory, 'selected module not committed: ' + path)
            source = repo/path
            need(not source.is_symlink() and source.resolve().is_relative_to(repo/SCOPE), 'source escapes scope')
            need(0 < source.stat().st_size <= 64*1024*1024, 'source byte budget exceeded')
            raw = source.read_bytes()
            blob = hashlib.sha1(b'blob '+str(len(raw)).encode()+b'\0'+raw).hexdigest()
            need(blob == inventory[path], 'source differs from HEAD: ' + path)
            try:
                graph = interpret(raw)
                columns, count = columns_and_rows(graph)
                encoded = compact(graph)
                if oracle is not None:
                    source_for_lua = raw[3:] if raw.startswith(b'\xef\xbb\xbf') else raw
                    need(oracle(source_for_lua) == encoded, 'Lua 5.3 semantic comparison failed')
            except (DataError, RuntimeError) as exc:
                raise DataError(name+': '+str(exc)) from exc
            digest = sha256(encoded)
            dest = staging/'modules'/(digest+'.json')
            if not dest.exists(): dest.write_bytes(encoded)
            records.append({'name': name, 'source_path': path, 'source_blob_sha1': blob,
                'source_sha256': sha256(raw), 'source_bytes': len(raw), 'sha256': digest,
                'bytes': len(encoded), 'table_count': len(graph['tables']), 'row_count': count,
                'entry_count': sum(len(t) for t in graph['tables']), 'columns': columns,
                'cell_sha256': cell_digest(graph, columns),
                'lua53_equal': oracle is not None, 'runtime_access': Accessors(graph).report(columns)})
            print(name+': '+str(count)+' records; '+str(len(encoded))+' bytes', flush=True)
        catalog = {'format': 'recovered-client-data-v2', 'accessor_contract': CONTRACT, 'state': 'ready', 'source_commit': commit,
            'source_tree': tree, 'tracked_lua_tables': len(inventory), 'selected_modules': len(records),
            'unselected_modules': len(inventory)-len(records), 'rows': sum(r['row_count'] for r in records),
            'modules': records, 'apk_verified': False, 'gameplay_port_complete': False,
            'scope': 'selected committed decompiled client tables, not the original APK'}
        (staging/'catalog.json').write_bytes(compact(catalog))
        need(not out.exists(), 'output appeared during conversion')
        staging.rename(out)
        return catalog
    finally:
        if staging.exists(): shutil.rmtree(staging)


def verify(root):
    root = Path(root)
    catalog = json.loads((root/'catalog.json').read_bytes())
    need(catalog.get('format') == 'recovered-client-data-v2' and catalog.get('accessor_contract') == CONTRACT and catalog.get('state') == 'ready', 'package not ready')
    modules = catalog.get('modules')
    need(type(modules) is list and modules and len(modules) == catalog['selected_modules'], 'module coverage mismatch')
    names = set(); files = {'catalog.json'}; rows = 0
    for module in modules:
        name = module['name']; sha = module['sha256']
        need(name not in names and re.fullmatch('[a-f0-9]{64}', sha), 'invalid/duplicate module identity')
        names.add(name); relative = 'modules/'+sha+'.json'; files.add(relative)
        file = root/relative
        need(not file.is_symlink(), 'symlink package file')
        raw = file.read_bytes()
        need(len(raw) == module['bytes'] and sha256(raw) == sha, 'module hash/size mismatch')
        doc = json.loads(raw); columns, count = columns_and_rows(doc)
        need(compact(doc) == raw and columns == module['columns'] and count == module['row_count'], 'module metadata mismatch')
        need(cell_digest(doc, columns) == module['cell_sha256'], 'raw cell digest mismatch')
        need(Accessors(doc).report(columns) == module.get('runtime_access'), 'runtime accessor metadata mismatch')
        need(len(doc['tables']) == module['table_count'] and sum(map(len, doc['tables'])) == module['entry_count'], 'graph counts mismatch')
        rows += count
    need(rows == catalog['rows'], 'row coverage mismatch')
    need({str(p.relative_to(root)) for p in root.rglob('*') if p.is_file()} == files, 'unexpected or missing package files')
    return {'state': 'verified', 'modules': len(modules), 'rows': rows,
            'catalog_sha256': sha256((root/'catalog.json').read_bytes()), 'source_commit': catalog['source_commit']}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('command', choices=['build', 'verify'])
    p.add_argument('--repo', type=Path, default=Path('.'))
    p.add_argument('--out', type=Path, required=True)
    p.add_argument('--name', action='append')
    p.add_argument('--lua53', action='store_true')
    a = p.parse_args()
    try:
        if a.command == 'build': build(a.repo, a.out, a.name, a.lua53)
        print(json.dumps(verify(a.out), indent=2))
    except (DataError, OSError, ValueError, KeyError, ImportError, subprocess.CalledProcessError) as exc:
        p.exit(2, 'client data blocked: '+str(exc)+'\n')


if __name__ == '__main__': main()
