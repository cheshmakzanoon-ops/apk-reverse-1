local CrossThroneStrategicAreaExchangeRespondMessage = BaseClass("CrossThroneStrategicAreaExchangeRespondMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossThroneStrategicAreaExchangeRespondMessage:OnCreate(uuid, agree)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("action", agree and 1 or 0)
end

function CrossThroneStrategicAreaExchangeRespondMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
end

return CrossThroneStrategicAreaExchangeRespondMessage
