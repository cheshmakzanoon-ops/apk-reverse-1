local TaskInfo = BaseClass("TaskInfo")

local function __init(self)
  self.id = 0
  self.num = 0
  self.state = 0
  self.rewardList = {}
  self.taskShow = false
  self.exp = 0
  self.taskReward = false
end

local function __delete(self)
  self.id = nil
  self.num = nil
  self.state = nil
  self.rewardList = nil
  self.taskShow = nil
  self.exp = nil
  self.taskReward = nil
end

local function UpdateInfo(self, message)
  if message == nil then
    return
  end
  if message.id ~= nil then
    self.id = message.id
  end
  if message.taskId ~= nil then
    self.id = message.taskId
  end
  if message.num ~= nil then
    self.num = message.num
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.reward ~= nil then
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
  if message.exp ~= nil then
    self.exp = message.exp
  end
end

local function SetTaskShowState(self)
  self.taskShow = true
end

local function SetTaskRewardState(self)
  self.taskReward = true
end

local function GetFinalReward(self)
  local rewardList = DeepCopy(self.rewardList) or {}
  if not self.id then
    return rewardList
  end
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.id)
  local bp_scores = questTemplate.bp_score
  for actId, count in pairs(bp_scores) do
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
    if actData and actData:IsValid() and not string.IsNullOrEmpty(actData.para_5) then
      local bpScoreInfo = {}
      bpScoreInfo.rewardType = RewardType.GOODS
      bpScoreInfo.itemId = actData.para_5
      bpScoreInfo.count = count
      table.insert(rewardList, bpScoreInfo)
    end
  end
  return rewardList
end

local function GetTaskProgress(self)
  if not self.id then
    return 0, 1, nil
  end
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.id)
  if questTemplate == nil then
    return 0, 1, nil
  end
  local max = toInt(questTemplate.para2)
  local now = math.max(math.min(toInt(self.num), max), 0)
  local type2 = toInt(questTemplate.type2)
  if 0 < type2 then
    Logger.Log(string.format("task_id=%s, (%s/%s), type2=%s", self.id, now, max, type2))
  end
  return now, max, questTemplate
end

local function GetPrevTask(self)
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.id)
  if questTemplate == nil then
    return nil
  end
  local preTaskId = questTemplate:GetPreQuestId()
  if string.IsNullOrEmpty(preTaskId) then
    return nil
  end
  local taskInfo = DataCenter.TaskManager:FindTaskInfo(preTaskId)
  return taskInfo
end

TaskInfo.__init = __init
TaskInfo.__delete = __delete
TaskInfo.UpdateInfo = UpdateInfo
TaskInfo.SetTaskShowState = SetTaskShowState
TaskInfo.SetTaskRewardState = SetTaskRewardState
TaskInfo.GetFinalReward = GetFinalReward
TaskInfo.GetTaskProgress = GetTaskProgress
TaskInfo.GetPrevTask = GetPrevTask
return TaskInfo
