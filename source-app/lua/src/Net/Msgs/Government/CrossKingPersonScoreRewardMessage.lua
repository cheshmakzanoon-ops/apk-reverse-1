local CrossKingPersonScoreRewardMessage = BaseClass("CrossKingPersonScoreRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingPersonScoreRewardMessage:OnCreate(index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

function CrossKingPersonScoreRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  SFSNetwork.SendMessage(MsgDefines.CrossKingFightInfo)
  EventManager:GetInstance():Broadcast(EventId.CrossKingPersonScoreRewardRefresh, t)
end

return CrossKingPersonScoreRewardMessage
