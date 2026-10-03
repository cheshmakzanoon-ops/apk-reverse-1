local UIInvasionSummonProgressView = BaseClass("UIInvasionSummonProgressView", UIBaseView)
local InvasionSummonProgressPopItem = require("UI.UIInvasionSummonProgress.Component.InvasionSummonProgressPopItem")
local base = UIBaseView
local invasion_progress_group_path = "Panel/InvasionProgressGroup"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.invasion_progress_group = self:AddComponent(InvasionSummonProgressPopItem, invasion_progress_group_path)
  self.tweenRootAni = self.invasion_progress_group.transform:GetComponent(typeof(CS.UnityEngine.Animator))
end

local function ComponentDestroy(self)
  self.invasion_progress_group = nil
  self.tweenRootAni = nil
end

local function DataDefine(self)
  self.groupTimer = nil
  self.timer = nil
end

local function DataDestroy(self)
  if self.groupTimer then
    self.groupTimer:Stop()
  end
  self.groupTimer = nil
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, param)
  param = param or self:GetUserData()
  self.param = param
  if param ~= nil then
    self.invasion_progress_group:ReInit(param.curProgress)
  end
  self:PlayAnim(param.targetProgress)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshInvasionProgressPanel, self.RefreshPanel)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshInvasionProgressPanel, self.RefreshPanel)
end

local function OnTweenFinished(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIInvasionSummonProgress)
end

local function RefreshPanel(self, param)
  self:ReInit(param)
end

local function PlayAnim(self, targetProgress)
  if self.groupTimer then
    self.groupTimer:Stop()
  end
  if self.timer then
    self.timer:Stop()
  end
  self.tweenRootAni:Play("V_ui_jiesuo_invasion_fade_in_out", 0, 0)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnTweenFinished()
  end, 2.6)
  self.groupTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.invasion_progress_group:DisplayProgressTween(targetProgress)
  end, 0.5)
end

UIInvasionSummonProgressView.OnCreate = OnCreate
UIInvasionSummonProgressView.OnDestroy = OnDestroy
UIInvasionSummonProgressView.OnEnable = OnEnable
UIInvasionSummonProgressView.OnDisable = OnDisable
UIInvasionSummonProgressView.OnAddListener = OnAddListener
UIInvasionSummonProgressView.OnRemoveListener = OnRemoveListener
UIInvasionSummonProgressView.ComponentDefine = ComponentDefine
UIInvasionSummonProgressView.ComponentDestroy = ComponentDestroy
UIInvasionSummonProgressView.DataDefine = DataDefine
UIInvasionSummonProgressView.DataDestroy = DataDestroy
UIInvasionSummonProgressView.ReInit = ReInit
UIInvasionSummonProgressView.OnTweenFinished = OnTweenFinished
UIInvasionSummonProgressView.RefreshPanel = RefreshPanel
UIInvasionSummonProgressView.PlayAnim = PlayAnim
return UIInvasionSummonProgressView
