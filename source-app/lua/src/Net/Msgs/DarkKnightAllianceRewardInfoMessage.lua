local DarkKnightAllianceRewardInfoMessage = BaseClass("DarkKnightAllianceRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DarkKnightAllianceRewardInfoMessage:OnCreate(activityId, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
  self.sfsObj:PutInt("type", type)
end

function DarkKnightAllianceRewardInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  if message.personRankReward ~= nil then
    DataCenter.CounterAttackDataManager:RecMsgLookPersonAward(message.personRankReward)
  end
  if message.allianceRoundReward ~= nil then
    DataCenter.CounterAttackDataManager:RecMsgLookRoundAward(message.allianceRoundReward)
  end
end

return DarkKnightAllianceRewardInfoMessage
