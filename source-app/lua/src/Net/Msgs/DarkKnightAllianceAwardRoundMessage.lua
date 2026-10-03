local DarkKnightAllianceAwardRoundMessage = BaseClass("DarkKnightAllianceAwardRoundMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DarkKnightAllianceAwardRoundMessage:OnCreate(activityId, round)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
  if round then
    self.sfsObj:PutInt("round", round)
    self.sfsObj:PutBool("all", false)
  else
    self.sfsObj:PutInt("round", 1)
    self.sfsObj:PutBool("all", true)
  end
end

function DarkKnightAllianceAwardRoundMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  if message.rewards then
    local fakeMsg = {
      reward = message.rewards
    }
    DataCenter.RewardManager:AddRewardsAndRes(fakeMsg)
    DataCenter.RewardManager:ShowCommonReward(fakeMsg)
  end
  if message.allianceRoundReward then
    DataCenter.CounterAttackDataManager:RecMsgCollectRoundAward(message.allianceRoundReward)
  end
end

return DarkKnightAllianceAwardRoundMessage
