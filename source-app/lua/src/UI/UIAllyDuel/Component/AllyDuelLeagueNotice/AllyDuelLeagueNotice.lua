local AllyDuelLeagueNotice = BaseClass("AllyDuelLeagueNotice", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllyDuelHistoryReward = require("UI.UIAllyDuel.Component.AllyDuelHistory.AllyDuelHistoryReward")

function AllyDuelLeagueNotice:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelLeagueNotice:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelLeagueNotice:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compAfter = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.title = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compPreview = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compReward = self.viewSkin:AddComponent(self, AllyDuelHistoryReward, 5)
  self.localTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.cupBg = self.viewSkin:AddComponent(self, UIRawImage, 7)
  self.cup = self.viewSkin:AddComponent(self, UIRawImage, 8)
  self.compStart = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.tipsItem = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.grade = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnStart = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnStart:SetOnClick(function()
    self:OnBtnStartClick()
  end)
end

function AllyDuelLeagueNotice:ComponentDestroy()
  self.viewSkin = nil
  self.compAfter = nil
  self.title = nil
  self.compPreview = nil
  self.btnInfo = nil
  self.compReward = nil
  self.localTime = nil
  self.cupBg = nil
  self.cup = nil
  self.compStart = nil
  self.tipsItem = nil
  self.grade = nil
  self.btnStart = nil
end

function AllyDuelLeagueNotice:DataDefine()
end

function AllyDuelLeagueNotice:DataDestroy()
end

function AllyDuelLeagueNotice:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.Refresh)
  self:AddUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.UpdateReward)
end

function AllyDuelLeagueNotice:OnRemoveListener()
  self:RemoveUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.Refresh)
  self:RemoveUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.UpdateReward)
  base.OnRemoveListener(self)
end

function AllyDuelLeagueNotice:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIUtil.ShowIntro(Localization:GetString("100239"), Localization:GetString("100239"), Localization:GetString("372813"))
end

function AllyDuelLeagueNotice:OnBtnStartClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("alliance_duel10004")
    return
  end
  DataCenter.LeagueMatchManager:SetHasSeenGroupResult()
  EventManager:GetInstance():Broadcast(EventId.AllyDuelLeagueStart)
end

function AllyDuelLeagueNotice:ShowPanel()
  self:Refresh()
end

function AllyDuelLeagueNotice:Refresh()
  local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
  local baseInfo = DataCenter.LeagueMatchManager:GetLeagueMatchBaseInfo()
  self.compPreview:SetActive(baseInfo ~= nil and tempStage == LeagueMatchStage.Preview)
  self.compStart:SetActive(baseInfo ~= nil and tempStage == LeagueMatchStage.GroupResult)
  self.compAfter:SetActive(baseInfo ~= nil and tempStage == LeagueMatchStage.FinalSummary)
  if baseInfo == nil then
    self.countDown = nil
    self.title:SetText("")
    self.localTime:SetActive(false)
    return
  end
  self.localTime:SetActive(true)
  self.title:SetLocalText("459001", baseInfo.season)
  DataCenter.LeagueMatchManager:SetCup(self.cup, self.cupBg, self.grade)
  self:RefreshReward()
  if tempStage == LeagueMatchStage.Preview then
    self.countDown = baseInfo.seasonStartTime
  elseif tempStage == LeagueMatchStage.GroupResult then
    self.countDown = baseInfo.seasonStartTime
  elseif tempStage == LeagueMatchStage.FinalSummary then
    self.countDown = baseInfo.seasonEndTime
  else
    self.countDown = nil
    self.localTime:SetActive(false)
  end
  self:Update1000MS()
end

function AllyDuelLeagueNotice:Update1000MS()
  if self.countDown == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.countDown - now
  if 0 < remainTime then
    self.localTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.countDown = nil
    self.localTime:SetActive(false)
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LeagueMatchManager:GetMyMatchInfoReq()
    end, 10 * math.random())
  end
end

function AllyDuelLeagueNotice:RefreshReward()
  DataCenter.LeagueMatchManager:GetLeagueMatchRewardInfoReq(3)
  self:UpdateReward()
end

function AllyDuelLeagueNotice:UpdateReward()
  self.curSegment = DataCenter.LeagueMatchManager:GetSegment()
  self.compReward:SetLeague(self.curSegment)
end

return AllyDuelLeagueNotice
