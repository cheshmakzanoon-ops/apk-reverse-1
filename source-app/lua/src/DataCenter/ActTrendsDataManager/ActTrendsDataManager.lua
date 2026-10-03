local ActTrendsDataManager = BaseClass("ActTrendsDataManager")
local ActTrendsData = require("DataCenter.ActTrendsDataManager.ActTrendsData")
local Localization = CS.GameEntry.Localization

function ActTrendsDataManager:__init()
  self.activityId = nil
  self.actData = {}
end

function ActTrendsDataManager:__delete()
  self.activityId = nil
  self.actData = nil
end

function ActTrendsDataManager:InitTrendData(message)
  local flag = true
  local activityId = message.activityId
  if activityId == nil then
    Logger.LogError("activityId is nil")
    return
  end
  self.activityId = activityId
  if self.actData[activityId] == nil then
    self.actData[activityId] = {}
    self.actData[activityId].season_start_time = nil
    self.actData[activityId].trend_time = nil
    self.actData[activityId].seasonTrendGroup = nil
    self.actData[activityId].trendData = {}
    self.actData[activityId].trendRewardRedState = false
    self.actData[activityId].trendRewardRedStateDirty = true
  end
  self.actData[activityId].season_start_time = message.season_start_time
  self.actData[activityId].trend_time = message.trend_time
  if message.season_group then
    self.actData[activityId].seasonTrendGroup = message.season_group
  else
    Logger.LogError("season_group is nil")
    flag = false
  end
  if message.trends then
    local trendsArray = message.trends
    for key, value in pairs(trendsArray) do
      local preData = self.actData[activityId].trendData[value.trend_id]
      local season_start_time = self.actData[activityId].season_start_time
      if preData then
        preData:SeasonTrendsData(value, season_start_time)
      else
        preData = ActTrendsData.New()
        preData:SeasonTrendsData(value, season_start_time)
        self.actData[activityId].trendData[value.trend_id] = preData
      end
    end
  else
    flag = false
  end
  if flag then
    self.actData[activityId].trendRewardRedStateDirty = true
    self:CheckActTrendRewardFlag(activityId)
    EventManager:GetInstance():Broadcast(EventId.LWActTrendsRewardRedPoint, activityId)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.LWActTrendDataInit, activityId)
  end
end

function ActTrendsDataManager:GetTrendsData(groupIndex)
  local activityId = self.activityId
  local result = {}
  if activityId == nil then
    return result
  end
  if self.actData[activityId] == nil then
    return result
  end
  local trendGroup = self.actData[activityId].seasonTrendGroup
  if trendGroup == nil then
    return result
  end
  local data = DataCenter.LWSeasonTrendsManager:GetConfigDate(trendGroup)
  if data == nil then
    return result
  end
  local groupData = data[groupIndex]
  if groupData == nil then
    return result
  end
  local index = 1
  for i, value in ipairs(groupData) do
    local tTrendData = self.actData[activityId].trendData[value.id]
    if tTrendData ~= nil then
      result[index] = tTrendData
      index = index + 1
    end
  end
  return result
end

function ActTrendsDataManager:HandleSeasonTrendsReward(message)
  local activityId = self.activityId
  if activityId == nil then
    return
  end
  local trendId = message.trend_id
  if trendId then
    local trendData = self.actData[activityId].trendData[trendId]
    if trendData then
      trendData.is_get_reward = true
      self.trendRewardRedStateDirty = true
      self:CheckActTrendRewardFlag(activityId)
      EventManager:GetInstance():Broadcast(EventId.LWActTrendsRewardRedPoint, activityId)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
      EventManager:GetInstance():Broadcast(EventId.LWActTrendDataRewardFlagChange, trendId)
    end
    local rewards = message.rewards
    if rewards then
      DataCenter.RewardManager:AddRewardsAndRes({reward = rewards})
      DataCenter.RewardManager:ShowCommonReward({reward = rewards})
    end
  end
end

function ActTrendsDataManager:CheckActTrendRewardFlag(activityId)
  if self.actData[activityId] == nil then
    return false
  end
  if self.actData[activityId].trendRewardRedStateDirty then
    self.actData[activityId].trendRewardRedState = false
    self.actData[activityId].trendRewardRedStateDirty = false
    if self.actData[activityId].trendData == nil or self.actData[activityId].seasonTrendGroup == nil then
      return self.actData[activityId].trendRewardRedState
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for key, value in pairs(self.actData[activityId].trendData) do
      if curTime > value.start_time and not value.is_get_reward then
        local trendsConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, value.config_id)
        local targetCount = trendsConfig.para2
        local getRewardBtnFlag = targetCount <= value.cur_count
        if getRewardBtnFlag then
          self.trendRewardRedState = true
          break
        end
      end
    end
  end
  return self.actData[activityId].trendRewardRedState
end

function ActTrendsDataManager:GetRedNum(activityId)
  local num = 0
  local groupNum = 4
  for i = 1, groupNum do
    local groupRedNum = self:GetTrendsDataRedPointCount(i)
    num = num + groupRedNum
  end
  return num
end

function ActTrendsDataManager:GetTrendsDataRedPointCount(groupIndex)
  local trendData = self:GetTrendsData(groupIndex)
  local num = 0
  if trendData then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for key, value in pairs(trendData) do
      if curTime > value.start_time and not value.is_get_reward then
        local trendsConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, value.config_id)
        if toInt(trendsConfig.para2) <= toInt(value.cur_count) then
          num = num + 1
        end
      end
    end
  end
  return num
end

function ActTrendsDataManager:OnTrendDonateMessage(msg)
  local trendId = msg.trend_id
  local curCount = msg.cur_count
  local type = msg.type
  if trendId and curCount and type then
    local trendData = self.actData[self.activityId].trendData[trendId]
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
    EventManager:GetInstance():Broadcast(EventId.LWActTrendsDonateSuccess, {
      id = trendId,
      type = msg.type
    })
  end
  if msg.accInfo ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(msg.accInfo.accPoint, nil)
  end
end

function ActTrendsDataManager:GetTrendsState(trendData)
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

function ActTrendsDataManager:ShareTask(trendData, index)
  local state = self:GetTrendsState(trendData)
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
  chatData.param = share_param
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function ActTrendsDataManager:Jump(trendData)
  if self.activityId == nil then
    return
  end
  if not trendData then
    return
  end
  local titleTxt
  local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
  local data = DataCenter.SeasonTemplateManager:GetConfigData(seasonId)
  if data then
    local key = data.truce_name
    titleTxt = Localization:GetString(key)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.SingleActivityContainerType2, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.activityId, nil, {
    trendData.groupIndex,
    trendData.config_id
  })
end

function ActTrendsDataManager:IsInitData()
  local activityId = self.activityId
  if activityId == nil then
    return false
  end
  local result = false
  if self.actData[activityId] then
    result = true
  end
  return result
end

function ActTrendsDataManager:GetTrendsStartTime()
  local activityId = self.activityId
  if activityId == nil then
    return 0
  end
  local startTime = 0
  if self.actData[activityId] then
    startTime = self.actData[activityId].trend_time
  end
  return startTime
end

function ActTrendsDataManager:GetTrendsConfigData(groupIndex, id)
  local data
  if self.activityId == nil then
    return data
  end
  if self.activityId and self.actData[self.activityId] then
    local trendGroup = self.actData[self.activityId].seasonTrendGroup
    local groupData = DataCenter.LWSeasonTrendsManager:GetConfigDate(trendGroup)
    if trendGroup and groupData then
      local groupData = groupData[groupIndex]
      if groupData and 0 < #groupData then
        for i, value in ipairs(groupData) do
          if value.id == id then
            data = value
          end
        end
      end
    end
  end
  return data
end

function ActTrendsDataManager:JumpWithType(jumpType, jumpData)
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
    elseif QuestGoType.GoMonopolyPlaceality == jump or QuestGoType.OpenUIDispatchTaskMain == jump then
      GoToUtil.CloseAllWindows()
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

return ActTrendsDataManager
