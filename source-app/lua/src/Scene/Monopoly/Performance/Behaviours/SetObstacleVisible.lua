local base = require("Scene.Monopoly.Performance.Behaviours.MonopolyBehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "monopolyId"},
  {
    "number",
    "visibleType"
  }
}

function behaviour:Begin()
  if self.visibleType == 1 then
    DataCenter.MonopolyManager:SetTargetObstableRelatedAppearanceVisible(self.monopolyId, true)
  else
    DataCenter.MonopolyManager:SetTargetObstableRelatedAppearanceVisible(self.monopolyId, false)
  end
end

function behaviour:OnDestroy()
end

return behaviour
