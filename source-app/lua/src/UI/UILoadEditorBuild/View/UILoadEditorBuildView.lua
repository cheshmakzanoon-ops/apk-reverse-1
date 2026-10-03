local base = UIBaseView
local UILoadEditorBuildView = BaseClass("UILoadEditorBuildView", UIBaseView)
local offset_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.str = self:GetUserData()
  self.offsetN = self:AddComponent(UIBaseContainer, offset_path)
  
  function self.timer_action()
    self:TimerAction()
  end
  
  self.delayCloseTimer = nil
  self:ShowLoading()
end

local function OnDestroy(self)
  self.str = nil
  self.offsetN = nil
  self:DeleteTimer()
  self.timer_action = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CLOSE_LOADEDITORBUILD, self.Close)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.CLOSE_LOADEDITORBUILD, self.Close)
  base.OnRemoveListener(self)
end

local function ShowLoading(self)
  if self.str == nil then
    self:Close()
  end
  local strVec = string.split(self.str, ";")
  if #strVec < 3 then
    self:Close()
  end
  local vec3 = Vector3.New(tonumber(strVec[1]), tonumber(strVec[2]), tonumber(strVec[3]))
  local screenPos = CS.CSUtils.WorldPositionToUISpacePosition(vec3)
  self.offsetN.transform.position = screenPos
  self:AddDelayTimer()
end

local function AddDelayTimer(self)
  if self.delayCloseTimer == nil then
    self.delayCloseTimer = TimerManager:GetInstance():GetTimer(0.8, self.timer_action, self, true, false, false)
  end
  self.delayCloseTimer:Start()
end

local function TimerAction(self)
  self:Close()
end

local function DeleteTimer(self)
  if self.delayCloseTimer ~= nil then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
end

local function Close(self)
  self:DeleteTimer()
  self.ctrl:CloseSelf()
end

UILoadEditorBuildView.OnCreate = OnCreate
UILoadEditorBuildView.OnDestroy = OnDestroy
UILoadEditorBuildView.OnAddListener = OnAddListener
UILoadEditorBuildView.OnRemoveListener = OnRemoveListener
UILoadEditorBuildView.ShowLoading = ShowLoading
UILoadEditorBuildView.AddDelayTimer = AddDelayTimer
UILoadEditorBuildView.TimerAction = TimerAction
UILoadEditorBuildView.DeleteTimer = DeleteTimer
UILoadEditorBuildView.Close = Close
return UILoadEditorBuildView
