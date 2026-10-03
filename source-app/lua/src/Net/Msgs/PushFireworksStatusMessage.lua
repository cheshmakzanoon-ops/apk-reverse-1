local PushFireworksStatusMessage = BaseClass("PushFireworksStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushFireworksStatusMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushFireworksStatusMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local buildingUuid = t.buildingUuid
    local pointId = t.pointId
    local statusTable = t.status
    local et = statusTable.et
    BaseBuildingDiscoManager:GetInstance():AddFireworkEffect(buildingUuid, pointId, et)
  end
end

return PushFireworksStatusMessage
