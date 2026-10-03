local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "city_hero_drop_anim_done"
trigger.params = {"number"}

function trigger.OnTrigger(heroId)
  base.TryTrigger(trigger, heroId)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)
return trigger
