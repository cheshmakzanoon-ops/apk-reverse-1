local UIPiggyBank = BaseClass("UIPiggyBank", UIBaseView)
local base = UIBaseView
local UIPiggyBankContent = require("UI.UIPiggyBank.Component.UIPiggyBankContent")
local content_path = "UIPiggyBankContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.content = self:AddComponent(UIPiggyBankContent, content_path)
  self.actName_txt = self:AddComponent(UIText, "NameText")
  self.actSubTitle_txt = self:AddComponent(UIText, "SubTitleText")
  self.time_txt = self:AddComponent(UIText, "TimeDesc")
end

local function ComponentDestroy(self)
  self.content = nil
  self.desc_text = nil
  self.actName_txt = nil
  self.actSubTitle_txt = nil
  self.time_txt = nil
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
  self.time_txt:SetLocalText(320192, restTimeStr)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, view)
  self.content:ReInitPanel(self.view)
  self:SetData()
end

function UIPiggyBank:SetData()
  self.pack = GiftPackageData.getPiggyBankPack()
  self.endTime = self.pack:getEndTime()
  self:RefreshTitle()
end

function UIPiggyBank:RefreshTitle()
  self.actName_txt:SetLocalText(self.pack._tableData.name)
  self.actSubTitle_txt:SetLocalText(self.pack._tableData.description)
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
UIPiggyBank.ReInit = ReInit
UIPiggyBank.TimerAction = TimerAction
return UIPiggyBank
