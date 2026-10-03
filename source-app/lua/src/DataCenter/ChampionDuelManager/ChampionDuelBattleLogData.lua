local ChampionDuelBattleLogData = BaseClass("ChampionDuelBattleLogData")
local ChampionDuelTeamInfoData = require("DataCenter.ChampionDuelManager.ChampionDuelTeamInfoData")

function ChampionDuelBattleLogData:__init()
  self.uuid = 0
  self.isWin = false
  self.my = nil
  self.target = nil
  self.time = 0
  self.stageId = 0
  self.attacker = ""
end

function ChampionDuelBattleLogData:__delete()
  self.uuid = 0
  self.isWin = false
  self.my = nil
  self.target = nil
  self.battle1 = 0
  self.battle2 = 0
  self.battle3 = 0
  self.time = 0
  self.stageId = 0
  self.attacker = ""
end

function ChampionDuelBattleLogData:ParseData(message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.isWin ~= nil then
    self.isWin = message.isWin
  end
  local my = message.self
  if my ~= nil then
    local info = ChampionDuelTeamInfoData.New()
    info:ParseData(my)
    self.my = info
  end
  local target = message.target
  if target ~= nil then
    local info = ChampionDuelTeamInfoData.New()
    info:ParseData(target)
    self.target = info
  end
  if message.battle1 ~= nil then
    self.battle1 = message.battle1
  end
  if message.battle2 ~= nil then
    self.battle2 = message.battle2
  end
  if message.battle3 ~= nil then
    self.battle3 = message.battle3
  end
  if message.time ~= nil then
    self.time = message.time
  end
  if message.stageId ~= nil then
    self.stageId = message.stageId
  end
  if message.attacker ~= nil then
    self.attacker = message.attacker
  end
end

return ChampionDuelBattleLogData
