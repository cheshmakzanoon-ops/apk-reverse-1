local UIActivityKillZombieHelpPopupItem = BaseClass("UIActivityKillZombieHelpPopupItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local bg_path = "bg"
local bg_active_path = "bgActive"
local chat_head_path = "ChatHead"
local name_path = "name"
local level_path = "level"
local time_path = "time"
local btn_help_path = "BtnHelp"
local go_text_path = "BtnHelp/GoText"

function UIActivityKillZombieHelpPopupItem:OnCreate()
  base.OnCreate(self)
  self.chat_head = self:AddComponent(ChatHead, chat_head_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.bg_active = self:AddComponent(UIImage, bg_active_path)
  self.name = self:AddComponent(UIText, name_path)
  self.level = self:AddComponent(UIText, level_path)
  self.remain_time = self:AddComponent(UIText, time_path)
  self.btn_help = self:AddComponent(UIButton, btn_help_path)
  self.go_text = self:AddComponent(UIText, go_text_path)
end

function UIActivityKillZombieHelpPopupItem:OnDestroy()
  self:DelCountDownTimer()
  self.chat_head = nil
  self.bg = nil
  self.bg_active = nil
  self.name = nil
  self.level = nil
  self.remain_time = nil
  self.btn_help = nil
  self.go_text = nil
  base.OnDestroy(self)
end

function UIActivityKillZombieHelpPopupItem:OnEnable()
  base.OnEnable(self)
end

function UIActivityKillZombieHelpPopupItem:OnDisable()
  base.OnDisable(self)
end

function UIActivityKillZombieHelpPopupItem:ReInit(index, param)
  self.param = param
  self.activityData = param
  self.bg:SetActive(1 < index)
  self.bg_active:SetActive(index == 1)
  self.name:SetText("UserName" .. index)
  self.level:SetText("Lv." .. index)
  self.go_text:SetLocalText("100389")
  self.remain_time:SetText("")
  self.btn_help:SetOnClick(function()
    if self.param ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityKillZombieHelpReward, {anim = true}, self.param)
    end
  end)
  self.chat_head:ReInit(nil)
  self:RefreshRemainTime()
  self:AddCountDownTimer()
end

function UIActivityKillZombieHelpPopupItem:RefreshUI()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityData.endTime - curTime
  if 0 < remainTime then
    self.remain_time:SetActive(true)
    self.btn_help:SetActive(true)
  else
    self.remain_time:SetActive(false)
    self.btn_help:SetActive(false)
  end
end

function UIActivityKillZombieHelpPopupItem:AddCountDownTimer()
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshRemainTime, self, false, false, false)
  end
  self.remain_time:SetActive(true)
  self.countDownTimer:Start()
end

function UIActivityKillZombieHelpPopupItem:RefreshRemainTime()
  if not self.activityData then
    self:DelCountDownTimer()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityData.endTime - curTime
  if 0 < remainTime then
    self.remain_time:SetText("Expired: " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remain_time:SetText("")
    self:RefreshUI()
    self:DelCountDownTimer()
  end
end

function UIActivityKillZombieHelpPopupItem:DelCountDownTimer()
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
  self.remain_time:SetActive(false)
end

return UIActivityKillZombieHelpPopupItem
