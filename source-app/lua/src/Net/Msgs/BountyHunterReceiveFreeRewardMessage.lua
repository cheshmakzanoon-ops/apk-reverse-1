local BountyHunterReceiveFreeRewardMessage = BaseClass("BountyHunterReceiveFreeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterReceiveFreeRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function BountyHunterReceiveFreeRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    DataCenter.BountyHunterActDataManager:UpdateDailyRewardData(t)
    EventManager:GetInstance():Broadcast(EventId.BountyHunterDailyRewardUpdate)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return BountyHunterReceiveFreeRewardMessage
