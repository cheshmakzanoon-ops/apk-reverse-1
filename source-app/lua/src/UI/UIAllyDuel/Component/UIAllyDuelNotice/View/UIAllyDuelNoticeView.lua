local UIAllyDuelNoticeView = BaseClass("UIAllyDuelNoticeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "safeArea/rightLayer/titleTxt"
local subTitle_path = "safeArea/rightLayer/desTxt"
local remainTimeTip_path = "safeArea/rightLayer/Time/timeTip"
local remainTime_path = "safeArea/rightLayer/Time/remainT"
local backBtn_path = "safeArea/topLeftLayer/closeBtn"
local ruleBtn_path = "safeArea/rightLayer/Btns/ruleBtn"
local ruleBtnTxt_path = "safeArea/rightLayer/Btns/ruleBtn/ruleTxt"
local techBtn_path = "safeArea/rightLayer/Btns/techBtn"
local techBtnTxt_path = "safeArea/rightLayer/Btns/techBtn/techTxt"
local rewardBtn_path = "safeArea/rightLayer/rewardBtn"
local rewardBtnTxt_path = "safeArea/rightLayer/rewardBtn/rewardBtnTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshAll()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.remainTimeTipN = self:AddComponent(UIText, remainTimeTip_path)
  self.remainTimeN = self:AddComponent(UIText, remainTime_path)
  self.closeBtnN = self:AddComponent(UIButton, backBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ruleBtnN = self:AddComponent(UIButton, ruleBtn_path)
  self.ruleBtnN:SetOnClick(function()
    self:OnClickRuleBtn()
  end)
  self.ruleBtnTxtN = self:AddComponent(UIText, ruleBtnTxt_path)
  self.techBtnN = self:AddComponent(UIButton, techBtn_path)
  self.techBtnN:SetOnClick(function()
    self:OnClickTechBtn()
  end)
  self.techBtnN:SetActive(false)
  self.techBtnTxtN = self:AddComponent(UIText, techBtnTxt_path)
  self.rewardBtnN = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtnN:SetOnClick(function()
    self:OnClickRewardBtn()
  end)
  self.rewardBtnTxtN = self:AddComponent(UIText, rewardBtnTxt_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.subTitleN = nil
  self.remainTimeTipN = nil
  self.closeBtnN = nil
  self.ruleBtnN = nil
  self.ruleBtnTxtN = nil
  self.techBtnN = nil
  self.techBtnTxtN = nil
  self.rewardBtnN = nil
  self.rewardBtnTxtN = nil
end

local function DataDefine(self)
  self.noticeEndT = nil
  self.noticeTimer = nil
end

local function DataDestroy(self)
  self.noticeEndT = nil
  self:DelNoticeTimer()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshAll(self)
  self.titleN:SetLocalText(361000)
  self.subTitleN:SetLocalText(372113)
  self.remainTimeTipN:SetLocalText(372114)
  self.ruleBtnTxtN:SetLocalText(372116)
  self.techBtnTxtN:SetLocalText(372117)
  self.rewardBtnTxtN:SetLocalText(100072)
  self.noticeEndT = self.ctrl:GetNoticeEndTime()
  if self.noticeEndT then
    self:RefreshRemainTime()
    self:AddNoticeTimer()
  end
end

local function AddNoticeTimer(self)
  function self.NoticeTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.noticeTimer == nil then
    self.noticeTimer = TimerManager:GetInstance():GetTimer(1, self.NoticeTimerAction, self, false, false, false)
  end
  self.noticeTimer:Start()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.noticeEndT - curTime
  if 0 < remainTime then
    self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:DelNoticeTimer()
    self.ctrl:CloseSelf()
  end
end

local function DelNoticeTimer(self)
  if self.noticeTimer ~= nil then
    self.noticeTimer:Stop()
    self.noticeTimer = nil
  end
end

local function GetTimeParams(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.noticeEndT - curTime
  local secs, delta = math.modf(remainTime / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  return day, hour, minute, second
end

local function OnClickRuleBtn(self)
  local strTitle = Localization:GetString("361000")
  local subTitle = Localization:GetString("100239")
  local strContent = Localization:GetString("372156")
  UIUtil.ShowIntro(strTitle, subTitle, strContent)
end

local function OnClickTechBtn(self)
end

local function OnClickRewardBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIAllyDuelRewardPanel, {anim = true})
end

UIAllyDuelNoticeView.OnCreate = OnCreate
UIAllyDuelNoticeView.OnDestroy = OnDestroy
UIAllyDuelNoticeView.ComponentDefine = ComponentDefine
UIAllyDuelNoticeView.ComponentDestroy = ComponentDestroy
UIAllyDuelNoticeView.DataDefine = DataDefine
UIAllyDuelNoticeView.DataDestroy = DataDestroy
UIAllyDuelNoticeView.OnAddListener = OnAddListener
UIAllyDuelNoticeView.OnRemoveListener = OnRemoveListener
UIAllyDuelNoticeView.RefreshAll = RefreshAll
UIAllyDuelNoticeView.AddNoticeTimer = AddNoticeTimer
UIAllyDuelNoticeView.RefreshRemainTime = RefreshRemainTime
UIAllyDuelNoticeView.DelNoticeTimer = DelNoticeTimer
UIAllyDuelNoticeView.GetTimeParams = GetTimeParams
UIAllyDuelNoticeView.OnClickRuleBtn = OnClickRuleBtn
UIAllyDuelNoticeView.OnClickTechBtn = OnClickTechBtn
UIAllyDuelNoticeView.OnClickRewardBtn = OnClickRewardBtn
return UIAllyDuelNoticeView
