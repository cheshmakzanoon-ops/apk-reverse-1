local PushCityLightStatusUpdateMessage = BaseClass("PushCityLightStatusUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCityLightStatusUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PushCityLightStatusUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.type ~= nil and t.lightStatusArr ~= nil then
    DataCenter.SeasonLightDataManager:UpdateLightBuff(t.type, t.lightStatusArr)
  end
end

return PushCityLightStatusUpdateMessage
