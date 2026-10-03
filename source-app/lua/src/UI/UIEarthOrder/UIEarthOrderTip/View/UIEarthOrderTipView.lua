local UIEarthOrderTipView = BaseClass("UIEarthOrderTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AutoCloseTime = 5
local des_text_path = "DesText"

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
  self.des_text = self:AddComponent(UIText, des_text_path)
end

local function ComponentDestroy(self)
  self.des_text = nil
end

local function DataDefine(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:DeleteTimer()
    self.ctrl:CloseSelf()
  end
end

local function DataDestroy(self)
  self.timer_action = nil
  self:DeleteTimer()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  local str, closeTime = self:GetUserData()
  self.closeTime = closeTime
  str = str or Localization:GetString(GameDialogDefine.ROCKET_HAS_ARRIVED)
  self.des_text:SetText(str)
  self:AddTimer()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if not self.closeTime then
    self.closeTime = AutoCloseTime
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(self.closeTime, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

UIEarthOrderTipView.OnCreate = OnCreate
UIEarthOrderTipView.OnDestroy = OnDestroy
UIEarthOrderTipView.OnEnable = OnEnable
UIEarthOrderTipView.OnDisable = OnDisable
UIEarthOrderTipView.OnAddListener = OnAddListener
UIEarthOrderTipView.OnRemoveListener = OnRemoveListener
UIEarthOrderTipView.ComponentDefine = ComponentDefine
UIEarthOrderTipView.ComponentDestroy = ComponentDestroy
UIEarthOrderTipView.DataDefine = DataDefine
UIEarthOrderTipView.DataDestroy = DataDestroy
UIEarthOrderTipView.ReInit = ReInit
UIEarthOrderTipView.DeleteTimer = DeleteTimer
UIEarthOrderTipView.AddTimer = AddTimer
return UIEarthOrderTipView
