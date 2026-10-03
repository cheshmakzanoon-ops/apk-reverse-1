local PushMonsterChallengeNewBossHpLostMessage = BaseClass("PushMonsterChallengeNewBossHpLostMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushMonsterChallengeNewBossHpLostMessage:OnCreate()
  base.OnCreate(self)
end

function PushMonsterChallengeNewBossHpLostMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.ChallengeZombieBossHpLost, message)
  end
end

return PushMonsterChallengeNewBossHpLostMessage
