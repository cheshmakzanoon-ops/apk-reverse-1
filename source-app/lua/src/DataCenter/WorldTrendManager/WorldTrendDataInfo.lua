local WorldTrendDataInfo = BaseClass("WorldTrendDataInfo")

function WorldTrendDataInfo:__init()
  self.id = ""
  self.finishTime = 0
  self.taskNeedNum = 0
  self.startTime = 0
  self.endTime = 0
  self.taskNum = 0
  self.rewardStatus = 0
  self.status = 0
  self.rewardList = {}
  self.functionIds = 0
  self.type = 0
  self.levelLimit = 0
end

function WorldTrendDataInfo:__delete()
  self.id = nil
  self.finishTime = nil
  self.taskNeedNum = nil
  self.startTime = nil
  self.endTime = nil
  self.taskNum = nil
  self.rewardStatus = nil
  self.status = nil
  self.rewardList = nil
  self.functionIds = nil
  self.type = nil
  self.levelLimit = nil
end

function WorldTrendDataInfo:UpdateDataInfo(message)
  if message == nil then
    return
  end
  if message.id ~= nil then
    self.id = message.id
  end
  if message.finishTime ~= nil then
    self.finishTime = message.finishTime
  end
  if message.taskNeedNum ~= nil then
    self.taskNeedNum = message.taskNeedNum
  end
  if message.startTime then
    self.startTime = message.startTime
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.taskNum ~= nil then
    self.taskNum = message.taskNum
  end
  if message.rewardStatus ~= nil then
    self.rewardStatus = message.rewardStatus
  end
  if message.status ~= nil then
    self.status = message.status
  end
  if message.functionIds ~= nil and next(message.functionIds) then
    self.functionIds = tonumber(message.functionIds[1])
  end
  if message.type then
    self.type = message.type
  end
  if message.levelLimit then
    self.levelLimit = tonumber(message.levelLimit)
  end
  local sortTab = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  for i = 1, #sortTab do
    if sortTab[i].rewardType == RewardType.GOODS then
      table.insert(self.rewardList, sortTab[i])
    else
      table.insert(self.rewardList, 1, sortTab[i])
    end
  end
end

function WorldTrendDataInfo:UpdateRewardStatus()
  self.rewardStatus = DataCenter.WorldTrendManager.ServerTrendsRewardStatus.Received
end

return WorldTrendDataInfo
