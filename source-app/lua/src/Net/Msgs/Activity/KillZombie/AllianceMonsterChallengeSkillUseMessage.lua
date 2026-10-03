local AllianceMonsterChallengeSkillUseMessage = BaseClass("AllianceMonsterChallengeSkillUseMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceMonsterChallengeSkillUseMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceMonsterChallengeSkillUseMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= nil then
      UIUtil.ShowTipsId(errorCode)
    end
  end
end

return AllianceMonsterChallengeSkillUseMessage
