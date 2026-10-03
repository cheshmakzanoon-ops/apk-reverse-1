local BattlefieldDsbDuelActAllianceBattleInfo = BaseClass("BattlefieldDsbDuelActAllianceBattleInfo")

local function __init(self)
  self.allianceId = ""
  self.serverId = 0
  self.allianceName = ""
  self.abbr = ""
  self.icon = ""
  self.battleScore = 0
  self.battleOriScore = 0
  self.battleMember = 0
  self.group = 1
  self.role = 1
  self.rank = 0
  self.team = 0
end

local function __delete(self)
  self.allianceId = nil
  self.serverId = nil
  self.allianceName = nil
  self.abbr = nil
  self.icon = nil
  self.battleScore = nil
  self.battleOriScore = nil
  self.battleMember = nil
  self.group = nil
  self.role = nil
  self.rank = nil
  self.team = nil
end

local function ParseData(self, message, teamId)
  if message == nil then
    return
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.serverId ~= nil then
    self.serverId = message.serverId
  end
  if message.name ~= nil then
    self.allianceName = message.name
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.icon ~= nil then
    self.icon = message.icon
  end
  if message.score ~= nil then
    self.battleScore = message.score
  end
  if message.oriScore ~= nil then
    self.battleOriScore = message.oriScore
  end
  if message.count ~= nil then
    self.battleMember = message.count
  end
  if message.group ~= nil then
    self.group = message.group
  end
  if message.role ~= nil then
    self.role = message.role
  end
  if message.rank then
    self.rank = message.rank
  else
    self.rank = nil
  end
  self.team = teamId
end

function BattlefieldDsbDuelActAllianceBattleInfo:GetRole()
  return self.role
end

function BattlefieldDsbDuelActAllianceBattleInfo:GetGroup()
  return self.group
end

function BattlefieldDsbDuelActAllianceBattleInfo:UpdateRank(rank)
  self.rank = rank
end

BattlefieldDsbDuelActAllianceBattleInfo.__init = __init
BattlefieldDsbDuelActAllianceBattleInfo.__delete = __delete
BattlefieldDsbDuelActAllianceBattleInfo.ParseData = ParseData
return BattlefieldDsbDuelActAllianceBattleInfo
