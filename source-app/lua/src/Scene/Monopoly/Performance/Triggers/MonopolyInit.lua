local base = require("Scene.Monopoly.Performance.Triggers.MonopolyTriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "MonopolyInit"
trigger.params = {"number", "number"}

function trigger:OnTrigger(monopolyId)
  base.TryTrigger(self, monopolyId)
end

function trigger.CheckParams(params, evtParam)
  local result = false
  if evtParam[1] ~= 0 and params[1] <= evtParam[1] and params[2] >= evtParam[1] then
    result = true
  end
  return result
end

return trigger
