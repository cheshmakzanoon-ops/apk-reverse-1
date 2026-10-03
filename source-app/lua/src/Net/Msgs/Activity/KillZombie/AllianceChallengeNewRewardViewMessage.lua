local AllianceChallengeNewRewardViewMessage = BaseClass("AllianceChallengeNewRewardViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceChallengeNewRewardViewMessage:OnCreate(uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", uid)
end

function AllianceChallengeNewRewardViewMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  EventManager:GetInstance():Broadcast(EventId.ChallengeZombieViewWorldBoxReward, message)
end

return AllianceChallengeNewRewardViewMessage
