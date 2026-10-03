local PushLightHouseSimpleInfoMessage = BaseClass("PushLightHouseSimpleInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushLightHouseSimpleInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushLightHouseSimpleInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  if t.updateType ~= nil and t.uid ~= nil and t.pointId ~= nil then
    CityDomeProtectEffectManager:GetInstance():UpdateBatteryPowerEffect(t.pointId, t, false)
  end
end

return PushLightHouseSimpleInfoMessage
