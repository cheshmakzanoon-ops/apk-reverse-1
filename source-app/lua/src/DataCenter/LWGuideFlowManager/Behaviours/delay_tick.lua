local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "ticks"}
}

function behaviour:Begin()
  EventManager:GetInstance():Broadcast(EventId.EnableInteractionBlocker, 2)
  self.__countdown = self.ticks
end

function behaviour:Update(dt)
  self.__countdown = self.__countdown - 1
  if self.__countdown <= 0 then
    self.done = true
  end
end

function behaviour:End()
  EventManager:GetInstance():Broadcast(EventId.DisableInteractionBlocker, 2)
end

return behaviour
