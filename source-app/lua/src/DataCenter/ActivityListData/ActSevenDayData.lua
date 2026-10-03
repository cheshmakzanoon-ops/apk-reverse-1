local ActSevenDayData = BaseClass("ActSevenDayData")
local ActSevenDayInfo = require("DataCenter.ActivityListData.ActSevenDayInfo")

local function __init(self)
  self.list = {}
end

local function __delete(self)
  self.list = nil
end

local function SetActivityId(self, id)
  self.list[tonumber(id)] = {}
end

local function ParseActivityData(self, dayActsMessage)
  if dayActsMessage == nil then
    return
  end
  if self.list[dayActsMessage.activityId] then
    local info = ActSevenDayInfo.New()
    if dayActsMessage.dayActs then
      local dayActs = dayActsMessage.dayActs
      info:ParseDayActs(dayActs)
    end
    if dayActsMessage.scoreReward ~= nil then
      local scoreReward = dayActsMessage.scoreReward
      info:ParseScoreReward(scoreReward)
    end
    info:ParseOther(dayActsMessage)
    info:CalculateDate()
    info:CheckRedDot()
    self.list[dayActsMessage.activityId] = info
  end
  EventManager:GetInstance():Broadcast(EventId.ActSevenDay)
end

local function UpdateDayActScore(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    self.list[message.activityId]:UpdateScore(message.score)
    self.list[message.activityId]:CheckRedDot()
    EventManager:GetInstance():Broadcast(EventId.ActSevenDayScore)
  end
end

local function GetRewardState(self, message)
  if message == nil then
    return
  end
  DataCenter.RewardManager:ShowCommonReward(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  if self.list[message.activityId] then
    self.list[message.activityId]:SetScoreBoxState(message.index, 1)
    self.list[message.activityId]:CheckRedDot()
    EventManager:GetInstance():Broadcast(EventId.ActSevenDayScore)
    EventManager:GetInstance():Broadcast(EventId.ActRewardState)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

local function GetInfoByActId(self, activityId)
  if self.list[activityId] then
    return self.list[activityId]
  end
  return nil
end

local function GetActRed(self, id)
  if self.list[id] and next(self.list[id]) then
    self.list[id]:CheckRedDot()
    return self.list[id]:GetActRed()
  end
  return 0
end

local function SetLastVisitTab(self, actId, value)
  if self.list[actId] and next(self.list[actId]) then
    self.list[actId]:SetLastVisitDayTab(value)
  end
end

local function GetLastVisitTab(self, actId)
  if self.list[actId] and next(self.list[actId]) then
    return self.list[actId]:GetLastVisitDayTab()
  end
  return nil
end

local function GetAllRewardState(self, message)
  if message == nil then
    return
  end
  DataCenter.RewardManager:ShowCommonReward(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  if self.list[message.activityId] then
    self.list[message.activityId]:ParseScoreReward(message.scoreReward)
    self.list[message.activityId]:CheckRedDot()
    EventManager:GetInstance():Broadcast(EventId.ActSevenDayScore)
    EventManager:GetInstance():Broadcast(EventId.ActRewardState)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

ActSevenDayData.__init = __init
ActSevenDayData.__delete = __delete
ActSevenDayData.SetActivityId = SetActivityId
ActSevenDayData.ParseActivityData = ParseActivityData
ActSevenDayData.GetInfoByActId = GetInfoByActId
ActSevenDayData.UpdateDayActScore = UpdateDayActScore
ActSevenDayData.GetRewardState = GetRewardState
ActSevenDayData.GetActRed = GetActRed
ActSevenDayData.SetLastVisitTab = SetLastVisitTab
ActSevenDayData.GetLastVisitTab = GetLastVisitTab
ActSevenDayData.GetAllRewardState = GetAllRewardState
return ActSevenDayData
