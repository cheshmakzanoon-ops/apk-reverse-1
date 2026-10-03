local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "zombie_battle_ult_ready"
trigger.params = {"number"}

function trigger.OnTrigger(heroIndex)
  base.TryTrigger(trigger, heroIndex)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  local result = true
  result = result and (params[1] < 0 or params[1] == evtParam[1])
  return result
end

return trigger
