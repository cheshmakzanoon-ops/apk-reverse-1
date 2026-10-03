local SeasonNuclearPowerPlantDataManager = BaseClass("SeasonNuclearPowerPlantDataManager")
local Localization = CS.GameEntry.Localization
local WorldMarchData = require("DataCenter.WorldMarchDataManager.WorldMarchData")

function SeasonNuclearPowerPlantDataManager:__init()
  self.buildStartTime = 0
  self.activityScoreMax = nil
  self.serverRankData = {}
  self.playerServerRankDate = nil
  self.monsterListData = {}
  self.perserRankData = nil
  self.perserDamageRankData = nil
  self.rankdRewardInfo = {}
  self.monsterExtraData = {}
  self.attackBossTime = 0
  self.attackOrBuildTime = {}
  self.activityTastData = {}
  self.activityTaskRedState = false
  self.activityPersonalTaskRedState = false
  self.activityServerTaskRedState = false
end

function SeasonNuclearPowerPlantDataManager:__delete()
  self.buildStartTime = nil
  self.serverRankData = nil
  self.playerServerRankDate = nil
  self.activityScoreMax = nil
  self.monsterListData = nil
  self.rankdRewardInfo = nil
  self.monsterExtraData = nil
  self.attackBossTime = nil
end

function SeasonNuclearPowerPlantDataManager:InitMsg(t)
  if t and t.attack_behemoth_boss_time then
    self.attackBossTime = t.attack_behemoth_boss_time
  else
    self.attackBossTime = 0
  end
end

function SeasonNuclearPowerPlantDataManager:SetAttackBossTime(t)
  if t.attackTime then
    self.attackBossTime = t.attackTime
  end
end

function SeasonNuclearPowerPlantDataManager:GetAttackBossTime()
  return self.attackBossTime
end

function SeasonNuclearPowerPlantDataManager:GetAttackBossMaxTime()
  local acitvityInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonNuclearPowerPlantActivity.Type)
  if acitvityInfo and acitvityInfo[1] and acitvityInfo[1].para_5 then
    return toInt(acitvityInfo[1].para_5)
  end
  return 0
end

function SeasonNuclearPowerPlantDataManager:GetBuildNuclearFurnaceMaxTime()
  local acitvityInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonNuclearPowerPlantActivity.Type)
  if acitvityInfo and acitvityInfo[1] and acitvityInfo[1].para_1 then
    return toInt(acitvityInfo[1].para_1)
  end
  return 0
end

function SeasonNuclearPowerPlantDataManager:GetBuildNuclearFurnaceTime()
  local max = self:GetBuildNuclearFurnaceMaxTime()
  local count = 0
  local loginServerId = self.GetActivityLegalServerId()
  if self.attackOrBuildTime then
    for key, value in pairs(self.attackOrBuildTime) do
      if value.type == 1 and value.serverId == loginServerId then
        count = value.count
        break
      end
    end
  end
  if max >= count then
    return max - count
  end
  return 0
end

function SeasonNuclearPowerPlantDataManager:GetActivityLegalServerId()
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if selfServerId == loginServerId then
    return loginServerId
  elseif DataCenter.SeasonFactionWarDataManager:IsSameAsMineCamp(loginServerId) then
    return loginServerId
  end
  return selfServerId
end

function SeasonNuclearPowerPlantDataManager:GetBuildNuclearFurnaceActivityId()
  local acitvityInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonNuclearPowerPlantActivity.Type)
  if acitvityInfo and acitvityInfo[1] then
    return acitvityInfo[1].id
  end
end

function SeasonNuclearPowerPlantDataManager:BuildNuclearPowerBtnOpen()
  local version = self:ActivityVersion()
  local crossConditionFlag = false
  if version == 0 then
    if LuaEntry.Player:AtHomeNow() then
      crossConditionFlag = true
    end
  elseif version == 1 then
    local selfServerId = LuaEntry.Player:GetSourceServerId()
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local curServerId = LuaEntry.Player:GetCurServerId()
    if loginServerId == curServerId then
      if selfServerId == loginServerId then
        crossConditionFlag = true
      elseif DataCenter.SeasonFactionWarDataManager:IsSameAsMineCamp(loginServerId) then
        crossConditionFlag = true
      end
    end
  end
  if crossConditionFlag then
    local acitvityInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonNuclearPowerPlantActivity.Type)
    local tBuildStartTime
    if acitvityInfo and acitvityInfo[1] then
      local now = UITimeManager:GetInstance():GetServerTime()
      tBuildStartTime = self:GetBuildStartTime(acitvityInfo[1].id)
      if tBuildStartTime and 0 < tBuildStartTime and now > tBuildStartTime and now < acitvityInfo[1].endTime then
        return true
      end
    end
  end
  return false
end

function SeasonNuclearPowerPlantDataManager:GetScoreMax()
  if self.activityScoreMax == nil or self.activityScoreMax == 0 then
    local max = LuaEntry.DataConfig:TryGetNum("congress_config", "k1")
    self.activityScoreMax = max
  end
  return self.activityScoreMax
end

function SeasonNuclearPowerPlantDataManager:GetBuildStartTime(actId)
  if self.buildStartTime == nil or self.buildStartTime == 0 then
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(actId))
    if actInfo and actInfo.donateStartTime then
      self.buildStartTime = actInfo.donateStartTime
    end
  end
  return self.buildStartTime
end

function SeasonNuclearPowerPlantDataManager:GetMonsterKillReward(uuid, sendFlag)
  if self.monsterExtraData[uuid] then
    return self.monsterExtraData[uuid].reward
  elseif sendFlag then
    SFSNetwork.SendMessage(MsgDefines.ViewBehemothBossList)
  end
end

function SeasonNuclearPowerPlantDataManager:GetMonsterSkillHurt(uuid)
  if self.monsterExtraData[uuid] then
    return self.monsterExtraData[uuid].skill_hurt
  end
  return 0
end

function SeasonNuclearPowerPlantDataManager:GetServerRankData()
  return self.serverRankData
end

function SeasonNuclearPowerPlantDataManager:GetServerRankDataCache()
  local serverId = self:GetActivityLegalServerId()
  local tScore = DataCenter.WorldAllianceCityDataManager:GetThroneNuclearScore(serverId)
  return {score = tScore}
end

function SeasonNuclearPowerPlantDataManager:GetMonsterList()
  local result = {}
  if self.monsterListData then
    for key, value in pairs(self.monsterListData) do
      table.insert(result, value)
    end
  end
  table.sort(result, function(a, b)
    if a.isAlive ~= b.isAlive then
      if a.isAlive then
        return true
      end
      return false
    end
    if a.isAlive then
      if a.priority == b.priority then
        return a.uuid < b.uuid
      end
      return a.priority > b.priority
    else
      return a.killTime > b.killTime
    end
  end)
  return result
end

function SeasonNuclearPowerPlantDataManager:UpdateBuildStartTime(msg)
  if msg and msg.actId and msg.donateStartTime then
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(msg.actId))
    if actInfo then
      actInfo.donateStartTime = msg.donateStartTime
      self.buildStartTime = msg.donateStartTime
      EventManager:GetInstance():Broadcast(EventId.ActNuclearBuildStartTimeUpdate)
    end
  end
end

function SeasonNuclearPowerPlantDataManager:UpdateMonsterData(data, value)
  data.uuid = value.uuid
  data.id = value.behemothId
  data.monsterId = value.monsterId
  data.startPointId = value.startPointId
  data.endPointId = value.endPointId
  data.marchState = value.marchState
  data.startTime = value.startTime
  data.endTime = value.endTime
  data.armyUnit = value.armyUnit
  data.killTime = value.killTime
  data.bossHp = value.armyUnit / value.totalArmyUnit
  data.killUserInfo = value.killUserInfo
  if data.march == nil then
    data.march = WorldMarchData.New()
  end
  data.march:UpdateWorldMarch(value.marchMsg)
  data.serverId = value.serverId
  if self.monsterExtraData[value.uuid] == nil then
    self.monsterExtraData[value.uuid] = {}
    self.monsterExtraData[value.uuid].reward = DataCenter.RewardManager:ReturnRewardParamForView(value.killReward)
    self.monsterExtraData[value.uuid].configId = data.id
    local config = LocalController:instance():getLine(TableName.Season_Congress_Boss, data.id)
    if config then
      self.monsterExtraData[value.uuid].skill_hurt = config.skill_hurt
    else
      self.monsterExtraData[value.uuid].skill_hurt = 0
    end
  end
  data.isAlive = value.armyUnit > 0
  local serverScore = LuaEntry.Player:GetSourceServerId() == data.serverId and 100 or 0
  local hpR = 1 - data.bossHp
  if 1 < hpR then
    hpR = 1
  elseif hpR < 0 then
    hpR = 0
  end
  data.priority = serverScore + hpR
end

function SeasonNuclearPowerPlantDataManager:UpdateMonsterListData(msg)
  if msg then
    if self.monsterExtraData == nil then
      self.monsterExtraData = {}
    end
    local serverDataCount = 0
    if msg.behemothBossArr then
      for index, value in ipairs(msg.behemothBossArr) do
        local data = self.monsterListData[index]
        if data == nil then
          data = {}
          self.monsterListData[index] = data
        end
        self:UpdateMonsterData(data, value)
        serverDataCount = serverDataCount + 1
      end
    end
    if msg.otherServerBehemothBossArr then
      for index, value in ipairs(msg.otherServerBehemothBossArr) do
        serverDataCount = serverDataCount + 1
        local data = self.monsterListData[serverDataCount]
        if data == nil then
          data = {}
          self.monsterListData[serverDataCount] = data
        end
        self:UpdateMonsterData(data, value)
      end
    end
    if serverDataCount < #self.monsterListData then
      for index = serverDataCount + 1, #self.monsterListData do
        self.monsterListData[index] = nil
      end
    end
    EventManager:GetInstance():Broadcast(EventId.ActNuclearMonsterListUpdate)
  end
end

function SeasonNuclearPowerPlantDataManager:UpdateRankData(msg)
  if msg and msg.rankType then
    local activityId = msg.activityId
    if msg.rankType == 1 then
      local selfServerId = LuaEntry.Player:GetSourceServerId()
      local serverId = LuaEntry.Player:GetSourceServerId()
      for index, value in ipairs(msg.ranks) do
        local data = self.serverRankData[index]
        if data == nil then
          data = {}
          self.serverRankData[index] = data
        end
        data.serverId = toInt(value.serverInfo.serverId)
        data.score = value.score
        data.rank = index
        data.rankScore = value.rankScore
        data.serverInfo = value.serverInfo
      end
      if #self.serverRankData > #msg.ranks then
        Logger.LogError("SeasonNuclearPowerPlantDataManager logicerror: ")
        for index = #msg.ranks + 1, #self.serverRankData do
          self.serverRankData[index] = nil
        end
      end
      EventManager:GetInstance():Broadcast(EventId.ActNuclearServerRankUpdate)
    elseif msg.rankType == 2 then
      if self.perserRankData == nil then
        self.perserRankData = {}
      end
      if self.perserRankData.rank == nil then
        self.perserRankData.rank = {}
      end
      for index, value in ipairs(msg.ranks) do
        local data = self.perserRankData.rank[index]
        if data == nil then
          local itemType = PlayerRankData
          data = itemType.New()
          self.perserRankData.rank[index] = data
        end
        data:ParseData(value, nil)
        data:SetRank(index)
      end
      self.perserRankData.selfRank = msg.rank
      self.perserRankData.selfScore = msg.score
      EventManager:GetInstance():Broadcast(EventId.ActNuclearBuildStartPersonalRankUpdate, activityId)
    elseif msg.rankType == 3 then
      if self.perserDamageRankData == nil then
        self.perserDamageRankData = {}
      end
      if self.perserDamageRankData.rank == nil then
        self.perserDamageRankData.rank = {}
      end
      for index, value in ipairs(msg.ranks) do
        local data = self.perserDamageRankData.rank[index]
        if data == nil then
          local itemType = PlayerRankData
          data = itemType.New()
          self.perserDamageRankData.rank[index] = data
        end
        data:ParseData(value, nil)
        data:SetRank(index)
      end
      self.perserDamageRankData.selfRank = msg.rank
      self.perserDamageRankData.selfScore = msg.score
      EventManager:GetInstance():Broadcast(EventId.ActNuclearPersonalDamageRankUpdate, activityId)
    end
  end
end

function SeasonNuclearPowerPlantDataManager:GetSelfRankData(index)
  if index == 2 then
    if self.perserRankData and self.perserRankData.selfRank and self.perserRankData.selfScore then
      return {
        rank = self.perserRankData.selfRank,
        score = self.perserRankData.selfScore
      }
    end
  elseif index == 3 and self.perserDamageRankData and self.perserDamageRankData.selfRank and self.perserDamageRankData.selfScore then
    return {
      rank = self.perserDamageRankData.selfRank,
      score = self.perserDamageRankData.selfScore
    }
  end
  return {rank = 0, score = 0}
end

function SeasonNuclearPowerPlantDataManager:GetRankData(index)
  if index == 1 and self.perserRankData then
    return self.perserRankData.rank
  elseif index == 2 and self.perserDamageRankData then
    return self.perserDamageRankData.rank
  end
  return nil
end

function SeasonNuclearPowerPlantDataManager:HandleRankRewardInfo(message)
  local activityId = message.activityId
  local rankType = message.rankType
  local rankReward = message.rankReward
  if activityId and rankType and rankReward then
    local rewardsInfo = {}
    if not table.IsNullOrEmpty(rankReward) then
      for _, v in pairs(rankReward) do
        local rewardInfo = {}
        local rank = v.rank
        local rankRange = string.split(rank, "-")
        if 1 < #rankRange then
          rewardInfo.minRanking = toInt(rankRange[1])
          rewardInfo.maxRanking = toInt(rankRange[2])
          rewardInfo.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.rewards)
          table.insert(rewardsInfo, rewardInfo)
        elseif 0 < #rankRange then
          rewardInfo.minRanking = toInt(rankRange[1])
          rewardInfo.maxRanking = toInt(rankRange[1])
          rewardInfo.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.rewards)
          table.insert(rewardsInfo, rewardInfo)
        end
      end
    end
    self.rankdRewardInfo[rankType] = rewardsInfo
    EventManager:GetInstance():Broadcast(EventId.ActNuclearRankReweardUpdate)
  end
end

function SeasonNuclearPowerPlantDataManager:GetRankRewardInfo(rankType)
  if self.rankdRewardInfo then
    return self.rankdRewardInfo[rankType]
  end
  return nil
end

function SeasonNuclearPowerPlantDataManager:ActivityVersion()
  local acitvityInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonNuclearPowerPlantActivity.Type)
  if acitvityInfo and acitvityInfo[1] then
    local v = toInt(acitvityInfo[1].para)
    if v ~= 1 then
      v = 0
    end
    return v
  end
  return 0
end

function SeasonNuclearPowerPlantDataManager:UpdataDailyTime(msg)
  if msg and msg.userBehemothDailyTimeArr then
    local selfServerId = LuaEntry.Player:GetSourceServerId()
    for key, value in pairs(msg.userBehemothDailyTimeArr) do
      if self.attackOrBuildTime[value.targetUuid] == nil then
        self.attackOrBuildTime[value.targetUuid] = {}
      end
      self.attackOrBuildTime[value.targetUuid].type = value.type
      self.attackOrBuildTime[value.targetUuid].count = value.num
      self.attackOrBuildTime[value.targetUuid].serverId = value.serverId
    end
  end
end

function SeasonNuclearPowerPlantDataManager:GetDailyAttackOrBuildTime(uuid)
  if self.attackOrBuildTime and self.attackOrBuildTime[uuid] and self.attackOrBuildTime[uuid].count then
    return self.attackOrBuildTime[uuid].count
  end
  return 0
end

function SeasonNuclearPowerPlantDataManager:UpdateTaskData(taskData, msgDate)
  taskData.taskId = msgDate.taskId
  taskData.subType = msgDate.subType
  taskData.num = msgDate.num
  taskData.state = msgDate.state
  if taskData.reward == nil then
    taskData.reward = DataCenter.RewardManager:ReturnRewardParamForView(msgDate.reward)
  end
end

function SeasonNuclearPowerPlantDataManager:GetActivityTaskRedState()
  return self.activityTaskRedState
end

function SeasonNuclearPowerPlantDataManager:GetActivityPersonalTaskRedState()
  return self.activityPersonalTaskRedState
end

function SeasonNuclearPowerPlantDataManager:GetActivityServerTaskRedState()
  return self.activityServerTaskRedState
end

function SeasonNuclearPowerPlantDataManager:InitActivityTaskData(msg)
  if msg and msg.behemothTaskArr then
    if self.activityTastData == nil then
      self.activityTastData = {}
    end
    local flagTab1 = false
    local flagTab2 = false
    for key, value in pairs(msg.behemothTaskArr) do
      local taskId = value.taskId
      local taskData = self.activityTastData[taskId]
      if taskData == nil then
        taskData = {}
        self.activityTastData[taskId] = taskData
      end
      if value.state == TaskState.CanReceive then
        if value.subType == 0 and not flagTab1 then
          flagTab1 = true
        elseif value.subType == 1 and not flagTab1 then
          flagTab2 = true
        end
      end
      self:UpdateTaskData(taskData, value)
    end
    self.activityPersonalTaskRedState = flagTab1
    self.activityServerTaskRedState = flagTab2
    self.activityTaskRedState = flagTab1 or flagTab2
    EventManager:GetInstance():Broadcast(EventId.ActNuclearTaskRedStateChange)
    EventManager:GetInstance():Broadcast(EventId.ActNuclearTaskDataInit)
  end
end

function SeasonNuclearPowerPlantDataManager:ActivityBehemothTaskUpdate(t)
  if t and t.behemothTaskInfo then
    local taskId = t.behemothTaskInfo.taskId
    local taskData = self.activityTastData[taskId]
    if taskData == nil then
      taskData = {}
      self.activityTastData[taskId] = taskData
    end
    self:UpdateTaskData(taskData, t.behemothTaskInfo)
    if taskData.state == TaskState.CanReceive then
      if taskData.subType == 0 then
        self.activityPersonalTaskRedState = true
      elseif taskData.subType == 1 then
        self.activityServerTaskRedState = true
      end
    end
    self.activityTaskRedState = self.activityPersonalTaskRedState or self.activityServerTaskRedState
    EventManager:GetInstance():Broadcast(EventId.ActNuclearTaskRedStateChange)
    EventManager:GetInstance():Broadcast(EventId.ActNuclearTaskStateUpdate)
  end
end

function SeasonNuclearPowerPlantDataManager:ActivityBehemothTaskGetReward(t)
  if t then
    if t.behemothTaskInfo then
      local taskId = t.behemothTaskInfo.taskId
      local taskData = self.activityTastData[taskId]
      if taskData then
        self:UpdateTaskData(taskData, t.behemothTaskInfo)
      else
        Logger.LogError("task data is nil, TaskId:" .. taskId)
      end
    end
    self.activityTaskRedState = false
    self.activityServerTaskRedState = false
    self.activityPersonalTaskRedState = false
    for key, value in pairs(self.activityTastData) do
      if value.state == TaskState.CanReceive then
        if value.subType == 0 then
          self.activityPersonalTaskRedState = true
        elseif value.subType == 1 then
          self.activityServerTaskRedState = true
        end
        if self.activityPersonalTaskRedState and self.activityServerTaskRedState then
          break
        end
      end
    end
    self.activityTaskRedState = self.activityPersonalTaskRedState or self.activityServerTaskRedState
    if t.reward then
      DataCenter.RewardManager:AddRewardsAndRes(t)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    EventManager:GetInstance():Broadcast(EventId.ActNuclearTaskRedStateChange)
    EventManager:GetInstance():Broadcast(EventId.ActNuclearTaskReweardGetSuccess)
  end
end

function SeasonNuclearPowerPlantDataManager:GetActivityTaskList(taskType)
  local result = {}
  if self.activityTastData then
    for key, value in pairs(self.activityTastData) do
      if value.subType == taskType then
        table.insert(result, value)
      end
    end
  end
  return result
end

function SeasonNuclearPowerPlantDataManager:CheckShowTip(conditionType)
  if not LuaEntry.Player:AtHomeNow() then
    if conditionType == MainUITipCondition.SeasonNuclearActivityMonster then
      local flag = CommonUtil.PlayerPrefsGetInt(SettingKeys.NUCLEAR_MONSTER_TIP_KEY, 0)
      if flag == 0 then
        local selfServerId = LuaEntry.Player:GetSourceServerId()
        for key, value in pairs(self.monsterListData) do
          if value.serverId == selfServerId and 0 < value.bossHp then
            return true
          end
        end
      end
      return false
    elseif conditionType == MainUITipCondition.SeasonNuclearActivityNonFinish then
      local today = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
      local recordDay = CommonUtil.PlayerPrefsGetInt(SettingKeys.NUCLEAR_NON_FINISH_TIP_KEY, 0)
      if today ~= recordDay then
        local selfServerId = LuaEntry.Player:GetSourceServerId()
        local tScore = DataCenter.WorldAllianceCityDataManager:GetThroneNuclearScore(selfServerId)
        local maxScore = DataCenter.SeasonNuclearPowerPlantDataManager:GetScoreMax()
        if tScore <= maxScore then
          return true
        end
      end
      return false
    end
  end
  return false
end

function SeasonNuclearPowerPlantDataManager:SetTipBubbleShow(conditionType)
  if conditionType == MainUITipCondition.SeasonNuclearActivityMonster then
    CommonUtil.PlayerPrefsSetInt(SettingKeys.NUCLEAR_MONSTER_TIP_KEY, 1)
  elseif conditionType == MainUITipCondition.SeasonNuclearActivityNonFinish then
    local today = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
    CommonUtil.PlayerPrefsSetInt(SettingKeys.NUCLEAR_NON_FINISH_TIP_KEY, today)
  end
end

return SeasonNuclearPowerPlantDataManager
