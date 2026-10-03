local ChampionDuelBetInfoData = BaseClass("ChampionDuelBetInfoData")
local ChampionDuelTeamInfoData = require("DataCenter.ChampionDuelManager.ChampionDuelTeamInfoData")

function ChampionDuelBetInfoData:__init()
  self.stageId = 0
  self.betMatchId = 0
  self.betMatchBattleTime = 0
  self.betMatchRivalA = nil
  self.betMatchRivalB = nil
  self.hasBet = false
  self.hasReward = false
  self.betCountId = 0
  self.odds = 0
  self.dayRemainingBets = 0
  self.isBattleEnd = false
  self.isStageBattleEnd = false
  self.groupId = 0
end

function ChampionDuelBetInfoData:__delete()
  self.stageId = 0
  self.betMatchId = 0
  self.betMatchBattleTime = 0
  self.betMatchRivalA = nil
  self.betMatchRivalB = nil
  self.hasBet = false
  self.hasReward = false
  self.betCountId = 0
  self.odds = 0
  self.dayRemainingBets = 0
  self.isBattleEnd = false
  self.isStageBattleEnd = false
  self.groupId = 0
end

function ChampionDuelBetInfoData:ParseData(message)
  if message == nil then
    return
  end
  if message.stageId ~= nil then
    self.stageId = message.stageId
  end
  if message.betMatchId ~= nil then
    self.betMatchId = message.betMatchId
  end
  if message.betMatchBattleTime ~= nil then
    self.betMatchBattleTime = message.betMatchBattleTime
  end
  local rivalA = message.betMatchRivalA
  if rivalA ~= nil then
    local teamInfo = ChampionDuelTeamInfoData.New()
    teamInfo:ParseData(rivalA)
    self.betMatchRivalA = teamInfo
  end
  local rivalB = message.betMatchRivalB
  if rivalB ~= nil then
    local teamInfo = ChampionDuelTeamInfoData.New()
    teamInfo:ParseData(rivalB)
    self.betMatchRivalB = teamInfo
  end
  if message.hasBet ~= nil then
    self.hasBet = message.hasBet
  end
  if message.hasReward ~= nil then
    self.hasReward = message.hasReward
  end
  if message.betCountId ~= nil then
    self.betCountId = message.betCountId
  end
  if message.odds ~= nil then
    self.odds = message.odds
  end
  if message.dayRemainingBets ~= nil then
    self.dayRemainingBets = message.dayRemainingBets
  end
  if message.isBattleEnd ~= nil then
    self.isBattleEnd = message.isBattleEnd
  end
  if message.isStageBattleEnd ~= nil then
    self.isStageBattleEnd = message.isStageBattleEnd
  end
  if message.groupId ~= nil then
    self.groupId = message.groupId
  end
end

return ChampionDuelBetInfoData
