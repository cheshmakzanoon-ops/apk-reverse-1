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
behaviour.optionalParams = {
  {
    "string",
    "childPath",
    "none"
  }
}

function behaviour:Begin()
  local decorate = DataCenter.MonopolyManager:GetDecorateById(self.monopolyId)
  if decorate then
    if self.childPath == "none" then
      decorate:SetVisible(self.visibleType == 1)
    else
      decorate:SetChildVisible(self.visibleType == 1, self.childPath)
    end
  end
end

function behaviour:OnDestroy()
end

return behaviour
