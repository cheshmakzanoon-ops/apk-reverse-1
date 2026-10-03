local PushMonsterCommonSkillClaimInfoMessage = BaseClass("PushMonsterCommonSkillClaimInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushMonsterCommonSkillClaimInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushMonsterCommonSkillClaimInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityKillZombieManager:OnBossAttacked(message)
  end
end

return PushMonsterCommonSkillClaimInfoMessage
