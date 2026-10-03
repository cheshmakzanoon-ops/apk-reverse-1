local PushZoneMobilizationBossHpLostMessage = BaseClass("PushZoneMobilizationBossHpLostMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZoneMobilizationBossHpLostMessage:OnCreate()
  base.OnCreate(self)
end

function PushZoneMobilizationBossHpLostMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationBossHpLost, message)
  end
end

return PushZoneMobilizationBossHpLostMessage
