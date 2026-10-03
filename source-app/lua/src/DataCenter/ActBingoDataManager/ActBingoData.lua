local ActBingoData = BaseClass("ActBingoData")

local function __init(self)
  self.activityId = 0
  self.hRewardArr = {}
  self.vRewardArr = {}
  self.bigReward = {}
  self.taskArr = {}
  self.hReceives = {}
  self.vReceives = {}
  self.bFlag = 0
  self.taskIdIndexDict = {}
end

local function __delete(self)
  self.activityId = nil
  self.hRewardArr = nil
  self.vRewardArr = nil
  self.bigReward = nil
  self.taskArr = nil
  self.hReceives = nil
  self.vReceives = nil
  self.bFlag = nil
  self.taskIdIndexDict = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.activityId ~= nil then
    self.activityId = message.activityId
  end
  if message.hRewardArr ~= nil then
    self.hRewardArr = message.hRewardArr
  end
  if message.vRewardArr ~= nil then
    self.vRewardArr = message.vRewardArr
  end
  if message.bigReward ~= nil then
    self.bigReward = message.bigReward
  end
  if message.taskArr ~= nil then
    self.taskArr = message.taskArr
    self.taskIdIndexDict = {}
    for i, task in pairs(self.taskArr) do
      local taskId = task.taskId or 0
      self.taskIdIndexDict[taskId] = i
    end
  end
  if message.hReceives ~= nil then
    self.hReceives = {}
    for k, v in pairs(message.hReceives) do
      self.hReceives[v + 1] = true
    end
  end
  if message.vReceives ~= nil then
    self.vReceives = {}
    for k, v in pairs(message.vReceives) do
      self.vReceives[v + 1] = true
    end
  end
  if message.bFlag ~= nil then
    self.bFlag = message.bFlag
  end
end

local function GetRedNum(self)
  local num = 0
  local taskNum = 0
  for i, task in pairs(self.taskArr) do
    if task.state == TaskState.CanReceive then
      taskNum = taskNum + 1
    end
  end
  local boxNum = 0
  for i = 1, ActBingoTaskNum.OneHorizontal do
    local boxState = self:GetBoxState(ActBingoBoxType.Vertical, i)
    if boxState == ActBingoBoxState.CanReceive then
      boxNum = boxNum + 1
    end
  end
  for i = 1, ActBingoTaskNum.OneVertical do
    local boxState = self:GetBoxState(ActBingoBoxType.Horizontal, i)
    if boxState == ActBingoBoxState.CanReceive then
      boxNum = boxNum + 1
    end
  end
  local boxState = self:GetBoxState(ActBingoBoxType.BigReward, 0)
  if boxState == ActBingoBoxState.CanReceive then
    boxNum = boxNum + 1
  end
  num = taskNum + boxNum
  return num
end

local function GetBoxState(self, boxType, boxIndex)
  local state = ActBingoBoxState.NoComplete
  if boxType == ActBingoBoxType.Horizontal then
    local isHaveNoComplete = false
    for i = 1, ActBingoTaskNum.OneHorizontal do
      local taskIndex = (boxIndex - 1) * ActBingoTaskNum.OneHorizontal + i
      local taskData = self.taskArr[taskIndex]
      if taskData.state == TaskState.NoComplete then
        isHaveNoComplete = true
        break
      end
    end
    if isHaveNoComplete == false then
      if self.hReceives[boxIndex] == true then
        state = ActBingoBoxState.Received
      else
        state = ActBingoBoxState.CanReceive
      end
    else
      state = ActBingoBoxState.NoComplete
    end
  elseif boxType == ActBingoBoxType.Vertical then
    local isHaveNoComplete = false
    for i = 1, ActBingoTaskNum.OneVertical do
      local taskIndex = boxIndex + (i - 1) * ActBingoTaskNum.OneHorizontal
      local taskData = self.taskArr[taskIndex]
      if taskData == nil then
        Logger.LogError("taskIndex is nil, boxIndex = " .. boxIndex .. ", i = " .. i .. ", taskIndex = " .. taskIndex)
      end
      if taskData.state == TaskState.NoComplete then
        isHaveNoComplete = true
        break
      end
    end
    if isHaveNoComplete == false then
      if self.vReceives[boxIndex] == true then
        state = ActBingoBoxState.Received
      else
        state = ActBingoBoxState.CanReceive
      end
    else
      state = ActBingoBoxState.NoComplete
    end
  elseif boxType == ActBingoBoxType.BigReward then
    local isHaveNoComplete = false
    for i, task in pairs(self.taskArr) do
      if task.state == TaskState.NoComplete then
        isHaveNoComplete = true
        break
      end
    end
    if isHaveNoComplete == false then
      if self.bFlag == 1 then
        state = ActBingoBoxState.Received
      else
        state = ActBingoBoxState.CanReceive
      end
    else
      state = ActBingoBoxState.NoComplete
    end
  end
  return state
end

local function GetCompleteTaskNum(self)
  local num = 0
  for i, task in pairs(self.taskArr) do
    if task.state ~= TaskState.NoComplete then
      num = num + 1
    end
  end
  return num
end

local function UpdateActTasks(self, message)
  local updateTaskList = message.a_task
  if updateTaskList and 0 < #updateTaskList then
    for k, v in pairs(updateTaskList) do
      local taskId = v.id
      local taskIndex = self.taskIdIndexDict[taskId]
      if taskIndex then
        self.taskArr[taskIndex].num = v.num
        self.taskArr[taskIndex].state = v.state
      end
    end
  end
end

local function GetOneTaskReward(self, message)
  local updateTaskList = message.taskArr
  if updateTaskList and 0 < #updateTaskList then
    for k, v in pairs(updateTaskList) do
      local taskId = v.id
      local taskIndex = self.taskIdIndexDict[taskId]
      if taskIndex then
        self.taskArr[taskIndex].state = v.state
      end
    end
  end
end

local function GetOneBoxReward(self, message)
  local type = message.type
  local index = message.index
  if type == ActBingoBoxType.Horizontal then
    self.hReceives[index + 1] = true
  elseif type == ActBingoBoxType.Vertical then
    self.vReceives[index + 1] = true
  elseif type == ActBingoBoxType.BigReward then
    self.bFlag = 1
  end
end

local function IsAllTaskReceived(self)
  local isAllReceived = true
  for i, task in pairs(self.taskArr) do
    if task.state == TaskState.NoComplete or task.state == TaskState.CanReceive then
      isAllReceived = false
      break
    end
  end
  return isAllReceived
end

ActBingoData.__init = __init
ActBingoData.__delete = __delete
ActBingoData.ParseData = ParseData
ActBingoData.GetRedNum = GetRedNum
ActBingoData.GetBoxState = GetBoxState
ActBingoData.GetCompleteTaskNum = GetCompleteTaskNum
ActBingoData.UpdateActTasks = UpdateActTasks
ActBingoData.GetOneTaskReward = GetOneTaskReward
ActBingoData.GetOneBoxReward = GetOneBoxReward
ActBingoData.IsAllTaskReceived = IsAllTaskReceived
return ActBingoData
