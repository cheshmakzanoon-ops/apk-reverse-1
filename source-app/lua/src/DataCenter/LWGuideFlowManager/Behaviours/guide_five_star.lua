local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {}

function behaviour:Begin()
  if self.OnFiveStarFinish == nil then
    function self.OnFiveStarFinish()
      self.done = true
    end
  end
  if self.OnWindowClose == nil then
    function self.OnWindowClose(windowName)
      if windowName == UIWindowNames.UIFiveStarGet then
        self.done = true
      end
    end
  end
  EventManager:GetInstance():AddListener(EventId.GF_five_star_finish, self.OnFiveStarFinish)
  EventManager:GetInstance():AddListener(EventId.GF_window_closed, self.OnWindowClose)
  local show = DataCenter.LWFiveStarManager:CheckShowFiveStarView("guide")
  if not show then
    self.done = true
  else
    self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 1)
  end
end

function behaviour:End()
  EventManager:GetInstance():RemoveListener(EventId.GF_five_star_finish, self.OnFiveStarFinish)
  EventManager:GetInstance():RemoveListener(EventId.GF_window_closed, self.OnWindowClose)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
  self.OnFiveStarFinish = nil
  self.OnWindowClose = nil
end

return behaviour
