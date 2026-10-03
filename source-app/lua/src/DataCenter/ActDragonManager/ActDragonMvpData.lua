local ActDragonMvpData = BaseClass("ActDragonMvpData")
local ActDragonPlayerData = require("DataCenter.ActDragonManager.ActDragonPlayerData")

function ActDragonMvpData:__init()
  self.score = 0
  self.killScore = 0
  self.brokeScore = 0
  self.collectScore = 0
  self.occupyScore = 0
  self.heroId = 0
  self.playerData = {}
end

function ActDragonMvpData:__delete()
  self.score = 0
  self.killScore = 0
  self.brokeScore = 0
  self.collectScore = 0
  self.occupyScore = 0
  self.heroId = 0
  self.playerData = {}
end

function ActDragonMvpData:ParseData(message)
  if message == nil then
    return
  end
  if message.score ~= nil then
    self.score = message.score
  end
  if message.killScore ~= nil then
    self.killScore = message.killScore
  end
  if message.brokeScore ~= nil then
    self.brokeScore = message.brokeScore
  end
  if message.collectScore ~= nil then
    self.collectScore = message.collectScore
  end
  if message.occupyScore ~= nil then
    self.occupyScore = message.occupyScore
  end
  if message.heroId ~= nil then
    self.heroId = message.heroId
  end
  self.playerData = ActDragonPlayerData.New()
  self.playerData:ParseData(message)
end

return ActDragonMvpData
