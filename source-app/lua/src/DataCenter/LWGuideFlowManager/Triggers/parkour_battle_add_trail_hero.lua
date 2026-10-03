local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "parkour_battle_add_trail_hero"
trigger.params = {"number", "number"}

function trigger.OnTrigger(tb)
  base.TryTrigger(trigger, tb[1], tb[2])
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  local result = true
  result = result and (params[1] < 0 or params[1] == evtParam[1])
  result = result and (0 > params[2] or params[2] == evtParam[2])
  return result
end

return trigger
