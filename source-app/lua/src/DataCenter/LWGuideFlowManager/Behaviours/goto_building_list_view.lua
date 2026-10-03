local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "buildingId"}
}

function behaviour:Begin()
  if string.IsNullOrEmpty(self.buildingId) then
    self:LogError("buildingId is empty")
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBuildList) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList, self.buildingId)
  else
    EventManager:GetInstance():Broadcast(EventId.GOTO_BUILD, {
      buildId = self.buildingId
    })
  end
  self.done = true
end

function behaviour:Clear()
end

return behaviour
