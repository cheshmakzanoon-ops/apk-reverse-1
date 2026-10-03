local SeasonPreviewTaskData = BaseClass("SeasonPreviewTaskData")

function SeasonPreviewTaskData:__init()
  self.taskId = 0
  self.activityId = nil
  self.num = nil
  self.state = nil
  self.reward = nil
  self.dayTime = nil
  self.staticData = nil
  self.howToPlayIds = nil
end

function SeasonPreviewTaskData:__delete()
  self.taskId = 0
  self.activityId = nil
  self.num = nil
  self.state = nil
  self.reward = nil
  self.dayTime = nil
  self.staticData = nil
  self.howToPlayIds = nil
end

function SeasonPreviewTaskData:ParseMsg(message)
  if message.taskId then
    self.taskId = message.taskId
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  if message.num then
    self.num = message.num
  end
  if message.state then
    self.state = message.state
  end
  if message.reward then
    self.reward = message.reward
  end
  if message.dayTime then
    self.dayTime = message.dayTime
  end
end

function SeasonPreviewTaskData:GetStaticData()
  if self.staticData == nil then
    self.staticData = LocalController:instance():getLine(TableName.LW_SEASON_PRE, self.taskId)
  end
  return self.staticData
end

function SeasonPreviewTaskData:HasHowToPlay()
  return self.staticData ~= nil and not string.IsNullOrEmpty(self.staticData.how_to_play)
end

return SeasonPreviewTaskData
