local ActEasterEggTaskInfo = BaseClass("ActEasterEggTaskInfo")

local function __init(self)
  self.id = 0
  self.num = 0
  self.startTime = 0
  self.time = 0
  self.state = 0
  self.reward = {}
end

local function __delete(self)
  self.id = nil
  self.num = nil
  self.startTime = nil
  self.time = nil
  self.state = nil
  self.reward = nil
  self.config = nil
end

local function UpdateInfo(self, message)
  if message == nil then
    return
  end
  if message.taskId ~= nil then
    self.id = tonumber(message.taskId)
  elseif message.id ~= nil then
    self.id = tonumber(message.id)
  else
    Logger.LogError("task Id is vaild!!")
  end
  if message.num ~= nil then
    self.num = message.num
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.time ~= nil then
    self.time = message.time
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.reward ~= nil then
    self.reward = message.reward
  end
  self.config = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(self.id)
end

local function SpawnMilestonesReward(self, mainConfig)
  local list = {}
  local rewardServerData = {}
  local str = string.split(mainConfig.game_task_score, ";")
  local type = tonumber(str[2])
  local id = tonumber(str[1])
  rewardServerData.type = type
  local itemData = {}
  itemData.id = id
  itemData.num = self.config.score
  rewardServerData.value = itemData
  table.insert(list, rewardServerData)
  self.reward = list
end

function ActEasterEggTaskInfo:IsDaily()
  if self.config then
    return self.config.daily_refresh == 1
  end
  return false
end

ActEasterEggTaskInfo.__init = __init
ActEasterEggTaskInfo.__delete = __delete
ActEasterEggTaskInfo.UpdateInfo = UpdateInfo
ActEasterEggTaskInfo.SpawnMilestonesReward = SpawnMilestonesReward
return ActEasterEggTaskInfo
