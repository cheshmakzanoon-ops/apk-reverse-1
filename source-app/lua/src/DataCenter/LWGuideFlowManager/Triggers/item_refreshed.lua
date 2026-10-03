local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "item_refreshed"
trigger.params = {"number"}

function trigger.OnTrigger(itemInfo)
  base.TryTrigger(trigger, tonumber(itemInfo.itemId))
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)
return trigger
