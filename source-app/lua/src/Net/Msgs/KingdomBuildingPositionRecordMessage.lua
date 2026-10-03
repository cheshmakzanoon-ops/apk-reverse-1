local KingdomBuildingPositionRecordMessage = BaseClass("KingdomBuildingPositionRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingPositionRecordMessage:OnCreate(serverId, buildingId, positionId)
  base.OnCreate(self)
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutUtfString("positionId", tostring(positionId))
  self.sfsObj:PutInt("serverId", serverId)
end

function KingdomBuildingPositionRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildingOfficialManager:HandleBuildingPositionRecord(t)
  end
end

return KingdomBuildingPositionRecordMessage
