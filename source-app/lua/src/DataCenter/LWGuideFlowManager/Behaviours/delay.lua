local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "duration"}
}

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.duration + 1)
  self.__timer = 0
end

function behaviour:Update(dt)
  self.__timer = self.__timer + dt
  if self.__timer >= self.duration then
    self.done = true
  end
end

function behaviour:End()
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
end

return behaviour
