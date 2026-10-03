local ValentineReceiveRankRewardMessage = BaseClass("ValentineReceiveRankRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineReceiveRankRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function ValentineReceiveRankRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    if t.activityId then
      local activityId = t.activityId
      local lastRankId = t.lastRankId
      DataCenter.ValentineDataManager:UpdateReceiveActivityLastRankId(activityId, lastRankId)
    end
    if t.rankRewards then
      DataCenter.ValentineDataManager:SetActSendRankRewardData(t)
    end
    EventManager:GetInstance():Broadcast(EventId.ValentineReceiveRankReward)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return ValentineReceiveRankRewardMessage
