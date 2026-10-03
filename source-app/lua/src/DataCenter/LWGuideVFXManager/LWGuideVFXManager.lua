local LWGuideVFXManager = BaseClass("LWGuideVFXManager", CEventable)
local ResourceManager = CS.GameEntry.Resource

function LWGuideVFXManager:__init()
  self.handleCounter = 0
  self.handleIndex = 0
  self.handlePriority = 0
  self.req = nil
  self.callBackObj = nil
  self.callBack = nil
  self.delay = nil
end

function LWGuideVFXManager:OnEnterGame()
end

function LWGuideVFXManager:__delete()
  self:ClearCurrent()
end

function LWGuideVFXManager:ClearCurrent()
  if not IsNull(self.req) then
    self.req:Destroy()
    self.req = nil
    self.callBackObj = nil
    self.callBack = nil
    self.handlePriority = 0
  end
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self.handleIndex = nil
  self.delayHandle = nil
end

function LWGuideVFXManager:InstantiateAsync(path, callBack, callBackObj, time, priority, checkHandle)
  local showPriority = priority or GuideVFXPriority.Low
  if showPriority < self.handlePriority then
    return nil
  end
  if checkHandle and self.handleIndex and checkHandle == self.handleIndex then
    if self.delay then
      self.delay:Reset()
    end
    return self.handleIndex
  end
  self:ClearCurrent()
  self.handleCounter = self.handleCounter + 1
  self.handleIndex = self.handleCounter
  self.handlePriority = showPriority
  self.callBack = callBack
  self.callBackObj = callBackObj
  self.req = ResourceManager:InstantiateAsync(path)
  self.req:completed("+", self.ReqCallBack)
  if 0 < time then
    self.delayHandle = self.handleIndex
    self.delay = TimerManager:GetInstance():DelayInvoke(self.DelayCallBack, time)
  end
  return self.handleIndex
end

function LWGuideVFXManager:StopCurrent(handle)
  if handle and self.handleIndex and handle == self.handleIndex then
    self:ClearCurrent()
  end
end

function LWGuideVFXManager.ReqCallBack(req)
  local self = DataCenter.LWGuideVFXManager
  self.req = req
  if req.isError then
    self:ClearCurrent()
    return
  end
  if self.callBack == nil then
    self:ClearCurrent()
    return
  end
  local ok, msg
  if self.callBackObj then
    ok, msg = pcall(self.callBack, self.callBackObj, req)
  else
    ok, msg = pcall(self.callBack, req)
  end
  if not ok and msg then
    Logger.LogError(msg)
    self.ClearCurrent()
  end
end

function LWGuideVFXManager.DelayCallBack()
  local self = DataCenter.LWGuideVFXManager
  self:StopCurrent(self.delayHandle)
end

return LWGuideVFXManager
