local TimerManager = BaseClass("TimerManager", Singleton)

local function __init(self)
  self.__update_handle = nil
  self.__coupdate_handle = nil
  self.__update_timer = {}
  self.__coupdate_timer = {}
  self.__update_toadd = {}
  self.__coupdate_toadd = {}
end

local function DelayRecycle(self, timers)
  for timer, _ in pairs(timers) do
    if timer:IsOver() then
      timer:Stop()
      timers[timer] = nil
    end
  end
end

local function UpdateHandle(self)
  for timer, _ in pairs(self.__update_toadd) do
    self.__update_timer[timer] = true
    self.__update_toadd[timer] = nil
  end
  for timer, _ in pairs(self.__update_timer) do
    timer:Update()
  end
  DelayRecycle(self, self.__update_timer)
end

local function CoUpdateHandle(self)
  for timer, _ in pairs(self.__coupdate_toadd) do
    self.__coupdate_timer[timer] = true
    self.__coupdate_toadd[timer] = nil
  end
  for timer, _ in pairs(self.__coupdate_timer) do
    timer:Update()
  end
  DelayRecycle(self, self.__coupdate_timer)
end

local function Startup(self)
  self:Dispose()
  self.__update_handle = UpdateBeat:CreateListener(UpdateHandle, TimerManager:GetInstance())
  self.__coupdate_handle = CoUpdateBeat:CreateListener(CoUpdateHandle, TimerManager:GetInstance())
  UpdateBeat:AddListener(self.__update_handle)
  CoUpdateBeat:AddListener(self.__coupdate_handle)
end

local function Dispose(self)
  if self.__update_handle ~= nil then
    UpdateBeat:RemoveListener(self.__update_handle)
    self.__update_handle = nil
  end
  if self.__coupdate_handle ~= nil then
    CoUpdateBeat:RemoveListener(self.__coupdate_handle)
    self.__coupdate_handle = nil
  end
  self:Cleanup()
end

local function Cleanup(self)
  self.__update_timer = {}
  self.__coupdate_timer = {}
  self.__update_toadd = {}
  self.__coupdate_toadd = {}
end

local function InnerGetTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
  local timer
  timer = Timer.New(delay, func, obj, one_shot, use_frame, unscaled)
  return timer
end

local function GetTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
  assert(not self.__update_timer[timer] and not self.__update_toadd[timer])
  local timer = InnerGetTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
  self.__update_toadd[timer] = true
  return timer
end

local function GetCoTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
  assert(not self.__coupdate_timer[timer] and not self.__coupdate_toadd[timer])
  local timer = InnerGetTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
  self.__coupdate_toadd[timer] = true
  return timer
end

local function DelayInvoke(self, callback, delayTime, userdata)
  delayTime = tonumber(delayTime or 1)
  local t = TimerManager:GetInstance():GetTimer(delayTime, function(userdata)
    if t ~= nil then
      t:Stop()
      t = nil
    end
    callback(userdata)
  end, userdata, true, false, false)
  t:Start()
  return t
end

local function DelayInvokeUnscaled(self, callback, delayTime, userdata)
  delayTime = tonumber(delayTime or 1)
  local t = TimerManager:GetInstance():GetTimer(delayTime, function(userdata)
    if t ~= nil then
      t:Stop()
      t = nil
    end
    callback(userdata)
  end, userdata, true, false, true)
  t:Start()
  return t
end

local function DelayFrameInvoke(self, callback, delayFrame, userdata)
  delayFrame = tonumber(delayFrame or 1)
  local t = TimerManager:GetInstance():GetTimer(delayFrame, function(userdata)
    if t ~= nil then
      t:Stop()
      t = nil
    end
    callback(userdata)
  end, userdata, true, true, false)
  t:Start()
  return t
end

local function __delete(self)
  self:Cleanup()
  self.__update_handle = nil
  self.__coupdate_handle = nil
  self.__update_timer = nil
  self.__coupdate_timer = nil
  self.__update_toadd = nil
  self.__coupdate_toadd = nil
end

TimerManager.__init = __init
TimerManager.__delete = __delete
TimerManager.Startup = Startup
TimerManager.Cleanup = Cleanup
TimerManager.Dispose = Dispose
TimerManager.GetTimer = GetTimer
TimerManager.GetCoTimer = GetCoTimer
TimerManager.DelayInvoke = DelayInvoke
TimerManager.DelayInvokeUnscaled = DelayInvokeUnscaled
TimerManager.DelayFrameInvoke = DelayFrameInvoke
return TimerManager
