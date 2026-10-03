local BattlefieldDsbDuelActAllianceRankInfo = BaseClass("BattlefieldDsbDuelActAllianceRankInfo")

function BattlefieldDsbDuelActAllianceRankInfo:__init()
  self.allianceId = ""
  self.serverId = 0
  self.name = ""
  self.abbr = ""
  self.icon = 0
  self.power = 0
  self.score = 0
  self.totalScore = 0
  self.rank = 0
  self.group = 0
  self.winScore = 0
end

function BattlefieldDsbDuelActAllianceRankInfo:__delete()
  self.allianceId = nil
  self.serverId = nil
  self.name = nil
  self.abbr = nil
  self.icon = nil
  self.power = nil
  self.score = nil
  self.totalScore = nil
  self.rank = nil
  self.group = nil
  self.winScore = nil
end

function BattlefieldDsbDuelActAllianceRankInfo:UpdateData(message)
  if not message then
    return
  end
  self.allianceId = message.allianceId or ""
  self.serverId = message.serverId or 0
  self.name = message.name or ""
  self.abbr = message.abbr or ""
  self.icon = message.icon or 0
  self.power = message.power or 0
  self.score = message.score or 0
  self.totalScore = message.totalScore or 0
  self.rank = message.rank or 0
  self.group = message.group or 0
  self.winScore = message.winScore or 0
end

function BattlefieldDsbDuelActAllianceRankInfo:GetAllianceId()
  return self.allianceId
end

function BattlefieldDsbDuelActAllianceRankInfo:GetServerId()
  return self.serverId
end

function BattlefieldDsbDuelActAllianceRankInfo:GetName()
  return self.name
end

function BattlefieldDsbDuelActAllianceRankInfo:GetAbbr()
  return self.abbr
end

function BattlefieldDsbDuelActAllianceRankInfo:GetIcon()
  return self.icon
end

function BattlefieldDsbDuelActAllianceRankInfo:GetPower()
  return self.power
end

function BattlefieldDsbDuelActAllianceRankInfo:GetScore()
  return self.score
end

function BattlefieldDsbDuelActAllianceRankInfo:GetTotalScore()
  return self.totalScore
end

function BattlefieldDsbDuelActAllianceRankInfo:GetRank()
  return self.rank
end

function BattlefieldDsbDuelActAllianceRankInfo:GetGroup()
  return self.group
end

function BattlefieldDsbDuelActAllianceRankInfo:GetWinScore()
  return self.winScore
end

return BattlefieldDsbDuelActAllianceRankInfo
