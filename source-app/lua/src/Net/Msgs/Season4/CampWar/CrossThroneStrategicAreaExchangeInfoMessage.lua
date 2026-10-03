local CrossThroneStrategicAreaExchangeInfoMessage = BaseClass("CrossThroneStrategicAreaExchangeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossThroneStrategicAreaExchangeInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function CrossThroneStrategicAreaExchangeInfoMessage:HandleMessage(t)
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

return CrossThroneStrategicAreaExchangeInfoMessage
