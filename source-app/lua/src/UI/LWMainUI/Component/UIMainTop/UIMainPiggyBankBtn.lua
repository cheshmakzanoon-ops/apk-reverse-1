local UIMainPiggyBankBtn = BaseClass("UIMainPiggyBankBtn", UIBaseContainer)
local TaskActivity = require("UI.UIActivityCenterTable.Component.Task.TaskActivity")
local base = UIBaseContainer
local this_path = ""
local time_txt_path = "TimeBg/TimeText"

function UIMainPiggyBankBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainPiggyBankBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainPiggyBankBtn:ComponentDefine()
  self.timeText = self:AddComponent(UIText, time_txt_path)
  self.piggyBankBtn = self:AddComponent(UIButton, this_path)
  self.piggyBankBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIMainPiggyBankBtn:ComponentDestroy()
  self.timeText = nil
  self.piggyBankBtn = nil
end

function UIMainPiggyBankBtn:DataDefine()
  function self.timer_call_back()
    self:RefreshPerSecond()
  end
end

function UIMainPiggyBankBtn:DataDestroy()
  self.pack = nil
  self.endTime = nil
end

function UIMainPiggyBankBtn:ReInit()
  self:RefreshPiggyBankBtn()
end

function UIMainPiggyBankBtn:Refresh()
  self.pack = GiftPackageData.getPiggyBankPack()
  self.piggyBankBtn:SetActive(self.pack)
  if self.pack then
    self.endTime = self.pack:getEndTime()
    self:RemoveTimer()
    self:AddTimer()
  end
end

function UIMainPiggyBankBtn:OnEnable()
  base.OnEnable(self)
end

function UIMainPiggyBankBtn:OnDisable()
  base.OnDisable(self)
end

function UIMainPiggyBankBtn:RefreshPiggyBankBtn()
end

function UIMainPiggyBankBtn:TryShowPiggyBankNoticeTime()
end

function UIMainPiggyBankBtn:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_call_back, self, false, false, false)
  end
  self.timer:Start()
end

function UIMainPiggyBankBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainPiggyBankBtn:RefreshPerSecond()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local restTime = self.endTime - curTime
  if restTime < 0 then
    self.piggyBankBtn:SetActive(false)
    self:RemoveTimer()
    return
  end
  local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
  self.timeText:SetText(restTimeStr)
end

function UIMainPiggyBankBtn:OnBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.PiggyBank)
end

return UIMainPiggyBankBtn
