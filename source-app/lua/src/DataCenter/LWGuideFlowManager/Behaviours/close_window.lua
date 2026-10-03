local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "windowName"}
}

function behaviour:Begin()
  if string.IsNullOrEmpty(self.windowName) then
    self:LogError("windowName is empty")
    return
  end
  UIManager:GetInstance():DestroyWindow(self.windowName)
  self.done = true
end

return behaviour
