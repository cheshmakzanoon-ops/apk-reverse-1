local BattlefieldBuildingDsb = BaseClass("BattlefieldBuildingDsb")

function BattlefieldBuildingDsb:__init(context, msg)
  self.battleInfo = context
  self.uuid = msg.buildUUID
end

function BattlefieldBuildingDsb:__delete()
  self.uuid = nil
  self.marchUUID = nil
  self.allianceId = nil
  self.curHp = nil
  self.totalHp = nil
end

function BattlefieldBuildingDsb:Update(msg)
  self.marchUUID = msg.marchUUID
  self.allianceId = msg.allianceId
  self.curHp = msg.curHp
  self.totalHp = msg.totalHp
  if self.allianceId then
    self.team = self.battleInfo:GetRoleIdByAllianceId(self.allianceId)
    self.myBuilding = self.allianceId == LuaEntry.Player:GetAllianceUid()
  end
end

function BattlefieldBuildingDsb:Description()
  local sb = StringBuilder.New()
  sb:AppendLineFormat("uuid = %s, marchUUID = %s, hp = %s/%s, alliance = %s", self.uuid, self.marchUUID, self.curHp, self.totalHp, self.allianceId)
  sb:AppendFormat("Team : %s,", self.team and self.team:GetRoleID() or "nil")
  sb:AppendFormat("My building : %s, ", self.myBuilding)
  return sb:ToString()
end

Implement(BattlefieldBuildingDsb, InterfaceConfig.Describable)
return BattlefieldBuildingDsb
