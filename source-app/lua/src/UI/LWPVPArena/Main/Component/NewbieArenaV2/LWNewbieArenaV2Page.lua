local base = UIBaseContainer
local LWNewbieArenaV2Page = BaseClass("LWNewbieArenaV2Page", base)
local UIAreaWait = require("UI.LWPVPArena.Main.Component.NewbieArenaV2.LWNewbieArenaV2Wait")
local UIAreaRank = require("UI.LWPVPArena.Main.Component.NewbieArenaV2.LWNewbieArenaV2Rank")
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

function LWNewbieArenaV2Page:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTick, self, false, false, false)
  self.timer:Start()
  self:OnTick()
  self.__tmpFlag_checkDefence = nil
end

function LWNewbieArenaV2Page:OnDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:ClearWaitingForMsg()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWNewbieArenaV2Page:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function LWNewbieArenaV2Page:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWNewbieArenaV2Page:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ServerError, self.OnServerError)
  self:AddUIListener(EventId.ActivityArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:AddUIListener(EventId.ActivityArenaRewardPreivewBack, self.OnPreviewRewardMsgBack)
  self:AddUIListener(EventId.ActivityArenaBattlePreviewBack, self.OnPreviewBattleMsgBack)
  self:AddUIListener(EventId.ActivityArenaV2LogsBack, self.OnGetLogsBack)
  self:AddUIListener(EventId.ActivityArenaReceiveBack, self.OnReceiveBack)
  self:AddUIListener(EventId.ActivityArenaBattleListBack, self.OnBattleListBack)
  self.notiBook = {}
  Notifier.AddListener("LWNewbieArenaV2PageArea.ShowRules", self.ShowRules, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.ShowRewards", self.ShowRewards, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.ShowRecords", self.ShowRecords, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.GotoShop", self.GotoShop, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.EditDefenceTeam", self.EditDefenceTeam, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.ChallengeOther", self.ChallengeOther, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.CheckOther", self.CheckOther, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.RevangeFromRecord", self.RevangeFromRecord, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.ViewOther", self.ViewOther, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.AddChallengeTimes", self.AddChallengeTimes, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.RefreshChallengeTimes", self.RefreshChallengeTimes, self, self.notiBook)
  Notifier.AddListener("LWNewbieArenaV2PageArea.BattleList", self.GetChallengeList, self, self.notiBook)
end

function LWNewbieArenaV2Page:OnRemoveListener()
  self:RemoveUIListener(EventId.ServerError, self.OnServerError)
  self:RemoveUIListener(EventId.ActivityArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:RemoveUIListener(EventId.ActivityArenaRewardPreivewBack, self.OnPreviewRewardMsgBack)
  self:RemoveUIListener(EventId.ActivityArenaBattlePreviewBack, self.OnPreviewBattleMsgBack)
  self:RemoveUIListener(EventId.ActivityArenaV2LogsBack, self.OnGetLogsBack)
  self:RemoveUIListener(EventId.ActivityArenaReceiveBack, self.OnReceiveBack)
  self:RemoveUIListener(EventId.ActivityArenaBattleListBack, self.OnBattleListBack)
  Notifier.RemoveListenerByBook(self.notiBook)
  base.OnRemoveListener(self)
end

function LWNewbieArenaV2Page:CloseAllPopups()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaRules)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaRewards)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaRecords)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaBuyTimes)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaViewOther)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaChallengeList)
end

function LWNewbieArenaV2Page:OnTick()
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

function LWNewbieArenaV2Page:SetWaitingForMsg()
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

function LWNewbieArenaV2Page:ClearWaitingForMsg()
  self.__waitingForMsg = false
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function LWNewbieArenaV2Page:Refresh()
  local info = DataCenter.LWNewbieArenaV2Manager.info
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

function LWNewbieArenaV2Page:ShowRules()
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

function LWNewbieArenaV2Page:ShowRewards(achieveId)
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  __tempShowAchieveId = achieveId
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2RewardPreview, self.info.id)
end

function LWNewbieArenaV2Page:ShowRecords()
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2Logs, self.info.id)
end

function LWNewbieArenaV2Page:GotoShop()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.HonorShop)
end

function LWNewbieArenaV2Page:EditDefenceTeam()
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2BattlePreview, self.info.id)
end

function LWNewbieArenaV2Page:ChallengeOther(targetRank)
  local function ParseEnemyData(data)
    local power = 0
    
    local uid
    local pic = ""
    local picVer
    if data ~= nil then
      local shareInfo = data.shareInfo
      if shareInfo then
        if data.formationPower and 0 < data.formationPower then
          power = data.formationPower
        else
          power = data.shareInfo.power
        end
        uid = data.shareInfo.uid
        pic = data.shareInfo.pic
        picVer = data.shareInfo.picver
      else
        local powerStr = LocalController:instance():getValue(TableName.LWArmy, data.playerId, "pve_power")
        local powerStrArr = string.split(powerStr, "|")
        local totalPower = 0
        for _, powStr in ipairs(powerStrArr) do
          totalPower = totalPower + tonumber(powStr)
        end
        power = totalPower
        pic = LoadPath.HeroIconsSmallPath .. LocalController:instance():getValue(TableName.LWArmy, data.playerId, "army_icon")
      end
    end
    return {
      uid = uid,
      pic = pic,
      picVer = picVer
    }, power
  end
  
  if not targetRank then
    return
  end
  if not self.info then
    return
  end
  local targetData = DataCenter.LWNewbieArenaV2Manager:GetBattleListDataByPlayerRank(targetRank)
  if self.info.remainFree <= 0 then
    self:AddChallengeTimes(targetRank)
  else
    local showSoldierLevelConfirmWindow = false
    local mySoldierTemplate, targetSoldierTemplate
    local info = DataCenter.LWNewbieArenaV2Manager.info
    if info ~= nil and targetData ~= nil then
      local mySoldierId = checknumber(info.rankInfo.myFormationSoldier)
      local enemySoldierId = checknumber(targetData.formationSoldier)
      if 0 < mySoldierId and 0 < enemySoldierId then
        mySoldierTemplate = DataCenter.SoldierDataManager:GetTemplate(mySoldierId)
        targetSoldierTemplate = DataCenter.SoldierDataManager:GetTemplate(enemySoldierId)
        if mySoldierTemplate ~= nil and targetSoldierTemplate ~= nil then
          local isMySoldierLevelLower = mySoldierTemplate.lv < targetSoldierTemplate.lv
          if isMySoldierLevelLower then
            showSoldierLevelConfirmWindow = true
          end
        end
      end
    end
    if showSoldierLevelConfirmWindow then
      local param = {}
      param.myPower = DataCenter.LWNewbieArenaV2Manager:GetMyPower()
      
      function param.confirmCallback()
        if self.__waitingForMsg then
          return
        end
        self:SetWaitingForMsg()
        SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2BattlePreview, self.info.id, targetRank)
      end
      
      param.myHeadData = {
        uid = LuaEntry.Player:GetUid(),
        pic = LuaEntry.Player:GetPic(),
        picVer = LuaEntry.Player.picVer,
        headSkinPath = LuaEntry.Player:GetHeadBgImg()
      }
      param.mySoldierData = mySoldierTemplate
      local parseEnemyData, enemyPower = ParseEnemyData(targetData)
      param.enemyPower = enemyPower
      param.enemyHeadData = parseEnemyData
      param.enemySoldierData = targetSoldierTemplate
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWPVPArenaSoldierConfirm, {anim = true}, param)
    else
      if self.__waitingForMsg then
        return
      end
      self:SetWaitingForMsg()
      SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2BattlePreview, self.info.id, targetRank)
    end
  end
end

function LWNewbieArenaV2Page:CheckOther(targetRank)
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
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2BattlePreview, self.info.id, targetRank)
end

function LWNewbieArenaV2Page:RevangeFromRecord(targetUid)
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
    SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2BattlePreview, self.info.id, targetRank)
  end
end

function LWNewbieArenaV2Page:ViewOther(targetRank)
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
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2BattlePreview, self.info.id, targetRank)
end

function LWNewbieArenaV2Page:GetChallengeList()
  if not self.info then
    return
  end
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaBattleList, self.info.id)
end

function LWNewbieArenaV2Page:AddChallengeTimes(targetRank)
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

function LWNewbieArenaV2Page:RefreshChallengeTimes()
  if not self.info then
    return
  end
  self.areaRank:RefreshChallengeTimes(self.info)
end

function LWNewbieArenaV2Page:OnServerError(msgName)
  if string.startswith(msgName, "activity.arena") then
    self:ClearWaitingForMsg()
  end
end

function LWNewbieArenaV2Page:OnArenaInfoUpdate(activityId)
  if self.info and tonumber(activityId) == tonumber(self.info.id) then
    self:ClearWaitingForMsg()
    self:Refresh()
  end
end

function LWNewbieArenaV2Page:OnPreviewRewardMsgBack(msgTbl)
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

function LWNewbieArenaV2Page:OnGetLogsBack(msgTbl)
  self:CloseAllPopups()
  self:ClearWaitingForMsg()
  self.info.logs = msgTbl.logs
  self.info.defLoseTimes = 0
  self.areaRank:RefreshRecordsRedDot(0)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaRecords, {anim = true}, self.info)
end

function LWNewbieArenaV2Page:OnPreviewBattleMsgBack(msgTbl)
  self:ClearWaitingForMsg()
  if not self.info then
    return
  end
  if not msgTbl.otherInfo then
    self:CloseAllPopups()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ActivityArenaV2Defence, msgTbl.ownerInfo, self.info.id)
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
      msgTbl.otherInfo.formationPower = nil
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
      param.enterType = PVEEnterType.ActivityArenaV2
      param.levelId = -1
      param.sceneId = 51
      param.extraData = {}
      param.extraData.activityId = self.info.id
      param.extraData.ownerInfo = msgTbl.ownerInfo
      param.extraData.otherInfo = msgTbl.otherInfo
      param.extraData.otherRank = msgTbl.rank
      self:CloseAllPopups()
      DataCenter.LWBattleManager:Enter(param)
    else
      self.__tmpFlag_checkDefence = nil
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaViewOther, {anim = true}, msgTbl.otherInfo)
    end
  end
end

function LWNewbieArenaV2Page:OnReceiveBack(msgTbl)
  if not self.info then
    return
  end
  self.info.hasAchieveReward = math.max(0, self.info.hasAchieveReward - 1)
  self.areaRank:RefreshRewardsRedDot(self.info.hasAchieveReward)
end

function LWNewbieArenaV2Page:OnBattleListBack(msgTbl)
  self:ClearWaitingForMsg()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaChallengeList, {anim = true}, msgTbl, PVPArenaType.NewbieArenaV2)
end

function LWNewbieArenaV2Page:Init(pagePara1)
  self:Refresh()
  assert(DataCenter.LWNewbieArenaV2Manager.info, "DataCenter.LWNewbieArenaV2Manager.info is nil")
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(DataCenter.LWNewbieArenaV2Manager.info.id))
end

return LWNewbieArenaV2Page
