local T11IdleGameEventData = BaseClass("T11IdleGameEventData")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameEventData:__init()
  self.uuid = 0
  self.eventId = 0
  self.figure = 0
  self.status = 0
  self.questId = 0
  self.rewardId = 0
  self.num = 0
  self.getTime = 0
end

function T11IdleGameEventData:__delete()
  self.uuid = nil
  self.eventId = nil
  self.figure = nil
  self.status = nil
  self.questId = nil
  self.rewardId = nil
  self.num = nil
  self.getTime = nil
  self.rowCfgData = nil
end

function T11IdleGameEventData:UpdateData(data)
  if data == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameEventData:UpdateData call with nil data")
    return
  end
  if data.uuid then
    self.uuid = data.uuid
  end
  if data.eventId then
    self.eventId = data.eventId
  end
  if data.figure then
    self.figure = data.figure
  end
  if data.status then
    self.status = data.status
  end
  if data.questId then
    self.questId = data.questId
  end
  if data.rewardId then
    self.rewardId = data.rewardId
  end
  if data.num then
    self.num = data.num
  end
  if data.getTime then
    self.getTime = data.getTime
  end
end

function T11IdleGameEventData:GetEventTimestamp()
  return self.getTime
end

return T11IdleGameEventData
