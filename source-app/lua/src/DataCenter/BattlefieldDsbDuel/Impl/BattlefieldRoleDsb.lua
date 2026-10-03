local BattlefieldRoleDsb = BaseClass("BattlefieldRoleDsb")

function BattlefieldRoleDsb:__init(context, msg)
  self.context = context
  self:SetRoleID(msg.role or -1)
  self.allianceId = msg.allianceId
  self.allianceAbbr = msg.abbr
  self.allianceName = msg.name
  self.allianceIcon = msg.icon
  self.serverId = msg.serverId
end

function BattlefieldRoleDsb:__delete()
  self.context = nil
  self.roleId = nil
  self.count = nil
  self.score = nil
  self.speed = nil
end

function BattlefieldRoleDsb:SetRoleID(id)
  self.roleId = id
end

function BattlefieldRoleDsb:GetRoleID()
  return self.roleId
end

function BattlefieldRoleDsb:UpdateTeam(msg)
  self.count = msg.count or 0
  self.score = msg.score or 0
  self.speed = msg.speed or 0
  self:OnUpdate(msg)
end

function BattlefieldRoleDsb:Description()
  local sb = StringBuilder.New()
  sb:AppendLineFormat("roleId = %s, count = %s, score = %s, spd = %s", self.roleId, self.count, self.score, self.speed)
  sb:AppendFormatLine("alliance:%s[%s]", self.allianceName, self.allianceAbbr)
  return sb:ToString()
end

function BattlefieldRoleDsb:OnUpdate(msg)
end

Implement(BattlefieldRoleDsb, InterfaceConfig.Describable)
return BattlefieldRoleDsb
