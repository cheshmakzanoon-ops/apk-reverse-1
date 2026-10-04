"""Recovered LocalController accessor semantics, distinct from raw table storage.

The vExt indirection and Lua truth/default rules are derived from the pinned
client source. Raw graph bytes are never rewritten. This does not implement split
manifest loading, localization, server validation, or arbitrary game execution.
"""
from __future__ import annotations
import hashlib
from pathlib import Path
import struct
from lua_table_data import DataError, compact, decode, interpret, need

CONTRACT = 'local-controller-line-v1'
CONTROLLER = 'source-app/lua/src/Common/LocalController.lua'
CONTROLLER_BLOB = '76a1301f9868528333cc45b73cc46988b487f9d1'
RANK = 'source-app/lua/src/DataCenter/HeroData/HeroRankTemplate.lua'
RANK_BLOB = 'f34dd61e8b6e7c2592bc6662cd73b2cf6bf7e45a'


def truth(token):
    """Unlike Python/GDScript, zero and the empty string are true in Lua."""
    return token is not None and token != ['b', False]


def canonical_key(token):
    if token is None or token[0] == 't':
        return None
    if token[0] == 'f':
        value = struct.unpack('<d', bytes.fromhex(token[1]))[0]
        if -(1 << 63) <= value < (1 << 63) and value.is_integer():
            token = ['i', str(int(value))]
    return compact(token)


class Accessors:
    def __init__(self, document):
        decode(document)  # Validate canonical graph, scalar ranges and all refs.
        self.document = document
        self.tables = [{compact(k): v for k, v in row} for row in document['tables']]
        self.data = self.ref(self.lookup(0, ['s', b'data'.hex()]))
        self.index = self.ref(self.lookup(0, ['s', b'index'.hex()]))
        self.pool = self.ref(self.lookup(0, ['s', b'vExt'.hex()]))
        need(self.data is not None and self.index is not None, 'index/data tables required')
        need(self.lookup(0, ['s', b'link'.hex()]) is None, 'split-table routing is not supported by this package')
        pool_token = self.lookup(0, ['s', b'vExt'.hex()])
        need(not truth(pool_token) or self.pool is not None, 'vExt must be a table when truthy')

    @staticmethod
    def ref(token):
        return token[1] if token is not None and token[0] == 't' else None

    def lookup(self, table_id, key):
        return self.tables[table_id].get(canonical_key(key)) if table_id is not None else None

    def descriptor(self, name_hex):
        return self.ref(self.lookup(self.index, ['s', name_hex]))

    def raw(self, key, name_hex):
        descriptor = self.descriptor(name_hex)
        row = self.ref(self.lookup(self.data, key))
        slot = self.lookup(descriptor, ['i', '1'])
        return self.lookup(row, slot)

    def resolve(self, key, name_hex):
        value = self.raw(key, name_hex)
        descriptor = self.descriptor(name_hex)
        if truth(self.lookup(descriptor, ['i', '3'])) and truth(value) and self.pool is not None:
            return self.lookup(self.pool, value)
        return value

    def line(self, key, name_hex, default=None):
        """LineData:getValue: unknown fields and absent rows differ from string fields."""
        descriptor = self.descriptor(name_hex)
        row = self.ref(self.lookup(self.data, key))
        if descriptor is None or row is None:
            return default
        value = self.resolve(key, name_hex)
        if truth(value):
            return value
        if self.lookup(descriptor, ['i', '2']) == ['s', b'string'.hex()]:
            return default if truth(default) else ['s', '']
        return default

    def controller(self, key, name_hex, default=None):
        """LocalController:getValue has an empty-string fallback for every type."""
        value = self.resolve(key, name_hex)
        return value if truth(value) else (default if truth(default) else ['s', ''])

    def report(self, columns):
        h = hashlib.sha256()
        stats = dict(cells=0, linked_cells=0, changed_cells=0, dangling_links=0,
                     linked_without_pool=0, resolved_cell_sha256='')
        for key, _ in self.document['tables'][self.data]:
            for column in columns:
                name = column['name_hex']
                raw = self.raw(key, name)
                flag = self.lookup(self.descriptor(name), ['i', '3'])
                if truth(flag) and truth(raw):
                    if self.pool is None:
                        stats['linked_without_pool'] += 1
                    else:
                        stats['linked_cells'] += 1
                        stats['dangling_links'] += self.lookup(self.pool, raw) is None
                resolved = self.line(key, name)
                stats['cells'] += 1
                stats['changed_cells'] += raw != resolved
                h.update(compact(key) + b'\n' + name.encode() + b'\n' + compact(resolved) + b'\n')
        stats['resolved_cell_sha256'] = h.hexdigest()
        return stats


def reference_sources(repo):
    """Use only these reviewed source revisions, never an arbitrary Lua path."""
    repo = Path(repo).resolve()
    sources = []
    evidence = []
    for path, expected in [(CONTROLLER, CONTROLLER_BLOB), (RANK, RANK_BLOB)]:
        target = repo/path
        need(not target.is_symlink() and target.resolve().is_relative_to(repo), 'reference path escaped repository')
        raw = target.read_bytes()
        actual = hashlib.sha1(b'blob ' + str(len(raw)).encode() + b'\0' + raw).hexdigest()
        need(actual == expected, 'review required: reference source changed: ' + path)
        evidence.append({'path': path, 'git_blob': actual, 'sha256': hashlib.sha256(raw).hexdigest()})
        sources.append(raw)
    return sources, evidence


def section(source, start, end):
    need(source.count(start) == 1 and source.count(end) == 1, 'ambiguous reference method boundary')
    first, last = source.index(start), source.index(end)
    need(first < last, 'invalid reference method boundary')
    return source[first:last]


# Data chunks are accepted by the static parser before this function is called.
# Source excerpts below are byte-for-byte methods from hash-pinned LocalController.
# No filesystem, network, require, OS or Python objects enter the source environment.
LUA_ORACLE = r'''
local function hex(s) return (s:gsub('.',function(c) return string.format('%02x',string.byte(c)) end)) end
local function scalar(v)
  if v==nil then return 'null' end
  local t=type(v)
  if t=='boolean' then return '["b",'..tostring(v)..']' end
  if t=='string' then return '["s","'..hex(v)..'"]' end
  if t=='number' then
    if math.type(v)=='integer' then return '["i","'..string.format('%d',v)..'"]' end
    return '["f","'..hex(string.pack('<d',v))..'"]'
  end
  error('unsupported scalar '..t)
end
return function(data_source,factory_source,controller_source,rank_source)
  local root=assert(load(data_source,'@accepted-data','t',{}))()
  local ids={[root]=0};local queue={root};local at=1
  while at<=#queue do
    local sorted={}
    for k,v in pairs(queue[at]) do sorted[#sorted+1]={key=scalar(k),value=v} end
    table.sort(sorted,function(a,b)return a.key<b.key end)
    for _,pair in ipairs(sorted) do
      local v=pair.value
      if type(v)=='table' and ids[v]==nil then ids[v]=#queue;queue[#queue+1]=v end
    end
    at=at+1
  end
  local env={LocalController={},setmetatable=setmetatable,BaseClass=function() return {} end,
    tostring=tostring,math={floor=math.floor},string={format=string.format}}
  assert(load(factory_source,'@LocalController.createLineData','t',env))()
  assert(load(controller_source,'@LocalController.getValue','t',env))()
  local owner=setmetatable({mtDataLine={},xmlValue={module=root}},{__index=env.LocalController})
  function owner:getTable(_) return root end
  function owner:fixXmlType(x) return x end
  function owner:getLineInternal(_,key) return root.data[key] end
  local rank_class=assert(load(rank_source,'@HeroRankTemplate','t',env))()
  local function encode(v)
    if type(v)=='table' then assert(ids[v]~=nil,'unknown oracle table');return '["t",'..ids[v]..']' end
    return scalar(v)
  end
  local function line(key)
    local row=owner:createLineData('module',key);row._lineData=root.data[key];return row
  end
  local function query(key,field,default,controller)
    if controller then return encode(owner:getValue('module',key,field,default)) end
    return encode(line(key):getValue(field,default))
  end
  local function rank(key,effect)
    local obj={};rank_class.__init(obj);rank_class.InitData(obj,line(key))
    local a,b=rank_class.GetStarCount(obj)
    return '['..encode(a)..','..encode(b)..','..encode(rank_class.GetEffectAdd(obj,effect,false))..','..
      encode(rank_class.GetEffectAdd(obj,effect,true))..','..encode(rank_class.GetAddEffect(obj,effect))..','..
      encode(rank_class.GetEffectRatio(obj))..']'
  end
  return query,rank
end
'''


def make_oracle(repo):
    from lupa.lua53 import LuaRuntime
    runtime = LuaRuntime(encoding=None, register_eval=False, register_builtins=False,
                         max_memory=256*1024*1024, unpack_returned_tuples=True)
    need(runtime.eval(b'_VERSION') == b'Lua 5.3', 'Lua 5.3 required')
    sources, evidence = reference_sources(repo)
    factory = section(sources[0], b'function LocalController:createLineData(', b'local VisitNoRelease =')
    controller = section(sources[0], b'function LocalController:getValue(', b'function LocalController:getIntValue(')
    # The trusted wrapper keeps hooks outside the source environment. Both source
    # loading and each call are bounded, including a regression introduced upstream.
    guard = runtime.execute(b'''return function(f) return function(...)
      local ticks=0; debug.sethook(function() ticks=ticks+1; if ticks>10000 then error('instruction budget') end end,'',1000)
      local result=table.pack(pcall(f,...));debug.sethook();assert(result[1],result[2]);return table.unpack(result,2,result.n)
    end end''')
    builder = guard(runtime.execute(LUA_ORACLE.encode()))
    def bind(raw):
        interpret(raw)  # Enforce the data-only language before any Lua execution.
        raw = raw[3:] if raw.startswith(b'\xef\xbb\xbf') else raw
        query, rank = builder(raw, factory, controller, sources[1])
        return guard(query), guard(rank)
    return bind, evidence
