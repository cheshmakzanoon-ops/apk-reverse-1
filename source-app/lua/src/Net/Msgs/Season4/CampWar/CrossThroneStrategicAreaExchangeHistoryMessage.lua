local CrossThroneStrategicAreaExchangeHistoryMessage = BaseClass("CrossThroneStrategicAreaExchangeHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossThroneStrategicAreaExchangeHistoryMessage:OnCreate()
  base.OnCreate(self)
end

function CrossThroneStrategicAreaExchangeHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.history then
    DataCenter.CampWarManager:CrossThroneStrategicAreaExchangeHistory(t.history)
  end
end

return CrossThroneStrategicAreaExchangeHistoryMessage
