local PushRefundBlackStatusMessage = BaseClass("PushRefundBlackStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushRefundBlackStatusMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushRefundBlackStatusMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWRefundManager:InitData(t)
    EventManager:GetInstance():Broadcast(EventId.LWRefundBanUpdate)
  end
end

return PushRefundBlackStatusMessage
