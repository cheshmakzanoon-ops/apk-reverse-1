local CrazyRockTaskData = BaseClass("CrazyRockTaskData")

function CrazyRockTaskData:__init()
  self.taskId = 0
  self.num = 0
  self.startTime = 0
  self.time = 0
  self.state = 0
  self.rewardList = {}
end

function CrazyRockTaskData:__delete()
  self.taskId = nil
  self.num = nil
  self.startTime = nil
  self.time = nil
  self.state = nil
  self.rewardList = nil
end

function CrazyRockTaskData:ParseTaskData(message)
  if message == nil then
    return
  end
  if message.taskId ~= nil then
    self.taskId = message.taskId
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
    self.rewardList = message.reward
  end
  self.config = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(self.taskId)
end

function CrazyRockTaskData:IsDaily()
  if self.config then
    return self.config.daily_refresh == 1
  end
  return false
end

return CrazyRockTaskData
