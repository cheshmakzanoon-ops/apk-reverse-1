local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "eventName"}
}
behaviour.optionalParams = {
  {
    "string",
    "eventParam",
    nil
  }
}

function behaviour:__Awake()
  self.eventId = EventId[self.eventName]
  if self.eventId == nil then
    self:LogError("eventId not exists! " .. self.eventName)
    return
  end
end

function behaviour:Begin()
  EventManager:GetInstance():Broadcast(self.eventId, self.eventParam)
  self.done = true
end

return behaviour
