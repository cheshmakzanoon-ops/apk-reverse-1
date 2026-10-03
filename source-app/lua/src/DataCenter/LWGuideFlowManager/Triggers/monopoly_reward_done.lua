local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "monopoly_reward_done"
trigger.params = {"number"}

function trigger.OnTrigger(stageId)
  base.TryTrigger(trigger, stageId)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)
return trigger
