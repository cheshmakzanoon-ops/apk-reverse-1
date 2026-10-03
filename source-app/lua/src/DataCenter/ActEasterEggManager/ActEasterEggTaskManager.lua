local ActEasterEggTaskManager = BaseClass("ActEasterEggTaskManager")

function ActEasterEggTaskManager:__init()
  self.totalTaskMap = {}
  self.totalTaskList = {}
end

function ActEasterEggTaskManager:__delete()
  self.totalTaskMap = nil
  self.totalTaskList = nil
  self.stageCompleteIndexList = nil
end

function ActEasterEggTaskManager:UpdateServerData(message)
  self.activityId = message.activityId
  self:UpdateTaskListInfo(message.taskArr)
  self:UpdateStageCompleteIndex(message.boxReceive)
end

function ActEasterEggTaskManager:OnTaskGetReward(message)
  local taskId = tonumber(message.taskId)
  self:SetTaskState(message.taskArr)
  if not table.IsNullOrEmpty(message.reward) then
    DataCenter.RewardManager:ShowGiftReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  EventManager:GetInstance():Broadcast(EventId.EasterEggTaskRewardGet)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActEasterEggTaskManager:OnStageGetReward(message)
  self:UpdateStageCompleteIndex(message.boxReceive)
  if not table.IsNullOrEmpty(message.reward) then
    DataCenter.RewardManager:ShowGiftReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  EventManager:GetInstance():Broadcast(EventId.EasterEggTaskStageRewardGet)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActEasterEggTaskManager:ParseTaskServerData(message)
  if message ~= nil then
    local taskList = message.a_task
    self:UpdateTaskListInfo(taskList)
  end
end

function ActEasterEggTaskManager:UpdateTaskListInfo(taskList)
  if taskList and 0 < #taskList then
    for k, v in pairs(taskList) do
      local id = 0
      if v.taskId then
        id = tonumber(v.taskId)
      elseif v.id then
        id = tonumber(v.id)
      end
      if 0 < id then
        local taskData = self:GetTaskInfo(id)
        if taskData == nil then
          taskData = ActEasterEggTaskInfo.New()
          taskData:UpdateInfo(v)
          self:SetTaskInfo(taskData)
        else
          taskData:UpdateInfo(v)
        end
      else
        Logger.LogError("wtf??? id is 0???  v:" .. tostring(v))
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.EasterEggTaskUpdate)
end

function ActEasterEggTaskManager:UpdateStageCompleteIndex(indexList)
  if indexList then
    self.stageCompleteIndexList = indexList
  end
end

function ActEasterEggTaskManager:SetTaskInfo(taskData)
  self.totalTaskMap[taskData.id] = taskData
  table.insert(self.totalTaskList, taskData)
end

function ActEasterEggTaskManager:GetTaskInfo(id)
  return self.totalTaskMap[id]
end

function ActEasterEggTaskManager:SetTaskState(taskArr)
  if not taskArr then
    return
  end
  for _, v in pairs(taskArr) do
    local id = v.taskId
    local state = v.state
    self.totalTaskMap[id].state = state
  end
end

function ActEasterEggTaskManager:GetAllTaskList()
  if #self.totalTaskList > 1 then
    table.sort(self.totalTaskList, function(a, b)
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
        if a:IsDaily() ~= b:IsDaily() then
          if a:IsDaily() then
            return true
          elseif b:IsDaily() then
            return false
          end
        end
        return a.config.order > b.config.order
      end
      return false
    end)
  end
  return self.totalTaskList
end

function ActEasterEggTaskManager:GetRedDotNum()
  local redNum = 0
  if self.totalTaskList then
    for i, taskData in ipairs(self.totalTaskList) do
      if taskData and taskData.state == 1 then
        redNum = redNum + 1
      end
    end
  end
  redNum = redNum + self:GetStageRewardRedNum()
  return redNum
end

function ActEasterEggTaskManager:GetStageRewardRedNum()
  local res = 0
  local config = DataCenter.ActEasterEggManager:GetEggConfigData()
  if config then
    local progressList = config:GetTaskStageRewardList()
    local curProgress = self:GetTaskStageProgress()
    for i, v in pairs(progressList) do
      if curProgress >= v.progress then
        local isGetReward = self:CheckTaskStageComplete(i - 1)
        if not isGetReward then
          res = res + 1
          break
        end
      end
    end
  end
  return res
end

function ActEasterEggTaskManager:GetTaskStageRewardList()
  local config = DataCenter.ActEasterEggManager:GetEggConfigData()
  if config then
    return config:GetTaskStageRewardList()
  end
  return nil
end

function ActEasterEggTaskManager:GetTaskStageProgress()
  local config = DataCenter.ActEasterEggManager:GetEggConfigData()
  if config then
    return DataCenter.ItemData:GetItemRealCount(config.score_item_id)
  end
  return 0
end

function ActEasterEggTaskManager:GetMilestonesTotalProgress()
  local result = 0
  local config = DataCenter.ActEasterEggManager:GetEggConfigData()
  if config then
    local list = config:GetTaskStageRewardList()
    if list then
      result = list[#list].progress
    end
  end
  return result
end

function ActEasterEggTaskManager:CheckTaskStageComplete(index)
  if self.stageCompleteIndexList then
    for i, v in ipairs(self.stageCompleteIndexList) do
      if v == index then
        return true
      end
    end
  end
  return false
end

return ActEasterEggTaskManager
