local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "enter_pvp_arena"
trigger.params = {"number"}

function trigger.OnTrigger(pvpArenaType)
  base.TryTrigger(trigger, pvpArenaType)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  local result = true
  result = result and params[1] == evtParam[1]
  return result
end

return trigger
