local LWBerserkBossManager = BaseClass("LWBerserkBossManager")
local LWBerserkBossInfo = require("DataCenter.LWBerserkBoss.LWBerserkBossInfo")
local LWBerserkBossRewardAndAttackTimesInfo = require("DataCenter.LWBerserkBoss.LWBerserkBossRewardAndAttackTimesInfo")
local LWBerserkBossAchievementRewardInfo = require("DataCenter.LWBerserkBoss.LWBerserkBossAchievementRewardInfo")
local LWBerserkBossRankRewardInfo = require("DataCenter.LWBerserkBoss.LWBerserkBossRankRewardInfo")
local Localization = CS.GameEntry.Localization
local PersonalDamageStatisticsData = {
  playerUid = "",
  damagesList = {}
}
local OneData = DataClass("OneData", PersonalDamageStatisticsData)

function LWBerserkBossManager:__init()
  self.berserkBossDict = {}
  self.berserkBossRewardAndAttackTimesDict = {}
  self.berserkBossAchievementRewardDict = {}
  self.berserkBossRankRewardList = {}
  self.seePersonalDamageStatistics = nil
  self.remainPraise = 0
  self.isFromActivityJumpToWorldBossMark = false
  self.selfRankInfo = nil
  self.personalRankDict = {}
  self.selfAllianceRankInfo = nil
  self.allianceRankDict = {}
  self.allianceDamageRankList = {}
end

function LWBerserkBossManager:__delete()
  self.berserkBossDict = nil
  self.berserkBossRewardAndAttackTimesDict = nil
  self.berserkBossAchievementRewardDict = nil
  self.berserkBossRankRewardList = nil
  self.seePersonalDamageStatistics = nil
  self.remainPraise = nil
  self.isFromActivityJumpToWorldBossMark = nil
  self.selfRankInfo = nil
  self.personalRankDict = nil
  self.selfAllianceRankInfo = nil
  self.allianceRankDict = nil
  self.allianceDamageRankList = nil
end

function LWBerserkBossManager:InitData(message)
  local data = message.actBerserkBoss
  if data ~= nil then
    if data.remainPraise then
      self.remainPraise = data.remainPraise
    end
    if data.array then
      self:HandleUpdateBerserkBossRewardAndTimes(data.array, false)
    end
  end
end

function LWBerserkBossManager:RequestAllBerserkBossInfo()
  SFSNetwork.SendMessage(MsgDefines.UserGetAllBerserkBossMarch)
end

function LWBerserkBossManager:HandleInitAllBerserkBossInfo(message)
  local list = message.marches
  if list ~= nil then
    for k, v in pairs(list) do
      self:RefreshSingleBerserkBossInfo(v)
    end
    EventManager:GetInstance():Broadcast(EventId.GetAllBerserkBossInfoData)
  end
end

function LWBerserkBossManager:RequestSingleBerserkBossInfo(bossUuid)
  SFSNetwork.SendMessage(MsgDefines.UserGetSingleBerserkBossMarch, bossUuid)
end

function LWBerserkBossManager:HandleUpdateSingleBerserkBossInfo(message)
  local isChange = self:RefreshSingleBerserkBossInfo(message)
  if isChange then
    local uuid = message.uuid
    EventManager:GetInstance():Broadcast(EventId.UpdateSingleBerserkBossInfoData, uuid)
  end
end

function LWBerserkBossManager:RefreshSingleBerserkBossInfo(message)
  local isChange = false
  if message.uuid ~= nil then
    local uuid = message.uuid
    local berserkBossInfo
    if self.berserkBossDict[uuid] ~= nil then
      berserkBossInfo = self.berserkBossDict[uuid]
    else
      berserkBossInfo = LWBerserkBossInfo.New()
      self.berserkBossDict[uuid] = berserkBossInfo
    end
    if berserkBossInfo ~= nil then
      isChange = berserkBossInfo:InitData(message)
    end
  end
  return isChange
end

function LWBerserkBossManager:RequestBerserkBossKillRewardData(bossUuid)
  SFSNetwork.SendMessage(MsgDefines.BerserkBossReward, bossUuid)
end

function LWBerserkBossManager:HandleUpdateBerserkBossRewardAndTimes(arrData, isUpdate)
  if arrData ~= nil then
    local receiveRewardBossUuid = {}
    local needRemoveMarchData = {}
    for i, v in pairs(arrData) do
      local uuid = 0
      if v.uuid ~= nil then
        uuid = v.uuid
        if v.hasReward then
          table.insert(receiveRewardBossUuid, uuid)
        end
      end
      local isChangeReceiveReward = self:RefreshSingleBerserkBossRewardAndTimesInfo(v)
      if isChangeReceiveReward and 0 < uuid then
        table.insert(needRemoveMarchData, uuid)
      end
    end
    if 0 < table.count(receiveRewardBossUuid) and CS.GameEntry.Data.Player.SetReceiveBerserkBossRewardDic ~= nil then
      CS.GameEntry.Data.Player:SetReceiveBerserkBossRewardDic(receiveRewardBossUuid)
    end
    if isUpdate then
      if 0 < table.count(needRemoveMarchData) then
        for i = 1, table.count(needRemoveMarchData) do
          if CS.SceneManager:IsInWorld() then
            CS.SceneManager.World:DestroyBerserkBossMarchData(needRemoveMarchData[i])
          end
        end
      end
      EventManager:GetInstance():Broadcast(EventId.UpdateBerserkBossRewardAndAttackTimesData)
    end
  end
end

function LWBerserkBossManager:RefreshSingleBerserkBossRewardAndTimesInfo(message)
  local isChangeReceiveReward = false
  if message.uuid ~= nil then
    local uuid = message.uuid
    local info
    if self.berserkBossRewardAndAttackTimesDict[uuid] ~= nil then
      info = self.berserkBossRewardAndAttackTimesDict[uuid]
    else
      info = LWBerserkBossRewardAndAttackTimesInfo.New()
      self.berserkBossRewardAndAttackTimesDict[uuid] = info
    end
    if info ~= nil then
      local newReceiveReward = false
      if message.hasReward then
        newReceiveReward = message.hasReward
      end
      if not info.receivedReward and newReceiveReward then
        isChangeReceiveReward = true
      end
      info:InitData(message)
    end
  end
  return isChangeReceiveReward
end

function LWBerserkBossManager:RequestBerserkBossAchievementRewardInfo(activityId, bossUuid)
  local rewardList = self.berserkBossAchievementRewardDict[bossUuid]
  if table.count(rewardList) == 0 then
    SFSNetwork.SendMessage(MsgDefines.ActBerserkBossGetAchievementInfo, activityId, bossUuid)
  end
end

function LWBerserkBossManager:HandleRefreshBerserkBossAchievementRewardInfo(message)
  if message.uuid then
    local uuid = message.uuid
    local list = message.tasks
    local rewardList = {}
    if list ~= nil then
      for i, v in pairs(list) do
        local rewardInfo = LWBerserkBossAchievementRewardInfo.New()
        rewardInfo:InitData(v)
        table.insert(rewardList, rewardInfo)
      end
    end
    self.berserkBossAchievementRewardDict[uuid] = rewardList
    EventManager:GetInstance():Broadcast(EventId.GetBerserkBossAchievementRewardData, uuid)
  end
end

function LWBerserkBossManager:RequestBerserkBossRankInfo(type, bossUuid, rankStart, rankEnd)
  SFSNetwork.SendMessage(MsgDefines.ActBerserkBossGetRanInfo, type, bossUuid, rankStart, rankEnd)
end

function LWBerserkBossManager:HandleRefreshBerserkBossRankInfo(message)
  local type = message.type
  local bossUuid = message.uuid
  local selfInfo = message.self
  if selfInfo then
    if type == LWUIBerserkBossRankType.Personal then
      if self.selfRankInfo == nil then
        self.selfRankInfo = BasePlayerInfo.New()
      end
      self.selfRankInfo:ParseData(selfInfo, true)
      self.selfRankInfo.uid = LuaEntry.Player.uid
      self.selfRankInfo.score = selfInfo.score
      self.selfRankInfo.rank = selfInfo.rank
    elseif type == LWUIBerserkBossRankType.Alliance then
      if self.selfAllianceRankInfo == nil then
        self.selfAllianceRankInfo = AllianceRankData.New()
      end
      self.selfAllianceRankInfo.uid = LuaEntry.Player.allianceId
      self.selfAllianceRankInfo:ParseData(selfInfo)
      self.selfAllianceRankInfo:SetRank(selfInfo.rank)
    end
  end
  if type == LWUIBerserkBossRankType.Personal then
    if self.personalRankDict[bossUuid] then
      self.personalRankDict[bossUuid] = {}
    end
  elseif type == LWUIBerserkBossRankType.Alliance then
    self.allianceRankDict = {}
  end
  local rankingList = message.ranks
  if rankingList then
    for _, v in pairs(rankingList) do
      local rank = v.rank
      if type == LWUIBerserkBossRankType.Personal then
        if self.personalRankDict[bossUuid] == nil then
          self.personalRankDict[bossUuid] = {}
        end
        local rankDict = self.personalRankDict[bossUuid]
        local playerData
        if rankDict[rank] == nil then
          playerData = BasePlayerInfo.New()
          rankDict[rank] = playerData
        else
          playerData = rankDict[rank]
        end
        playerData:ParseData(v, true)
        playerData.score = v.score
        playerData.rank = v.rank
        if v.praise then
          playerData.praise = v.praise
        end
      elseif type == LWUIBerserkBossRankType.Alliance then
        local allianceData
        if self.allianceRankDict[rank] == nil then
          allianceData = AllianceRankData.New()
          self.allianceRankDict[rank] = allianceData
        else
          allianceData = self.allianceRankDict[rank]
        end
        allianceData:ParseData(v)
        allianceData:SetRank(v.rank)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GetBerserkBossRankInfoData, type)
end

function LWBerserkBossManager:RequestBerserkBossRankRewardInfo()
  if table.count(self.berserkBossRankRewardList) == 0 then
    SFSNetwork.SendMessage(MsgDefines.ActBerserkBossGetRewardInfo)
  end
end

function LWBerserkBossManager:HandleRefreshBerserkBossRankRewardInfo(message)
  local list = message.rewards
  if list ~= nil then
    for i, v in pairs(list) do
      local rewardInfo = LWBerserkBossRankRewardInfo.New()
      rewardInfo:InitData(v)
      table.insert(self.berserkBossRankRewardList, rewardInfo)
    end
    EventManager:GetInstance():Broadcast(EventId.GetBerserkBossRankRewardInfoData)
  end
end

function LWBerserkBossManager:RequestBerserkBossUserDamageStatistics(uid)
  SFSNetwork.SendMessage(MsgDefines.ActBerserkBossGetUserScore, uid)
end

function LWBerserkBossManager:HandleBerserkBossUserDamageStatistics(message)
  if self.seePersonalDamageStatistics == nil then
    self.seePersonalDamageStatistics = OneData.New()
  end
  self.seePersonalDamageStatistics.playerUid = message.uid
  self.seePersonalDamageStatistics.damagesList = {}
  local list = message.damages
  if list ~= nil then
    for i, v in pairs(list) do
      local damageStatisticsData = {}
      damageStatisticsData.bossUuid = v.uuid
      damageStatisticsData.score = v.score
      table.insert(self.seePersonalDamageStatistics.damagesList, damageStatisticsData)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GetBerserkBossPersonalDamageStatisticalData, self.seePersonalDamageStatistics)
end

function LWBerserkBossManager:RequestBerserkBossRankPraiseData(uid)
  if self.remainPraise <= 0 then
    local maxPraiseNum = LuaEntry.DataConfig:TryGetNum("BerserkBoss_config", "k4")
    UIUtil.ShowTips(Localization:GetString("activity_berserkboss_tips_05", maxPraiseNum))
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BerserkBossRankPraise, uid)
end

function LWBerserkBossManager:HandleBerserkBossRankPraiseData(message)
  if message.remainPraise then
    self.remainPraise = message.remainPraise
  end
  local playerUid = ""
  if message.uid then
    playerUid = message.uid
    local praise = message.praise
    local rankList = self:GetRankDataByTypeAndBossUuid(LWUIBerserkBossRankType.Personal, 0)
    for rank, personalRankInfo in pairs(rankList) do
      if personalRankInfo.uid == playerUid then
        personalRankInfo.praise = praise
        break
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateBerserkBossRankPraiseData, playerUid)
end

function LWBerserkBossManager:RequestBerserkBossDetailData(bossUuid)
  SFSNetwork.SendMessage(MsgDefines.BerserkBossDetail, bossUuid)
end

function LWBerserkBossManager:HandleBerserkBossDetailData(message)
  self.allianceDamageRankList = {}
  local ranks = message.ranks
  if ranks ~= nil then
    for i, v in pairs(ranks) do
      local allianceData = AllianceRankData.New()
      allianceData:ParseData(v)
      allianceData:SetRank(v.rank)
      table.insert(self.allianceDamageRankList, allianceData)
    end
    EventManager:GetInstance():Broadcast(EventId.GetBerserkBossDetailData)
  end
end

function LWBerserkBossManager:GetBerserkBossInfoByUuid(uuid)
  if self.berserkBossDict[uuid] ~= nil then
    return self.berserkBossDict[uuid]
  end
  return nil
end

function LWBerserkBossManager:GetAllBerserkBossInfoData()
  return self.berserkBossDict
end

function LWBerserkBossManager:GetAllBerserkBossInfoList()
  local bossList = {}
  for k, v in pairs(self.berserkBossDict) do
    table.insert(bossList, v)
  end
  table.sort(bossList, function(a, b)
    local aTemplate = DataCenter.LWActivityBerserkBossTemplateManager:GetTemplate(a.bossId)
    local bTemplate = DataCenter.LWActivityBerserkBossTemplateManager:GetTemplate(b.bossId)
    if aTemplate and bTemplate then
      return aTemplate.type < bTemplate.type
    end
  end)
  return bossList
end

function LWBerserkBossManager:GetBerserkBossRewardAndAttackTimesInfoByUuid(uuid)
  if self.berserkBossRewardAndAttackTimesDict[uuid] ~= nil then
    return self.berserkBossRewardAndAttackTimesDict[uuid]
  end
  return nil
end

function LWBerserkBossManager:GetBerserkBossAchievementRewardInfoByUuid(uuid)
  if self.berserkBossAchievementRewardDict[uuid] ~= nil then
    return self.berserkBossAchievementRewardDict[uuid]
  end
  return nil
end

function LWBerserkBossManager:GetBerserkBossIsDead(uuid)
  local berserkBossInfo = self:GetBerserkBossInfoByUuid(uuid)
  local berserkBossRewardAndAttackTimesInfo = self:GetBerserkBossRewardAndAttackTimesInfoByUuid(uuid)
  local curHp = 0
  local receivedReward = false
  if berserkBossInfo then
    curHp = berserkBossInfo.curHp
  end
  if berserkBossRewardAndAttackTimesInfo then
    receivedReward = berserkBossRewardAndAttackTimesInfo.receivedReward
  end
  return curHp <= 0 and receivedReward
end

function LWBerserkBossManager:GetBerserkBossIsReceiveReward(uuid)
  local berserkBossInfo = self:GetBerserkBossInfoByUuid(uuid)
  local berserkBossRewardAndAttackTimesInfo = self:GetBerserkBossRewardAndAttackTimesInfoByUuid(uuid)
  local curHp = 0
  local receivedReward = false
  if berserkBossInfo then
    curHp = berserkBossInfo.curHp
  end
  if berserkBossRewardAndAttackTimesInfo then
    receivedReward = berserkBossRewardAndAttackTimesInfo.receivedReward
  end
  return curHp <= 0 and not receivedReward
end

function LWBerserkBossManager:GetBerserkBossSurplusAttackTimes(uuid)
  local berserkBossRewardAndAttackTimesInfo = self:GetBerserkBossRewardAndAttackTimesInfoByUuid(uuid)
  local alreadyAttackTimes = 0
  if berserkBossRewardAndAttackTimesInfo then
    alreadyAttackTimes = berserkBossRewardAndAttackTimesInfo.alreadyAttackedTimes
  end
  local maxAttackTimes = LuaEntry.DataConfig:TryGetNum("BerserkBoss_config", "k1")
  return maxAttackTimes - alreadyAttackTimes
end

function LWBerserkBossManager:GetBerserkBossAlreadyReceiveRewardStatus(bossUuid)
  local berserkBossRewardAndAttackTimesInfo = self:GetBerserkBossRewardAndAttackTimesInfoByUuid(bossUuid)
  if berserkBossRewardAndAttackTimesInfo then
    return berserkBossRewardAndAttackTimesInfo.receivedReward
  end
  return false
end

function LWBerserkBossManager:GetRankDataByTypeAndBossUuid(type, bossUuid)
  if type == LWUIBerserkBossRankType.Personal then
    return self.personalRankDict[bossUuid]
  elseif type == LWUIBerserkBossRankType.Alliance then
    return self.allianceRankDict
  end
end

function LWBerserkBossManager:GetSelfRankInfo()
  return self.selfRankInfo
end

function LWBerserkBossManager:GetSelfAllianceRankInfo()
  return self.selfAllianceRankInfo
end

function LWBerserkBossManager:GetBerserkBossRankRewardData()
  return self.berserkBossRankRewardList
end

function LWBerserkBossManager:GetBerserkBossNameByBossUuid(uuid)
  local berserkBossInfo = self:GetBerserkBossInfoByUuid(uuid)
  if berserkBossInfo then
    local monsterName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), berserkBossInfo.monsterId, "name")
    return monsterName
  end
  return ""
end

function LWBerserkBossManager:GetRankRemainPraise()
  return self.remainPraise
end

function LWBerserkBossManager:GetBerserkBossAllianceDamageRankList()
  return self.allianceDamageRankList
end

function LWBerserkBossManager:JumpToTargetBerserkBoss(pointId, bossUuid)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), nil, nil, function()
    self:SetIsFromActivityJumpToWorldBossMark(true)
    UIUtil.OnClickWorldTroop(bossUuid)
    self:SetIsFromActivityJumpToWorldBossMark(false)
  end, mySourceServerId)
end

function LWBerserkBossManager:SetIsFromActivityJumpToWorldBossMark(value)
  self.isFromActivityJumpToWorldBossMark = value
end

function LWBerserkBossManager:GetIsFromActivityJumpToWorldBossMark()
  return self.isFromActivityJumpToWorldBossMark
end

return LWBerserkBossManager
