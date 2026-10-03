local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "open_activity_content"
trigger.params = {"string"}

function trigger.OnTrigger(eventInfo)
  base.TryTrigger(trigger, eventInfo)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  if params then
    local activityId = params[1]
    if evtParam and evtParam[1] and evtParam[1].activityId and evtParam[1].activityId == activityId then
      return true
    end
  end
  return false
end

return trigger
