local AllianceChallengeNewRewardGetMessage = BaseClass("AllianceChallengeNewRewardGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceChallengeNewRewardGetMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceChallengeNewRewardGetMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  EventManager:GetInstance():Broadcast(EventId.ChallengeZombieGetWorldBoxReward, message)
end

return AllianceChallengeNewRewardGetMessage
