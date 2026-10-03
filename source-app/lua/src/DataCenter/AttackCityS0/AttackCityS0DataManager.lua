local AttackCityS0DataManager = BaseClass("AttackCityS0DataManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.AllianceRankList = {}
  self.AllianceRankDetailMap = {}
  self.BattlePassScoreTaskList = {}
  self.BattlePassCityTaskMap = {}
  self.BattlePassScore = 0
  self.curMaxCityLevel = 0
  self.CityClueData = {}
  self.activityState = 0
  self.curCityLevel = 0
  self.nextStateTime = 0
  self.toggleState = false
  self.radarStateList = nil
end

local function __delete(self)
  self.AllianceRankList = nil
  self.AllianceRankDetailMap = nil
  self.BattlePassScoreTaskList = nil
  self.BattlePassCityTaskMap = nil
  self.BattlePassScore = nil
  self.curMaxCityLevel = nil
  self.CityClueData = nil
  self.fixedTaskMap = nil
  self.activityState = nil
  self.curCityLevel = nil
  self.nextStateTime = nil
  self.toggleState = nil
  self.radarStateList = nil
end

function AttackCityS0DataManager:GetCityAttackActivityInfoMsg()
  SFSNetwork.SendMessage(MsgDefines.CityCompetitionS0GainActivityInfo)
end

function AttackCityS0DataManager:GetAllianceRankMsg()
  SFSNetwork.SendMessage(MsgDefines.CityCompetitionS0GainAllianceRankPreviewInfo)
end

function AttackCityS0DataManager:GetAllianceRankDetailMsg(CityId)
  SFSNetwork.SendMessage(MsgDefines.CityCompetitionS0GainAllianceRankDetailInfo, CityId)
end

function AttackCityS0DataManager:GetBattlePassTaskMsg(cityLv)
  SFSNetwork.SendMessage(MsgDefines.CityCompetitionS0GainTaskInfo, cityLv)
end

function AttackCityS0DataManager:SendBattlePassTaskRewardMsg(cityLv, configId)
  SFSNetwork.SendMessage(MsgDefines.CityCompetitionS0GainTaskReward, cityLv, configId)
end

function AttackCityS0DataManager:SendThumpsUpRewardMsg(cityId, targetUid)
  if targetUid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
  else
    SFSNetwork.SendMessage(MsgDefines.CityCompetitionS0GainThumbsUpReward, cityId, targetUid)
  end
end

function AttackCityS0DataManager:SendCityClueMsg()
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.CityCompetitionS0GainCityClueInfo)
  end
end

function AttackCityS0DataManager:SendUnlockCityClueRewardMsg(configId)
  SFSNetwork.SendMessage(MsgDefines.CityCompetitionS0CityClueUnlockReward, configId)
end

function AttackCityS0DataManager:SendGetCityClueRewardMsg(configId)
  SFSNetwork.SendMessage(MsgDefines.CityCompetitionS0CityClueGainReward, tonumber(configId))
end

function AttackCityS0DataManager:UpdateActivityMainMessage(msg)
  self.activityState = msg.activityState
  self.curCityLevel = msg.curCityLevel
  self.nextStateTime = msg.nextStateTime
end

function AttackCityS0DataManager:UpdateCityClueInfoMessage(msg)
  self.CityClueData = {
    unLock = msg.unLock,
    hasReward = msg.hasReward,
    configId = msg.configId,
    curCount = msg.curCount,
    cityClueList = msg.cityClueList
  }
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.AttackCityS0CityClueInfo)
end

function AttackCityS0DataManager:UpdateRewardInfoMessage(msg)
  if msg.configId and msg.configId == self.CityClueData.configId then
    self.CityClueData.hasReward = true
  end
  local rewards = msg.reward
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  EventManager:GetInstance():Broadcast(EventId.AttackCityS0CityClueInfo)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function AttackCityS0DataManager:UpdateAllianceRankMessage(msg)
  self.AllianceRankList = msg.ranks
  EventManager:GetInstance():Broadcast(EventId.AttackCityS0ThreeRankInfo)
end

function AttackCityS0DataManager:UpdateAllianceRankDetailMessage(msg)
  if msg.cityId then
    self.AllianceRankDetailMap[msg.cityId] = {
      selfRank = msg.self,
      rankList = msg.ranks,
      battleResult = msg.battleResult,
      battleEndTime = msg.battleEndTime,
      selfAllianceInfo = msg.selfAllianceInfo,
      targetAllianceInfo = msg.targetAllianceInfo
    }
    EventManager:GetInstance():Broadcast(EventId.AttackCityRankDetailList)
  end
end

function AttackCityS0DataManager:UpdateBattlePassTaskMessage(msg)
  self.BattlePassScore = msg.score
  self.curMaxCityLevel = msg.maxCityLevel
  if msg.taskInfo then
    for k, v in pairs(msg.taskInfo) do
      if v.cityLv == -1 then
        self.BattlePassScoreTaskList = v.taskRequests
      else
        self.BattlePassCityTaskMap[v.cityLv] = v.taskRequests
      end
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.AttackCityS0BattlePass)
  end
end

function AttackCityS0DataManager:UpdateBattlePassTaskRewardStateMessage(msg)
  if msg.cityLv and msg.taskInfo then
    if msg.cityLv == -1 then
      if self.BattlePassScoreTaskList then
        local msgMap = {}
        for _, m in ipairs(msg.taskInfo) do
          for _, v in ipairs(m.taskRequests) do
            msgMap[v.configId] = v
          end
        end
        for _, task in ipairs(self.BattlePassScoreTaskList) do
          local upd = msgMap[task.configId]
          if upd then
            task.hasReward = upd.hasReward
          end
        end
      end
    elseif self.BattlePassCityTaskMap[msg.cityLv] then
      local msgMap = {}
      for _, m in ipairs(msg.taskInfo) do
        for _, v in ipairs(m.taskRequests) do
          msgMap[v.configId] = v
        end
      end
      for _, task in ipairs(self.BattlePassCityTaskMap[msg.cityLv]) do
        local upd = msgMap[task.configId]
        if upd then
          task.hasReward = upd.hasReward
        end
      end
    end
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  if msg.reward then
    local rewards = msg.reward
    DataCenter.RewardManager:AddRewardsAndRes(msg)
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
end

function AttackCityS0DataManager:PushRefreshMsg(t)
  if t.updateType == 0 then
    self:GetCityAttackActivityInfoMsg()
    self:SendCityClueMsg()
    self:GetBattlePassTaskMsg(CityAttackS0NewBattlePassType.ALL)
  elseif t.updateType == 1 then
    self:SendCityClueMsg()
  elseif t.updateType == 2 then
    self:GetBattlePassTaskMsg(CityAttackS0NewBattlePassType.ALL)
  elseif t.updateType == 3 then
    if t.extendInfo and tonumber(t.extendInfo) == 1 then
      local goodsId = DataCenter.AttackCityS0ConfigManager:GetCityClueItemIdAndLevelLimit()
      local scoreNum = 1
      local reward = {}
      if goodsId and scoreNum then
        local param = {
          type = RewardType.GOODS,
          value = {count = scoreNum, itemId = goodsId}
        }
        table.insert(reward, param)
      end
      DataCenter.RewardManager:AddRewardsAndRes({reward = reward})
      DataCenter.RewardManager:ShowCommonReward({reward = reward})
    end
  elseif t.updateType == 4 then
    UIUtil.ShowTipsId("city_war_detect_event_07")
  elseif t.updateType == 5 then
    DataCenter.RadarCenterDataManager:GetDetectEventData()
  end
end

function AttackCityS0DataManager:UpdateThumbsUpRewardMessage(msg)
  if self.AllianceRankList then
    for _, v in pairs(self.AllianceRankList) do
      if msg.cityId == v.cityId then
        for _, value in pairs(v.ranks) do
          if value.roleInfo.uid == msg.targetUid then
            value.isThumbsUp = true
            value.thumbsUpCount = value.thumbsUpCount + 1
          end
        end
        break
      end
    end
  end
  if self.AllianceRankDetailMap[msg.cityId] then
    for _, v in pairs(self.AllianceRankDetailMap[msg.cityId].rankList) do
      if v.roleInfo.uid == msg.targetUid then
        v.isThumbsUp = true
        v.thumbsUpCount = v.thumbsUpCount + 1
      end
    end
  end
  DataCenter.WorldAllianceCityDataManager:UpdateOccupyReward(msg.cityId, msg.targetUid)
  EventManager:GetInstance():Broadcast(EventId.AttackCityThumbsUpRewardRefresh)
  local rewards = msg.reward
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  DataCenter.RewardManager:ShowCommonReward({reward = rewards})
end

function AttackCityS0DataManager:GetCityClueAndRadarOpenState()
  return self.activityState == CityAttackS0ActivityState.Waiting
end

function AttackCityS0DataManager:GetActivityState()
  return self.activityState
end

function AttackCityS0DataManager:JudgeActOpen()
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.S0AttackCityNew.Type)
  if actData then
    return DataCenter.ActivityListDataManager:CheckIsSend(actData)
  else
    return false
  end
end

function AttackCityS0DataManager:GetActCityLevelAndStateTime()
  return self.curCityLevel, self.nextStateTime
end

function AttackCityS0DataManager:GetOccupyRewardByCityId(cityId)
  return DataCenter.WorldAllianceCityDataManager:GetOccupyRewardByCityId(cityId)
end

function AttackCityS0DataManager:GetAllianceNormalRankInfo()
  return self.AllianceRankList
end

function AttackCityS0DataManager:GetAllianceRankDetailInfo(cityId)
  return self.AllianceRankDetailMap[cityId]
end

function AttackCityS0DataManager:GetScoreBattlePassInfo()
  return self.BattlePassScoreTaskList
end

function AttackCityS0DataManager:GetBattlePassScore()
  return self.BattlePassScore
end

function AttackCityS0DataManager:GetMaxCityLevel()
  return self.curMaxCityLevel
end

function AttackCityS0DataManager:GetCityLvTaskInfo(cityLv)
  return self.BattlePassCityTaskMap[cityLv]
end

function AttackCityS0DataManager:GetCityClueInfo()
  return self.CityClueData
end

function AttackCityS0DataManager:HaveRadarEventInThisCity(cityId)
  local radarList = self:GetDetectEventInfoByType(DetectEventType.AttackCityS0_City_Scout)
  local haveRadar = false
  table.walk(radarList, function(k, v)
    if v.cityId == cityId and v.state ~= DetectEventState.DETECT_EVENT_STATE_FINISHED and v.state ~= DetectEventState.DETECT_EVENT_STATE_REWARDED and not self:GetCityDetectRadarIsDoing(v.uuid) then
      haveRadar = true
    end
  end)
  return haveRadar
end

function AttackCityS0DataManager:GetDetectEventInfoByTypeAndCityId(type, cityId)
  local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local uuid
  table.walk(list, function(k, v)
    local param = self:GetOneEventData(v)
    if param ~= nil and param.type == type and param.cityId and param.cityId == cityId then
      uuid = v
    end
  end)
  return uuid
end

function AttackCityS0DataManager:GetDetectEventInfoByType(type)
  local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local result = {}
  table.walk(list, function(k, v)
    local param = self:GetOneEventData(v)
    if param ~= nil and param.type == type then
      table.insert(result, param)
    end
  end)
  return result
end

function AttackCityS0DataManager:GetOneEventData(uuid)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if data == nil then
    return nil
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template == nil then
    return nil
  end
  local param = {}
  param.uuid = uuid
  param.eventId = data.eventId
  param.state = data.state
  param.pointId = data.pointId
  param.type = template.type
  param.helpInfo = data.helpInfo
  param.cityId = data.originalData.cityIdS0
  param.configIdS0 = data.originalData.configIdSO
  param.completeByHelper = data.completeByHelper
  param.endTime = data.endTime
  return param
end

function AttackCityS0DataManager:GetOneEventFeatureConfigId(pointId)
  local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local result = ""
  table.walk(list, function(k, v)
    local param = self:GetOneEventData(v)
    if param ~= nil and param.type == DetectEventType.AttackCityS0_City_Monster and pointId == param.pointId and param.state ~= DetectEventState.DETECT_EVENT_STATE_FINISHED and param.state ~= DetectEventState.DETECT_EVENT_STATE_REWARDED then
      result = param.eventId
    end
  end)
  return result
end

function AttackCityS0DataManager:HavePointIdRadar(pointId)
  local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local have = false
  table.walk(list, function(k, v)
    local param = self:GetOneEventData(v)
    if param ~= nil and param.type == DetectEventType.AttackCityS0_City_Monster and pointId == param.pointId then
      have = true
    end
  end)
  return have
end

function AttackCityS0DataManager:GetOneEventDataByPointId(pointId)
  local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local result
  table.walk(list, function(k, v)
    local param = self:GetOneEventData(v)
    if param ~= nil and param.type == DetectEventType.AttackCityS0_City_Monster and pointId == param.pointId then
      result = param
    end
  end)
  return result
end

function AttackCityS0DataManager:GetDetectEventInfoByEventId(eventId)
  local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local cityId
  table.walk(list, function(k, v)
    local param = self:GetOneEventData(v)
    if param ~= nil and tonumber(param.eventId) == eventId then
      cityId = param.cityId
    end
  end)
  return cityId
end

function AttackCityS0DataManager:GetCityClueRedPoint()
  if self.CityClueData and not table.IsNullOrEmpty(self.CityClueData) then
    if self.CityClueData.unLock and not self.CityClueData.hasReward then
      return 1
    end
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    local param = DataCenter.AttackCityS0ConfigManager:GetCityClueConfigData(self.CityClueData.configId)
    if isR4orR5 and self.CityClueData.curCount == tonumber(param.total) and not self.CityClueData.unLock then
      return 1
    end
  end
  return 0
end

function AttackCityS0DataManager:GetBattlePassRedPointNum()
  local score = self:GetBattlePassScoreRedPointNum()
  local cityRed = self:GetBattlePassCitySRedPointNum()
  return score + cityRed
end

function AttackCityS0DataManager:GetBattlePassScoreRedPointNum()
  local count = 0
  for _, task in ipairs(self.BattlePassScoreTaskList) do
    if task.hasReward == 1 then
      count = count + 1
    end
  end
  return count
end

function AttackCityS0DataManager:GetBattlePassCitySRedPointNum()
  local cityRed = 0
  for i, city in ipairs(self.BattlePassCityTaskMap) do
    if i <= self.curMaxCityLevel + 1 then
      for _, v in ipairs(city) do
        if v.hasReward == 1 then
          cityRed = cityRed + 1
        end
      end
    end
  end
  return cityRed
end

function AttackCityS0DataManager:GetBattlePassScoreRedPoint()
  for _, task in ipairs(self.BattlePassScoreTaskList) do
    if task.hasReward == 1 then
      return true
    end
  end
  return false
end

function AttackCityS0DataManager:GetBattlePassCityRedPoint(cityLv)
  if cityLv and cityLv <= self.curMaxCityLevel + 1 and self.BattlePassCityTaskMap[cityLv] then
    for _, task in ipairs(self.BattlePassCityTaskMap[cityLv]) do
      if task.hasReward == 1 then
        return true
      end
    end
  end
  return false
end

function AttackCityS0DataManager:GetBattlePassCitySRedPoint()
  local cityRed = self:GetBattlePassCitySRedPointNum()
  return 0 < cityRed
end

function AttackCityS0DataManager:GetBattlePassRedPoint()
  local score = self:GetBattlePassScoreRedPoint()
  local cityRed = self:GetBattlePassCitySRedPoint()
  return score or cityRed
end

function AttackCityS0DataManager:GetCityClueOpen()
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  local state = DataCenter.AttackCityS0DataManager:GetActivityState()
  local nowLevel = DataCenter.AttackCityS0DataManager:GetActCityLevelAndStateTime()
  local _, limitLevel = DataCenter.AttackCityS0ConfigManager:GetCityClueItemIdAndLevelLimit()
  limitLevel = tonumber(limitLevel)
  return state == CityAttackS0ActivityState.Waiting and limitLevel <= nowLevel + 1 and isInAlliance
end

function AttackCityS0DataManager:GetFixedTaskTypeData(type)
  if table.IsNullOrEmpty(self.fixedTaskMap) then
    self.fixedTaskMap = {
      [CityAttackS0FixedTask.OneLimitLevel] = 1,
      [CityAttackS0FixedTask.FiveLimitLevel] = 5,
      [CityAttackS0FixedTask.OneLimitStar] = 1,
      [CityAttackS0FixedTask.FiveLimitStar] = 5
    }
  end
  return self.fixedTaskMap[type]
end

function AttackCityS0DataManager:SetToggleState(value)
  self.toggleState = value
end

function AttackCityS0DataManager:GetToggleState()
  return self.toggleState
end

function AttackCityS0DataManager:SetCityDetectRadarDoing(uuid, value)
  if table.IsNullOrEmpty(self.radarStateList) then
    self.radarStateList = {}
  end
  self.radarStateList[uuid] = value
end

function AttackCityS0DataManager:GetCityDetectRadarIsDoing(uuid)
  if table.IsNullOrEmpty(self.radarStateList) then
    self.radarStateList = {}
  end
  return self.radarStateList[uuid]
end

AttackCityS0DataManager.__init = __init
AttackCityS0DataManager.__delete = __delete
return AttackCityS0DataManager
