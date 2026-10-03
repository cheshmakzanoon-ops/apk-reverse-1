local base = require("Scene.Monopoly.Performance.Triggers.MonopolyTriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "MonopolyGoto"
trigger.params = {"number"}

function trigger:OnTrigger(monopolyId)
  base.TryTrigger(self, monopolyId)
end

return trigger
