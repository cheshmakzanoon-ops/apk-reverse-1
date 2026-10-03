local LWGhostParkourDataManager = BaseClass("LWGhostParkourDataManager", CEventable)
local Localization = CS.GameEntry.Localization
local string_format = string.format
local Mathf_Floor = Mathf.Floor

function LWGhostParkourDataManager:__init()
  self.activityId = nil
  self.remainTimes = 0
  self.startChallengeMsgTs = nil
  self.startMatchMsgTs = nil
  self.nitrogenBuffId = nil
  self.nitrogenNeedEnergy = nil
  self.notSyncUuidList = nil
  self.nextRoundTime = nil
  self.round = nil
  self.roundStart = nil
  self.roundEnd = nil
  self.highestScore = nil
  self.remainTimes = nil
  self.remainChallengeTimes = nil
  self.battlePassList = nil
  self.tier = nil
  self.allianceBPMap = nil
  self.allianceBpRankMap = nil
  self.typeRankMap = nil
  self.typeRankRewardMap = nil
  self.selfTierInfo = nil
  self.tierRewardMap = nil
  self.tierConfigInfo = nil
  self.challengeRecord = nil
  self.todayProgress = nil
  self.tomorrow = nil
  self.newRecordList = nil
  self.tierReward = nil
  self.alBpReward = nil
  self.alPraiseNum = nil
  self.serverPraiseNum = nil
  self.areaPraiseNum = nil
  self.roundChange = nil
  self.logUuidDic = {}
end

function LWGhostParkourDataManager:__delete()
  self.activityId = nil
  self.remainTimes = nil
  self.startChallengeMsgTs = nil
  self.startMatchMsgTs = nil
  self.nitrogenBuffId = nil
  self.nitrogenNeedEnergy = nil
  self.nextRoundTime = nil
  self.round = nil
  self.roundStart = nil
  self.roundEnd = nil
  self.highestScore = nil
  self.remainTimes = nil
  self.remainChallengeTimes = nil
  self.battlePassList = nil
  self.tier = nil
  self.allianceBPMap = nil
  self.allianceBpRankMap = nil
  self.typeRankRewardMap = nil
  self.typeRankMap = nil
  self.selfTierInfo = nil
  self.tierRewardMap = nil
  self.tierConfigInfo = nil
  self.todayProgress = nil
  self.tomorrow = nil
  self.endlessModeSwitch = nil
  self.allChallengeTimes = nil
  self.newRecordList = nil
  self.tierReward = nil
  self.alBpReward = nil
  self.laterTime = nil
  self.settingSwitch = nil
  self.alPraiseNum = nil
  self.serverPraiseNum = nil
  self.areaPraiseNum = nil
  self.roundChange = nil
  self.logUuidDic = nil
end

function LWGhostParkourDataManager:AddListeners()
end

function LWGhostParkourDataManager:RemoveListeners()
end

function LWGhostParkourDataManager:SendGetGhostParkourInfosMessage(isOpenView, roundchange)
  if isOpenView then
    SFSNetwork.SendMessage(MsgDefines.GetGhostParkourActivityInfo, isOpenView)
  else
    SFSNetwork.SendMessage(MsgDefines.GetGhostParkourActivityInfo, false)
  end
  self.roundChange = roundchange
end

function LWGhostParkourDataManager:SendGetGhostParkourAllianceBattlePassMessage(round)
  if not round then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetGhostParkourAllianceBattlePass, round)
end

function LWGhostParkourDataManager:SendRewardGhostParkourBattlePassMessage(round, id, type)
  if not round then
    return
  end
  local param = {
    round = round,
    id = id,
    type = type
  }
  SFSNetwork.SendMessage(MsgDefines.RewardGhostParkourBattlePass, param)
end

function LWGhostParkourDataManager:SendGhostParkourBPRankInfoMessage(round)
  if not round then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GhostParkourBpRankInfo, round)
end

function LWGhostParkourDataManager:SendGhostParkourRankInfoMessage(round, type, startNum, endNum)
  if not round then
    return
  end
  local param = {
    round = round,
    type = type,
    start = startNum,
    endNum = endNum
  }
  SFSNetwork.SendMessage(MsgDefines.GhostParkourRankInfo, param)
end

function LWGhostParkourDataManager:SendGhostTypeRankRewardInfoMessage(round, type)
  if not round then
    return
  end
  local param = {round = round, type = type}
  SFSNetwork.SendMessage(MsgDefines.GhostParkourRankRewardInfo, param)
end

function LWGhostParkourDataManager:SendGetGhostParkourTierInfoMessage()
  SFSNetwork.SendMessage(MsgDefines.GetGhostParkourTierInfo)
end

function LWGhostParkourDataManager:SendGetGhostParkourTierRewardMessage(tier, id)
  local param = {tier = tier, id = id}
  SFSNetwork.SendMessage(MsgDefines.GetGhostParkourTierReward, param)
end

function LWGhostParkourDataManager:SendGhostParkourGuideRewardMessage()
  SFSNetwork.SendMessage(MsgDefines.GhostParkourGuideReward)
end

function LWGhostParkourDataManager:SendGhostParkourGetChallengeRecordMessage()
  SFSNetwork.SendMessage(MsgDefines.GhostParkourGetChallengeRecord)
end

function LWGhostParkourDataManager:SendGhostParkourRankPraiseMessage(type, targetUid)
  local param = {type = type, targetUid = targetUid}
  SFSNetwork.SendMessage(MsgDefines.GhostParkourRankPraise, param)
end

function LWGhostParkourDataManager:SaveGhostParkourMainInfo(msg)
  if msg then
    self.nextRoundTime = msg.nextRoundTime
    self.round = msg.round
    self.roundStart = msg.roundStart
    self.roundEnd = msg.roundEnd
    self.highestScore = msg.highestScore
    self.remainTimes = msg.remainTimes
    self.remainChallengeTimes = msg.remainChallengeTimes
    self.battlePassList = msg.battlePassList
    self.tier = msg.tier
    self.todayProgress = msg.todayProgress
    self.tomorrow = msg.tomorrow
    self.newRecordList = msg.newRecordList
    self.guideReward = msg.guideReward
    self.tierReward = msg.tierReward
    self.alBpReward = msg.alBpReward
    self.notSyncUuidList = msg.notSyncUuidList
    self.alPraiseNum = msg.alPraiseNum
    self.serverPraiseNum = msg.serverPraiseNum
    self.areaPraiseNum = msg.areaPraiseNum
  end
  if self.roundChange then
    EventManager:GetInstance():Broadcast(EventId.GhostParkourRefreshActInfoByRound)
    self.roundChange = false
  end
  EventManager:GetInstance():Broadcast(EventId.GhostParkourMainUIRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LWGhostParkourDataManager:SaveGhostParkourAllianceBPInfo(msg)
  if not self.allianceBPMap then
    self.allianceBPMap = {}
  end
  if msg and msg.round then
    self.allianceBPMap[msg.round] = msg
  end
  EventManager:GetInstance():Broadcast(EventId.GhostParkourAllianceBPRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LWGhostParkourDataManager:SaveGhostParkourRewardInfo(msg)
  if msg.type == GhostParkourPassType.Personal then
    if msg.list then
      self.battlePassList = msg.list
    end
    EventManager:GetInstance():Broadcast(EventId.GhostParkourPersonalBPRefresh)
  elseif msg.type == GhostParkourPassType.Alliance then
    if not self.allianceBPMap then
      self.allianceBPMap = {}
    end
    if msg and msg.round then
      self.allianceBPMap[msg.round] = self.allianceBPMap[msg.round] or {}
      self.allianceBPMap[msg.round].list = msg.list
    end
    EventManager:GetInstance():Broadcast(EventId.GhostParkourAllianceBPRefresh)
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  DataCenter.RewardManager:ShowCommonReward(msg)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LWGhostParkourDataManager:SaveGhostParkourBpRankInfo(msg)
  if not self.allianceBpRankMap then
    self.allianceBpRankMap = {}
  end
  if msg and msg.round then
    self.allianceBpRankMap[msg.round] = msg
  end
  EventManager:GetInstance():Broadcast(EventId.GhostParkourAllianceBPRankRefresh)
end

function LWGhostParkourDataManager:SaveGhostParkourTypeRankInfo(msg)
  if not self.typeRankMap then
    self.typeRankMap = {}
  end
  if msg and msg.round then
    if not self.typeRankMap[msg.round] then
      self.typeRankMap[msg.round] = {}
    end
    if self.typeRankMap[msg.round] then
      if not self.typeRankMap[msg.round][msg.type] then
        self.typeRankMap[msg.round][msg.type] = {}
      end
      self.typeRankMap[msg.round][msg.type].selfInfo = msg.self
      self.typeRankMap[msg.round][msg.type].ranks = msg.ranks
      self.typeRankMap[msg.round][msg.type].remainPraise = msg.remainPraise
      self.typeRankMap[msg.round][msg.type].stageId = msg.stageId
    end
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.GhostParkourTypeRankRefresh)
end

function LWGhostParkourDataManager:SaveTypeRankRewardInfos(msg)
  if not self.typeRankRewardMap then
    self.typeRankRewardMap = {}
  end
  if msg and msg.round then
    if not self.typeRankRewardMap[msg.round] then
      self.typeRankRewardMap[msg.round] = {}
    end
    if self.typeRankRewardMap[msg.round] then
      if not self.typeRankRewardMap[msg.round][msg.type] then
        self.typeRankRewardMap[msg.round][msg.type] = {}
      end
      self.typeRankRewardMap[msg.round][msg.type] = msg.rewards
    end
    EventManager:GetInstance():Broadcast(EventId.GhostParkourTypeRankRewardRefresh, msg.type)
  end
end

function LWGhostParkourDataManager:SaveGhostParkourTierInfos(msg)
  if not self.selfTierInfo then
    self.selfTierInfo = {}
  end
  self.selfTierInfo.tier = msg.tier
  self.selfTierInfo.tierExp = msg.tierExp
  self.tier = msg.tier
  if msg.tierInfo then
    if not self.tierRewardMap then
      self.tierRewardMap = {}
    end
    for _, info in ipairs(msg.tierInfo) do
      local tier = info.tier
      self.tierRewardMap[tier] = info
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GhostParkourRankInfoRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LWGhostParkourDataManager:UpdateGhostParkourTierRewardInfo(msg)
  if self.tierRewardMap and msg then
    if msg.tier and msg.id and self.tierRewardMap[msg.tier] then
      for key, value in ipairs(self.tierRewardMap[msg.tier].rewardInfo) do
        if value.id == msg.id then
          value.state = GhostParkourTierRewardState.Rewarded
          EventManager:GetInstance():Broadcast(EventId.GhostParkourRankInfoRewardRefresh, value.id)
        end
      end
    end
    DataCenter.RewardManager:AddRewardsAndRes(msg)
    DataCenter.RewardManager:ShowCommonReward(msg)
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LWGhostParkourDataManager:SaveChallengeRecordInfos(msg)
  self.challengeRecord = msg
  EventManager:GetInstance():Broadcast(EventId.GhostParkourRecordRefresh)
end

function LWGhostParkourDataManager:UpdateRankPraiseInfo(msg)
  if msg and msg.type then
    local type = msg.type
    if self.typeRankMap and self.typeRankMap[self.round] and self.typeRankMap[self.round][type] then
      self.typeRankMap[self.round][type].remainPraise = msg.remainPraise
      for _, value in ipairs(self.typeRankMap[self.round][type].ranks) do
        if value.uid == msg.targetUid then
          value.praiseNum = msg.praiseNum
          local param = {
            praiseNum = value.praiseNum,
            targetUid = msg.targetUid
          }
          EventManager:GetInstance():Broadcast(EventId.GhostParkourTypeRankPraiseRefresh, param)
          break
        end
      end
    end
    local reward = msg.reward
    if reward ~= nil then
      DataCenter.RewardManager:AddRewardsAndRes(msg)
      if msg.changeGold and msg.changeGold > 0 then
        local name = DataCenter.ResourceManager:GetResourceNameByType(ResourceType.Gold)
        local num = msg.changeGold
        UIUtil.ShowTips(Localization:GetString("500216", name, num))
      end
    end
  end
end

function LWGhostParkourDataManager:SetActivityId(actId)
  self.activityId = actId
end

function LWGhostParkourDataManager:GetGhostParkourRound()
  return self.round
end

function LWGhostParkourDataManager:GetRoundEndTime()
  return self.roundEnd
end

function LWGhostParkourDataManager:GetDelayTime()
  if self.laterTime == nil then
    self.laterTime = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config", "k8", 10)
    self.laterTime = self.laterTime * 60000
  end
  return self.laterTime
end

function LWGhostParkourDataManager:GetNextRoundTime()
  return self.nextRoundTime
end

function LWGhostParkourDataManager:GetGhostParkourTierInfo()
  return self.selfTierInfo
end

function LWGhostParkourDataManager:GetGhostParkourTierList()
  return self.tierRewardMap
end

function LWGhostParkourDataManager:GetRemainChallengeTimes()
  return self.remainChallengeTimes
end

function LWGhostParkourDataManager:GetTier()
  return self.tier
end

function LWGhostParkourDataManager:GetNewRecordList()
  return self.newRecordList
end

function LWGhostParkourDataManager:ClearNewRecordList()
  self.newRecordList = nil
end

function LWGhostParkourDataManager:GetAllChallengeTimes()
  if self.allChallengeTimes then
    return self.allChallengeTimes
  else
    self.allChallengeTimes = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config", "k9", 0)
  end
  return self.allChallengeTimes
end

function LWGhostParkourDataManager:GetGhostParkourTierConfigInfo()
  if not table.IsNullOrEmpty(self.tierConfigInfo) then
    return self.tierConfigInfo
  end
  self.tierConfigInfo = {}
  local tierRewardMap = self.tierRewardMap
  if tierRewardMap then
    for tier, reward in pairs(tierRewardMap) do
      local tierMeta = DataCenter.ParkourScoreTierTemplateManager:GetTemplate(tier)
      if tierMeta then
        local rewardIds = ""
        if not table.IsNullOrEmpty(tierMeta.rewardList) then
          rewardIds = tierMeta.rewardList
        end
        local param = {
          tier = tierMeta.tier,
          icon = tierMeta.icon,
          rewardInfos = rewardIds,
          name = tierMeta.tier_name,
          maxExp = tierMeta.exp
        }
        table.insert(self.tierConfigInfo, param)
      end
    end
  end
  return self.tierConfigInfo
end

function LWGhostParkourDataManager:GetTierMaxExp(tier)
  local tierConfigs = self:GetGhostParkourTierConfigInfo()
  for key, value in ipairs(tierConfigs) do
    if value.tier == tier then
      return value.maxExp
    end
  end
  return nil
end

function LWGhostParkourDataManager:GetPersonalBattlePassList()
  if self.battlePassList and #self.battlePassList > 0 then
    return self.battlePassList
  end
  return nil
end

function LWGhostParkourDataManager:GetPersonalBattleProgressScore()
  if self.todayProgress then
    return self.todayProgress
  end
  return 0
end

function LWGhostParkourDataManager:GetPersonalHightestScore()
  if self.highestScore then
    return self.highestScore
  end
  return 0
end

function LWGhostParkourDataManager:GetAllianceBattlePassInfo(round)
  if self.allianceBPMap and self.allianceBPMap[round] then
    return self.allianceBPMap[round]
  end
  return nil
end

function LWGhostParkourDataManager:GetAllianceBpRankInfo(round)
  if self.allianceBpRankMap and self.allianceBpRankMap[round] then
    return self.allianceBpRankMap[round]
  end
  return nil
end

function LWGhostParkourDataManager:GetTypeRankInfo(round, type)
  if self.typeRankMap and self.typeRankMap[round] and self.typeRankMap[round][type] then
    return self.typeRankMap[round][type]
  end
  return nil
end

function LWGhostParkourDataManager:GetEmojiConfigList()
  if self.emojiIds == nil then
    local emojiIds = LuaEntry.DataConfig:TryGetStr("parkour_ghost_config", "k19") or ""
    if not string.IsNullOrEmpty(emojiIds) then
      self.emojiIds = {}
      for value in string.gmatch(emojiIds, "([^|]+)") do
        local data = LocalController:instance():getLine(TableName.LW_EMOJI, value)
        if data then
          table.insert(self.emojiIds, data)
        end
      end
    end
  end
  return self.emojiIds
end

function LWGhostParkourDataManager:GetTypeRankRewardInfo(round, type)
  if self.typeRankRewardMap and self.typeRankRewardMap[round] and self.typeRankRewardMap[round][type] then
    return self.typeRankRewardMap[round][type]
  end
  return nil
end

function LWGhostParkourDataManager:GetGhostParkourRecord()
  if self.challengeRecord then
    return self.challengeRecord
  end
  return nil
end

function LWGhostParkourDataManager:GetEndlessModeSwitch()
  if self.endlessModeSwitch == nil then
    self.endlessModeSwitch = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config_c", "k5") or 0
  end
  return self.endlessModeSwitch == 1
end

function LWGhostParkourDataManager:GetBtnSettingSwitch()
  if self.settingSwitch == nil then
    self.settingSwitch = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config_c", "k7") or 0
  end
  return self.settingSwitch == 1
end

function LWGhostParkourDataManager:PersonalRewardRedPoint()
  local redCount = 0
  if self.battlePassList then
    for key, value in ipairs(self.battlePassList) do
      if value.state == TaskState.CanReceive then
        redCount = redCount + 1
      end
    end
  end
  return 0 < redCount
end

function LWGhostParkourDataManager:AllianceRewardRedPoint()
  local redCount = 0
  if self.allianceBPMap and self.allianceBPMap[self.round] then
    local list = self.allianceBPMap[self.round].list
    if table.IsNullOrEmpty(list) then
      return 0 < redCount
    else
      for i, v in ipairs(list) do
        if v.state == TaskState.CanReceive then
          redCount = redCount + 1
        end
      end
    end
  else
    return self.alBpReward
  end
  return 0 < redCount
end

function LWGhostParkourDataManager:OneTierRewardRedPoint(tier)
  local redCount = 0
  if self.tierRewardMap and self.tierRewardMap[tier] then
    local rewards = self.tierRewardMap[tier].rewardInfo
    if rewards then
      for key, value in ipairs(rewards) do
        if value.state == GhostParkourTierRewardState.CanReward then
          redCount = redCount + 1
        end
      end
    end
  end
  return redCount
end

function LWGhostParkourDataManager:AllTierRewardRedPoint()
  local redCount = 0
  if self.tierRewardMap then
    for key, value in pairs(self.tierRewardMap) do
      redCount = redCount + self:OneTierRewardRedPoint(key)
    end
  else
    return self.tierReward
  end
  return 0 < redCount
end

function LWGhostParkourDataManager:GetRedCount()
  local redCount = 0
  if self:PersonalRewardRedPoint() then
    redCount = redCount + 1
  end
  if self:AllianceRewardRedPoint() then
    redCount = redCount + 1
  end
  if self:AllTierRewardRedPoint() then
    redCount = redCount + 1
  end
  if self:GetRankItemThumbsUpRedPoint() then
    redCount = redCount + 1
  end
  if self:GetRankItemChallengeRedPoint() then
    redCount = redCount + 1
  end
  return redCount
end

function LWGhostParkourDataManager:GetRankItemChallengeRedPoint()
  for key, value in pairs(GhostParkourTypeRank) do
    local red = self:GetRankChallengeRedPoint(value)
    if red then
      return red
    end
  end
  return false
end

function LWGhostParkourDataManager:GetRankItemThumbsUpRedPoint()
  for key, value in pairs(GhostParkourTypeRank) do
    local red = self:GetTypeRankItemThumbsUpRedPoint(value)
    if red then
      return red
    end
  end
  return false
end

function LWGhostParkourDataManager:GetTypeRankItemThumbsUpRedPoint(type)
  if not self.round then
    return false
  end
  local rankData = DataCenter.LWGhostParkourDataManager:GetTypeRankInfo(self.round, type)
  if rankData then
    local count = rankData.remainPraise
    if 0 < count and rankData.ranks and 0 < #rankData.ranks then
      return true
    end
  else
    if not self.highestScore or self.highestScore == 0 then
      return false
    end
    if type == GhostParkourTypeRank.AllianceRank and self.alPraiseNum then
      return 0 < self.alPraiseNum
    elseif type == GhostParkourTypeRank.ServerRank and self.serverPraiseNum then
      return 0 < self.serverPraiseNum
    elseif type == GhostParkourTypeRank.AreaRank and self.areaPraiseNum then
      return 0 < self.areaPraiseNum
    end
  end
  return false
end

function LWGhostParkourDataManager:GetRankChallengeRedPoint(type)
  local lastTime = CommonUtil.PlayerPrefsGetLong(SettingKeys.GHOST_PARKOUR_ON_FIRST_CHALLENGE_BTN, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isTheSameDay = UITimeManager:GetInstance():IsSameDayForServer(lastTime / 1000, curTime / 1000)
  if type then
    if not self.round then
      return false
    end
    local rankData = DataCenter.LWGhostParkourDataManager:GetTypeRankInfo(self.round, type)
    if rankData and rankData.ranks and 0 < #rankData.ranks then
      return not isTheSameDay
    end
  end
  if not self.highestScore or self.highestScore == 0 then
    return false
  end
  return not isTheSameDay
end

function LWGhostParkourDataManager:ReqFightChallenge(uid)
  local curTs = UITimeManager:GetInstance():GetServerTime()
  if self.startChallengeMsgTs ~= nil and curTs - self.startChallengeMsgTs <= self:GetStartMsgCD() then
    UIUtil.ShowTipsId("avatar_tips002")
    return
  end
  self.startChallengeMsgTs = curTs
  SFSNetwork.SendMessage(MsgDefines.GhostParkourFightChallenge, uid)
end

function LWGhostParkourDataManager:ReqFightMatch(restart)
  if DataCenter.ActWinterStormManager:CheckInMatchingViewState() then
    return
  end
  local curTs = UITimeManager:GetInstance():GetServerTime()
  if self.startMatchMsgTs ~= nil and curTs - self.startMatchMsgTs <= self:GetStartMsgCD() then
    UIUtil.ShowTipsId("avatar_tips002")
    return
  end
  self.startMatchMsgTs = curTs
  restart = restart or false
  SFSNetwork.SendMessage(MsgDefines.GhostParkourFightMarch, restart)
end

function LWGhostParkourDataManager:FightStartCheck(message)
  if message == nil then
    return
  end
  if self:CheckStageVersion(message.stageId, message.version) then
    self:ReqStartGame(message.fightType, message.restart)
  end
end

function LWGhostParkourDataManager:ReqStartGame(fightType, restart)
  SFSNetwork.SendMessage(MsgDefines.GhostParkourFightStart, fightType, restart)
end

function LWGhostParkourDataManager:OnStartGame(message)
  if message == nil then
    Logger.LogError("GhostParkour -- [ghost.parkour.fight.start] message is nil")
    return
  end
  local fightType = message.fightType
  if fightType == 1 then
    self.remainTimes = message.remainTimes
  end
  local stageId = message.stageId
  local uuid = message.uuid
  if stageId and 0 < stageId then
    local param = {}
    param.type = PVEType.GhostParkour
    param.levelId = stageId
    param.uuid = uuid
    param.fightType = fightType
    param.message = message
    if message.restart then
      DataCenter.LWBattleManager:RestartParam(param)
    else
      DataCenter.LWBattleManager:Enter(param)
    end
  else
    Logger.LogError("stage id is nil")
  end
  PostEventLog.Track(PostEventLog.Defines.GHOST_GAMING_ON_START, {
    uuid = tostring(uuid)
  })
end

function LWGhostParkourDataManager:ReqEndGame(uuid, index, id, distance, score, totalRunTime, buffList)
  if uuid == nil or uuid == 0 then
    return false
  end
  local buffArr = ""
  if buffList then
    buffArr = table.concat(buffList, "|")
  end
  local param = {
    uuid = uuid,
    index = index,
    id = id,
    distance = distance,
    score = score,
    totalRunTime = totalRunTime,
    buffList = buffArr
  }
  SFSNetwork.SendMessage(MsgDefines.GhostParkourFightEnd, param)
  return true
end

function LWGhostParkourDataManager:ReqEndStage(uuid, index, id, distance, score)
  if uuid == nil or uuid == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GhostParkourStageEnd, {
    uuid = uuid,
    index = index,
    id = id,
    distance = distance,
    score = score
  })
end

function LWGhostParkourDataManager:ReqTimeCheck(uuid, distance, totalRunTime, totalStopTime, coinNum, buffList)
  if uuid == nil or uuid == 0 then
    return
  end
  local buffArr = ""
  if buffList then
    buffArr = table.concat(buffList, "|")
  end
  SFSNetwork.SendMessage(MsgDefines.GhostParkourStageTimeCheck, distance, totalRunTime, totalStopTime, uuid, coinNum, buffArr)
end

function LWGhostParkourDataManager:ReqSyncChallengeInfo(uuid, succeed)
  self:UploadLogTrack(LuaEntry.Player.uid, uuid or "", succeed)
  if not succeed then
    return
  end
  if uuid == nil or uuid == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GhostParkourSyncChallengeInfo, uuid)
end

function LWGhostParkourDataManager:ReqSendRecordEmoji(emojiId, ownerUuid, targetUid, targetUuid)
  SFSNetwork.SendMessage(MsgDefines.GhostParkourSendRecordEmoji, emojiId, ownerUuid, targetUid, targetUuid)
end

function LWGhostParkourDataManager:ReqGuideReward()
  SFSNetwork.SendMessage(MsgDefines.GhostParkourGuideReward)
  DataCenter.LWGhostParkourDataManager:SetGuideReward()
end

function LWGhostParkourDataManager:SetGuideReward()
  if not self.activityId then
    return
  end
  self.guideReward = true
end

function LWGhostParkourDataManager:IsGuideReward()
  return self.guideReward
end

function LWGhostParkourDataManager:CheckStageVersion(stageId, version)
  if stageId == nil then
    return false
  end
  local stageMeta = DataCenter.SurfingStageTemplateManager:GetTemplate(stageId)
  if stageMeta then
    local ver = stageMeta.version
    if ver ~= version then
      local param = {
        contentText = CS.GameEntry.Localization:GetString("parkour_activity_data_exception"),
        btnNum = 2,
        showToggle = false,
        confirmBtnParam = {
          action = function()
            CS.ApplicationLaunch.Instance:ReloadGame()
          end
        }
      }
      UIUtil.ShowConfirmNew(param)
      return false
    end
  end
  return true
end

function LWGhostParkourDataManager:GetStartMsgCD()
  if self.startMsgCD == nil then
    local startMsgCD = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config", "k16") or 0
    self.startMsgCD = startMsgCD * 1000
  end
  return self.startMsgCD
end

function LWGhostParkourDataManager:GetRemainTimes()
  return self.remainTimes
end

function LWGhostParkourDataManager:GetResultTipKey()
  if self.resultTipKey == nil then
    self.resultTipKey = StringPool.New("ghost_parkour_loading_rule_9;ghost_parkour_loading_rule_10;ghost_parkour_loading_rule_11;ghost_parkour_loading_rule_12;ghost_parkour_loading_rule_13", ";")
  end
  return self.resultTipKey:GetRandom()
end

function LWGhostParkourDataManager:GetNpcUid()
  if self.npcUid == nil then
    self.npcUid = LuaEntry.DataConfig:TryGetStr("parkour_ghost_config_c", "k1") or ""
  end
  return self.npcUid
end

function LWGhostParkourDataManager:GetTimeFormat(millisecond)
  if millisecond and 0 < millisecond then
    local msec = millisecond % 1000
    msec = Mathf_Floor(msec)
    local second = Mathf_Floor(millisecond / 1000)
    second = second % 60
    local minute = Mathf_Floor(millisecond / 1000 / 60)
    return string_format("%d:%02d.%03d", minute, second, msec)
  end
  return CS.GameEntry.Localization:GetString("ghost_parkour_match_no_record")
end

function LWGhostParkourDataManager:GetNitrogenBuffId()
  if self.nitrogenBuffId == nil then
    local nitrogen = LuaEntry.DataConfig:TryGetStr("parkour_ghost_config", "k15") or ""
    local arr = string.split(nitrogen, "|")
    if arr and #arr == 2 then
      self.nitrogenBuffId = tonumber(arr[1])
      self.nitrogenNeedEnergy = tonumber(arr[2])
    end
  end
  return self.nitrogenBuffId, self.nitrogenNeedEnergy
end

function LWGhostParkourDataManager:GetActivityId()
  return self.activityId
end

function LWGhostParkourDataManager:GoBackToActivityPanel()
  if self.activityId then
    DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.GhostParkour)
    local preLoadAssets = {
      [UIAssets.ActivityTabGroupItem] = true,
      [UIAssets.UIActivityListItem] = true,
      [UIAssets.UIGhostParkourActMain] = true
    }
    GoToUtil.GotoOpenView_BattleReturnOpt(UIWindowNames.UIActivityCenterTable, preLoadAssets, self.activityId, preLoadAssets)
  end
  DataCenter.LWBattleManager:Exit()
end

function LWGhostParkourDataManager:GetDeviceLevel()
  if self.deviceLevelConfig == nil then
    self.deviceLevelConfig = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config", "k23", 0)
  end
  return self.deviceLevelConfig
end

function LWGhostParkourDataManager:GetNotSyncUuidList()
  return self.notSyncUuidList
end

function LWGhostParkourDataManager:GetBeginTime()
  return self.roundStart or 0
end

function LWGhostParkourDataManager:CheckDeviceLevel(callback)
  local deviceLevel = GameQualitySettings.GetDeviceLevel()
  local qualityLevel = GameQualitySettings.GetQuality()
  if deviceLevel < self:GetDeviceLevel() and qualityLevel > EnumQualityLevel.Low then
    local param = {
      contentText = Localization:GetString("parkour_activity_graphics_quality_check"),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          GameQualitySettings.SetQuality(EnumQualityLevel.Low)
          if callback then
            callback()
          end
        end
      },
      cancelBtnParam = {
        action = function()
          if callback then
            callback()
          end
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.SurfingDeviceLevelLowRemind, param)
  elseif callback then
    callback()
  end
end

function LWGhostParkourDataManager:CheckRoundFirstEnterAct()
  if self.nextRoundTime ~= nil and self.round == nil then
    local path = CS.UnityEngine.Application.persistentDataPath .. PVE_LOG_LOCAL_PATH .. PVELogFilePathName[PVELogFuncType.GhostParkour]
    CS.FileUtils.DeleteDirectoryIfExists(path)
    CS.GameEntry.Setting:SetPrivateInt(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND, 0)
    CS.GameEntry.Setting:SetPrivateString(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND_START_TIME, "")
    return
  end
  if self.round == nil or self.roundStart == nil then
    return
  end
  local round = CS.GameEntry.Setting:GetPrivateInt(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND, 0)
  if round == 0 then
    CS.GameEntry.Setting:SetPrivateInt(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND, self.round)
    CS.GameEntry.Setting:SetPrivateString(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND_START_TIME, tostring(self.roundStart))
    return
  end
  if self.round ~= round then
    local path = CS.UnityEngine.Application.persistentDataPath .. PVE_LOG_LOCAL_PATH .. PVELogFilePathName[PVELogFuncType.GhostParkour]
    CS.FileUtils.DeleteDirectoryIfExists(path)
    CS.GameEntry.Setting:SetPrivateInt(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND, self.round)
    CS.GameEntry.Setting:SetPrivateString(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND_START_TIME, tostring(self.roundStart))
  elseif self.roundStart then
    local timeStr = CS.GameEntry.Setting:GetPrivateString(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND_START_TIME, "")
    local time = tonumber(timeStr) or 0
    if time < self.roundStart then
      local path = CS.UnityEngine.Application.persistentDataPath .. PVE_LOG_LOCAL_PATH .. PVELogFilePathName[PVELogFuncType.GhostParkour]
      CS.FileUtils.DeleteDirectoryIfExists(path)
      CS.GameEntry.Setting:SetPrivateInt(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND, self.round)
      CS.GameEntry.Setting:SetPrivateString(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND_START_TIME, tostring(self.roundStart))
    end
  end
end

function LWGhostParkourDataManager:GetMainUIDisplayInfo(actId, index)
  if self.displayInfo and index <= #self.displayInfo then
    return self.displayInfo[index]
  else
    self.displayInfo = {}
    local iconsStr = LocalController:instance():getValue(TableName.Activity, actId, "para_4")
    if not string.IsNullOrEmpty(iconsStr) then
      local iconsSplit = string.split(iconsStr, "|")
      for k, v in pairs(iconsSplit) do
        if self.displayInfo[k] then
          self.displayInfo[k].icon = v
        else
          self.displayInfo[k] = {}
          self.displayInfo[k].icon = v
        end
      end
    end
    return self.displayInfo[index]
  end
end

function LWGhostParkourDataManager:UploadLogTrack(uid, uuid, success)
  if uid and uuid then
    if success == nil then
      success = false
    end
    PostEventLog.Track(PostEventLog.Defines.GHOST_GAMING_ON_LOG_UPLOADED, {
      uid = tostring(uid),
      uuid = tostring(uuid),
      result = success
    })
  end
end

function LWGhostParkourDataManager:LoadLogTrack(uuid, success, isLocal)
  if uuid then
    if success == nil then
      success = false
    end
    if isLocal == nil then
      isLocal = false
    end
    local value = isLocal and 0 or 1
    PostEventLog.Track(PostEventLog.Defines.GHOST_GAMING_ON_LOG_LOADED, {
      uuid = tostring(uuid),
      result = success,
      status = value
    })
  end
end

function LWGhostParkourDataManager:CheckFileUploading(uuid)
  if table.containsKey(self.logUuidDic, uuid) then
    local curTs = UITimeManager:GetInstance():GetServerSeconds()
    if curTs - self.logUuidDic[uuid] > 30 then
      self.logUuidDic[uuid] = nil
      return false
    end
    return true
  end
  return false
end

function LWGhostParkourDataManager:AddUploadingFile(uuid, curTs)
  curTs = curTs or UITimeManager:GetInstance():GetServerSeconds()
  if table.containsKey(self.logUuidDic, uuid) then
    return false
  end
  self.logUuidDic[uuid] = curTs
  return true
end

function LWGhostParkourDataManager:RemoveUploadingFile(uuid)
  if table.containsKey(self.logUuidDic, uuid) then
    self.logUuidDic[uuid] = nil
    return true
  end
  return false
end

return LWGhostParkourDataManager
