local ChampionDuelInfoData = BaseClass("ChampionDuelInfoData")

function ChampionDuelInfoData:__init()
  self.stageId = 0
  self.beginTime = 0
  self.endTime = 0
  self.tableId = 0
  self.season = 0
  self.auditionUpperNums = 0
  self.semiFinalUpperNums = 0
  self.serverList = nil
  self.stageBeginTime = 0
  self.stageEndTime = 0
  self.sign = false
  self.group = 0
  self.groupCount = 0
  self.rank = 0
  self.battleWord = ""
  self.group3 = 0
  self.group5 = 0
  self.dayRemainingBets = 0
  self.redDot = false
end

function ChampionDuelInfoData:__delete()
  self.stageId = 0
  self.beginTime = 0
  self.endTime = 0
  self.tableId = 0
  self.season = 0
  self.auditionUpperNums = 0
  self.semiFinalUpperNums = 0
  self.serverList = nil
  self.stageBeginTime = 0
  self.stageEndTime = 0
  self.sign = false
  self.group = 0
  self.groupCount = 0
  self.rank = 0
  self.winCount = 0
  self.loseCount = 0
  self.keepWinCount = 0
  self.fightCount = 0
  self.battleWord = ""
  self.group3 = 0
  self.group5 = 0
  self.dayRemainingBets = 0
  self.redDot = false
end

function ChampionDuelInfoData:ParseData(message)
  if message == nil then
    return
  end
  if message.stageId ~= nil then
    self.stageId = message.stageId
  end
  if message.beginTime ~= nil then
    self.beginTime = message.beginTime
  end
  if message.tableId ~= nil then
    self.tableId = message.tableId
  end
  if message.season ~= nil then
    self.season = message.season
  end
  if message.auditionUpperNums ~= nil then
    self.auditionUpperNums = message.auditionUpperNums
  end
  if message.semiFinalUpperNums ~= nil then
    self.semiFinalUpperNums = message.semiFinalUpperNums
  end
  if message.serverList ~= nil then
    self.serverList = message.serverList
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.stageBeginTime ~= nil then
    self.stageBeginTime = message.stageBeginTime
  end
  if message.stageEndTime ~= nil then
    self.stageEndTime = message.stageEndTime
  end
  if message.sign ~= nil then
    self.sign = message.sign
  end
  if message.group ~= nil then
    self.group = message.group
  end
  if message.groupCount ~= nil then
    self.groupCount = message.groupCount
  end
  if message.rank ~= nil then
    self.rank = message.rank
  end
  if message.battleWord ~= nil then
    self.battleWord = message.battleWord
  end
  if message.group3 ~= nil then
    self.group3 = message.group3
  end
  if message.group5 ~= nil then
    self.group5 = message.group5
  end
  if message.dayRemainingBets ~= nil then
    self.dayRemainingBets = message.dayRemainingBets
  end
  if message.redDot ~= nil then
    self.redDot = message.redDot
  end
end

return ChampionDuelInfoData
