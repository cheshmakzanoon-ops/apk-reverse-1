local S0AllianceBossInfo = BaseClass("S0AllianceBossInfo")

local function __init(self)
  self.bossPointId = 0
  self.bossServerId = 0
  self.bossUuid = 0
  self.buildUuid = 0
  self.difficultyLevel = 0
  self.startTime = 0
  self.battleStartTime = 0
  self.battleEndTime = 0
  self.donateLevel = 0
  self.donateExp = 0
  self.currBonus = 0
  self.totalDamage = 0
  self.mvpDamage = 0
  self.playerDamage = 0
end

local function __delete(self)
  self.bossPointId = nil
  self.bossServerId = nil
  self.bossUuid = nil
  self.buildUuid = nil
  self.difficultyLevel = nil
  self.startTime = nil
  self.battleStartTime = nil
  self.battleEndTime = nil
  self.donateLevel = nil
  self.donateExp = nil
  self.currBonus = nil
  self.totalDamage = nil
  self.mvpDamage = nil
  self.playerDamage = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.bossPointId ~= nil then
    self.bossPointId = message.bossPointId or 0
  end
  if message.bossServerId ~= nil then
    self.bossServerId = message.bossServerId or 0
  end
  if message.bossUuid ~= nil then
    self.bossUuid = message.bossUuid or 0
  end
  if message.buildUuid ~= nil then
    self.buildUuid = message.buildUuid or 0
  end
  if message.difficultyLevel ~= nil then
    self.difficultyLevel = message.difficultyLevel or 0
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime or 0
  end
  if message.battleStartTime ~= nil then
    self.battleStartTime = message.battleStartTime or 0
  end
  if message.battleEndTime ~= nil then
    self.battleEndTime = message.battleEndTime or 0
  end
  if message.donateLevel ~= nil then
    self.donateLevel = message.donateLevel or 0
  end
  if message.donateExp ~= nil then
    self.donateExp = message.donateExp or 0
  end
  if message.currBonus ~= nil then
    self.currBonus = message.currBonus or 0
  end
  if message.totalDamage ~= nil then
    self.totalDamage = message.totalDamage or 0
  end
  if message.mvpDamage ~= nil then
    self.mvpDamage = message.mvpDamage or 0
  end
  if message.playerDamage ~= nil then
    self.playerDamage = message.playerDamage or 0
  end
end

S0AllianceBossInfo.__init = __init
S0AllianceBossInfo.__delete = __delete
S0AllianceBossInfo.ParseData = ParseData
return S0AllianceBossInfo
