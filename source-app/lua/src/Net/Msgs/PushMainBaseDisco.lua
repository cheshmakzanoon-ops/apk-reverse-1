local PushMainBaseDisco = BaseClass("PushMainBaseDisco", SFSBaseMessage)
local base = SFSBaseMessage

function PushMainBaseDisco:OnCreate(param)
  base.OnCreate(self)
end

function PushMainBaseDisco:HandleMessage(t)
  base.HandleMessage(self, t)
  local buildingUuid = t.buildingUuid
  local pointId = t.pointId
  local statusTable = t.status
  local et = statusTable.et
  BaseBuildingDiscoManager:GetInstance():AddDiscoBuildEffect(buildingUuid, pointId, et)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  else
  end
end

return PushMainBaseDisco
