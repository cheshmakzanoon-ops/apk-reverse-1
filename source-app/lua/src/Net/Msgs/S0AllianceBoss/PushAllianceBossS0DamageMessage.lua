local PushAllianceBossS0DamageMessage = BaseClass("PushAllianceBossS0DamageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceBossS0DamageMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceBossS0DamageMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:UpdatePersonalDmg(message)
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossMarchInfoChanged, message.bossUuid)
end

return PushAllianceBossS0DamageMessage
