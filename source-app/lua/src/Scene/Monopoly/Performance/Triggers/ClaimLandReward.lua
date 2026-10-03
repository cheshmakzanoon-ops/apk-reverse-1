local base = require("Scene.Monopoly.Performance.Triggers.MonopolyTriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "ClaimLandReward"
trigger.params = {"number"}

function trigger:OnTrigger(landId)
  base.TryTrigger(self, landId)
end

return trigger
