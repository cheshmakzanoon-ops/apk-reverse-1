local DiggingInfoData = BaseClass("DiggingInfoData")

function DiggingInfoData:__init()
  self.uuid = 0
  self.mapConfigId = 0
  self.startTime = 0
  self.endTime = 0
  self.rewardState = 0
  self.redNum = 0
  self.type = 0
end

function DiggingInfoData:__delete()
  self.uuid = nil
  self.mapConfigId = nil
  self.startTime = nil
  self.endTime = nil
  self.redNum = nil
end

function DiggingInfoData:UpdateData(message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.mapConfigId ~= nil then
    self.mapConfigId = message.mapConfigId
    local config = DataCenter.DiggingDataTemplateManager:GetConfigData(self.mapConfigId)
    self.type = config and config.type or 0
    if self.type >= 3 then
      self.type = SeasonDigGameType.Single
    end
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.rewardState ~= nil then
    self.rewardState = message.rewardState
    self:UpdateRewardState(self.rewardState)
  end
  self.order = self:GetSortOrder()
  if self.type == SeasonDigGameType.Single then
    self.order = self.order + 1
  end
end

function DiggingInfoData:UpdateRewardState(rewardState)
  self.rewardState = rewardState
  if self.rewardState == 1 then
    self.redNum = 2
    return
  end
  if self.rewardState == 0 and self.type == SeasonDigGameType.Alliance then
    self.redNum = 1
    return
  end
  self.redNum = 0
end

function DiggingInfoData:GetSortOrder()
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.endTime then
    return 30
  end
  if now < self.startTime then
    return 40
  end
  if self.rewardState == 0 then
    return 10
  elseif self.rewardState == 1 then
    return 0
  end
  return 20
end

return DiggingInfoData
