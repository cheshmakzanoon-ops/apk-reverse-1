local SeasonPreviewManager = BaseClass("SeasonPreviewManager")
local SeasonPreviewTaskData = require("DataCenter.SeasonPreview.SeasonPreviewTaskData")

function SeasonPreviewManager:__init()
  self.activityId = nil
  self.selectingIndex = nil
  self.todayIndex = nil
  self.taskList = {}
  self.taskRankList = {}
  self.myRanks = {}
end

function SeasonPreviewManager:__delete()
  self.activityId = nil
  self.selectingIndex = nil
  self.todayIndex = nil
  self.taskRankList = {}
  self.myRanks = {}
end

function SeasonPreviewManager:InitData(data)
  self.activityId = data.id
  self.activityType = data.type
  SFSNetwork.SendMessage(MsgDefines.ViewSeasonPreTaskMessage, self.activityId)
end

function SeasonPreviewManager:SetSelectingIndex(index)
  if index <= 0 or 7 < index then
    return
  end
  self.selectingIndex = index
end

function SeasonPreviewManager:GetSelectingIndex()
  return self.selectingIndex
end

function SeasonPreviewManager:GetTodayIndex()
  return self.todayIndex
end

function SeasonPreviewManager:GetSelectingData()
  return self.taskList[self.selectingIndex]
end

function SeasonPreviewManager:HandlePreTaskData(data)
  local now = UITimeManager:GetInstance():GetServerTime()
  local seasonPreTaskArr = data.seasonPreTaskArr or {}
  self.taskList = {}
  for _, v in ipairs(seasonPreTaskArr) do
    local task = SeasonPreviewTaskData.New()
    task:ParseMsg(v)
    table.insert(self.taskList, task)
  end
  table.sort(self.taskList, function(a, b)
    return a.taskId < b.taskId
  end)
  if self.selectingIndex == nil then
    for i, v in ipairs(self.taskList) do
      if now < v.dayTime then
        self.selectingIndex = math.max(1, i - 1)
        break
      end
    end
    if self.selectingIndex == nil then
      self.selectingIndex = math.max(1, #self.taskList)
    end
  end
  self:UpdateTodayIndex()
  EventManager:GetInstance():Broadcast(EventId.GetSeasonPreviewTaskList)
end

function SeasonPreviewManager:UpdateTodayIndex()
  local now = UITimeManager:GetInstance():GetServerTime()
  for i, v in ipairs(self.taskList) do
    if now < v.dayTime then
      self.todayIndex = math.max(1, i - 1)
      break
    end
  end
  if self.todayIndex == nil then
    self.todayIndex = self.selectingIndex
  end
end

function SeasonPreviewManager:GetTaskList()
  return self.taskList
end

function SeasonPreviewManager:GetReward(taskId)
  SFSNetwork.SendMessage(MsgDefines.SeasonPreTaskGetRewardMessage, self.activityId, taskId)
end

function SeasonPreviewManager:HandleRewardData(data)
  if data == nil then
    return
  end
  DataCenter.RewardManager:ShowCommonReward(data)
  DataCenter.RewardManager:AddRewardsAndRes(data)
  if data.seasonPreTaskInfo then
    for _, v in ipairs(self.taskList) do
      if v.taskId == data.seasonPreTaskInfo.taskId then
        v:ParseMsg(data.seasonPreTaskInfo)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GetSeasonPreviewTaskList)
end

function SeasonPreviewManager:ReqRankList(index)
  local data = self.taskList[index or self.todayIndex]
  if data == nil then
    return
  end
  local taskId = data.taskId
  if taskId == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonPreTaskRankMessage, self.activityId, tostring(taskId))
end

function SeasonPreviewManager:HandleRankData(data)
  self.taskRankList[tostring(data.taskId)] = data
  EventManager:GetInstance():Broadcast(EventId.GetSeasonPreviewRankList)
end

function SeasonPreviewManager:GetRankList(index)
  local data = self.taskList[index or self.todayIndex]
  if data == nil then
    return {}
  end
  if self.taskRankList[tostring(data.taskId)] == nil then
    return {}
  end
  return self.taskRankList[tostring(data.taskId)].ranks
end

function SeasonPreviewManager:GetRankData(index)
  local data = self.taskList[index or self.todayIndex]
  if data == nil then
    return {}
  end
  if self.taskRankList[tostring(data.taskId)] == nil then
    return {}
  end
  return self.taskRankList[tostring(data.taskId)]
end

function SeasonPreviewManager:GetBoxDisplayRewardList(index)
  local data = self.taskList[index or self.todayIndex]
  if data == nil then
    return {}
  end
  return data.reward
end

function SeasonPreviewManager:GetActivityTaskRedState()
  local state = false
  for i, v in ipairs(self.taskList) do
    if v.state == 1 then
      state = true
      break
    end
  end
  return state
end

return SeasonPreviewManager
