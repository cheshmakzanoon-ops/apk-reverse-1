local ActDragonSelfDetailData = BaseClass("ActDragonSelfDetailData")

function ActDragonSelfDetailData:__init()
  self.occupyScore = 0
  self.avgOccupyScore = 0
  self.maxOccupyScore = 0
  self.killScore = 0
  self.avgKillScore = 0
  self.maxKillScore = 0
  self.collectScore = 0
  self.avgCollectScore = 0
  self.maxCollectScore = 0
  self.brokeScore = 0
  self.avgBrokeScore = 0
  self.maxBrokeScore = 0
  self.score = 0
  self.mvpId = 0
end

function ActDragonSelfDetailData:__delete()
  self.occupyScore = 0
  self.avgOccupyScore = 0
  self.maxOccupyScore = 0
  self.killScore = 0
  self.avgKillScore = 0
  self.maxKillScore = 0
  self.collectScore = 0
  self.avgCollectScore = 0
  self.maxCollectScore = 0
  self.brokeScore = 0
  self.avgBrokeScore = 0
  self.maxBrokeScore = 0
  self.score = 0
  self.mvpId = 0
end

function ActDragonSelfDetailData:ParseData(message)
  if message == nil then
    return
  end
  if message.occupyScore ~= nil then
    self.occupyScore = message.occupyScore
  end
  if message.avgOccupyScore ~= nil then
    self.avgOccupyScore = message.avgOccupyScore
  end
  if message.maxOccupyScore ~= nil then
    self.maxOccupyScore = message.maxOccupyScore
  end
  if message.killScore ~= nil then
    self.killScore = message.killScore
  end
  if message.avgKillScore ~= nil then
    self.avgKillScore = message.avgKillScore
  end
  if message.maxKillScore ~= nil then
    self.maxKillScore = message.maxKillScore
  end
  if message.collectScore ~= nil then
    self.collectScore = message.collectScore
  end
  if message.avgCollectScore ~= nil then
    self.avgCollectScore = message.avgCollectScore
  end
  if message.maxCollectScore ~= nil then
    self.maxCollectScore = message.maxCollectScore
  end
  if message.brokeScore ~= nil then
    self.brokeScore = message.brokeScore
  end
  if message.avgBrokeScore ~= nil then
    self.avgBrokeScore = message.avgBrokeScore
  end
  if message.maxBrokeScore ~= nil then
    self.maxBrokeScore = message.maxBrokeScore
  end
  if message.score ~= nil then
    self.score = message.score
  end
  if message.mvpId ~= nil then
    self.mvpId = message.mvpId
  end
end

return ActDragonSelfDetailData
