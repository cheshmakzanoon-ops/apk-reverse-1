local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "window_opened_UIDispatchTaskMain"
trigger.params = {"number"}

function trigger.OnTrigger(activityType)
  base.TryTrigger(trigger, activityType)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)
return trigger
