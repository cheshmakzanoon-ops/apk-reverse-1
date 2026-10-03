local KingdomBuildingAppointMessage = BaseClass("KingdomBuildingAppointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingAppointMessage:OnCreate(targetUid, buildingId, positionId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", tostring(targetUid))
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutUtfString("positionId", tostring(positionId))
  self.sfsObj:PutInt("serverId", serverId)
end

function KingdomBuildingAppointMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildingOfficialManager:HandleBuildingAppoint(t)
  end
end

return KingdomBuildingAppointMessage
