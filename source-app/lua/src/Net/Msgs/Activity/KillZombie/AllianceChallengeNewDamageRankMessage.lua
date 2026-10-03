local AllianceChallengeNewDamageRankMessage = BaseClass("AllianceChallengeNewDamageRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceChallengeNewDamageRankMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceChallengeNewDamageRankMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.ChallengeZombieGetAlChallengeRank, message)
  end
end

return AllianceChallengeNewDamageRankMessage
