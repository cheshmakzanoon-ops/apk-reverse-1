local KingdomBuildingPositionListMessage = BaseClass("KingdomBuildingPositionListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingPositionListMessage:OnCreate(buildingId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutInt("serverId", serverId)
end

function KingdomBuildingPositionListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildingOfficialManager:HandleOfficialList(t)
  end
end

return KingdomBuildingPositionListMessage
