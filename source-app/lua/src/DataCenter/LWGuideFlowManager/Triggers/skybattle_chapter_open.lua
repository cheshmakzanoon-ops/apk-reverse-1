local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "skybattle_chapter_open"

function trigger.OnTrigger()
  base.TryTrigger(trigger)
end

EventManager:GetInstance():AddListener(EventId[trigger.name], trigger.OnTrigger)
return trigger
