local LWActMeteoriteGenNoticeView = BaseClass("LWActMeteoriteGenNoticeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWActMeteoriteGenNoticeItem = require("UI.LWActMeteorite.Component.LWActMeteoriteGenNoticeItem")
local closeBtn_path = "Panel"
local messageItem_path = "Panel/LWUIActMeteoriteGenNoticeItem"

local function OnCreate(self)
  base.OnCreate(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.itemRenderer = self:AddComponent(LWActMeteoriteGenNoticeItem, messageItem_path)
  self.itemRenderer:SetActive(true)
  self.itemRenderer:ResetItem()
end

local function OnDestroy(self)
  self.closeBtnN = nil
  self:DeleteCloseTimer()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.data = self:GetUserData()
  if self.data then
    self:Display(self.data.msg, self.data.pic)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

function LWActMeteoriteGenNoticeView:Display(msg, pic)
  local sec = self.itemRenderer:Play(msg, pic)
  self:DelayClose(sec)
end

function LWActMeteoriteGenNoticeView:DeleteCloseTimer()
  if self.timerClose ~= nil then
    self.timerClose:Stop()
    self.timerClose = nil
  end
end

function LWActMeteoriteGenNoticeView:DelayClose(sec)
  self:DeleteCloseTimer()
  self.timerClose = TimerManager:GetInstance():GetTimer(sec, self.BeforeClose, self, true, false, false)
  self.timerClose:Start()
end

function LWActMeteoriteGenNoticeView:BeforeClose()
  self.ctrl:CloseSelf()
end

LWActMeteoriteGenNoticeView.OnCreate = OnCreate
LWActMeteoriteGenNoticeView.OnDestroy = OnDestroy
LWActMeteoriteGenNoticeView.OnEnable = OnEnable
LWActMeteoriteGenNoticeView.OnDisable = OnDisable
return LWActMeteoriteGenNoticeView
