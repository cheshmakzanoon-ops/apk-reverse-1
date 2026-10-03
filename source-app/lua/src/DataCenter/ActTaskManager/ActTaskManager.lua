local ActTaskManager = BaseClass("ActTaskManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.dataDict = {}
end

local function __delete(self)
  self.dataDict = nil
end

local function RefreshActDetailData(self, message)
  local activityId = message.activityId
  self.dataDict[activityId] = message
  self.dataDict[activityId].taskArrDict = {}
  for k, v in ipairs(message.taskArr) do
    local taskId = v.taskId
    self.dataDict[activityId].taskArrDict[taskId] = v
  end
end

local function GetActData(self, activityId)
  local data
  data = self.dataDict[activityId]
  return data
end

local function UpdateActScore(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId].achieve_score = message.score
end

local function UpdateActTasks(self, message)
  local activityId = message.aid
  if self.dataDict[activityId] == nil then
    return
  end
  local updateTaskList = message.a_task
  if updateTaskList and 0 < #updateTaskList then
    for k, v in pairs(updateTaskList) do
      local taskId = v.id
      if self.dataDict[activityId].taskArrDict[taskId] then
        local taskData = self.dataDict[activityId].taskArrDict[taskId]
        taskData.num = v.num
        taskData.state = v.state
      end
    end
  end
end

local function GetRedNum(self, activityId)
  local num = 0
  local data = self.dataDict[activityId]
  if data then
    for k, v in pairs(data.taskArrDict) do
      if v.state == TaskState.CanReceive then
        num = num + 1
      end
    end
    local haveGetStage = #data.score_receives
    local maxStage = #data.achieveArr
    local targetStage = haveGetStage + 1
    if maxStage < targetStage then
      targetStage = maxStage
    end
    if haveGetStage < targetStage then
      local targetScoreData = data.achieveArr[targetStage]
      if data.achieve_score >= targetScoreData.targetScore then
        num = num + 1
      end
    end
  end
  return num
end

local function IsLoopTask(self, activityId)
  local isLoop = false
  local activityData = self:GetActData(activityId)
  if activityData and activityData.cycle_group ~= nil and activityData.cycle_group > 0 then
    isLoop = true
  end
  return isLoop
end

local function GetLoopTaskShowData(self, activityId)
  local showData = {}
  local activityData = self:GetActData(activityId)
  if activityData == nil then
    return showData
  end
  local isLoop = self:IsLoopTask(activityId)
  if not isLoop then
    return showData
  end
  local taskLoopParam = activityData.cycle_param
  local loopParamList = string.string2array_i(taskLoopParam, ";", "|")
  local cycle_group_dict = {}
  for k, v in pairs(activityData.taskArrDict) do
    local taskId = tonumber(k)
    local taskTemp = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(taskId)
    local pre_id = taskTemp.pre_id
    local cycle_group = taskTemp.cycle_group
    if cycle_group_dict[cycle_group] == nil then
      cycle_group_dict[cycle_group] = {}
      cycle_group_dict[cycle_group].sortDict = {}
      cycle_group_dict[cycle_group].showList = {}
    end
    if cycle_group_dict[cycle_group].sortDict[taskId] == nil then
      cycle_group_dict[cycle_group].sortDict[taskId] = {}
    end
    cycle_group_dict[cycle_group].sortDict[taskId].data = v
    cycle_group_dict[cycle_group].sortDict[taskId].temp = taskTemp
    cycle_group_dict[cycle_group].sortDict[taskId].pre_id = pre_id
    if 0 < pre_id then
      if cycle_group_dict[cycle_group].sortDict[pre_id] == nil then
        cycle_group_dict[cycle_group].sortDict[pre_id] = {}
      end
      cycle_group_dict[cycle_group].sortDict[pre_id].next_id = taskId
    end
  end
  for k, v in pairs(cycle_group_dict) do
    local firstTaskId = 0
    for taskId, taskData in pairs(v.sortDict) do
      if taskData.temp.pre_id == 0 then
        firstTaskId = taskId
        break
      end
    end
    if firstTaskId == 0 then
      break
    end
    local maxNum = table.count(v.sortDict)
    local addTaskId = firstTaskId
    for i = 1, maxNum do
      local taskData = v.sortDict[addTaskId]
      table.insert(v.showList, taskData)
      addTaskId = taskData.next_id
      if addTaskId == nil then
        break
      end
    end
  end
  local preFinNum = 0
  local preGroupNum = 0
  local preGroupId = 0
  local curGroupTaskNum = 0
  local breakK = -1
  for k, v in ipairs(loopParamList) do
    if #v == 2 then
      local groupId = v[1]
      local cycle = v[2]
      local oneGroupFinNum = 0
      if cycle_group_dict[groupId] then
        oneGroupFinNum = #cycle_group_dict[groupId].showList
      end
      curGroupTaskNum = oneGroupFinNum
      preGroupId = groupId
      local addGroupNum = 0
      if activityData.cycle_group ~= groupId then
        addGroupNum = cycle
      else
        addGroupNum = activityData.cycle_group_num
      end
      preGroupNum = preGroupNum + addGroupNum
      preFinNum = preFinNum + oneGroupFinNum * addGroupNum
      if activityData.cycle_group == groupId then
        breakK = k
        break
      end
    end
  end
  if activityData.cycle_group_num == loopParamList[#loopParamList][1] and activityData.cycle_group == loopParamList[#loopParamList][2] then
    preFinNum = preFinNum - curGroupTaskNum
  end
  showData.finTaskNum = preFinNum
  showData.finTaskGroup = activityData.cycle_group_num
  showData.curTaskGroup = activityData.cycle_group
  showData.lastGroup = loopParamList[#loopParamList][1]
  showData.lastGroupNum = loopParamList[#loopParamList][2]
  showData.taskList = {}
  if cycle_group_dict[activityData.cycle_group] then
    showData.taskList = cycle_group_dict[activityData.cycle_group].showList
  end
  return showData
end

local function IsDailyTask(self, activityId)
  local isDaily = false
  local activityData = self:GetActData(activityId)
  if activityData then
    for k, v in pairs(activityData.taskArrDict) do
      if v.daily_refresh > 0 then
        isDaily = true
        break
      end
    end
  end
  return isDaily
end

local function GetTaskEndTine(self, activityId)
  local endTime = 0
  local activityData = self:GetActData(activityId)
  if activityData then
    endTime = activityData.nowZeroTime + 86400000
  end
  return endTime
end

local function TaskDataUpdateAtGetReward(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  if message.cycle_group then
    self.dataDict[activityId].cycle_group = message.cycle_group
  end
  if message.cycle_group_num then
    self.dataDict[activityId].cycle_group_num = message.cycle_group_num
  end
end

ActTaskManager.__init = __init
ActTaskManager.__delete = __delete
ActTaskManager.RefreshActDetailData = RefreshActDetailData
ActTaskManager.GetActData = GetActData
ActTaskManager.UpdateActScore = UpdateActScore
ActTaskManager.UpdateActTasks = UpdateActTasks
ActTaskManager.GetRedNum = GetRedNum
ActTaskManager.IsLoopTask = IsLoopTask
ActTaskManager.GetLoopTaskShowData = GetLoopTaskShowData
ActTaskManager.IsDailyTask = IsDailyTask
ActTaskManager.GetTaskEndTine = GetTaskEndTine
ActTaskManager.TaskDataUpdateAtGetReward = TaskDataUpdateAtGetReward
return ActTaskManager
