local ActChampionBattleBetRecordsInfo = BaseClass("ActChampionBattleBetRecordsInfo")

local function __init(self)
  self.type = 0
  self.playerInfo = nil
  self.time = 0
  self.oneBetCount = 0
  self.odds = 0
  self.state = 0
  self.totalWinCount = 0
  self.phase = 0
  self.location = 0
end

local function parseServerData(type, player, record, state)
  self.state = state
  self.type = type
  self.playerInfo = player
  if type == 1 or type == 3 then
    self.time = record.time
    self.oneBetCount = record.oneBetCount
    self.odds = record.odds
  elseif type == 2 then
    self.totalWinCount = record
  end
end

ActChampionBattleBetRecordsInfo.__init = __init
ActChampionBattleBetRecordsInfo.parseServerData = parseServerData
return ActChampionBattleBetRecordsInfo
