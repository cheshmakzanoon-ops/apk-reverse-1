local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "hero_squad_saved"
trigger.params = {"number"}

function trigger.OnTrigger(squadIdx)
  base.TryTrigger(trigger, squadIdx)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)
return trigger
