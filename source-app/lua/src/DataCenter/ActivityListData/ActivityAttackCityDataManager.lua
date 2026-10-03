local ActivityAttackCityDataManager = BaseClass("ActivityAttackCityDataManager")

function ActivityAttackCityDataManager:__init()
  self.taskDataDict = {}
  self.rankDataDict = {}
  self.rankRewardDataDict = {}
  self.taskDataRefreshTime = 2000
  self.rankDataRefreshTime = 2000
end

function ActivityAttackCityDataManager:__delete()
  self.taskDataDict = nil
  self.rankDataDict = nil
  self.rankRewardDataDict = nil
end

function ActivityAttackCityDataManager:UpdateTaskData(message)
  if message == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local activityId = message.activityId
  local data = {
    getTime = curTime,
    activityId = activityId,
    refreshTime = self.taskDataRefreshTime,
    data = message.targets and message.targets or {}
  }
  table.sort(data.data, function(a, b)
    if a.state ~= b.state then
      return a.state < b.state
    end
    return a.id < b.id
  end)
  self.taskDataDict[activityId] = data
end

function ActivityAttackCityDataManager:UpdateRankData(message)
  if message == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local activityId = message.activityId
  local data = {
    getTime = curTime,
    activityId = activityId,
    refreshTime = self.rankDataRefreshTime,
    data = message.rank and message.rank or {}
  }
  self.rankDataDict[activityId] = data
end

function ActivityAttackCityDataManager:UpdateRankRewardData(message)
  if message == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local activityId = message.activityId
  local data = {
    getTime = curTime,
    activityId = activityId,
    data = message.rewardList and message.rewardList or {}
  }
  self.rankRewardDataDict[activityId] = data
end

function ActivityAttackCityDataManager:GetTaskData(activityId)
  local data = self.taskDataDict[activityId]
  return data
end

function ActivityAttackCityDataManager:GetRankData(activityId)
  local data = self.rankDataDict[activityId]
  return data
end

function ActivityAttackCityDataManager:GetRankRewardData(activityId)
  local data = self.rankRewardDataDict[activityId]
  return data
end

return ActivityAttackCityDataManager
