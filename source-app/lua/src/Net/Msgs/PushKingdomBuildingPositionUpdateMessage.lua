local PushKingdomBuildingPositionUpdateMessage = BaseClass("PushKingdomBuildingPositionUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushKingdomBuildingPositionUpdateMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushKingdomBuildingPositionUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildingOfficialManager:HandlePushBuildingPositionUpdate(t)
  end
end

return PushKingdomBuildingPositionUpdateMessage
