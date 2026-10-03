local base = require("Framework.Common.Messenger")
local MessengerWithParam = BaseClass("MessengerWithParam", base)
local GLOBAL_SCOPE_KEY = "__ALL__"

local function _getScopeKey(scope)
  if scope == nil then
    return GLOBAL_SCOPE_KEY
  end
  local t = type(scope)
  if t ~= "number" and t ~= "string" then
    error("scope must be number or string or nil")
  end
  return scope
end

local function AddListener(self, e_type, scope, e_listener, ...)
  local scopeKey = _getScopeKey(scope)
  local event = self.events[e_type]
  if event == nil then
    event = {}
    self.events[e_type] = event
  end
  local scopeMap = event[scopeKey]
  if scopeMap == nil then
    scopeMap = setmetatable({}, {__mode = "k"})
    event[scopeKey] = scopeMap
  end
  if scopeMap[e_listener] ~= nil then
    error("Aready cotains listener : " .. tostring(e_listener))
    return
  end
  if select("#", ...) == 0 then
    scopeMap[e_listener] = base.__popATable(self)
  else
    scopeMap[e_listener] = setmetatable(SafePack(...), {__mode = "kv"})
  end
end

local function Broadcast(self, e_type, scope, ...)
  local event = self.events[e_type]
  if event == nil then
    return
  end
  local scopeKey = _getScopeKey(scope)
  local arglen = select("#", ...)
  local ok, msg
  local tmp_event = base.__popATable(self)
  local scopeMap = event[scopeKey]
  if scopeMap then
    for k, v in pairs(scopeMap) do
      tmp_event[k] = v
    end
  end
  if scopeKey ~= GLOBAL_SCOPE_KEY then
    local globalMap = event[GLOBAL_SCOPE_KEY]
    if globalMap then
      for k, v in pairs(globalMap) do
        tmp_event[k] = v
      end
    end
  end
  for k, v in pairs(tmp_event) do
    local vlen = v.n and v.n or #v
    if 0 < arglen and 0 < vlen then
      local args = ConcatSafePack(v, SafePack(...))
      ok, msg = xpcall(k, debug.traceback, scope, SafeUnpack(args))
    elseif 0 < vlen then
      ok, msg = xpcall(k, debug.traceback, scope, table.unpack(v, 1, vlen))
    elseif 0 < arglen then
      ok, msg = xpcall(k, debug.traceback, scope, ...)
    else
      ok, msg = xpcall(k, debug.traceback, scope)
    end
    if not ok then
      Logger.LogError(msg)
    end
  end
  table.clear(tmp_event)
  base.__recycleATable(self, tmp_event)
end

local function RemoveListener(self, e_type, scope, e_listener)
  local event = self.events[e_type]
  if event == nil then
    return
  end
  local scopeKey = _getScopeKey(scope)
  local scopeMap = event[scopeKey]
  if scopeMap == nil then
    return
  end
  if e_listener then
    base.__recycleATable(self, scopeMap[e_listener])
    scopeMap[e_listener] = nil
  end
end

MessengerWithParam.AddListener = AddListener
MessengerWithParam.Broadcast = Broadcast
MessengerWithParam.RemoveListener = RemoveListener
return MessengerWithParam
