local PushZoneMobilizationBossSkillMessage = BaseClass("PushZoneMobilizationBossSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZoneMobilizationBossSkillMessage:OnCreate()
  base.OnCreate(self)
end

function PushZoneMobilizationBossSkillMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationBossAttack, message)
    DataCenter.LWZoneMobilizationManager:OnBossAttacked(message)
  end
end

return PushZoneMobilizationBossSkillMessage
