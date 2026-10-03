local PushMonsterCommonSkillInfoMessage = BaseClass("PushMonsterCommonSkillInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushMonsterCommonSkillInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushMonsterCommonSkillInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.OnMonsterCommonCastSkill, message)
  end
end

return PushMonsterCommonSkillInfoMessage
