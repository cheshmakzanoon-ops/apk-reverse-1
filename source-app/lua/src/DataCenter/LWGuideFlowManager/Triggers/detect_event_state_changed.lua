local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "detect_event_state_changed"
trigger.params = {"number", "number"}

function trigger.OnTrigger(eventInfo)
  base.TryTrigger(trigger, tonumber(eventInfo.eventId), eventInfo.state)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)
return trigger
