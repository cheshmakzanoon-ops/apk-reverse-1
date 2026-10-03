local ActivitySevenDayInfo = BaseClass("ActivitySevenDayInfo")

local function __init(self)
  self.score = 0
  self.days = 0
  self.endTime = 0
  self.scoreMax = 0
  self.scoreReward = {}
  self.dayActs = {}
  self.taskRedNum = 0
  self.taskRed = {}
end

local function __delete(self)
  self.score = nil
  self.days = nil
  self.endTime = nil
  self.scoreMax = nil
  self.scoreReward = nil
  self.dayActs = nil
  self.taskRedNum = nil
  self.taskRed = nil
end

local function ParseActivityData(self, dayActsMessage)
  if dayActsMessage == nil then
    return
  end
  if dayActsMessage.score ~= nil then
    self.score = dayActsMessage.score
  end
  if dayActsMessage.days ~= nil then
    self.days = dayActsMessage.days
  end
  if dayActsMessage.endTime ~= nil then
    self.endTime = dayActsMessage.endTime
  end
  if dayActsMessage.scoreMax ~= nil then
    self.scoreMax = dayActsMessage.scoreMax
  end
  for i = 1, #dayActsMessage.dayActs do
    self.dayActs[i] = dayActsMessage.dayActs[i]
    for j = 1, #dayActsMessage.dayActs[i] do
      self.dayActs[i][j] = dayActsMessage.dayActs[i][j]
      local id = self.dayActs[i][j].id
      local dayAct_table = LocalController:instance():getLine(TableName.DayAct, id)
      if dayAct_table == nil then
        return
      end
      self.dayActs[i][j].type1_text = dayAct_table.type1_text
      self.dayActs[i][j].type2_text = dayAct_table.type2_text
    end
  end
  if dayActsMessage.scoreReward ~= nil then
    self.scoreReward = dayActsMessage.scoreReward
  end
  self:CheckRedDot()
  EventManager:GetInstance():Broadcast(EventId.SevenDayGetReward)
end

local function CheckRedDot(self)
  self.taskRedNum = 0
  if self.scoreReward ~= nil then
    for i = 1, #self.scoreReward do
      local reward = self.scoreReward[i]
      if reward ~= nil and reward.rewardFlag == 0 and self.score >= reward.needScore then
        self.taskRedNum = self.taskRedNum + 1
      else
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
            local taskId = tasks[k].taskId
            local taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
            if taskValue ~= nil then
              local state = taskValue.state
              if state == 2 then
              elseif state == 1 then
                self.taskRedNum = self.taskRedNum + 1
                self.taskRed[i][j] = 1
              end
            end
          end
        end
      end
    end
  end
end

local function CheckIsSevenDayTask(self, taskId)
  if self.dayActs ~= nil then
    for i = 1, #self.dayActs do
      local dayInfos = self.dayActs[i]
      if i <= self.days then
        for j = 1, #dayInfos do
          local tasks = dayInfos[j].tasks
          for k = 1, #tasks do
            if taskId == tasks[k].taskId then
              return true
            end
          end
        end
      end
    end
  end
end

local function SetScoreBoxState(self, index, state)
  if self.scoreReward ~= nil then
    self.scoreReward[index].rewardFlag = state
  end
end

local function GetScoreByIndex(self, index)
  local score = 0
  if self.scoreReward ~= nil then
    local data = self.scoreReward[index]
    if data ~= nil and data.needScore ~= nil then
      score = data.needScore
    end
  end
  return score
end

local function SortTask(self, tasks)
  local list = {}
  if tasks ~= nil then
    local canReceiveList = {}
    local unFinishList = {}
    local hasFinishList = {}
    for i = 1, #tasks do
      local taskId = tasks[i].taskId
      local taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
      if taskValue ~= nil then
        local state = taskValue.state
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

local function GetRewardItemListByDay(self, day)
  if self.dayActs == nil then
    return nil
  end
  local rewardList = {}
  local dayAct = self.dayActs[day]
  if dayAct ~= nil then
    local count = #dayAct
    for i = 1, count do
      local tasks = dayAct[i].tasks
      for j = 1, #tasks do
        local taskValue = DataCenter.TaskManager:FindTaskInfo(tasks[j].taskId)
        for k = 1, #taskValue.rewardList do
          if rewardList[tonumber(taskValue.rewardList[k].itemId)] == nil then
            local reward = {}
            reward.type = taskValue.rewardList[k].rewardType
            reward.count = taskValue.rewardList[k].count
            reward.itemId = tonumber(taskValue.rewardList[k].itemId)
            rewardList[reward.itemId] = reward
          else
            rewardList[tonumber(taskValue.rewardList[k].itemId)].count = taskValue.rewardList[k].count + rewardList[tonumber(taskValue.rewardList[k].itemId)].count
          end
        end
      end
    end
  end
  return rewardList
end

local function UpdateDayActScore(self, message)
  self.score = message.score
  self:CheckRedDot()
  EventManager:GetInstance():Broadcast(EventId.SevenDayGetReward)
end

ActivitySevenDayInfo.__init = __init
ActivitySevenDayInfo.__delete = __delete
ActivitySevenDayInfo.ParseActivityData = ParseActivityData
ActivitySevenDayInfo.CheckRedDot = CheckRedDot
ActivitySevenDayInfo.GetScoreByIndex = GetScoreByIndex
ActivitySevenDayInfo.SortTask = SortTask
ActivitySevenDayInfo.SetScoreBoxState = SetScoreBoxState
ActivitySevenDayInfo.GetRewardItemListByDay = GetRewardItemListByDay
ActivitySevenDayInfo.UpdateDayActScore = UpdateDayActScore
ActivitySevenDayInfo.CheckIsSevenDayTask = CheckIsSevenDayTask
return ActivitySevenDayInfo
