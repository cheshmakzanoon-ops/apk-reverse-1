local ActCrazyRockTaskManager = BaseClass("ActCrazyRockTaskManager")
local CrazyRockTaskData = require("DataCenter.ActCrazyRockDataManager.Data.CrazyRockTaskData")

function ActCrazyRockTaskManager:__init()
  self.taskList = {}
end

function ActCrazyRockTaskManager:__delete()
  self.taskList = nil
end

function ActCrazyRockTaskManager:UpdateServerData(message)
  self.activityId = message.activityId
  self:UpdateTaskListInfo(message.taskArr)
end

function ActCrazyRockTaskManager:UpdateTaskListInfo(taskList)
  if taskList and 0 < #taskList then
    for k, v in pairs(taskList) do
      if v.taskId or v.id then
        if not v.taskId and v.id then
          v.taskId = toInt(v.id)
        end
        local taskData = self:GetTaskInfo(v.taskId)
        if taskData == nil then
          taskData = CrazyRockTaskData.New()
          taskData:ParseTaskData(v)
          table.insert(self.taskList, taskData)
        else
          taskData:ParseTaskData(v)
        end
      end
    end
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActCrazyRockTaskManager:OnTaskGetReward(message)
  self:SetTaskState(message.taskArr)
  if not table.IsNullOrEmpty(message.reward) then
    DataCenter.RewardManager:ShowGiftReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  EventManager:GetInstance():Broadcast(EventId.CrazyRockTaskRewardGet)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActCrazyRockTaskManager:SetTaskState(taskArr)
  if not taskArr then
    return
  end
  for _, v in pairs(taskArr) do
    local taskId = v.taskId
    local state = v.state
    local taskInfo = self:GetTaskInfo(taskId)
    if taskInfo then
      taskInfo.state = state
    end
  end
end

function ActCrazyRockTaskManager:ParseTaskServerData(message)
  if message ~= nil then
    local taskList = message.a_task
    self:UpdateTaskListInfo(taskList)
  end
end

function ActCrazyRockTaskManager:GetTaskInfo(taskId)
  local taskInfo
  for k, v in pairs(self.taskList) do
    if v and v.taskId == taskId then
      taskInfo = v
    end
  end
  return taskInfo
end

function ActCrazyRockTaskManager:GetAllTaskList()
  if table.length(self.taskList) > 1 then
    table.sort(self.taskList, function(a, b)
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
  return self.taskList
end

function ActCrazyRockTaskManager:GetRedDotNum()
  local redNum = 0
  if self.taskList then
    for _, taskData in ipairs(self.taskList) do
      if taskData and taskData.state == 1 then
        redNum = redNum + 1
      end
    end
  end
  return redNum
end

function ActCrazyRockTaskManager:RequestReceiveTaskReward(activityId, taskId)
  SFSNetwork.SendMessage(MsgDefines.MusicReceiveTaskReward, activityId, taskId)
end

return ActCrazyRockTaskManager
