local Messenger = BaseClass("Messenger")

local function __init(self)
  self.events = {}
  self.emptyTableList = {}
end

local function __delete(self)
  self.events = nil
  self.error_handle = nil
  self.emptyTableList = nil
end

local function __popATable(self)
  local c = #self.emptyTableList
  local ret
  if 0 < c then
    ret = self.emptyTableList[c]
    self.emptyTableList[c] = nil
  else
    ret = {}
  end
  return ret
end

local function __recycleATable(self, t)
  if t and t.n == nil and #t == 0 then
    table.insert(self.emptyTableList, t)
  end
end

local function AddListener(self, e_type, e_listener, ...)
  local event = self.events[e_type]
  if event == nil then
    event = setmetatable({}, {__mode = "k"})
    self.events[e_type] = event
  end
  if event[e_listener] ~= nil then
    error("Aready cotains listener : " .. tostring(e_listener))
    return
  end
  if select("#", ...) == 0 then
    event[e_listener] = __popATable(self)
  else
    event[e_listener] = setmetatable(SafePack(...), {__mode = "kv"})
  end
end

local function Broadcast(self, e_type, ...)
  local event = self.events[e_type]
  if event == nil then
    return
  end
  local arglen = select("#", ...)
  local ok, msg
  local tmp_event = __popATable(self)
  for k, v in pairs(event) do
    tmp_event[k] = v
  end
  for k, v in pairs(tmp_event) do
    local vlen = v.n and v.n or #v
    if 0 < arglen and 0 < vlen then
      local args = ConcatSafePack(v, SafePack(...))
      ok, msg = xpcall(k, debug.traceback, SafeUnpack(args))
    elseif 0 < vlen then
      ok, msg = xpcall(k, debug.traceback, table.unpack(v, 1, vlen))
    elseif 0 < arglen then
      ok, msg = xpcall(k, debug.traceback, ...)
    else
      ok, msg = xpcall(k, debug.traceback)
    end
    if not ok then
      Logger.LogError(msg)
    end
  end
  table.clear(tmp_event)
  __recycleATable(self, tmp_event)
end

local function RemoveListener(self, e_type, e_listener)
  local event = self.events[e_type]
  if event == nil then
    return
  end
  if e_listener then
    self:__recycleATable(event[e_listener])
    event[e_listener] = nil
  end
end

local function RemoveListenerByType(self, e_type)
  self.events[e_type] = nil
end

local function Cleanup(self)
  self.events = {}
end

Messenger.__init = __init
Messenger.__delete = __delete
Messenger.__popATable = __popATable
Messenger.__recycleATable = __recycleATable
Messenger.AddListener = AddListener
Messenger.Broadcast = Broadcast
Messenger.RemoveListener = RemoveListener
Messenger.RemoveListenerByType = RemoveListenerByType
Messenger.Cleanup = Cleanup
return Messenger
