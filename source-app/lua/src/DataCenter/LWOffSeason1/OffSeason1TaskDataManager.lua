local OffSeason1TaskDataManager = BaseClass("OffSeason1TaskDataManager")
local Localization = CS.GameEntry.Localization

function OffSeason1TaskDataManager:__init()
  self.totalTaskMap = {}
  self.activityTaskMap = {}
  self.goalTaskMap = {}
  self.taskGroupScore = {}
end

function OffSeason1TaskDataManager:__delete()
  self.totalTaskMap = nil
  self.activityTaskMap = nil
  self.goalTaskMap = nil
  self.taskGroupScore = nil
end

function OffSeason1TaskDataManager:ParseTaskServerData(message)
  if message ~= nil then
    local taskList = message.taskRequests
    self.taskGroupScore[message.group] = message.score
    self:UpdateTaskListInfo(message.group, taskList)
    if message.group == OffSeason1TaskGroup.QueenOfBlood then
      EventManager:GetInstance():Broadcast(EventId.PushOffSeason1QueenOfBloodTaskInfoUpdate)
    end
    if message.group == OffSeason1TaskGroup.OffSeason1Recapture then
      EventManager:GetInstance():Broadcast(EventId.PushOffSeason1ActivityTaskInfoUpdate)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function OffSeason1TaskDataManager:UpdateTaskListInfo(groupId, taskList)
  if taskList and 0 < #taskList then
    self.activityTaskMap[groupId] = {}
    self.goalTaskMap[groupId] = {}
    for k, questInfo in pairs(taskList) do
      local id = 0
      if questInfo.configId then
        id = tonumber(questInfo.configId)
      end
      if 0 < id then
        local taskData = self.totalTaskMap[id]
        if taskData == nil then
          taskData = {
            configId = questInfo.configId,
            id = questInfo.configId,
            descStr = Localization:GetString(GetTableData(TableName.LW_OFFSEASON_TASK, id, "desc"), GetTableData(TableName.LW_OFFSEASON_TASK, id, "para")),
            type = GetTableData(TableName.LW_OFFSEASON_TASK, id, "Type"),
            hasReceived = questInfo.hasReward == TaskState.Received,
            canReceive = questInfo.hasReward == TaskState.CanReceive,
            hasReward = questInfo.hasReward,
            state = questInfo.hasReward,
            reward = questInfo.reward,
            curNum = questInfo.curNum,
            totalNum = questInfo.totalNum
          }
          self.totalTaskMap[taskData.id] = taskData
        else
          taskData.hasReceived = questInfo.hasReward == TaskState.Received
          taskData.canReceive = questInfo.hasReward == TaskState.CanReceive
          taskData.hasReward = questInfo.hasReward
          taskData.state = questInfo.hasReward
          taskData.reward = questInfo.reward
          taskData.curNum = questInfo.curNum
          taskData.totalNum = questInfo.totalNum
        end
        self:SetTaskInfo(taskData, groupId)
      else
        Logger.LogError("wtf??? id is 0???  v:" .. tostring(questInfo))
      end
    end
  end
end

function OffSeason1TaskDataManager:SetTaskInfo(taskData, groupId)
  if taskData.type == OffSeason1GoalTaskType[groupId] then
    if self.goalTaskMap[groupId] then
      table.insert(self.goalTaskMap[groupId], taskData)
    else
      self.goalTaskMap[groupId] = {}
      table.insert(self.goalTaskMap[groupId], taskData)
    end
  elseif self.activityTaskMap[groupId] then
    table.insert(self.activityTaskMap[groupId], taskData)
  else
    self.activityTaskMap[groupId] = {}
    table.insert(self.activityTaskMap[groupId], taskData)
  end
end

function OffSeason1TaskDataManager:GetRedDotNum(groupId)
  local redNum = 0
  if groupId and self.activityTaskMap and self.activityTaskMap[groupId] then
    local taskList = self.activityTaskMap[groupId]
    for i, taskData in ipairs(taskList) do
      if taskData and taskData.hasReward == 1 then
        redNum = redNum + 1
      end
    end
  end
  return redNum
end

function OffSeason1TaskDataManager:GetActivityTaskList(groupId)
  if groupId and self.activityTaskMap and self.activityTaskMap[groupId] then
    return self.activityTaskMap[groupId]
  end
  return nil
end

function OffSeason1TaskDataManager:GetScoreByTaskGroup(groupId)
  return self.taskGroupScore[groupId] or 0
end

function OffSeason1TaskDataManager:GetGoalTaskListByGroup(groupId)
  local taskList
  if groupId and self.goalTaskMap and self.goalTaskMap[groupId] then
    taskList = self.goalTaskMap[groupId]
    table.sort(taskList, function(a, b)
      return a.id < b.id
    end)
  end
  return taskList
end

function OffSeason1TaskDataManager:RefreshRankFullData(rankFullData, msgData)
  if msgData.thumbUpdate then
    if rankFullData and rankFullData.activityCount == msgData.activityCount and msgData.rankArray and rankFullData.rankArray then
      for i, msgRankData in ipairs(msgData.rankArray) do
        local nowRankData = self:GetRankDataByQuality(rankFullData, msgRankData.quality)
        if nowRankData then
          if msgRankData.self then
            nowRankData.self = msgRankData.self
          end
          if msgRankData.ranks and nowRankData.ranks then
            for j, rank in ipairs(msgRankData.ranks) do
              nowRankData.ranks[j] = rank
            end
          end
        end
      end
    end
  else
    rankFullData = msgData
  end
  return rankFullData
end

function OffSeason1TaskDataManager:GetRankDataByQuality(rankFullData, quality)
  if rankFullData and rankFullData.rankArray and rankFullData.rankArray then
    for i, v in ipairs(rankFullData.rankArray) do
      if v.quality == quality then
        return v
      end
    end
  end
  return nil
end

return OffSeason1TaskDataManager
