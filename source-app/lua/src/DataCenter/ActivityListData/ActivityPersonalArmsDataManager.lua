local ActivityPersonalArmsDataManager = BaseClass("ActivityPersonalArmsDataManager")

function ActivityPersonalArmsDataManager:__init()
  self.dataDict = {}
  self.calenderDataDict = {}
  self.rankList = {}
  self.rewards = {}
  self.scoreGroupDict = {}
  self.isShowSvrTimeDesc = CommonUtil.PlayerPrefsGetBool(SettingKeys.PERSONAL_ARMS_SHOW_SVR_TIME, false)
end

function ActivityPersonalArmsDataManager:__delete()
  self:StopAllStageEndTimer()
  self.dataDict = nil
  self.calenderDataDict = nil
  self.rankList = nil
  self.rewards = nil
  self.scoreGroupDict = nil
end

function ActivityPersonalArmsDataManager:UpdateData(message)
  if message == nil then
    return
  end
  local activityData = {}
  activityData.activityId = message.aid
  activityData.curDay = message.curDay
  activityData.curStage = message.curStage
  activityData.resourceItemId = message.resourceItemId
  activityData.event_id = message.eventId
  activityData.minLevelStage = message.minLevelStage or 0
  activityData.maxLevelStage = message.maxLevelStage or 0
  activityData.heroActivityId = message.heroActivityId or 1
  activityData.resourceItemNum = message.resourceItemNum or 0
  activityData.sc = message.sc
  DataCenter.GetDuelScoreManager:SetScoreByType(GetDuelScoreType.Person, message)
  activityData.score_rewards = message.score_rewards
  activityData.score_reward_max = activityData.score_rewards[#activityData.score_rewards].target
  for i = 1, #activityData.score_rewards do
    local rewardList = activityData.score_rewards[i].reward
    if rewardList then
      table.sort(rewardList, function(a, b)
        if a.type ~= b.type then
          return a.type - b.type > 0
        end
        return false
      end)
    end
  end
  activityData.scores = message.scores
  activityData.scoresList = self:SplitScoreList(activityData.scores)
  activityData.day_rewards = message.day_rewards
  activityData.day_rewards_max = activityData.day_rewards[#activityData.day_rewards].resourceNum
  activityData.stage_end_time = message.stage_end_time
  activityData.exchangeList = message.exchangeList
  activityData.exchangeNum = message.exchangeNum
  self.dataDict[activityData.activityId] = activityData
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  self:StartStageEndTimer(activityData.activityId, activityData.stage_end_time)
end

function ActivityPersonalArmsDataManager:UpdateCalenderData(message)
  local aid = message.aid
  self.calenderDataDict[aid] = message
  self.calenderDataDict[aid].UpdateTime = UITimeManager:GetInstance():GetServerTime()
end

function ActivityPersonalArmsDataManager:GetCalenderData(activityId)
  local data = self.calenderDataDict[activityId]
  if data ~= nil and UITimeManager:GetInstance():CheckIfIsSameWeek(checknumber(data.UpdateTime)) then
    return data
  end
  return nil
end

function ActivityPersonalArmsDataManager:ClearCalenderData(activityId)
  if self.calenderDataDict ~= nil then
    self.calenderDataDict[activityId] = nil
  end
end

function ActivityPersonalArmsDataManager:DailyRewardGet(message)
  local aid = tonumber(message.aid)
  local curDay = message.curDay
  local curStage = message.curStage
  local activityData = self:GetCurData(aid)
  if activityData and activityData.curDay == curDay and activityData.curStage == curStage then
    if message.reward ~= nil then
      DataCenter.RewardManager:ShowCommonReward(message)
      DataCenter.RewardManager:AddRewardsAndRes(message)
      EventManager:GetInstance():Broadcast(EventId.UpdatePlayerExp)
    end
    if message.gold ~= nil then
      LuaEntry.Player.gold = message.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    local boxIndex = message.index + 1
    activityData.day_rewards[boxIndex].receive = 1
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityPersonalArmsDataManager:ScoreRewardGet(message)
  local aid = tonumber(message.aid)
  local curDay = message.curDay
  local curStage = message.curStage
  local activityData = self:GetCurData(aid)
  if activityData and activityData.curDay == curDay and activityData.curStage == curStage then
    local dailyScoreAdd = 0
    if message.reward ~= nil then
      DataCenter.RewardManager:ShowCommonReward(message)
      DataCenter.RewardManager:AddRewardsAndRes(message)
      EventManager:GetInstance():Broadcast(EventId.UpdatePlayerExp)
      local rewards = message.reward
      for i = 1, #rewards do
        local type = rewards[i].type
        local itemId = rewards[i].value.itemId
        local value = rewards[i].value.addNum
        if type == RewardType.RESOURCE_ITEM and itemId == activityData.resourceItemId then
          dailyScoreAdd = dailyScoreAdd + value
        end
      end
    end
    if message.gold ~= nil then
      LuaEntry.Player.gold = message.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    local boxIndex = message.index + 1
    activityData.score_rewards[boxIndex].receive = 1
    activityData.resourceItemNum = activityData.resourceItemNum + dailyScoreAdd
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityPersonalArmsDataManager:UpdateScData(message)
  local aid = tonumber(message.activityId)
  local curDay = message.day
  local curStage = message.stage
  local activityData = self:GetCurData(aid)
  if activityData and activityData.curDay == curDay and activityData.curStage == curStage then
    activityData.sc = toInt(message.cur_sc)
    self.dataDict[activityData.activityId] = activityData
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    DataCenter.GetDuelScoreManager:PushScoreChangeByType(GetDuelScoreType.Person, message)
  end
end

function ActivityPersonalArmsDataManager:IsCurDataStageExpired(activityId)
  local isExpired = true
  local curData = self.dataDict[activityId]
  if curData then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if curTime < curData.stage_end_time then
      isExpired = false
    end
  end
  return isExpired
end

function ActivityPersonalArmsDataManager:GetCurData(activityId)
  local isExpired = self:IsCurDataStageExpired(activityId)
  local curData
  if not isExpired then
    curData = self.dataDict[activityId]
  end
  return curData
end

function ActivityPersonalArmsDataManager:GetDataByType(t)
  for key, value in pairs(self.dataDict) do
    local isExpired = self:IsCurDataStageExpired(key)
    if not isExpired then
      local tabData = LocalController:instance():getLine(TableName.Activity, toInt(key))
      if tabData.type == t then
        return value
      end
    end
  end
  return nil
end

function ActivityPersonalArmsDataManager:GetDailyBoxState(data, index)
  local boxData = data.day_rewards[index]
  local boxState = ActivityBoxState.Close
  if boxData.receive == 1 then
    boxState = ActivityBoxState.Open
  else
    local curNum = data.resourceItemNum
    if curNum >= boxData.resourceNum then
      boxState = ActivityBoxState.CanOpen
    else
      boxState = ActivityBoxState.Close
    end
  end
  return boxState
end

function ActivityPersonalArmsDataManager:GetScoreBoxState(data, index)
  if data.score_rewards == nil then
    return ActivityBoxState.Close
  end
  local boxData = data.score_rewards[index]
  if boxData == nil then
    return ActivityBoxState.Close
  end
  local boxState = ActivityBoxState.Close
  if boxData.receive == 1 then
    boxState = ActivityBoxState.Open
  else
    local curNum = data.sc
    if curNum >= boxData.target then
      boxState = ActivityBoxState.CanOpen
    else
      boxState = ActivityBoxState.Close
    end
  end
  return boxState
end

function ActivityPersonalArmsDataManager:IsAllBoxRewardReceivedByType(activityType)
  local actData = self:GetDataByType(activityType)
  if actData == nil or table.IsNullOrEmpty(actData.score_rewards) then
    return false
  end
  for i = 1, #actData.score_rewards do
    if self:GetScoreBoxState(actData, i) ~= ActivityBoxState.Open then
      return false
    end
  end
  return true
end

function ActivityPersonalArmsDataManager:GetActRedNum(activityId)
  local redNum = 0
  local actData = self.dataDict[activityId]
  if actData ~= nil then
    local boxNum = #actData.score_rewards
    for i = 1, boxNum do
      local state = self:GetScoreBoxState(actData, i)
      if state == ActivityBoxState.CanOpen then
        redNum = redNum + 1
      end
    end
    local dayRewardsNum = #actData.day_rewards
    for i = 1, dayRewardsNum do
      local state = self:GetDailyBoxState(actData, i)
      if state == ActivityBoxState.CanOpen then
        redNum = redNum + 1
      end
    end
  end
  return redNum
end

function ActivityPersonalArmsDataManager:ParseRankingData(message)
  if not message then
    return
  end
  local actId = message.activityId
  local preRankingInfo = self.rankList[actId]
  local prePlayerRankData = {}
  if preRankingInfo ~= nil and preRankingInfo.rankList ~= nil then
    local preRankList = preRankingInfo.rankList
    for _, v in pairs(preRankList) do
      prePlayerRankData[v.uid] = v
    end
  end
  local rankingInfo = {}
  local playerRankingInfoMsg = message.owner
  if playerRankingInfoMsg then
    local selfPlayerData = BasePlayerInfo.New()
    selfPlayerData:ParseData(playerRankingInfoMsg)
    selfPlayerData.score = playerRankingInfoMsg.score
    selfPlayerData.rank = playerRankingInfoMsg.rank
    rankingInfo.selfRankData = selfPlayerData
  end
  local maxScore = -1
  rankingInfo.rankList = {}
  local rankingList = message.list
  if rankingList then
    for _, v in pairs(rankingList) do
      local playerData = BasePlayerInfo.New()
      playerData:ParseData(v)
      playerData.score = tonumber(v.score)
      playerData.rank = v.rank
      playerData.level = v.level
      playerData.changerank = 0
      local predata = prePlayerRankData[v.uid]
      if predata ~= nil then
        local changerank = predata.rank - v.rank
        playerData.changerank = changerank
      end
      table.insert(rankingInfo.rankList, playerData)
      if maxScore < playerData.score then
        maxScore = playerData.score
      end
    end
  end
  rankingInfo.maxScore = maxScore
  self.rankList[actId] = rankingInfo
  EventManager:GetInstance():Broadcast(EventId.PersonalArmsRank)
end

function ActivityPersonalArmsDataManager:GetRankDataByActId(actId)
  return self.rankList[actId]
end

function ActivityPersonalArmsDataManager:UpdateRankRewardData(message)
  if not message then
    return
  end
  local actId = message.activityId
  if self.rewards[actId] == nil then
    self.rewards[actId] = {}
  end
  local rewardData = message.rewardList
  local rewardsInfo = {}
  if not table.IsNullOrEmpty(rewardData) then
    for _, v in pairs(rewardData) do
      local rewardInfo = {}
      rewardInfo.minRanking = v.minLv
      rewardInfo.maxRanking = v.maxLv
      rewardInfo.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
      rewardInfo.value = v.value
      table.insert(rewardsInfo, rewardInfo)
    end
  end
  self.rewards[actId] = rewardsInfo
end

function ActivityPersonalArmsDataManager:GetRewardsDataByActId(actId)
  local dataList = {}
  if self.rewards[actId] then
    dataList = self.rewards[actId]
  end
  return dataList
end

function ActivityPersonalArmsDataManager:GetRewardsDataByActIdAndRank(actId, rank)
  local rewardData
  local dataList = {}
  if self.rewards[actId] then
    dataList = self.rewards[actId]
  end
  for k, v in pairs(dataList) do
    if rank >= v.minRanking and rank <= v.maxRanking then
      rewardData = v
      break
    end
  end
  return rewardData
end

function ActivityPersonalArmsDataManager:Description()
  return "\228\189\160\231\140\156\230\136\145\230\152\175\232\176\129\239\188\140\230\136\145\230\152\175\228\184\170\228\186\186\229\134\155\229\164\135\231\171\158\232\181\155\229\149\138\239\188\129\239\188\129"
end

function ActivityPersonalArmsDataManager:GetRankGradeByActIdAndRank(actId, rank)
  local grade = 1
  local dataList = {}
  if self.rewards[actId] then
    dataList = self.rewards[actId]
  end
  for i, v in ipairs(dataList) do
    if rank >= v.minRanking and rank <= v.maxRanking then
      grade = i
      break
    end
  end
  return grade
end

function ActivityPersonalArmsDataManager:SplitScoreList(scores)
  local array = string._split_ss_array(scores, "|")
  local result = {}
  self.scoreGroupDict = {}
  for i = 1, #array do
    local scoreId = array[i]
    local cfg = LocalController:instance():getLine(TableName.Score, scoreId)
    if not string.IsNullOrEmpty(cfg.group) then
      local group = tonumber(cfg.group)
      if self.scoreGroupDict[group] == nil then
        self.scoreGroupDict[group] = {}
        self.scoreGroupDict[group].type = cfg.type
        self.scoreGroupDict[group].cfgList = {}
      end
      local cfgList = self.scoreGroupDict[group].cfgList
      if cfgList[scoreId] == nil then
        cfgList[scoreId] = {}
        cfgList[scoreId].id = tonumber(cfg.id)
        cfgList[scoreId].value = tonumber(cfg.value)
        cfgList[scoreId].name = cfg.tips
        cfgList[scoreId].points = cfg.points
      end
    else
      table.insert(result, scoreId)
    end
  end
  for k, v in pairs(self.scoreGroupDict) do
    local list = self.scoreGroupDict[k].cfgList
    if self.scoreGroupDict[k].type == ScoreType.TrainSolider then
      local soldier = DataCenter.SoldierDataManager:GetCanTrainHighestLevelSoldier()
      local maxLevel = soldier and soldier.lv or 0
      local targetId
      local targetMaxLevel = 0
      for id, score in pairs(list) do
        local curSoldierId = score.value
        local curSoliderTemplate = DataCenter.SoldierDataManager:GetTemplate(curSoldierId)
        if curSoliderTemplate and maxLevel >= curSoliderTemplate.lv and targetMaxLevel < curSoliderTemplate.lv then
          targetId = id
          targetMaxLevel = curSoliderTemplate.lv
        end
      end
      if targetId then
        table.insert(result, 1, targetId)
      end
    end
  end
  return result
end

function ActivityPersonalArmsDataManager:GetScoreGroup(groupId)
  return self.scoreGroupDict[groupId]
end

function ActivityPersonalArmsDataManager:StartStageEndTimer(activityId, stageEndTime)
  self:StopStageEndTimer(activityId)
  local diff = stageEndTime - UITimeManager:GetInstance():GetServerSeconds()
  if 0 < diff then
    if self.stageEndTimerDict == nil then
      self.stageEndTimerDict = {}
    end
    local timer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
      DataCenter.GetDuelScoreManager:ClearDuelInfoByType(GetDuelScoreType.Person)
      SFSNetwork.SendMessage(MsgDefines.ActivityHeroGetInfo, toInt(activityId))
      self:StopStageEndTimer(activityId)
    end, diff)
    self.stageEndTimerDict[activityId] = timer
  end
end

function ActivityPersonalArmsDataManager:StopStageEndTimer(activityId)
  if self.stageEndTimerDict then
    local timer = self.stageEndTimerDict[activityId]
    if timer then
      timer:Stop()
      self.stageEndTimerDict[activityId] = nil
    end
  end
end

function ActivityPersonalArmsDataManager:StopAllStageEndTimer()
  if self.stageEndTimerDict then
    for k, timer in pairs(self.stageEndTimerDict) do
      timer:Stop()
    end
    self.stageEndTimerDict = nil
  end
end

function ActivityPersonalArmsDataManager:SetIsShowSvrTimeDesc(isShowSvrTimeDesc)
  self.isShowSvrTimeDesc = isShowSvrTimeDesc
  CommonUtil.PlayerPrefsSetBool(SettingKeys.PERSONAL_ARMS_SHOW_SVR_TIME, self.isShowSvrTimeDesc)
end

function ActivityPersonalArmsDataManager:GetBadgeItemId(actId)
  actId = checknumber(actId)
  local showData = self:GetCurData(actId)
  if showData ~= nil then
    local cell = LocalController:instance():getLine(TableName.HERO_ACTIVITY, showData.heroActivityId)
    if cell ~= nil then
      local isUp = false
      if not string.IsNullOrEmpty(cell.season_condition_up) then
        local season, seasonDay = string.string2_ii(cell.season_condition_up, ";")
        local curSeason = SeasonUtil.GetSeason()
        local curSeasonDay = SeasonUtil.GetSeasonDay()
        if season < curSeason or curSeason == season and seasonDay <= curSeasonDay then
          isUp = true
        end
      end
      local boxRewardStr = isUp and cell.day_reward_up or cell.day_reward
      if not string.IsNullOrEmpty(boxRewardStr) then
        local boxRewards = string.split(boxRewardStr, "|")
        if table.count(boxRewards) > 0 then
          local boxReward = boxRewards[1]
          local rewards = string.split(boxReward, ";")
          if table.count(rewards) > 0 then
            return checknumber(rewards[1])
          end
        end
      end
    end
  end
  return 9001
end

function ActivityPersonalArmsDataManager:IsExchangeFuncOpen(actId)
  local isOpen = LuaEntry.DataConfig:CheckSwitch("arms_race_exchange")
  if not isOpen then
    return false
  end
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if actData == nil or checknumber(actData.para) ~= 1 then
    return false
  end
  return FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.PersonalArmsExchange)
end

function ActivityPersonalArmsDataManager:GetLeftExchangeTimes(actId)
  if not self:IsExchangeFuncOpen(actId) then
    return 0
  end
  local activityData = self:GetCurData(checknumber(actId))
  if activityData ~= nil then
    local curExchangeTimes = checknumber(activityData.exchangeNum)
    local maxExchangeTimes = LuaEntry.DataConfig:TryGetNum("person_arms_race", "k7", 0)
    return math.max(0, maxExchangeTimes - curExchangeTimes)
  end
  return 0
end

function ActivityPersonalArmsDataManager:SendExchange(aid, fromIndex, fromStage, toIndex, toStage)
  if not self:IsExchangeFuncOpen(aid) then
    return
  end
  local leftTime = self:GetLeftExchangeTimes(aid)
  if leftTime <= 0 then
    return
  end
  self:ClearCalenderData(aid)
  local param = {}
  param.aid = aid
  param.startIndex = fromIndex
  param.startStage = fromStage
  param.endIndex = toIndex
  param.endStage = toStage
  SFSNetwork.SendMessage(MsgDefines.ActivityHeroExchange, param)
end

function ActivityPersonalArmsDataManager:OnExchange(res)
  EventManager:GetInstance():Broadcast(EventId.ActivityPersonalArmsExchangeCallback)
end

function ActivityPersonalArmsDataManager:NeedExchangeGuide(aid)
  if self:IsExchangeFuncOpen(aid) then
    local isFirstOpen = CommonUtil.PlayerPrefsGetInt("PERSONAL_ARMS_CALENDAR_EXCHANGE_GUIDE", 0)
    return isFirstOpen == 0
  end
  return false
end

function ActivityPersonalArmsDataManager:SetExchangeGuided(trigger)
  CommonUtil.PlayerPrefsSetInt("PERSONAL_ARMS_CALENDAR_EXCHANGE_GUIDE", 1)
  if trigger then
    EventManager:GetInstance():Broadcast(EventId.ActivityPersonalArmsCalendarExchangeRed)
  end
end

function ActivityPersonalArmsDataManager:NeedExchangeConfirmMessage(aid)
  if self:IsExchangeFuncOpen(aid) then
    local isFirstOpen = CommonUtil.PlayerPrefsGetInt("PERSONAL_ARMS_CALENDAR_EXCHANGE_FIRST", 0)
    return isFirstOpen == 0
  end
  return false
end

function ActivityPersonalArmsDataManager:SetExchangeConfirmed()
  CommonUtil.PlayerPrefsSetInt("PERSONAL_ARMS_CALENDAR_EXCHANGE_FIRST", 1)
end

return ActivityPersonalArmsDataManager
