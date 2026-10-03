local FetchFormationSimulatedBattleResultMessage = BaseClass("FetchFormationSimulatedBattleResultMessage", SFSBaseMessage)
local base = SFSBaseMessage
local SimulatedBattle = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationSimulatedBattleV2")

function FetchFormationSimulatedBattleResultMessage:OnCreate(sequence, formationUuid, soldierType, targetType, targetUuid, targetServerId, formationParam, extraParam)
  base.OnCreate(self)
  self.sfsObj:PutInt("sequence", sequence)
  self.sfsObj:PutInt("target", targetType)
  self.sfsObj:PutLong("targetUid", targetUuid)
  self.sfsObj:PutInt("targetServer", targetServerId)
  self.sfsObj:PutInt("soldierType", soldierType)
  self.sfsObj:PutLong("formationUuid", formationUuid)
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  self.sfsObj:PutInt("worldType", LuaEntry.Player:GetCurWorldType())
  local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationUuid, LuaEntry.Player.allianceId)
  if march ~= nil then
    self.sfsObj:PutLong("uuid", march.uuid)
  end
  if extraParam ~= nil then
    self.sfsObj:PutSFSObject("extraParam", extraParam)
  end
  if formationParam ~= nil then
    self.sfsObj:PutSFSObject("formationParam", formationParam)
  end
  local clientCreateGuid = CS.SceneManager.World:SaveCreateMarchRecordTime()
  self.sfsObj:PutUtfString("clientCreateUuid", clientCreateGuid)
end

function FetchFormationSimulatedBattleResultMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.errorCode ~= "sim_battle_tips_1" then
    SimulatedBattle.OnResponseMessage(t)
  end
end

return FetchFormationSimulatedBattleResultMessage
