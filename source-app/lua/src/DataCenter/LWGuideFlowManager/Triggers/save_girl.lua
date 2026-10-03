local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "save_girl"
trigger.params = {"number"}

function trigger.OnTrigger(lastSaveTimes)
  base.TryTrigger(trigger, lastSaveTimes)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  local result = true
  result = result and (params[1] < 0 or params[1] == evtParam[1])
  return result
end

return trigger
