local LeagueMatchNoticePanel = BaseClass("LeagueMatchNoticePanel", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "title"
local subTitle_path = "subTitle"
local infoBtn_path = "rightLayer/infoBtn"
local rewardBtn_path = "rightLayer/rewardBtn"
local rewardBtnTxt_path = "rightLayer/rewardBtn/rewawdTxt"
local cdTime_path = "cdTime"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.baseInfo = nil
end

local function DataDestroy(self)
  self.baseInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.subTitleN:SetLocalText("372617")
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.rewardBtnN = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtnN:SetOnClick(function()
    self:OnClickRewardBtn()
  end)
  self.rewardBtnTxtN = self:AddComponent(UIText, rewardBtnTxt_path)
  self.rewardBtnTxtN:SetLocalText(100072)
  self.cdTimeN = self:AddComponent(UIText, cdTime_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.subTitleN = nil
  self.infoBtnN = nil
  self.rewardBtnN = nil
  self.cdTimeN = nil
end

local function ShowPanel(self)
  self:RefreshAll()
end

local function RefreshAll(self)
  if IsNull(self.gameObject) then
    return
  end
  self.baseInfo = DataCenter.LeagueMatchManager:GetLeagueMatchBaseInfo()
  if not self.baseInfo then
    return
  end
  self.titleN:SetLocalText("372616", self.baseInfo.season)
  self.subTitleN:SetLocalText("372617")
  self:AddCountDownTimer()
end

local function AddCountDownTimer(self)
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
  self:RefreshRemainTime()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.baseInfo.drawStartTime - curTime
  if 0 < remainTime then
    self.cdTimeN:SetText(Localization:GetString("372618", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
  else
    self.cdTimeN:SetText("")
    self:DelCountDownTimer()
    DataCenter.LeagueMatchManager:GetMyMatchInfoReq()
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function OnClickInfoBtn(self)
  UIUtil.ShowIntro(Localization:GetString("100239"), Localization:GetString("100239"), Localization:GetString("372813"))
end

local function OnClickRewardBtn(self)
  local targetTab = 3
  local targetSeg = DataCenter.LeagueMatchManager:GetSegment()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILeagueMatchReward, {anim = true}, targetTab, targetSeg)
end

LeagueMatchNoticePanel.OnCreate = OnCreate
LeagueMatchNoticePanel.OnDestroy = OnDestroy
LeagueMatchNoticePanel.DataDefine = DataDefine
LeagueMatchNoticePanel.DataDestroy = DataDestroy
LeagueMatchNoticePanel.ComponentDefine = ComponentDefine
LeagueMatchNoticePanel.ComponentDestroy = ComponentDestroy
LeagueMatchNoticePanel.OnAddListener = OnAddListener
LeagueMatchNoticePanel.OnRemoveListener = OnRemoveListener
LeagueMatchNoticePanel.RefreshAll = RefreshAll
LeagueMatchNoticePanel.AddCountDownTimer = AddCountDownTimer
LeagueMatchNoticePanel.RefreshRemainTime = RefreshRemainTime
LeagueMatchNoticePanel.DelCountDownTimer = DelCountDownTimer
LeagueMatchNoticePanel.OnClickInfoBtn = OnClickInfoBtn
LeagueMatchNoticePanel.OnClickRewardBtn = OnClickRewardBtn
LeagueMatchNoticePanel.ShowPanel = ShowPanel
return LeagueMatchNoticePanel
