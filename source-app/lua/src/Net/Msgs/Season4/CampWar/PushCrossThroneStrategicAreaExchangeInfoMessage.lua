local PushCrossThroneStrategicAreaExchangeInfoMessage = BaseClass("PushCrossThroneStrategicAreaExchangeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCrossThroneStrategicAreaExchangeInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushCrossThroneStrategicAreaExchangeInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.requests then
    DataCenter.CampWarManager:CrossThroneStrategicAreaExchangeInfo(t.requests)
  end
end

return PushCrossThroneStrategicAreaExchangeInfoMessage
