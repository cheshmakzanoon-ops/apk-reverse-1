local CrossThroneStrategicAreaExchangeCancelMessage = BaseClass("CrossThroneStrategicAreaExchangeCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossThroneStrategicAreaExchangeCancelMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function CrossThroneStrategicAreaExchangeCancelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.request then
    DataCenter.CampWarManager:CrossThroneStrategicAreaExchangeCancel(t.request)
  end
end

return CrossThroneStrategicAreaExchangeCancelMessage
