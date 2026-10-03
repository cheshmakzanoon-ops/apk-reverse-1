local KingdomBuildingPositionDeclarationUpdateMessage = BaseClass("KingdomBuildingPositionDeclarationUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingPositionDeclarationUpdateMessage:OnCreate(serverId, buildingId, declaration)
  base.OnCreate(self)
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutUtfString("declaration", tostring(declaration))
end

function KingdomBuildingPositionDeclarationUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildingOfficialManager:HandleDeclarationUpdate(t)
  end
end

return KingdomBuildingPositionDeclarationUpdateMessage
