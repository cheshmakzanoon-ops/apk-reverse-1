local PushZoneMobilizationDonateMessage = BaseClass("PushZoneMobilizationDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZoneMobilizationDonateMessage:OnCreate()
  base.OnCreate(self)
end

function PushZoneMobilizationDonateMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationDonateSuccess, message)
  end
end

return PushZoneMobilizationDonateMessage
