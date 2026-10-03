local PushCityLightStatusRemoveMessage = BaseClass("PushCityLightStatusRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCityLightStatusRemoveMessage:OnCreate()
  base.OnCreate(self)
end

function PushCityLightStatusRemoveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.deleteArr ~= nil then
    DataCenter.SeasonLightDataManager:DeleteLightBuff(t.deleteArr)
  end
end

return PushCityLightStatusRemoveMessage
