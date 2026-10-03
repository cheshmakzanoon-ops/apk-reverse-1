local KingdomBuildingFireMessage = BaseClass("KingdomBuildingFireMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingFireMessage:OnCreate(targetUid, buildingId, positionId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", tostring(targetUid))
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutUtfString("positionId", tostring(positionId))
  self.sfsObj:PutInt("serverId", serverId)
end

function KingdomBuildingFireMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildingOfficialManager:HandleBuildingFire(t)
  end
end

return KingdomBuildingFireMessage
