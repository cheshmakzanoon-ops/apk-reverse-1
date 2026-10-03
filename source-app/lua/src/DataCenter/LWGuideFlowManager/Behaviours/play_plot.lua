local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {
    "number",
    "plotGroupId"
  }
}
behaviour.optionalParams = {
  {
    "bool",
    "hideMainUI",
    true
  }
}

function behaviour:__Awake()
  function self.OnPlotGroupStart(plotGroupId)
    if self.plotGroupId == plotGroupId then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    end
  end
  
  function self.OnPlotGroupDone(plotGroupId)
    if self.plotGroupId == plotGroupId then
      self.done = true
    end
  end
  
  function self.OnPlotViewClosedAbnormally(plotGroupId)
    if self.plotGroupId == plotGroupId then
      self.done = true
    end
  end
end

local BLOCKER_EXPIRE_TIME = 1

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, BLOCKER_EXPIRE_TIME)
  EventManager:GetInstance():AddListener(EventId.PlotGroupStart, self.OnPlotGroupStart, self)
  EventManager:GetInstance():AddListener(EventId.PlotGroupDone, self.OnPlotGroupDone, self)
  EventManager:GetInstance():AddListener(EventId.PlotViewClosedAbnormally, self.OnPlotViewClosedAbnormally, self)
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
    plotGroupId = self.plotGroupId,
    hideMainUI = self.hideMainUI
  })
end

function behaviour:End()
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupStart, self.OnPlotGroupStart, self)
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupDone, self.OnPlotGroupDone, self)
  EventManager:GetInstance():RemoveListener(EventId.PlotViewClosedAbnormally, self.OnPlotViewClosedAbnormally, self)
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
end

return behaviour
