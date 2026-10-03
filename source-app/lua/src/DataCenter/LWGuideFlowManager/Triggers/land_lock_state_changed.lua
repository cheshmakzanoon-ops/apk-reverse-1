local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "land_lock_state_changed"
trigger.params = {"number", "number"}

function trigger.OnTrigger(landInfo)
  base.TryTrigger(trigger, landInfo.id, landInfo.state)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)
return trigger
