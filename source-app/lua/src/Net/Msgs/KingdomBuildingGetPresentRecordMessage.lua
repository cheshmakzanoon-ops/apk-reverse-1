local KingdomBuildingGetPresentRecordMessage = BaseClass("KingdomBuildingGetPresentRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingGetPresentRecordMessage:OnCreate(groupId, buildingId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("groupId", groupId)
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutInt("serverId", serverId)
end

function KingdomBuildingGetPresentRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildingOfficialManager:HandleBuildingGetPresentRecord(t)
  end
end

return KingdomBuildingGetPresentRecordMessage
