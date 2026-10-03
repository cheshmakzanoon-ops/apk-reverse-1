local BattleHistory = BaseClass("BattleHistory")

function BattleHistory:__init()
  self.abbr = ""
  self.name = ""
  self.icon = ""
  self.allianceId = ""
  self.server = 0
  self.side = 0
  self.state = 0
  self.score = 0
  self.userNum = 0
  self.enemyAbbr = ""
  self.enemyName = ""
  self.enemyIcon = ""
  self.enemyAllianceId = ""
  self.enemyScore = 0
  self.enemyServer = 0
  self.enemyUserNum = 0
  self.maxUserNum = 0
  self.battleTime = 0
  self.groupM = 0
  self.groupE = 0
end

function BattleHistory:__delete()
  self.abbr = ""
  self.name = ""
  self.icon = ""
  self.allianceId = ""
  self.side = 0
  self.server = 0
  self.state = 0
  self.score = 0
  self.userNum = 0
  self.enemyAbbr = ""
  self.enemyName = ""
  self.enemyIcon = ""
  self.enemyAllianceId = ""
  self.enemyScore = 0
  self.enemyUserNum = 0
  self.enemyServer = 0
  self.maxUserNum = 0
  self.battleTime = 0
  self.groupM = 0
  self.groupE = 0
end

function BattleHistory:ParseData(message)
  if message == nil then
    return
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.icon ~= nil then
    self.icon = message.icon
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.side ~= nil then
    self.side = message.side
  end
  if message.server ~= nil then
    self.server = message.server
  end
  if message.enemyServer ~= nil then
    self.enemyServer = message.enemyServer
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.score ~= nil then
    self.score = message.score
  end
  if message.userNum ~= nil then
    self.userNum = message.userNum
  end
  if message.enemyAbbr ~= nil then
    self.enemyAbbr = message.enemyAbbr
  end
  if message.enemyName ~= nil then
    self.enemyName = message.enemyName
  end
  if message.enemyIcon ~= nil then
    self.enemyIcon = message.enemyIcon
  end
  if message.enemyAllianceId ~= nil then
    self.enemyAllianceId = message.enemyAllianceId
  end
  if message.enemyScore ~= nil then
    self.enemyScore = message.enemyScore
  end
  if message.enemyUserNum ~= nil then
    self.enemyUserNum = message.enemyUserNum
  end
  if message.maxUserNum ~= nil then
    self.maxUserNum = message.maxUserNum
  end
  if message.battleTime ~= nil then
    self.battleTime = message.battleTime
  end
  if message.groupM ~= nil then
    self.groupM = message.groupM
  end
  if message.groupE ~= nil then
    self.groupE = message.groupE
  end
end

function BattleHistory:GetMineName()
  return "[" .. self.abbr .. "] " .. self.name
end

function BattleHistory:GetEnemyName()
  return "[" .. self.enemyAbbr .. "] " .. self.enemyName
end

return BattleHistory
