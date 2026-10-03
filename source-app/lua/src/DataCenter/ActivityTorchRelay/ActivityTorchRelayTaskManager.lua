local ActivityTorchRelayTaskManager = BaseClass("ActivityTorchRelayTaskManager")

function ActivityTorchRelayTaskManager:__init()
  self.activityDataMap = {}
end

function ActivityTorchRelayTaskManager:__delete()
  self.activityDataMap = nil
end

function ActivityTorchRelayTaskManager:GetActivityData(activityId)
  activityId = tonumber(activityId)
  if not self.activityDataMap[activityId] then
    local data = {}
    data.taskListMap = {}
    data.totalTaskMap = {}
    data.milestonesProgress = 0
    data.milestonesCompleteIndexList = {}
    self.activityDataMap[activityId] = data
  end
  return self.activityDataMap[activityId]
end

function ActivityTorchRelayTaskManager:InitServerData(activityIdStr, message)
  local activityId = tonumber(activityIdStr)
  self:UpdateTaskListInfo(activityId, message.taskArr)
  self:UpdateMilestonesProgress(activityId, message.totalScore)
  self:UpdateMilestonesCompleteIndex(activityId, message.rewardProcess)
end

function ActivityTorchRelayTaskManager:OnTaskGetReward(message)
  local activityId = tonumber(message.activityId)
  local taskId = tonumber(message.id)
  self:SetTaskState(activityId, taskId, TaskState.Received)
  self:UpdateMilestonesProgress(activityId, message.totalScore)
  if not table.IsNullOrEmpty(message.reward) then
    DataCenter.RewardManager:ShowGiftReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayTaskRewardGet)
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActResUpdate)
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActUpdateRed)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityTorchRelayTaskManager:OnMilesGetReward(message)
  local activityId = tonumber(message.activityId)
  self:UpdateMilestonesProgress(activityId, message.totalScore)
  self:UpdateMilestonesCompleteIndex(activityId, message.rewardProcess)
  if not table.IsNullOrEmpty(message.reward) then
    DataCenter.RewardManager:ShowGiftReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayMilesRewardGet)
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActResUpdate)
end

function ActivityTorchRelayTaskManager:UpdateMilestonesProgress(activityId, progress)
  if progress then
    local activityData = self:GetActivityData(activityId)
    activityData.milestonesProgress = progress
  end
end

function ActivityTorchRelayTaskManager:UpdateMilestonesCompleteIndex(activityId, indexList)
  if indexList then
    local activityData = self:GetActivityData(activityId)
    activityData.milestonesCompleteIndexList = indexList
  end
end

function ActivityTorchRelayTaskManager:CheckMilestonesComplete(activityId, index)
  local activityData = self:GetActivityData(activityId)
  if activityData and activityData.milestonesCompleteIndexList then
    for i, v in ipairs(activityData.milestonesCompleteIndexList) do
      if v == index then
        return true
      end
    end
  end
  return false
end

function ActivityTorchRelayTaskManager:GetMilestonesProgress(activityId)
  local activityData = self:GetActivityData(activityId)
  if activityData then
    return activityData.milestonesProgress
  end
  return 0
end

function ActivityTorchRelayTaskManager:ParseTaskServerData(message)
  if message ~= nil then
    local activityId = tonumber(message.aid)
    local taskList = message.a_task
    self:UpdateTaskListInfo(activityId, taskList)
  end
end

function ActivityTorchRelayTaskManager:ParseTaskUpdateByDayServerData(message)
  if message ~= nil then
    local activityId = tonumber(message.activityId)
    local taskList = message.taskArr
    self:UpdateTaskListInfo(activityId, taskList)
  end
end

function ActivityTorchRelayTaskManager:UpdateTaskListInfo(activityId, taskList)
  if taskList and 0 < #taskList then
    for k, v in pairs(taskList) do
      local id = tonumber(v.id)
      local taskData = self:GetTaskInfo(activityId, id)
      if taskData == nil then
        taskData = TorchRelayTaskInfo.New()
        taskData:UpdateInfo(v)
        self:SetTaskInfo(activityId, taskData)
      else
        taskData:UpdateInfo(v)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayTaskUpdate)
end

function ActivityTorchRelayTaskManager:SetTaskInfo(activityId, taskData)
  local activityData = self:GetActivityData(activityId)
  activityData.totalTaskMap[taskData.id] = taskData
end

function ActivityTorchRelayTaskManager:GetTaskInfo(activityId, id)
  local activityData = self:GetActivityData(activityId)
  return activityData.totalTaskMap[id]
end

function ActivityTorchRelayTaskManager:SetTaskState(activityId, id, state)
  local activityData = self:GetActivityData(activityId)
  if activityData.totalTaskMap[id] then
    activityData.totalTaskMap[id].state = state
    EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayTaskStateUpdate, id)
  end
end

function ActivityTorchRelayTaskManager:GetAllTaskListByIds(activityId, idListList)
  local activityData = self:GetActivityData(activityId)
  local list = activityData.totalTaskList
  if not list then
    list = {}
    for i, idListData in ipairs(idListList) do
      if idListData then
        local type = idListData.type
        local idList = idListData.idList
        for k, id in ipairs(idList) do
          if activityData.totalTaskMap[id] then
            if type == ActivityTorchRelayTaskType.Milestones then
              local activityMainData = DataCenter.ActivityTorchRelayManager:GetActivityData(activityId)
              activityData.totalTaskMap[id]:SpawnMilestonesReward(activityMainData.config)
            end
            activityData.totalTaskMap[id].taskType = type
            table.insert(list, activityData.totalTaskMap[id])
          end
        end
      end
    end
  end
  if 1 < #list then
    table.sort(list, function(a, b)
      if not a then
        return false
      elseif not b then
        return true
      elseif a.state ~= b.state then
        if a.state == 1 then
          return true
        elseif b.state == 1 then
          return false
        elseif a.state == 2 then
          return false
        elseif b.state == 2 then
          return true
        end
      else
        if a.taskType ~= b.taskType then
          if a.taskType == ActivityTorchRelayTaskType.Daily then
            return true
          elseif b.taskType == ActivityTorchRelayTaskType.Daily then
            return false
          end
        end
        return a.config.order > b.config.order
      end
      return false
    end)
  end
  activityData.totalTaskList = list
  return list
end

function ActivityTorchRelayTaskManager:GetTaskListByIds(activityId, idList, type)
  local activityData = self:GetActivityData(activityId)
  local list = activityData.taskListMap[type]
  if not list then
    list = {}
    for k, id in ipairs(idList) do
      if activityData.totalTaskMap[id] then
        if type == ActivityTorchRelayTaskType.Milestones then
          local activityMainData = DataCenter.ActivityTorchRelayManager:GetActivityData(activityId)
          activityData.totalTaskMap[id]:SpawnMilestonesReward(activityMainData.config)
        end
        table.insert(list, activityData.totalTaskMap[id])
      end
    end
    activityData.taskListMap[type] = list
  end
  if 1 < #list then
    table.sort(list, function(a, b)
      if not a then
        return false
      elseif not b then
        return true
      elseif a.state ~= b.state then
        if a.state == 1 then
          return true
        elseif b.state == 1 then
          return false
        elseif a.state == 2 then
          return false
        elseif b.state == 2 then
          return true
        end
      else
        return a.config.order > b.config.order
      end
    end)
  end
  activityData.taskListMap[type] = list
  return list
end

function ActivityTorchRelayTaskManager:GetMilestonesRedNum(activityId)
  local res = 0
  local actData = DataCenter.ActivityTorchRelayManager:GetActivityData(activityId)
  if actData and actData.config then
    local progressList = actData.config:GetMilestonesPointList()
    local curProgress = self:GetMilestonesProgress(activityId)
    for i, v in pairs(progressList) do
      if curProgress >= v.progress then
        local isGetReward = self:CheckMilestonesComplete(activityId, i - 1)
        if not isGetReward then
          res = res + 1
          break
        end
      end
    end
  end
  return res
end

function ActivityTorchRelayTaskManager:GetRedDotNum(activityId, torchRelayTaskType)
  local redNum = 0
  if torchRelayTaskType == nil then
    redNum = redNum + self:GetRedDotDailyTaskNum(activityId)
    redNum = redNum + self:GetRedDotMilesTaskNum(activityId)
  elseif torchRelayTaskType == ActivityTorchRelayTaskType.Daily then
    redNum = self:GetRedDotDailyTaskNum(activityId)
  elseif torchRelayTaskType == ActivityTorchRelayTaskType.Milestones then
    redNum = self:GetRedDotMilesTaskNum(activityId)
  end
  return redNum
end

function ActivityTorchRelayTaskManager:GetRedDotDailyTaskNum(activityId)
  local redNum = 0
  local activityData = self:GetActivityData(activityId)
  local activityMainData = DataCenter.ActivityTorchRelayManager:GetActivityData(activityId)
  if activityData == nil or activityMainData == nil then
    return redNum
  end
  local idList = activityMainData.config:GetDailyTaskIdList()
  if idList then
    for i, id in ipairs(idList) do
      local taskData = activityData.totalTaskMap[id]
      if taskData and taskData.state == 1 then
        redNum = redNum + 1
      end
    end
  end
  return redNum
end

function ActivityTorchRelayTaskManager:GetRedDotMilesTaskNum(activityId)
  local redNum = 0
  local activityData = self:GetActivityData(activityId)
  local activityMainData = DataCenter.ActivityTorchRelayManager:GetActivityData(activityId)
  if activityData == nil or activityMainData == nil then
    return redNum
  end
  local idList = activityMainData.config:GetMilesTaskIdList()
  if idList then
    for i, id in ipairs(idList) do
      local taskData = activityData.totalTaskMap[id]
      if taskData and taskData.state == 1 then
        redNum = redNum + 1
      end
    end
  end
  redNum = redNum + self:GetMilestonesRedNum(activityId)
  return redNum
end

return ActivityTorchRelayTaskManager
