local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
local parser = require("DataCenter.LWGuideFlowManager.LWGuideFlowParamParser")
behaviour.params = {
  {
    "string",
    "nextEventName"
  }
}
behaviour.optionalParams = {
  {
    "string",
    "cancelEventName",
    "none"
  },
  {
    "number",
    "blockerExpireTime",
    999
  }
}

function behaviour:__Awake()
  self:ParseNextEventParams()
  self:ParseCancelEventParams()
  self:InitNextEventListener()
  self:InitCancelEventListener()
end

function behaviour:ParseNextEventParams()
  parser.ParseEntryWithParams(self, self.nextEventName, "nextEventName", "nextEventParams")
end

function behaviour:ParseCancelEventParams()
  if self.cancelEventName == "none" then
    return
  end
  parser.ParseEntryWithParams(self, self.cancelEventName, "cancelEventName", "cancelEventParams")
end

function behaviour:InitNextEventListener()
  self.nextEventName = "GF_" .. self.nextEventName
  self.nextEventId = EventId[self.nextEventName]
  if self.nextEventId == nil then
    self:LogError("nextEventId not exists:" .. self.nextEventName)
    return
  end
  
  function self.OnNextEvent(evtParam)
    if self.recievedNextEvent then
      return
    end
    local hit = true
    if self.nextEventParams ~= nil and #self.nextEventParams > 0 then
      if type(evtParam) == "table" then
        for paramKey, paramValue in pairs(self.nextEventParams) do
          hit = hit and evtParam[paramKey] == paramValue
          if not hit then
            break
          end
        end
      else
        hit = evtParam == self.nextEventParams[1]
      end
    end
    if hit then
      self.recievedNextEvent = true
      self.done = true
    end
  end
end

function behaviour:InitCancelEventListener()
  if self.cancelEventName == "none" then
    return
  end
  self.cancelEventName = "GF_" .. self.cancelEventName
  self.cancelEventId = EventId[self.cancelEventName]
  if self.cancelEventId == nil then
    Logger.LogError("wait_for_event behaviour cancelEventId not exists! " .. self.flowId .. " -> " .. self.cancelEventName)
    return
  end
  
  function self.OnCancelEvent(evtParam)
    if self.recievedCancelEvent then
      return
    end
    local hit = true
    if self.cancelEventParams ~= nil and #self.cancelEventParams > 0 then
      if type(evtParam) == "table" then
        for paramKey, paramValue in pairs(self.cancelEventParams) do
          hit = hit and evtParam[paramKey] == paramValue
          if not hit then
            break
          end
        end
      else
        hit = evtParam == self.cancelEventParams[1]
      end
    end
    if hit then
      self.recievedCancelEvent = true
      self.canceled = true
    end
  end
end

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.blockerExpireTime)
  self.recievedNextEvent = false
  self.recievedCancelEvent = false
  EventManager:GetInstance():AddListener(self.nextEventId, self.OnNextEvent)
  if self.cancelEventId then
    EventManager:GetInstance():AddListener(self.cancelEventId, self.OnCancelEvent)
  end
end

function behaviour:End()
  EventManager:GetInstance():RemoveListener(self.nextEventId, self.OnNextEvent)
  if self.cancelEventId then
    EventManager:GetInstance():RemoveListener(self.cancelEventId, self.OnCancelEvent)
  end
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
end

return behaviour
