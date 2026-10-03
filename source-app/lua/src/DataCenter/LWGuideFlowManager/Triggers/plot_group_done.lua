local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "plot_group_done"
trigger.params = {"number"}

function trigger.OnTrigger(ployGroupId)
  base.TryTrigger(trigger, ployGroupId)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)
return trigger
