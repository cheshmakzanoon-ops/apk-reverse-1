local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "t11_idle_game_trigger"
trigger.params = {"number"}

function trigger.OnTrigger(eventInfo)
  base.TryTrigger(trigger, eventInfo)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  if params and evtParam and evtParam[1] then
    local triggerId = params[1]
    if triggerId == evtParam[1].trigger_id then
      return true
    end
  end
  return false
end

return trigger
