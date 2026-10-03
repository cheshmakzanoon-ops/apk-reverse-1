local PushZoneMobilizationInfoMessage = BaseClass("PushZoneMobilizationInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZoneMobilizationInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushZoneMobilizationInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  EventManager:GetInstance():Broadcast(EventId.ReceivePushRequestZoneMobilizationData, message)
end

return PushZoneMobilizationInfoMessage
