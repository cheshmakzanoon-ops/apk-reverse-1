local UIPiggyBank = BaseClass("UIPiggyBank", UIBaseView)
local base = UIBaseView
local UIPiggyBankContent = require("UI.UIPiggyBank.Component.UIPiggyBankContent")
local close_path = "panel"
local content_path = "UIPiggyBankContent"
local time_txt_path = "TimeText"
local time_value_txt_path = "TimeValueText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.pack = GiftPackageData.getPiggyBankPack()
  self.endTime = self.pack:getEndTime()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.content:ReInitView(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(UIPiggyBankContent, content_path)
  self.time_text = self:AddComponent(UIText, time_txt_path)
  self.time_value_text = self:AddComponent(UIText, time_value_txt_path)
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.content = nil
  self.desc_text = nil
  self.time_text = nil
  self.time_value_text = nil
end

local function DataDefine(self)
  self.timer = nil
  self.timer = TimerManager:GetInstance():GetTimer(0.1, self.TimerAction, self, false, false, false)
  self.timer:Start()
end

local function DataDestroy(self)
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
  self.endTime = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function TimerAction(self)
  if not self.activeSelf or not self.endTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local restTime = self.endTime - curTime
  if restTime < 0 then
    return
  end
  local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
  self.time_text:SetLocalText(320192, restTimeStr)
end

UIPiggyBank.OnCreate = OnCreate
UIPiggyBank.OnDestroy = OnDestroy
UIPiggyBank.OnEnable = OnEnable
UIPiggyBank.OnDisable = OnDisable
UIPiggyBank.ComponentDefine = ComponentDefine
UIPiggyBank.ComponentDestroy = ComponentDestroy
UIPiggyBank.DataDefine = DataDefine
UIPiggyBank.DataDestroy = DataDestroy
UIPiggyBank.OnAddListener = OnAddListener
UIPiggyBank.OnRemoveListener = OnRemoveListener
UIPiggyBank.TimerAction = TimerAction
return UIPiggyBank
