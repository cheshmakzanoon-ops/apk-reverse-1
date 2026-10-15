#!/usr/bin/env python3
"""Generate source-derived traces of the stage-six opening encounter.

The hash-pinned recovered Lua that drives the encounter (ShowInTroubledFellow, the real
utils update loop, the event dealer's respawn handler, SoloHero, ZakuZombie, the FSM base
class and all seven state scripts) runs unmodified in a bounded Lua 5.3 sandbox. Only the
Unity engine surface is replaced by small stubs defined in HARNESS below: resource loading,
transforms, animators, the timer service and the SoloHeroTurret component (reimplemented
from the recovered C#). Randomness comes from a scripted sequence so a run is reproducible.

This validates the GDScript port against recovered source under stated engine assumptions.
It is not an execution of the shipped game binary, and the turret/muzzle placement used here
is a fixture, not data read from the SoloHero prefab.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import random
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import lua_table_data as ltd  # noqa: E402

LUA_ROOT = 'source-app/lua/src/'
STAGE_TABLE = 'source-app/data-tables-lua/lw_opening_stage.lua'
STAGE_TABLE_BLOB = None  # filled from PINNED_TABLES below
PINNED = {
    'Framework/Common/BaseClassOri.lua': 'a5b299cdb6bff0a4b92e7c4b00c0206f74630a2a',
    'Common/FSMachine.lua': '7020cb3898078da49f59875de1272fd26913080e',
    'Common/StringUtil.lua': 'e04cee64ae2a204d2155b3108aefaa4e664d53d5',
    'DataCenter/LWOpeningStageManager/LWOpeningStageSoloHero.lua': 'b481de95b6eebe2d3a7f506e8119198aa210d3c5',
    'DataCenter/LWOpeningStageManager/LWOpeningStageZakuZombie.lua': '005423ad737e9abd4cbdfa7d6e9cd8f2c8335a80',
    'DataCenter/LWOpeningStageManager/LWOpeningStageUtils.lua': '1e30b6afe515459e489055625775b79ed8e2e910',
    'DataCenter/LWOpeningStageManager/LWOpeningStageEventDealer.lua': '9310f56b884400b2db7c98d30218395f0ee0df68',
    'DataCenter/LWOpeningStageManager/LWOpeningStageDirtyWorks.lua': '29d91dd296a51e96feeaed10be9f5b2c604318d2',
    'DataCenter/LWOpeningStageManager/SoloHeroStates/SoloHeroStateIdle.lua': 'ae68d5357150a7a721c8ff55920d8ac6a41de3f0',
    'DataCenter/LWOpeningStageManager/SoloHeroStates/SoloHeroStateAim.lua': '6d6575c4f08fdb636af49e99ac5c46ba6e1d17d3',
    'DataCenter/LWOpeningStageManager/SoloHeroStates/SoloHeroStateFire.lua': '535f7ba7e0614be8d06bae7d1880e16ca4b8a9d9',
    'DataCenter/LWOpeningStageManager/SoloHeroStates/SoloHeroStateReload.lua': '57db09b5dae75795d2c6ca21c4e147f85e6e17ea',
    'DataCenter/LWOpeningStageManager/ZakuZombieStates/ZakuZombieStateBorn.lua': '0af3d937fd58eca32296bfcc1b2f0b3a6eac000d',
    'DataCenter/LWOpeningStageManager/ZakuZombieStates/ZakuZombieStateWalk.lua': '5c69575f2c0bae6ef61a753ef8cb72ca1b58f2ec',
    'DataCenter/LWOpeningStageManager/ZakuZombieStates/ZakuZombieStateAttack.lua': 'e58ae96ab9cba0c841b9fe6184c82857e409f7eb',
}
PINNED_TABLES = {STAGE_TABLE: None}
SOLO_HERO_STAGE_ID = 6
RNG_RANGE = 1 << 30
INSTRUCTION_BUDGET = 400_000_000

# A scenario is data only. Turret and muzzle placement are FIXTURES: the shipped values live in
# the SoloHero prefab hierarchy and are supplied by the scene builder, not assumed here.
FIXTURE_HERO = {'turret_pos': [98.0, 1.0, 104.0], 'muzzle_local': [0.0, 0.25, 1.1], 'rotate_speed': 30.0}
SCENARIOS = [
    dict(name='baseline_64fps', fps=64, seconds=45, hero_load_delay=0.0, zaku_load_delay=0.0,
         vfx_load_delay=0.0, seed=1, turret_yaw=0.0),
    dict(name='load_latency_32fps', fps=32, seconds=60, hero_load_delay=0.3, zaku_load_delay=0.15,
         vfx_load_delay=0.06, seed=2, turret_yaw=0.0),
    dict(name='turret_faces_away_128fps', fps=128, seconds=40, hero_load_delay=0.0, zaku_load_delay=0.0,
         vfx_load_delay=0.0, seed=3, turret_yaw=170.0),
    dict(name='turret_negative_start_64fps', fps=64, seconds=40, hero_load_delay=0.1, zaku_load_delay=0.0,
         vfx_load_delay=0.03, seed=4, turret_yaw=-120.0),
    dict(name='long_soak_64fps', fps=64, seconds=150, hero_load_delay=0.0, zaku_load_delay=0.0,
         vfx_load_delay=0.0, seed=5, turret_yaw=0.0),
]

HARNESS = r'''
local lua_load, lua_debug = load, debug
local std_math, std_string, std_table = math, string, table

local function copy(t) local c = {} for k, v in pairs(t) do c[k] = v end return c end

return function(sources, sc)
  local trace, errors = {}, {}
  local now, draws, kills = 0.0, 0, 0
  local running = false
  local touches = {}

  local function rec(ev, fields)
    local e = {t = now, ev = ev}
    for k, v in pairs(fields or {}) do e[k] = v end
    trace[#trace + 1] = e
  end

  -- Any global or field the recovered chunks reach that this harness does not define resolves to
  -- an inert "ghost". Touches during the run are reported so nothing can hide behind one.
  local ghost_cache = {}
  local function ghost(path)
    local g = ghost_cache[path]
    if g then return g end
    g = {}
    ghost_cache[path] = g
    local function touch(name) if running then touches[name] = (touches[name] or 0) + 1 end end
    setmetatable(g, {
      __index = function(_, k) local p = path .. "." .. tostring(k); touch(p); return ghost(p) end,
      __call = function() touch(path .. "()"); return ghost(path .. "()") end,
      __add = function() return ghost(path) end, __sub = function() return ghost(path) end,
      __mul = function() return ghost(path) end, __div = function() return ghost(path) end,
      __unm = function() return ghost(path) end, __concat = function() return path end,
      __len = function() return 0 end, __lt = function() return false end, __le = function() return false end,
      __tostring = function() return "<ghost " .. path .. ">" end,
    })
    return g
  end

  -- Scripted time, timers and randomness ----------------------------------------------------
  local timers, timer_seq = {}, 0
  local timer_ctl = {Stop = function(self) self.stopped = true end}
  local function schedule(delay, fn)
    timer_seq = timer_seq + 1
    local t = setmetatable({due = now + delay, seq = timer_seq, fn = fn}, {__index = timer_ctl})
    timers[#timers + 1] = t
    return t
  end
  local function run_due()
    while true do
      local best
      for i, t in ipairs(timers) do
        if t.due <= now and (best == nil or t.due < timers[best].due
            or (t.due == timers[best].due and t.seq < timers[best].seq)) then best = i end
      end
      if not best then return end
      local t = table.remove(timers, best)
      if not t.stopped then t.fn() end
    end
  end

  local base = {}
  for _, name in ipairs({"pairs", "ipairs", "next", "select", "type", "tostring", "tonumber", "error",
      "assert", "pcall", "xpcall", "setmetatable", "getmetatable", "rawget", "rawset", "rawequal", "rawlen"}) do
    base[name] = _G[name]
  end
  base.unpack = std_table.unpack
  base.string, base.table, base.math = copy(std_string), copy(std_table), copy(std_math)
  base.math.random = function(...)
    assert(select("#", ...) == 0, "only math.random() is supported")
    draws = draws + 1
    local k = sc.rng[draws]
    assert(k ~= nil, "scripted random sequence exhausted")
    return k / 1073741824.0
  end

  -- Engine value types ------------------------------------------------------------------------
  local V3 = {}
  V3.__index = V3
  local function vec(x, y, z) return setmetatable({x = x, y = y, z = z}, V3) end
  V3.__add = function(a, b) return vec(a.x + b.x, a.y + b.y, a.z + b.z) end
  V3.__sub = function(a, b) return vec(a.x - b.x, a.y - b.y, a.z - b.z) end
  V3.__mul = function(a, b)
    if type(a) == "number" then return vec(a * b.x, a * b.y, a * b.z) end
    return vec(a.x * b, a.y * b, a.z * b)
  end
  base.Vector3 = setmetatable({New = vec, zero = vec(0, 0, 0), one = vec(1, 1, 1)},
    {__call = function(_, x, y, z) return vec(x, y, z) end})
  base.Quaternion = {Euler = function(x, y, z) return {yaw = y} end, identity = {yaw = 0}}
  local function forward_of(yaw) local r = yaw * math.pi / 180; return vec(math.sin(r), 0.0, math.cos(r)) end

  local function new_transform(on_set)
    local data = {position = vec(0, 0, 0), rotation = {yaw = 0}, localScale = vec(1, 1, 1)}
    return setmetatable({}, {
      __index = function(_, k) if k == "forward" then return forward_of(data.rotation.yaw) end return data[k] end,
      __newindex = function(_, k, v) data[k] = v; if on_set then on_set(k, v) end end,
    })
  end

  local function arr(v) return {v.x, v.y, v.z} end
  local who_of = setmetatable({}, {__mode = "k"})
  local serial_of = setmetatable({}, {__mode = "k"})
  local constructing, zserial = nil, 0
  local hero_obj, hero_turret
  local latest_by_id = {}

  local function new_animator(who)
    return {
      Play = function(_, clip) rec("anim", {who = who, call = "Play", arg = clip}) end,
      SetBool = function(_, key, val) rec("anim", {who = who, call = "SetBool", arg = key, val = val}) end,
      SetTrigger = function(_, key) rec("anim", {who = who, call = "SetTrigger", arg = key}) end,
    }
  end

  -- SoloHeroTurret reimplemented from the recovered C# component.
  local function new_turret()
    local h = sc.hero
    local t = {pos = vec(h.turret_pos[1], h.turret_pos[2], h.turret_pos[3]), yaw = h.turret_yaw,
               rotateSpeed = h.rotate_speed, target = nil, OnComplete = nil}
    function t.Update(self, dt)
      if self.target == nil then return end
      local tp = self.target.position
      local vx, vz = tp.x - self.pos.x, tp.z - self.pos.z
      local len = math.sqrt(vx * vx + vz * vz)
      if len > 1e-5 then vx, vz = vx / len, vz / len else vx, vz = 0.0, 0.0 end
      local f = forward_of(self.yaw)
      if vx * f.x + vz * f.z > 0.999 then
        if self.OnComplete then self.OnComplete() end
        self.target = nil
      else
        local turn_positive = (f.z * vx - f.x * vz) > 0
        self.yaw = self.yaw + self.rotateSpeed * dt * (turn_positive and 1 or -1)
      end
    end
    return t
  end

  local function new_muzzle(turret)
    local h = sc.hero
    local ml = h.muzzle_local
    local tf = setmetatable({}, {__index = function(_, k)
      local r = turret.yaw * math.pi / 180
      local c, s = math.cos(r), math.sin(r)
      if k == "position" then
        local rx, ry, rz = ml[1] * c + ml[3] * s, ml[2], -ml[1] * s + ml[3] * c
        return vec(turret.pos.x + rx, turret.pos.y + ry, turret.pos.z + rz)
      elseif k == "forward" then
        return forward_of(turret.yaw)
      end
    end})
    return {transform = tf}
  end

  local function classify(path)
    if path:find("SoloHero.prefab", 1, true) then return "hero" end
    if path:find("ZakuB.prefab", 1, true) or path:find("ZakuC.prefab", 1, true) then return "zaku" end
    if path:find("qiangkou", 1, true) then return "muzzle" end
    if path:find("Eff_shiti_boom", 1, true) then return "blood" end
    return "other"
  end
  local LOAD_DELAY = {hero = sc.hero_load_delay, zaku = sc.zaku_load_delay,
                      muzzle = sc.vfx_load_delay, blood = sc.vfx_load_delay}

  local function make_go(kind)
    local go = {}
    local who = constructing
    if kind == "hero" then
      local turret = new_turret()
      local muzzle = new_muzzle(turret)
      local anim = new_animator("hero")
      hero_turret = turret
      go.transform = new_transform()
      go.GetComponentInChildren = function(_, typ)
        if typ == base.CS.SimpleAnimation then return anim end
        if typ == base.CS.SoloHeroTurret then return turret end
        if typ == base.CS.SoloHeroMuzzle then return muzzle end
      end
    elseif kind == "zaku" then
      local anim = new_animator(who)
      go.transform = new_transform()
      go.GetComponentInChildren = function(_, typ)
        if typ == base.CS.UnityEngine.Animator then return anim end
      end
    elseif kind == "muzzle" or kind == "blood" then
      local tf
      tf = new_transform(function(k, v)
        if k == "localScale" then rec("vfx", {kind = kind, pos = arr(tf.position), scale = v.x}) end
      end)
      go.transform = tf
    else
      go.transform = new_transform()
    end
    return go
  end

  local resource = {}
  function resource.InstantiateAsync(_, path)
    local kind = classify(path)
    local handle = {isError = false, gameObject = make_go(kind)}
    function handle.Destroy(self) self.destroyed = true end
    function handle.completed(self, _, cb) schedule(LOAD_DELAY[kind] or 0.0, function() cb(self) end) end
    return handle
  end
  base.CS = setmetatable({
    GameEntry = {Resource = resource},
    SimpleAnimation = {}, SoloHeroTurret = {}, SoloHeroMuzzle = {},
    UnityEngine = setmetatable({Animator = {}}, {__index = function(_, k) return ghost("CS.UnityEngine." .. k) end}),
  }, {__index = function(_, k) return ghost("CS." .. tostring(k)) end})
  base.typeof = function(x) return x end
  base.IsNull = function(x) return x == nil or (type(x) == "table" and rawget(x, "destroyed") == true) end
  base.Logger = {LogError = function(m) errors[#errors + 1] = tostring(m) end, LogInfo = function() end,
                 LogWarning = function() end, Log = function() end}
  base.Time = {deltaTime = 0.0}
  base.EventId = setmetatable({}, {__index = function(_, k) return k end})

  -- Timers and the event bus; instrumentation only observes, it never changes behaviour. -------
  base.TimerManager = {
    GetInstance = function(self) return self end,
    DelayInvoke = function(_, fn, delay) return schedule(delay, fn) end,
  }

  local listeners = {}
  local bus = {}
  bus.GetInstance = function() return bus end
  bus.AddListener = function(_, name, cb)
    listeners[name] = listeners[name] or {}
    table.insert(listeners[name], cb)
  end
  bus.RemoveListener = function(_, name, cb)
    local list = listeners[name]
    if not list then return end
    for i, f in ipairs(list) do if f == cb then table.remove(list, i); return end end
  end
  bus.Broadcast = function(_, name, ...)
    local arg = ...
    if name == "OpeningStageZakuZombieInited" then
      rec("inited", {z = serial_of[arg], id = arg.config.id})
    elseif name == "OpeningStageZakuZombieDestroyed" then
      kills = kills + 1
      rec("destroyed", {z = serial_of[arg], id = arg.config.id})
    end
    local list = listeners[name]
    if not list then return end
    local snapshot = {}
    for i, f in ipairs(list) do snapshot[i] = f end
    for _, f in ipairs(snapshot) do f(...) end
  end
  base.EventManager = bus

  local env = setmetatable({}, {__index = function(_, k)
    local v = base[k]
    if v ~= nil then return v end
    if running then touches[tostring(k)] = (touches[tostring(k)] or 0) + 1 end
    return ghost(tostring(k))
  end})
  base._G = env
  base.DataCenter = setmetatable({}, {__index = function(_, k) return ghost("DataCenter." .. tostring(k)) end})

  -- Module loading: pinned sources only; anything else is a ghost module. ----------------------
  local loaded = {["Framework.UI.Message.EventManager"] = bus}
  local function require_module(name)
    if loaded[name] ~= nil then return loaded[name] end
    local src = sources[name]
    if src == nil then loaded[name] = ghost("require(" .. name .. ")"); return loaded[name] end
    local chunk, err = lua_load(src, "=" .. name, "t", env)
    assert(chunk, err)
    local result = chunk()
    if result == nil then result = true end
    loaded[name] = result
    return result
  end
  base.require = require_module

  lua_debug.sethook(function() error("instruction budget exceeded") end, "", sc.instruction_budget)

  require_module("Framework.Common.BaseClassOri")
  require_module("Common.StringUtil")
  local FSM = require_module("Common.FSMachine")
  local orig_switch = FSM.Switch
  FSM.Switch = function(self, name, ...)
    local before = self.currStateName
    orig_switch(self, name, ...)
    if self.currStateName ~= before then
      rec("fsm", {who = who_of[self.owner], state = self.currStateName})
    end
  end

  local Hero = require_module("DataCenter.LWOpeningStageManager.LWOpeningStageSoloHero")
  local Zaku = require_module("DataCenter.LWOpeningStageManager.LWOpeningStageZakuZombie")
  local orig_hero_new, orig_zaku_new = Hero.New, Zaku.New
  Hero.New = function(config)
    constructing = "hero"
    local obj = orig_hero_new(config)
    who_of[obj] = "hero"; hero_obj = obj
    return obj
  end
  Zaku.New = function(config)
    zserial = zserial + 1
    local who, serial = "z" .. zserial, zserial
    constructing = who
    rec("spawn", {z = serial, id = config.id, kind = config.model:match("(Zaku%a)%.prefab")})
    local obj = orig_zaku_new(config)
    who_of[obj] = who; serial_of[obj] = serial
    latest_by_id[config.id] = obj
    return obj
  end
  local utils = require_module("DataCenter.LWOpeningStageManager.LWOpeningStageUtils")
  local dealer = require_module("DataCenter.LWOpeningStageManager.LWOpeningStageEventDealer")
  local dirty = require_module("DataCenter.LWOpeningStageManager.LWOpeningStageDirtyWorks")

  base.DataCenter.LWOpeningStageManager = {utils = utils, openStages = {sc.stage}}

  running = true
  dealer:Setup()
  dirty:ShowInTroubledFellow()

  local dt = 1.0 / sc.fps
  local per_frame_draws, ambiguous = 0, {}
  for _ = 1, sc.steps do
    now = now + dt
    base.Time.deltaTime = dt
    run_due()
    local before = draws
    utils.OnUpdate()
    if draws - before > 1 then ambiguous[#ambiguous + 1] = now end
    if hero_turret then hero_turret:Update(dt) end
  end

  lua_debug.sethook()
  running = false

  local zombies = {}
  for id, obj in pairs(latest_by_id) do
    local transform = obj.transform
    zombies[tostring(serial_of[obj])] = {
      id = id,
      pos = transform and arr(transform.position) or {},
      state = obj.fsm and obj.fsm.currStateName or "",
    }
  end
  local targets = {}
  if hero_obj then for i, z in ipairs(hero_obj.targets) do targets[i] = serial_of[z] end end
  local final = {
    t = now, kills = kills, rng_draws = draws,
    hero_state = hero_obj and hero_obj.fsm and hero_obj.fsm.currStateName or "",
    turret_yaw = hero_turret and hero_turret.yaw or 0.0,
    targets = targets, zombies = zombies,
  }
  return {trace = trace, errors = errors, touches = touches, final = final, ambiguous_frames = ambiguous}
end
'''


def blob_id(data: bytes) -> str:
    return hashlib.sha1(b'blob %d\0' % len(data) + data).hexdigest()


def load_sources(repo: Path) -> dict:
    sources = {}
    for rel, expected in PINNED.items():
        data = (repo / LUA_ROOT / rel).read_bytes()
        if blob_id(data) != expected:
            raise SystemExit(f'pinned source changed: {rel}')
        try:
            text = data.decode('ascii')
        except UnicodeDecodeError as exc:
            raise SystemExit(f'non-ASCII source is not supported: {rel}') from exc
        sources[rel[:-4].replace('/', '.')] = text
    return sources


def stage_row(repo: Path) -> dict:
    data = (repo / STAGE_TABLE).read_bytes()
    root = ltd.decode(ltd.interpret(data))

    def plain(value):
        if isinstance(value, ltd.Table):
            return {(k[1].decode() if isinstance(k[1], bytes) else k[1]): plain(v) for k, v in value.entries.items()}
        return value.decode() if isinstance(value, bytes) else value

    table = plain(root)
    columns = {spec[1]: name for name, spec in table['index'].items()}
    row = table['data'][SOLO_HERO_STAGE_ID]
    resolved = {}
    for column, value in row.items():
        name = columns[column]
        spec = table['index'][name]
        resolved[name] = table['vExt'][value] if spec.get(3) else value
    if resolved['id'] != SOLO_HERO_STAGE_ID or not resolved.get('nodes'):
        raise SystemExit('unexpected opening-stage row')
    return {'id': resolved['id'], 'nodes': [resolved['nodes'][i] for i in sorted(resolved['nodes'])]}


def to_lua(lua, value):
    if isinstance(value, dict):
        return lua.table_from({k: to_lua(lua, v) for k, v in value.items()})
    if isinstance(value, (list, tuple)):
        return lua.table_from([to_lua(lua, v) for v in value])
    return value


def from_lua(value):
    if hasattr(value, 'items') and hasattr(value, 'keys'):
        keys = list(value.keys())
        if keys and all(isinstance(k, int) for k in keys) and sorted(keys) == list(range(1, len(keys) + 1)):
            return [from_lua(value[k]) for k in sorted(keys)]
        return {str(k): from_lua(value[k]) for k in keys}
    return value


def run_scenario(sources: dict, stage: dict, spec: dict) -> dict:
    from lupa.lua53 import LuaRuntime
    steps = int(spec['seconds'] * spec['fps'])
    rng = random.Random(spec['seed'])
    draws = [rng.randrange(RNG_RANGE) for _ in range(20000)]
    hero = dict(FIXTURE_HERO, turret_yaw=float(spec['turret_yaw']))
    scenario = {
        'name': spec['name'], 'fps': spec['fps'], 'steps': steps,
        'hero_load_delay': spec['hero_load_delay'], 'zaku_load_delay': spec['zaku_load_delay'],
        'vfx_load_delay': spec['vfx_load_delay'], 'rng': draws, 'hero': hero, 'stage': stage,
        'instruction_budget': INSTRUCTION_BUDGET,
    }
    lua = LuaRuntime(register_eval=False, register_builtins=False)
    harness = lua.execute(HARNESS)
    result = harness(lua.table_from(sources), to_lua(lua, scenario))
    exported = {k: v for k, v in scenario.items() if k != 'instruction_budget'}
    return {
        'scenario': exported,
        'trace': from_lua(result['trace']),
        'final': from_lua(result['final']),
        'errors': list(from_lua(result['errors']) or []),
        'touches': dict(from_lua(result['touches']) or {}),
        'ambiguous_frames': list(from_lua(result['ambiguous_frames']) or []),
    }


def build(repo: Path) -> dict:
    sources = load_sources(repo)
    table_bytes = (repo / STAGE_TABLE).read_bytes()
    stage = stage_row(repo)
    runs = [run_scenario(sources, stage, spec) for spec in SCENARIOS]
    from lupa.lua53 import LuaRuntime
    return {
        'schema': 1,
        'scope': 'Stage-six encounter traces from recovered Lua under stubbed engine services; '
                 'turret/muzzle placement is a fixture, not prefab data',
        'lua_version': LuaRuntime().eval('_VERSION'),
        'harness_sha256': hashlib.sha256(HARNESS.encode()).hexdigest(),
        'sources': {f'{LUA_ROOT}{rel}': expected for rel, expected in sorted(PINNED.items())},
        'stage_table': {'path': STAGE_TABLE, 'git_blob': blob_id(table_bytes)},
        'stage': stage,
        'scenarios': runs,
    }


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('--repo', default='.', type=Path)
    parser.add_argument('--out', required=True, type=Path)
    args = parser.parse_args(argv)
    if args.out.exists():
        raise SystemExit(f'refusing to overwrite {args.out}')
    document = build(args.repo.resolve())
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(document, sort_keys=True, separators=(',', ':')) + '\n', encoding='ascii')
    for run in document['scenarios']:
        print(f"{run['scenario']['name']}: {len(run['trace'])} events, {run['final']['kills']} kills, "
              f"errors={len(run['errors'])}, ghost_touches={len(run['touches'])}, "
              f"ambiguous_frames={len(run['ambiguous_frames'])}")
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
