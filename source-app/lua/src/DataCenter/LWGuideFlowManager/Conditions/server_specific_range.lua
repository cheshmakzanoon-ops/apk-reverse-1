local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "server_specific_range"
condition.params = {"string"}

function condition.ParseParams(params)
  if CS.CommonUtils.IsDebug() then
    return
  end
  local ret = {}
  local map = {}
  table.insert(ret, map)
  local serverRangeGroupStr = params[1]
  local serverRanges = string.split(serverRangeGroupStr, ";")
  for i, v in ipairs(serverRanges) do
    local sp = string.split(v, "-")
    if #sp == 2 then
      local min = tonumber(sp[1])
      local max = tonumber(sp[2])
      local range = {}
      range.min = min
      range.max = max
      table.insert(map, range)
    elseif #sp == 1 then
      local min = tonumber(sp[1])
      local max = math.maxinteger
      local range = {}
      range.min = min
      range.max = max
      table.insert(map, range)
    end
  end
  return ret
end

function condition.__Check(map)
  if CS.CommonUtils.IsDebug() then
    return true
  end
  if not map then
    return false
  end
  local server = LuaEntry.Player:GetSourceServerId()
  for i, v in ipairs(map) do
    if server >= v.min and server <= v.max then
      return true
    end
  end
  return false
end

return condition
