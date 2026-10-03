local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "server_id"

function condition.ParseParams(params)
  local ret = {}
  local map = {}
  if not string.IsNullOrEmpty(params) then
    local array = string.split(params, ";")
    for i, v in ipairs(array) do
      local sp = string.split(v, "-")
      if #sp == 2 then
        local min = tonumber(sp[1])
        local max = tonumber(sp[2])
        for i = min, max do
          table.insert(map, i)
        end
      elseif #sp == 1 then
        table.insert(map, tonumber(sp[1]) or 0)
      end
    end
  end
  table.insert(ret, map)
  return ret
end

function condition.__Check(map)
  if not map then
    return false
  end
  local server = LuaEntry.Player:GetSourceServerId()
  if not table.hasvalue(map, server) then
    return false
  end
  return true
end

return condition
