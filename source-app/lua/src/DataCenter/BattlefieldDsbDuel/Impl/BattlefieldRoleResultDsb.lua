local BattlefieldRoleResultDsb = BaseClass("BattlefieldRoleResultDsb")

function BattlefieldRoleResultDsb:__init()
  self.rank = nil
  self.allianceId = nil
  self.allianceIcon = nil
  self.allianceAbbr = nil
  self.teamId = nil
  self.battleResultScore = nil
  self.score = nil
  self.oriScore = nil
  self.occupiedScore = nil
  self.resourceScore = nil
  self.plunderScore = nil
  self.serverId = nil
  self.empty = nil
end

function BattlefieldRoleResultDsb:__delete()
end

function BattlefieldRoleResultDsb:Update(msg)
  self.empty = nil
  self.rank = msg.rank
  self.allianceId = msg.allianceInfo.allianceId
  self.allianceIcon = msg.allianceInfo.icon
  self.allianceAbbr = msg.allianceInfo.abbr
  self.teamId = msg.teamId
  self.battleResultScore = msg.battleResultScore or 0
  self.winAddExtraScore = msg.winAddExtraScore or 0
  self.score = msg.score or 0
  self.oriScore = msg.oriScore or 0
  self.occupiedScore = msg.occupiedScore or 0
  self.resourceScore = msg.resourceScore or 0
  self.plunderScore = msg.plunderScore or 0
  self.serverId = msg.serverId
  self.role = msg.role
  self.rankScore = Mathf.Max(self.battleResultScore - self.winAddExtraScore, 0)
end

function BattlefieldRoleResultDsb:SetEmpty()
  self.empty = true
  self.rank = nil
  self.allianceId = nil
  self.allianceIcon = nil
  self.allianceAbbr = nil
  self.teamId = nil
  self.battleResultScore = nil
  self.winAddExtraScore = nil
  self.score = nil
  self.oriScore = nil
  self.occupiedScore = nil
  self.resourceScore = nil
  self.plunderScore = nil
  self.serverId = nil
end

function BattlefieldRoleResultDsb:Description()
end

return BattlefieldRoleResultDsb
