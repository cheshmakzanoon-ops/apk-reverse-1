local base = require("Scene.Monopoly.Performance.Behaviours.MonopolyBehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "otherPerId"},
  {"number", "ctrlType"},
  {
    "number",
    "visibleType"
  }
}

function behaviour:Begin()
  if self.ctrlType == 1 then
    local performance = DataCenter.MonopolyManager.performanceManager:TryTriggerPerformanceBegin(self.otherPerId)
    if performance then
      performance:SetActive(self.visibleType == 1)
    end
  else
    DataCenter.MonopolyManager.performanceManager:TryTriggerPerformanceEnd(self.otherPerId)
  end
end

function behaviour:OnDestroy()
end

return behaviour
