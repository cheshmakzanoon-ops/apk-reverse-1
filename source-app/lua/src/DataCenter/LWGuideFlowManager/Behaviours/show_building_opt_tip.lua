local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "buildingId"},
  {
    "number",
    "tileBtnType"
  }
}

function behaviour:Begin()
  if string.IsNullOrEmpty(self.buildingId) then
    self:LogError("buildingId is empty")
    return
  end
  GoToUtil.GotoCityByBuildId(self.buildingId, WorldTileBtnType.T11Research)
  self.done = true
end

function behaviour:Clear()
end

return behaviour
