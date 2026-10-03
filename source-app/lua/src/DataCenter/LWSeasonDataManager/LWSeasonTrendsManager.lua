local LWSeasonTrendsManager = BaseClass("LWSeasonTrendsManager")
local LWSeasonTrendsTemplate = require("DataCenter.LWSeasonDataManager.LWSeasonTrendsTemplate")
local LWSeasonTrendsData = require("DataCenter.LWSeasonDataManager.LWSeasonTrendsData")
local SeasonTrendAllianceRank = require("DataCenter.RankData.SeasonTrendAllianceRankData")

function LWSeasonTrendsManager:__init()
  self.seasonStartTime = nil
  self.seasonTrendGroup = nil
  self.fullConfigData = {}
  self.configData = {}
  self.trendData = {}
  self.trendsRankMap = {}
  self.trendsSelfRankMap = {}
  self.trendsRankRewardMap = {}
  self.wastedlandRankData = {}
  self.trendRewardRedState = false
  self.trendRewardRedStateDirty = true
end

function LWSeasonTrendsManager:__delete()
  self.seasonStartTime = nil
  self.seasonTrendGroup = nil
  self.configData = nil
  self.trendData = nil
  self.trendsRankMap = nil
  self.trendsRankRewardMap = nil
  self.trendsSelfRankMap = nil
  self.wastedlandRankData = nil
  self.trendRewardRedState = false
  self.trendRewardRedStateDirty = true
end

function LWSeasonTrendsManager:Startup()
end

function LWSeasonTrendsManager:InitTableByGroup(group)
  if LocalController:instance():getTable(TableName.LW_Season_Trends) ~= nil then
    LocalController:instance():visitTable(TableName.LW_Season_Trends, function(id, line)
      local dataLine = LWSeasonTrendsTemplate.New()
      local season_group = line.season_group
      if season_group == group then
        local week_stage = line.week_stage
        dataLine:InitData(line)
        if self.configData[season_group] == nil then
          self.configData[season_group] = {}
        end
        self.fullConfigData[dataLine.id] = dataLine
        local data = self.configData[season_group]
        if data[week_stage] == nil then
          data[week_stage] = {}
        end
        local index = #data[week_stage] + 1
        data[week_stage][index] = dataLine
      end
    end)
    local groupData = self.configData[group]
    if groupData then
      for k1, v1 in pairs(groupData) do
        if 0 < #v1 then
          table.sort(v1, function(a, b)
            if a.unlock_time == a.unlock_time then
              return a.id < b.id
            end
            return b.unlock_time > a.unlock_time
          end)
        end
      end
    end
    return groupData
  end
end

function LWSeasonTrendsManager:CreateTableDataById(configId)
  if LocalController:instance():getTable(TableName.LW_Season_Trends) ~= nil then
    local line = LocalController:instance():getLine(TableName.LW_Season_Trends, tostring(configId))
    if line ~= nil then
      local dataLine = LWSeasonTrendsTemplate.New()
      dataLine:InitData(line)
      self.fullConfigData[dataLine.id] = dataLine
      return dataLine
    end
  end
end

function LWSeasonTrendsManager:GetConfigDate(season_group)
  local result = self.configData[season_group]
  if result == nil then
    result = self:InitTableByGroup(season_group)
  end
  return result
end

function LWSeasonTrendsManager:GetConfigDateById(configId)
  local result = self.fullConfigData[configId]
  if result == nil then
    result = self:CreateTableDataById(configId)
  end
  return result
end

function LWSeasonTrendsManager:InitTrendData(message)
  local flag = true
  if message.season_group then
    self.seasonTrendGroup = message.season_group
  else
    Logger.LogError("season_group is nil")
    flag = false
  end
  local data = self:GetConfigDate(self.seasonTrendGroup)
  if data == nil then
    Logger.LogError("no group data, group: " .. self.seasonTrendGroup)
    return nil
  end
  local seasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
  if message.trends then
    local trendsArray = message.trends
    for key, value in pairs(trendsArray) do
      local preData = self.trendData[value.trend_id]
      if preData then
        preData:SeasonTrendsData(value, seasonStartTime)
      else
        preData = LWSeasonTrendsData.New()
        preData:SeasonTrendsData(value, seasonStartTime)
        self.trendData[value.trend_id] = preData
      end
    end
  else
    flag = false
  end
  if flag then
    self.trendRewardRedStateDirty = true
    self:CheckSeasonTrendRewardFlag()
    EventManager:GetInstance():Broadcast(EventId.LWSeasonTrendsRewardRedPoint)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonTrendDataInit)
  end
end

function LWSeasonTrendsManager:GetTrendsData(groupIndex)
  local result = {}
  local data = self:GetConfigDate(self.seasonTrendGroup)
  if data == nil then
    return result
  end
  local groupData = data[groupIndex]
  if groupData == nil then
    return result
  end
  local index = 1
  for i, value in ipairs(groupData) do
    local tTrendData = self.trendData[value.id]
    if tTrendData ~= nil then
      result[index] = self.trendData[value.id]
      index = index + 1
    end
  end
  return result
end

function LWSeasonTrendsManager:GetTrendsConfigData(groupIndex, id)
  if self.configDataCache == nil then
    self.configDataCache = {}
  end
  if self.configDataCache[id] then
    return self.configDataCache[id]
  end
  local data = self:GetConfigDate(self.seasonTrendGroup)
  if data == nil then
    return nil
  end
  local groupData = data[groupIndex]
  if groupData == nil then
    return nil
  end
  for i, value in ipairs(groupData) do
    if value.id == id then
      self.configDataCache[id] = value
      return value
    end
  end
  return nil
end

function LWSeasonTrendsManager:IsInitData()
  return self.seasonTrendGroup ~= nil
end

function LWSeasonTrendsManager:HandleSeasonTrendsRankInfo(message)
  local trendId = message.trend_id
  if trendId then
    local trendsConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, trendId)
    local isAlliance = trendsConfig.user_type == 2
    local ranks = message.ranks
    local selfData = message.self
    if ranks and selfData then
      local rankList = {}
      for k, v in pairs(ranks) do
        local oneData
        if isAlliance then
          oneData = SeasonTrendAllianceRank.New()
          oneData:ParseData(v, nil)
          oneData:SetRank(k)
        else
          oneData = PlayerRankData.New()
          oneData:ParseData(v, nil)
          oneData:SetRank(k)
        end
        table.insert(rankList, oneData)
      end
      self.trendsRankMap[trendId] = rankList
      if self.trendsSelfRankMap[trendId] then
        self.trendsSelfRankMap[trendId].score = selfData.score
        self.trendsSelfRankMap[trendId].rank = selfData.rank
      else
        self.trendsSelfRankMap[trendId] = {
          score = selfData.score,
          rank = selfData.rank
        }
      end
      EventManager:GetInstance():Broadcast(EventId.LWSeasonTrendRankInfoUpdate, trendId)
    end
  end
end

function LWSeasonTrendsManager:HandleSeasonTrendsRankRewardInfo(message)
  local trendId = message.trend_id
  local rewardData = message.ranks
  if trendId and rewardData then
    local rewardsInfo = {}
    if not table.IsNullOrEmpty(rewardData) then
      for _, v in pairs(rewardData) do
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
    self.trendsRankRewardMap[trendId] = rewardsInfo
    EventManager:GetInstance():Broadcast(EventId.LWSeasonTrendRankRewardInfoUpdate)
  end
end

function LWSeasonTrendsManager:HandleSeasonTrendsRankReward(message)
  if message.rank_id then
    local reward = message.reward
    if reward then
      EventManager:GetInstance():Broadcast(EventId.LWSeasonTrendRankRewardUpdate)
    end
  end
end

function LWSeasonTrendsManager:HandleSeasonTrendsReward(message)
  local trendId = message.trend_id
  if trendId then
    local trendData = self.trendData[trendId]
    if trendData then
      trendData.is_get_reward = true
      self.trendRewardRedStateDirty = true
      self:CheckSeasonTrendRewardFlag()
      EventManager:GetInstance():Broadcast(EventId.LWSeasonTrendsRewardRedPoint)
      EventManager:GetInstance():Broadcast(EventId.LWSeasonTrendDataRewardFlagChange, trendId)
    end
    local rewards = message.rewards
    if rewards then
      DataCenter.RewardManager:AddRewardsAndRes({reward = rewards})
      DataCenter.RewardManager:ShowCommonReward({reward = rewards})
    end
  end
end

function LWSeasonTrendsManager:GetTrendsRankData(trendId)
  if self.trendsRankMap then
    return self.trendsRankMap[trendId]
  end
  return nil
end

function LWSeasonTrendsManager:GetTrendsSelfRankData(trendId)
  if self.trendsSelfRankMap then
    return self.trendsSelfRankMap[trendId]
  end
  return nil
end

function LWSeasonTrendsManager:GetTrendsRankRewardList(trendId)
  if self.trendsRankRewardMap then
    return self.trendsRankRewardMap[trendId]
  end
  return nil
end

function LWSeasonTrendsManager:HandleWastedlandRank(message)
  if message.activityId then
    if self.wastedlandRankData[message.activityId] == nil then
      self.wastedlandRankData[message.activityId] = {}
    end
    if message.type then
      if self.wastedlandRankData[message.activityId][message.type] == nil then
        self.wastedlandRankData[message.activityId][message.type] = {}
      end
      local tData = self.wastedlandRankData[message.activityId][message.type]
      local messageRanks = message.ranks
      local selfData = message.self
      local itemType = message.type == CommonActivityRankType.ALLINCE and SeasonTrendAllianceRank or PlayerRankData
      if messageRanks and selfData then
        if tData.rank == nil then
          tData.rank = {}
        end
        if tData.medalMember == nil then
          tData.medalMember = {}
        end
        local rank = tData.rank
        local messageCount = #messageRanks
        local rankCount = #rank
        if messageCount >= rankCount then
          for index, value in ipairs(messageRanks) do
            local rankData = rank[index]
            if rankData then
              rankData:ParseData(value, nil)
              rankData:SetRank(index)
            else
              rankData = itemType.New()
              rankData:ParseData(value, nil)
              rankData:SetRank(index)
              table.insert(rank, rankData)
            end
            if index <= 3 then
              local oneData = tData.medalMember[index]
              if oneData == nil then
                oneData = itemType.New()
                tData.medalMember[index] = oneData
              end
              oneData:ParseData(value, nil)
              oneData:SetRank(index)
            end
          end
        else
          for index, value in ipairs(rank) do
            if index <= messageCount then
              local mData = messageRanks[index]
              value:ParseData(mData, nil)
              value:SetRank(index)
            else
              break
            end
            if index <= 3 then
              local oneData = tData.medalMember[index]
              if oneData == nil then
                oneData = itemType.New()
                tData.medalMember[index] = oneData
              end
              oneData:ParseData(value, nil)
              oneData:SetRank(index)
            end
          end
          for i = 1, rankCount - messageCount do
            table.remove(rank)
          end
        end
        if tData.selfRank then
          tData.selfRank.score = selfData.score
          tData.selfRank.rank = selfData.rank
        else
          tData.selfRank = {
            score = selfData.score,
            rank = selfData.rank
          }
        end
        EventManager:GetInstance():Broadcast(EventId.LWSeasonWastedlandChallengeRankInfoUpdate, message.activityId, message.type)
      end
    end
  end
end

function LWSeasonTrendsManager:HandleWastedlandMainRank(message)
  if message.activityId then
    if self.wastedlandRankData[message.activityId] == nil then
      self.wastedlandRankData[message.activityId] = {}
    end
    if message.type then
      self.wastedlandRankData[message.activityId][message.type] = {}
      local tData = self.wastedlandRankData[message.activityId][message.type]
      if tData.medalMember == nil then
        tData.medalMember = {}
      end
      local itemType = message.type == CommonActivityRankType.ALLINCE and SeasonTrendAllianceRank or PlayerRankData
      if message.ranks then
        for k, v in ipairs(message.ranks) do
          local oneData = tData.medalMember[k]
          if oneData == nil then
            oneData = itemType.New()
            tData.medalMember[k] = oneData
          end
          oneData:ParseData(v, nil)
          oneData:SetRank(k)
        end
        EventManager:GetInstance():Broadcast(EventId.LWSeasonWastedlandChallengeMainRankInfoUpdate, message.activityId)
      end
      if message.self then
        local oneData = tData.selfRank
        if oneData == nil then
          oneData = itemType.New()
          tData.selfRank = oneData
        end
        oneData:ParseData(message.self, nil)
        oneData:SetRank(message.self.rank)
      end
    end
  end
end

function LWSeasonTrendsManager:HandleWastedlandRankRewardInfo(message)
  if message.activityId then
    if self.wastedlandRankData[message.activityId] == nil then
      self.wastedlandRankData[message.activityId] = {}
    end
    if message.type then
      if self.wastedlandRankData[message.activityId][message.type] == nil then
        self.wastedlandRankData[message.activityId][message.type] = {}
      end
      local tData = self.wastedlandRankData[message.activityId][message.type]
      local rewardData = message.show_ranks
      if rewardData then
        local rewardsInfo = {}
        if not table.IsNullOrEmpty(rewardData) then
          for _, v in pairs(rewardData) do
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
        tData.rewards = rewardsInfo
        EventManager:GetInstance():Broadcast(EventId.LWSeasonWastedlandChallengeRankRewardInfoUpdate, message.activityId)
      end
    end
  end
end

function LWSeasonTrendsManager:GetWastedlandRankRewardList(activityId, type)
  local rankType = type and type or CommonActivityRankType.PERSONAL
  if self.wastedlandRankData[activityId] and self.wastedlandRankData[activityId][rankType] then
    return self.wastedlandRankData[activityId][rankType].rewards
  end
  return nil
end

function LWSeasonTrendsManager:GetWastedSelfRankData(activityId, type)
  local rankType = type and type or CommonActivityRankType.PERSONAL
  if self.wastedlandRankData[activityId] and self.wastedlandRankData[activityId][rankType] then
    return self.wastedlandRankData[activityId][rankType].selfRank
  end
  return nil
end

function LWSeasonTrendsManager:GetWastedlandRankList(activityId, type)
  local rankType = type and type or CommonActivityRankType.PERSONAL
  if self.wastedlandRankData[activityId] and self.wastedlandRankData[activityId][rankType] then
    return self.wastedlandRankData[activityId][rankType].rank
  end
  return nil
end

function LWSeasonTrendsManager:GetWastedlandMedalRank(activityId, type)
  local rankType = type and type or CommonActivityRankType.PERSONAL
  if self.wastedlandRankData[activityId] and self.wastedlandRankData[activityId][rankType] then
    return self.wastedlandRankData[activityId][rankType].medalMember
  end
  return nil
end

function LWSeasonTrendsManager:CheckSeasonTrendRewardFlag()
  if self.trendRewardRedStateDirty then
    self.trendRewardRedState = false
    self.trendRewardRedStateDirty = false
    if self.trendData == nil or self.seasonTrendGroup == nil then
      return self.trendRewardRedState
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for key, value in pairs(self.trendData) do
      if value.start_time ~= nil and value.start_time ~= 0 and curTime > value.start_time and not value.is_get_reward then
        local trendsConfig = LocalController:instance():tryGetLine(TableName.LW_Season_Trends, value.config_id)
        if trendsConfig ~= nil then
          local targetCount = trendsConfig.para2
          local getRewardBtnFlag = targetCount <= value.cur_count
          if getRewardBtnFlag then
            self.trendRewardRedState = true
            break
          end
        end
      end
    end
  end
  return self.trendRewardRedState
end

function LWSeasonTrendsManager:GetTrendsDataRedPointCount(groupIndex)
  local trendData = DataCenter.LWSeasonTrendsManager:GetTrendsData(groupIndex)
  local num = 0
  if trendData then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for key, value in pairs(trendData) do
      if value.start_time ~= nil and value.start_time ~= 0 and curTime > value.start_time and not value.is_get_reward then
        local trendsConfig = LocalController:instance():tryGetLine(TableName.LW_Season_Trends, value.config_id)
        if trendsConfig ~= nil and toInt(trendsConfig.para2) <= toInt(value.cur_count) then
          num = num + 1
        end
      end
    end
  end
  return num
end

function LWSeasonTrendsManager:OnTrendDonateMessage(msg)
  local trendId = msg.trend_id
  local curCount = msg.cur_count
  local type = msg.type
  if trendId and curCount and type then
    local trendData = self.trendData[trendId]
    trendData.cur_count = msg.cur_count
    if type == 1 then
      trendData.day_donate = msg.day_donate
      if msg.resource ~= nil then
        LuaEntry.Resource:UpdateResource(msg.resource)
      end
    elseif type == 2 and msg.remainGold ~= nil then
      LuaEntry.Player.gold = msg.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonTrendsDonateSuccess, {
      id = trendId,
      type = msg.type
    })
  end
  if msg.accInfo ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(msg.accInfo.accPoint, nil)
  end
end

function LWSeasonTrendsManager:GetCurOpenList()
  local season, seasonWeek = DataCenter.SeasonDataManager:GetSeasonWeekInfo()
  local result = {}
  if seasonWeek then
    local trendsData = DataCenter.LWSeasonTrendsManager:GetTrendsData(seasonWeek)
    for key, value in pairs(trendsData) do
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime >= value.start_time and curTime < value.end_time then
        table.insert(result, value)
      end
    end
  end
  return result
end

function LWSeasonTrendsManager:GetEffectValue(theEffectId)
  if self.trendData == nil then
    return 0
  end
  local season_group = 22
  local season_config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if season_config and season_config.trends ~= nil and season_config.trends ~= "" and season_config.trends ~= 0 then
    season_group = toInt(season_config.trends)
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local effectId = toInt(theEffectId)
  local config
  local effectValue = 0
  local finishEvent = false
  for k, v in pairs(self.trendData) do
    config = self:GetConfigDateById(v.config_id)
    if config and config.season_group == season_group and (config.personEffectId == effectId or config.allianceEffectId == effectId) then
      finishEvent = false
      if curTime >= v.end_time then
        finishEvent = true
      elseif curTime >= v.start_time and curTime < v.end_time and v.cur_count >= config.targetCount then
        finishEvent = true
      end
      if finishEvent then
        if config.personEffectId == effectId then
          effectValue = effectValue + config.personEffectValue
        end
        if config.allianceEffectId == effectId then
          effectValue = effectValue + config.allianceEffectValue
        end
      end
    end
  end
  return effectValue
end

function LWSeasonTrendsManager:GetTrendsState(trendData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local state = SeasonTrendState.None
  if curTime < trendData.start_time then
    state = SeasonTrendState.NotOpen
  elseif curTime >= trendData.start_time and curTime < trendData.end_time then
    state = SeasonTrendState.Open
  else
    state = SeasonTrendState.Expire
  end
  return state
end

function LWSeasonTrendsManager:ShareTask(trendData, index)
  local state = DataCenter.LWSeasonTrendsManager:GetTrendsState(trendData)
  if state == SeasonTrendState.Expire then
    UIUtil.ShowTipsId("391036")
    return
  end
  local share_param = {}
  share_param.postType = PostType.SeasonTrendsShare
  share_param.config_id = trendData.config_id
  share_param.groupIndex = trendData.groupIndex
  share_param.index = index
  share_param.start_time = trendData.start_time
  share_param.end_time = trendData.end_time
  share_param.cur_count = trendData.cur_count
  local chatData = {}
  chatData.post = share_param.postType
  chatData.postType = share_param.postType
  chatData.param = share_param
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function LWSeasonTrendsManager:Jump(trendData)
  if not trendData then
    return
  end
  GoToUtil.GoToByTypeAndParam(QuestGoType.GoSeasonTrendMain, {
    trendData.groupIndex,
    trendData.config_id
  })
end

function LWSeasonTrendsManager:JumpWithType(jumpType, jumpData)
  if not jumpType or not jumpData then
    return
  end
  if jumpType == SeasonTrendJumpType.Function or jumpType == SeasonTrendJumpType.City then
    if string.IsNullOrEmpty(jumpData.jump) then
      return
    end
    local jump = tonumber(jumpData.jump)
    local param
    if jumpData.param and not string.IsNullOrEmpty(jumpData.param) then
      param = tonumber(jumpData.param)
    end
    if QuestGoType.GoSeasonMain == jump and param then
      local act = DataCenter.ActivityListDataManager:GetActivityDataById(param)
      if not act then
        UIUtil.ShowTipsId("801141")
        return true
      end
    end
    GoToUtil.GoToByTypeAndParam(jump, {param})
    return true
  end
  if jumpType == SeasonTrendJumpType.CardPool and jumpData.cardId and jumpData.cardId > 0 then
    local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(tostring(jumpData.cardId))
    if not lotteryData then
      UIUtil.ShowTipsId("season_recruit_tips003")
      return true
    end
    GoToUtil.GoToByTypeAndParam(QuestGoType.GoHeroRecruit, {
      jumpData.cardId
    })
    return true
  end
end

function LWSeasonTrendsManager:FetchTrendFirstRank(queryList)
  if self.dataFirstRank == nil then
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonTrendFirstRankPlayer, table.concat(queryList, ","))
  else
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.dataFirstRankTime and self.dataFirstRank and now - self.dataFirstRankTime < 15000 then
      local dataFirstRank = self.dataFirstRank
      for _, v in ipairs(queryList) do
        if dataFirstRank[v] ~= nil then
          return
        end
      end
    end
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonTrendFirstRankPlayer, table.concat(queryList, ","))
  end
end

function LWSeasonTrendsManager:GetTrendFirstRank(theId)
  if self.dataFirstRank then
    return self.dataFirstRank[toInt(theId)]
  end
  return nil
end

function LWSeasonTrendsManager:OnTrendFirstRankMessage(msg)
  if msg and msg.info then
    local dataFirstRank = self.dataFirstRank or {}
    for k, v in pairs(msg.info) do
      dataFirstRank[toInt(k)] = v
    end
    self.dataFirstRank = dataFirstRank
    self.dataFirstRankTime = UITimeManager:GetInstance():GetServerTime()
    EventManager:GetInstance():Broadcast(EventId.LWSeasonTrendDataRewardFlagChange)
  end
end

return LWSeasonTrendsManager
