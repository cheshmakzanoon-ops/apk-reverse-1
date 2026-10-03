local PushZoneMobilizationBossRemoveMessage = BaseClass("PushZoneMobilizationBossRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZoneMobilizationBossRemoveMessage:OnCreate()
  base.OnCreate(self)
end

function PushZoneMobilizationBossRemoveMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.OnZoneMobilizationBossDeadOrRun, message)
  end
end

return PushZoneMobilizationBossRemoveMessage
