local KingdomBuildingGetPresentInfoMessage = BaseClass("KingdomBuildingGetPresentInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingGetPresentInfoMessage:OnCreate(group, buildingId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("groupId", group)
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutInt("serverId", serverId)
end

function KingdomBuildingGetPresentInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildingOfficialManager:HandleBuildingGetPresentInfo(t)
  end
end

return KingdomBuildingGetPresentInfoMessage
