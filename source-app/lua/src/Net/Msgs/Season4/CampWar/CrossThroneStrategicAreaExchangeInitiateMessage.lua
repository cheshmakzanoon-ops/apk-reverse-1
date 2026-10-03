local CrossThroneStrategicAreaExchangeInitiateMessage = BaseClass("CrossThroneStrategicAreaExchangeInitiateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossThroneStrategicAreaExchangeInitiateMessage:OnCreate(targetServerId, targetCityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetServerId", targetServerId)
  self.sfsObj:PutInt("targetCityId", targetCityId)
end

function CrossThroneStrategicAreaExchangeInitiateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.request then
    DataCenter.CampWarManager:CrossThroneStrategicAreaExchangeInitiate(t.request)
  end
end

return CrossThroneStrategicAreaExchangeInitiateMessage
