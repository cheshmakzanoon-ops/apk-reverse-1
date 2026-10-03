local ActSevenDayV2Info = BaseClass("ActSevenDayV2Info")

local function __init(self)
  self.dayActs = {}
  self.scoreReward = {}
  self.scoreMax = 0
  self.activityId = 0
  self.score = 0
  self.taskRed = {}
  self.days = 0
  self.endTime = 0
  self.taskRedNum = 0
  self.vipRewardRedNum = 0
  self.rewardRedNum = 0
  self.lastVisitDayTab = {}
end

local function __delete(self)
  self.dayActs = nil
  self.scoreReward = nil
  self.scoreMax = nil
  self.activityId = nil
  self.score = nil
  self.taskRed = nil
  self.days = nil
  self.endTime = nil
  self.taskRedNum = nil
  self.vipRewardRedNum = nil
  self.rewardRedNum = nil
  self.lastVisitDayTab = nil
end

local function ParseDayActs(self, message)
  if message == nil then
    return
  end
  local list = {}
  local perGroupNum = 3
  local group = math.floor((#message + perGroupNum - 1) / perGroupNum)
  for i = 1, group do
    list[i] = {}
    for j = 1, perGroupNum do
      local index = (i - 1) * perGroupNum + j
      table.insert(list[i], message[index])
    end
  end
  for i = 1, group do
    self.dayActs[i] = list[i]
    for j = 1, #list[i] do
      self.dayActs[i][j] = list[i][j]
      local id = self.dayActs[i][j].id
      local dayAct_table = LocalController:instance():getLine(TableName.ActSevenV2, id)
      if dayAct_table == nil then
        return
      end
      self.dayActs[i][j].type1_text = dayAct_table.type1_text
      self.dayActs[i][j].type2_text = dayAct_table.type2_text
    end
  end
end

local function ParseScoreReward(self, message)
  if message == nil then
    return
  end
  self.scoreReward = {}
  for i = 1, #message do
    local param = {}
    param.needScore = message[i].needScore
    param.reward = DataCenter.RewardManager:ReturnRewardParamForView(message[i].reward)
    param.rewardFlag = message[i].rewardFlag
    if message[i].needVipLevel then
      param.needVipLevel = message[i].needVipLevel
    end
    if message[i].vipReward then
      param.vipReward = DataCenter.RewardManager:ReturnRewardParamForView(message[i].vipReward)
    end
    if message[i].vipRewardFlag then
      param.vipRewardFlag = message[i].vipRewardFlag
    end
    table.insert(self.scoreReward, param)
    self.scoreMax = message[i].needScore
  end
end

local function ParseOther(self, message)
  if message == nil then
    return
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  if message.score then
    self.score = message.score
  end
end

local function CalculateDate(self)
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
  if not actListData then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.endTime = actListData.endTime
  if curTime >= actListData.startTime and curTime < actListData.endTime then
    local value = (curTime - actListData.startTime) / 1000
    for i = 1, #self.dayActs do
      if value <= i * OneDayTime then
        self.days = i
        break
      end
    end
    if self.days == 0 then
      self.days = #self.dayActs
    end
  end
end

local function CheckRedDot(self)
  self.taskRedNum = 0
  self.vipRewardRedNum = 0
  self.vipRewardLockNum = 0
  self.rewardRedNum = 0
  local vipInfo = DataCenter.VIPManager:GetVipData()
  if self.scoreReward ~= nil then
    for i = 1, #self.scoreReward do
      local reward = self.scoreReward[i]
      if reward ~= nil and reward.rewardFlag == 0 and self.score >= reward.needScore then
        self.taskRedNum = self.taskRedNum + 1
        self.rewardRedNum = self.rewardRedNum + 1
      end
      if reward ~= nil and reward.vipRewardFlag == 0 and self.score >= reward.needScore then
        if vipInfo.level >= reward.needVipLevel then
          self.taskRedNum = self.taskRedNum + 1
          self.vipRewardRedNum = self.vipRewardRedNum + 1
        else
          self.vipRewardLockNum = self.vipRewardLockNum + 1
        end
      end
    end
  end
  if self.dayActs ~= nil then
    for i = 1, #self.dayActs do
      self.taskRed[i] = {}
      local dayInfos = self.dayActs[i]
      if i <= self.days then
        for j = 1, #dayInfos do
          local tasks = dayInfos[j].tasks
          self.taskRed[i][j] = 0
          for k = 1, #tasks do
            if tasks[k].state == TaskState.CanReceive then
              self.taskRedNum = self.taskRedNum + 1
              self.taskRed[i][j] = 1
            end
          end
        end
      end
    end
  end
end

local function GetActRed(self)
  return self.taskRedNum
end

local function SortTask(self, tasks)
  local list = {}
  if tasks ~= nil then
    local canReceiveList = {}
    local unFinishList = {}
    local hasFinishList = {}
    for i = 1, #tasks do
      local taskId = tasks[i].id
      local taskConfig = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(taskId)
      if taskConfig ~= nil then
        local state = tasks[i].state
        if state == 2 then
          table.insert(hasFinishList, tasks[i])
        elseif state == 1 then
          table.insert(canReceiveList, tasks[i])
        else
          table.insert(unFinishList, tasks[i])
        end
      end
    end
    list = canReceiveList
    for i = 1, #unFinishList do
      table.insert(list, unFinishList[i])
    end
    for i = 1, #hasFinishList do
      table.insert(list, hasFinishList[i])
    end
  end
  return list
end

local function UpdateScore(self, value)
  self.score = value
end

local function SetScoreBoxState(self, index, state)
  if self.scoreReward ~= nil then
    self.scoreReward[index].rewardFlag = state
  end
end

local function SetLastVisitDayTab(self, value)
  self.lastVisitDayTab = value
end

local function GetLastVisitDayTab(self)
  return self.lastVisitDayTab
end

local function GetVipRewardRed(self)
  return self.vipRewardRedNum
end

local function GetRewardRed(self)
  return self.rewardRedNum
end

local function GetVipLockRed(self)
  return self.vipRewardLockNum
end

local function UpdateTaskData(self, taskData)
  if self.dayActs ~= nil and taskData then
    for i = 1, #self.dayActs do
      local dayInfos = self.dayActs[i]
      for j = 1, #dayInfos do
        local tasks = dayInfos[j].tasks
        for k = 1, #tasks do
          if tasks[k].id == taskData.taskId then
            tasks[k].state = taskData.state
          end
        end
      end
    end
  end
end

ActSevenDayV2Info.__init = __init
ActSevenDayV2Info.__delete = __delete
ActSevenDayV2Info.ParseDayActs = ParseDayActs
ActSevenDayV2Info.ParseScoreReward = ParseScoreReward
ActSevenDayV2Info.ParseOther = ParseOther
ActSevenDayV2Info.CalculateDate = CalculateDate
ActSevenDayV2Info.CheckRedDot = CheckRedDot
ActSevenDayV2Info.UpdateScore = UpdateScore
ActSevenDayV2Info.SetScoreBoxState = SetScoreBoxState
ActSevenDayV2Info.GetActRed = GetActRed
ActSevenDayV2Info.SortTask = SortTask
ActSevenDayV2Info.SetLastVisitDayTab = SetLastVisitDayTab
ActSevenDayV2Info.GetLastVisitDayTab = GetLastVisitDayTab
ActSevenDayV2Info.GetVipRewardRed = GetVipRewardRed
ActSevenDayV2Info.GetRewardRed = GetRewardRed
ActSevenDayV2Info.GetVipLockRed = GetVipLockRed
ActSevenDayV2Info.UpdateTaskData = UpdateTaskData
return ActSevenDayV2Info
