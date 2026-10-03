local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIArenaNewbie = BaseClass("UIArenaNewbie", base)
local UIAreaWait = require("UI.UIActivityCenterTable.Component.ArenaNewbie.UIArenaNewbieAreaWait")
local UIAreaRank = require("UI.UIActivityCenterTable.Component.ArenaNewbie.UIArenaNewbieAreaRank")
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local compBook = {
  {
    path = "areaWait",
    name = "areaWait",
    type = UIAreaWait
  },
  {
    path = "areaRank",
    name = "areaRank",
    type = UIAreaRank
  },
  {
    path = "btnInfo",
    name = "btnInfo",
    type = UIButton,
    onClick = function(self)
      self:ShowRules()
    end
  }
}

function UIArenaNewbie:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTick, self, false, false, false)
  self.timer:Start()
  self:Refresh()
  self:OnTick()
  self.__tmpFlag_checkDefence = nil
  assert(DataCenter.LWNewbieArenaManager.info, "DataCenter.LWNewbieArenaManager.info is nil")
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(DataCenter.LWNewbieArenaManager.info.id))
end

function UIArenaNewbie:OnDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:ClearWaitingForMsg()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIArenaNewbie:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIArenaNewbie:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIArenaNewbie:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ServerError, self.OnServerError)
  self:AddUIListener(EventId.ActivityArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:AddUIListener(EventId.ActivityArenaRewardPreivewBack, self.OnPreviewRewardMsgBack)
  self:AddUIListener(EventId.ActivityArenaBattlePreviewBack, self.OnPreviewBattleMsgBack)
  self:AddUIListener(EventId.ActivityArenaLogsBack, self.OnGetLogsBack)
  self:AddUIListener(EventId.ActivityArenaReceiveBack, self.OnReceiveBack)
  self.notiBook = {}
  Notifier.AddListener("UIArenaNewbieArea.ShowRules", self.ShowRules, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.ShowRewards", self.ShowRewards, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.ShowRecords", self.ShowRecords, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.GotoShop", self.GotoShop, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.EditDefenceTeam", self.EditDefenceTeam, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.ChallengeOther", self.ChallengeOther, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.CheckOther", self.CheckOther, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.RevangeFromRecord", self.RevangeFromRecord, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.ViewOther", self.ViewOther, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.AddChallengeTimes", self.AddChallengeTimes, self, self.notiBook)
  Notifier.AddListener("UIArenaNewbieArea.RefreshChallengeTimes", self.RefreshChallengeTimes, self, self.notiBook)
end

function UIArenaNewbie:OnRemoveListener()
  self:RemoveUIListener(EventId.ServerError, self.OnServerError)
  self:RemoveUIListener(EventId.ActivityArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:RemoveUIListener(EventId.ActivityArenaRewardPreivewBack, self.OnPreviewRewardMsgBack)
  self:RemoveUIListener(EventId.ActivityArenaBattlePreviewBack, self.OnPreviewBattleMsgBack)
  self:RemoveUIListener(EventId.ActivityArenaLogsBack, self.OnGetLogsBack)
  self:RemoveUIListener(EventId.ActivityArenaReceiveBack, self.OnReceiveBack)
  Notifier.RemoveListenerByBook(self.notiBook)
  base.OnRemoveListener(self)
end

function UIArenaNewbie:CloseAllPopups()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaRules)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaRewards)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaRecords)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaBuyTimes)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaViewOther)
end

function UIArenaNewbie:OnTick()
  if not self.info then
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local targetTime = self.info.targetTime
  if targetTime then
    local remainTime = targetTime - serverTime
    if 0 < remainTime then
      self.areaWait:RefreshTimer(remainTime)
      self.areaRank:RefreshTimer(remainTime, self.info.state)
    else
      self.areaWait:RefreshTimer(0)
      self.areaRank:RefreshTimer(0, self.info.state)
      if self.info and self.info.state < ActivityArenaState.Over then
        if self.__waitingForMsg then
          return
        end
        self:SetWaitingForMsg()
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.info.id))
      end
    end
  end
end

function UIArenaNewbie:SetWaitingForMsg()
  if not self.__waitingForMsg then
    self.__waitingForMsg = true
    if self.delayTimer then
      self.delayTimer:Stop()
    end
    self.delayTimer = TimerManager:GetInstance():GetTimer(6, function()
      self.__waitingForMsg = false
    end, self, true, true)
  end
end

function UIArenaNewbie:ClearWaitingForMsg()
  self.__waitingForMsg = false
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIArenaNewbie:Refresh()
  local info = DataCenter.LWNewbieArenaManager.info
  if not info then
    return
  end
  self.info = info
  if info.state == ActivityArenaState.Wait then
    self.areaWait:SetActive(true)
    self.areaRank:SetActive(false)
    self.areaWait:Refresh(info)
  else
    self.areaWait:SetActive(false)
    self.areaRank:SetActive(true)
    self.areaRank:Refresh(info)
  end
end

function UIArenaNewbie:ShowRules()
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:CloseAllPopups()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaRules, {anim = true}, LocalController:instance():getValue(TableName.Activity, self.info.id, "desc"))
end

local __tempShowAchieveId

function UIArenaNewbie:ShowRewards(achieveId)
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  __tempShowAchieveId = achieveId
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaRewardPreivew, self.info.id)
end

function UIArenaNewbie:ShowRecords()
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaLogs, self.info.id)
end

function UIArenaNewbie:GotoShop()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.HonorShop)
end

function UIArenaNewbie:EditDefenceTeam()
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaBattlePreview, self.info.id)
end

function UIArenaNewbie:ChallengeOther(targetRank)
  if not targetRank then
    return
  end
  if not self.info then
    return
  end
  if self.info.remainFree <= 0 then
    self:AddChallengeTimes(targetRank)
  else
    if self.__waitingForMsg then
      return
    end
    self:SetWaitingForMsg()
    SFSNetwork.SendMessage(MsgDefines.ActivityArenaBattlePreview, self.info.id, targetRank)
  end
end

function UIArenaNewbie:CheckOther(targetRank)
  if not targetRank then
    return
  end
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  self.__tmpFlag_checkDefence = true
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaBattlePreview, self.info.id, targetRank)
end

function UIArenaNewbie:RevangeFromRecord(targetUid)
  if not targetUid then
    return
  end
  if not self.info then
    return
  end
  if not self.info.rankInfo then
    return
  end
  local targetRank
  for _, rankData in ipairs(self.info.rankInfo.dataList) do
    if tostring(rankData.playerId) == tostring(targetUid) then
      targetRank = rankData.rank
      break
    end
  end
  if not targetRank then
    return
  end
  if self.info.remainFree <= 0 then
    self:AddChallengeTimes(targetRank)
  else
    if self.__waitingForMsg then
      return
    end
    self:SetWaitingForMsg()
    SFSNetwork.SendMessage(MsgDefines.ActivityArenaBattlePreview, self.info.id, targetRank)
  end
end

function UIArenaNewbie:ViewOther(targetRank)
  if not targetRank then
    return
  end
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaBattlePreview, self.info.id, targetRank)
end

function UIArenaNewbie:AddChallengeTimes(targetRank)
  if self.info.remainBuy <= 0 then
    UIUtil.ShowTipsId(500268)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaBuyTimes, {anim = true}, self.info, function()
      if targetRank then
        self:ChallengeOther(targetRank)
      end
    end)
  end
end

function UIArenaNewbie:RefreshChallengeTimes()
  if not self.info then
    return
  end
  self.areaRank:RefreshChallengeTimes(self.info)
end

function UIArenaNewbie:OnServerError(msgName)
  if string.startswith(msgName, "activity.arena") then
    self:ClearWaitingForMsg()
  end
end

function UIArenaNewbie:OnArenaInfoUpdate(activityId)
  if self.info and tonumber(activityId) == tonumber(self.info.id) then
    self:ClearWaitingForMsg()
    self:Refresh()
  end
end

function UIArenaNewbie:OnPreviewRewardMsgBack(msgTbl)
  self:CloseAllPopups()
  self:ClearWaitingForMsg()
  if not self.info then
    return
  end
  msgTbl.state = self.info.state
  msgTbl.myRank = self.info.rankInfo and self.info.rankInfo.myRank or 0
  msgTbl.targetTime = self.info.targetTime
  msgTbl.activityId = self.info.id
  msgTbl.anchorAchieveId = __tempShowAchieveId
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaRewards, {anim = true}, msgTbl)
end

function UIArenaNewbie:OnGetLogsBack(msgTbl)
  self:CloseAllPopups()
  self:ClearWaitingForMsg()
  self.info.logs = msgTbl.logs
  self.info.defLoseTimes = 0
  self.areaRank:RefreshRecordsRedDot(0)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaRecords, {anim = true}, self.info)
end

function UIArenaNewbie:OnPreviewBattleMsgBack(msgTbl)
  self:CloseAllPopups()
  self:ClearWaitingForMsg()
  if not self.info then
    return
  end
  if not msgTbl.otherInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ActivityArenaDefence, msgTbl.ownerInfo, self.info.id)
  else
    if msgTbl.otherInfo.isPlayer ~= 1 then
      local fakeName = Localization:GetString(LocalController:instance():getValue(TableName.LWArmy, msgTbl.otherInfo.armyId, "name"))
      local powerStr = LocalController:instance():getValue(TableName.LWArmy, msgTbl.otherInfo.armyId, "pve_power")
      local powerStrArr = string.split(powerStr, "|")
      local fakePower = 0
      for _, power in ipairs(powerStrArr) do
        fakePower = fakePower + tonumber(power)
      end
      local fakeIconRes = LoadPath.HeroIconsSmallPath .. LocalController:instance():getValue(TableName.LWArmy, msgTbl.otherInfo.armyId, "army_icon")
      msgTbl.otherInfo.playerInfo = {
        careerType = 0,
        gender = 1,
        countryflag = "",
        pic = fakeIconRes,
        picver = nil,
        allianceId = "",
        uid = nil,
        careerLevel = 0,
        name = fakeName,
        headFrame = 0,
        allianceName = "",
        power = fakePower,
        abbr = ""
      }
    end
    if self.info.state == ActivityArenaState.Fight and not self.__tmpFlag_checkDefence then
      local param = {}
      param.type = PVEType.FakePVP
      param.enterType = PVEEnterType.ActivityArena
      param.levelId = -1
      param.sceneId = 51
      param.extraData = {}
      param.extraData.activityId = self.info.id
      param.extraData.ownerInfo = msgTbl.ownerInfo
      param.extraData.otherInfo = msgTbl.otherInfo
      param.extraData.otherRank = msgTbl.rank
      DataCenter.LWBattleManager:Enter(param)
    else
      self.__tmpFlag_checkDefence = nil
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaViewOther, {anim = true}, msgTbl.otherInfo)
    end
  end
end

function UIArenaNewbie:OnReceiveBack(msgTbl)
  if not self.info then
    return
  end
  self.info.hasAchieveReward = math.max(0, self.info.hasAchieveReward - 1)
  self.areaRank:RefreshRewardsRedDot(self.info.hasAchieveReward)
end

return UIArenaNewbie
