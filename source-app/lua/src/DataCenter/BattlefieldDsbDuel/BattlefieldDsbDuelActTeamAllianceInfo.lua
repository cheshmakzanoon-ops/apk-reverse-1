local BattlefieldDsbDuelActTeamAllianceInfo = BaseClass("BattlefieldDsbDuelActTeamAllianceInfo")

function BattlefieldDsbDuelActTeamAllianceInfo:__init()
  self.allianceId = ""
  self.serverId = 0
  self.allianceName = ""
  self.abbr = ""
  self.icon = ""
  self.power = 0
  self.signCount = 0
  self.group = 0
  self.rank = 0
  self.role = 0
  self.winAddExtraScore = 0
end

function BattlefieldDsbDuelActTeamAllianceInfo:__delete()
  self.allianceId = nil
  self.serverId = nil
  self.allianceName = nil
  self.abbr = nil
  self.icon = nil
  self.power = nil
  self.signCount = nil
  self.group = nil
  self.rank = nil
  self.role = nil
  self.winAddExtraScore = nil
end

function BattlefieldDsbDuelActTeamAllianceInfo:UpdateData(message)
  if not message then
    return
  end
  self.allianceId = message.allianceId or ""
  self.serverId = message.serverId or 0
  self.allianceName = message.allianceName or ""
  self.abbr = message.abbr or ""
  self.icon = message.icon or ""
  self.power = message.power or 0
  self.signCount = message.signCount or 0
  self.group = message.group or 0
  self.rank = message.rank or 0
  self.role = message.role or 0
  self.winAddExtraScore = message.winAddExtraScore or 0
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetAllianceId()
  return self.allianceId
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetServerId()
  return self.serverId
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetAllianceName()
  return self.allianceName
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetAbbr()
  return self.abbr
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetIcon()
  return self.icon
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetPower()
  return self.power
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetSignCount()
  return self.signCount
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetGroup()
  return self.group
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetRank()
  return self.rank
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetRole()
  return self.role
end

function BattlefieldDsbDuelActTeamAllianceInfo:GetWinAddExtraScore()
  return self.winAddExtraScore
end

return BattlefieldDsbDuelActTeamAllianceInfo
