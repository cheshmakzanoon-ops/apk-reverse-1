local base = UIEventTrigger
local UILongPressTrigger = BaseClass("UILongPressTrigger", base)

function UILongPressTrigger:OnCreate()
  base.OnCreate(self)
  self.triggerLongPressTime = 0.5
  self.longPressInterval = 0.15
  self.longPressMinInterval = 0.05
  self.longPressIntervalAccTime = 0.5
  self.activation = false
  self.listener = nil
end

function UILongPressTrigger:OnDestroy()
  self:StopLongPressListener()
  self.activation = false
  self.listener = nil
  base.OnDestroy(self)
end

function UILongPressTrigger:SetCallback(fun)
  self.listener = fun
  if self.unity_event_trigger ~= nil and fun ~= nil and type(fun) == "function" then
    self.activation = true
    self.unity_event_trigger.onPointerDown = BindCallback(self, self.OnPointerDown)
    self.unity_event_trigger.onPointerUp = BindCallback(self, self.OnPointerUp)
  end
end

function UILongPressTrigger:SetTimeInterval(triggerLongPressTime, longPressInterval, longPressMinInterval, longPressIntervalAccTime)
  self.triggerLongPressTime = triggerLongPressTime
  self.longPressInterval = longPressInterval
  self.longPressMinInterval = longPressMinInterval
  self.longPressIntervalAccTime = longPressIntervalAccTime
end

function UILongPressTrigger:StartLongPressListener()
  if self.unity_event_trigger ~= nil then
    self.activation = true
  end
end

function UILongPressTrigger:StopLongPressListener()
  self.activation = false
  self:BreakLongPress()
end

function UILongPressTrigger:Update100MS()
  if self.activation and self.listener ~= nil then
    if self.lastTime == nil then
      return
    end
    local checkIntervalTime = Time.time - self.lastTime
    if not self.isLongPress then
      if checkIntervalTime < self.triggerLongPressTime then
        return
      end
      self.lastTime = Time.time
      self.startPressTime = Time.time
      self.isLongPress = true
      self.isClick = false
    end
    local curPressTime = Time.time - self.startPressTime
    local DynamicCheckInterval = Mathf.Lerp(self.longPressInterval, self.longPressMinInterval, Mathf.Clamp01(curPressTime / self.longPressIntervalAccTime))
    if checkIntervalTime < DynamicCheckInterval then
      return
    end
    self.lastTime = Time.time
    if self.listener ~= nil and type(self.listener) == "function" then
      CommonUtil.ProtectCall(function()
        local canDo = self.listener()
        if not canDo then
          self.activation = false
        end
      end)
    end
  end
end

function UILongPressTrigger:OnPointerDown()
  self.isClick = true
  self.lastTime = Time.time
end

function UILongPressTrigger:OnPointerUp()
  if self.isClick and self.listener ~= nil and type(self.listener) == "function" then
    CommonUtil.ProtectCall(function()
      if not self.listener() then
        self.activation = false
      end
    end)
  end
  self:BreakLongPress()
end

function UILongPressTrigger:BreakLongPress()
  self.isLongPress = false
  self.lastTime = nil
  self.startPressTime = nil
end

return UILongPressTrigger
