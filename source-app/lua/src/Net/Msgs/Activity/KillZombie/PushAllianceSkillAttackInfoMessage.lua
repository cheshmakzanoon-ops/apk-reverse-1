local PushAllianceSkillAttackInfoMessage = BaseClass("PushAllianceSkillAttackInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceSkillAttackInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceSkillAttackInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.OnNewAllianceSkillAttacked, message)
  end
end

return PushAllianceSkillAttackInfoMessage
