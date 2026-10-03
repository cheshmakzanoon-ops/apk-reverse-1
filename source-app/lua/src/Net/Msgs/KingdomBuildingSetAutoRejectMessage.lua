local KingdomBuildingSetAutoRejectMessage = BaseClass("KingdomBuildingSetAutoRejectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingSetAutoRejectMessage:OnCreate(serverId, buildingId, autoReject)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutBool("autoReject", autoReject)
end

function KingdomBuildingSetAutoRejectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.success then
    DataCenter.BuildingOfficialManager:HandleSetAutoReject(t)
  end
end

return KingdomBuildingSetAutoRejectMessage
