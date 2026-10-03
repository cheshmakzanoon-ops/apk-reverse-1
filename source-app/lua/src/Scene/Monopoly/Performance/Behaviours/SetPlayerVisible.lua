local base = require("Scene.Monopoly.Performance.Behaviours.MonopolyBehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {
    "number",
    "visibleType"
  }
}

function behaviour:Begin()
  if self.visibleType == 1 then
    DataCenter.MonopolyManager.player.model:SetVisible(true)
  else
    DataCenter.MonopolyManager.player.model:SetVisible(false)
  end
end

function behaviour:OnDestroy()
end

return behaviour
