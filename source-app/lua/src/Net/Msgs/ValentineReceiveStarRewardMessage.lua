local ValentineReceiveStarRewardMessage = BaseClass("ValentineReceiveStarRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineReceiveStarRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function ValentineReceiveStarRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.RewardManager:AddRewardsAndRes(t)
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if t.activityId then
      local activityId = toInt(t.activityId)
      if t.lastStarId then
        DataCenter.ValentineDataManager:UpdateReceiveActivityLastStarId(activityId, t.lastStarId)
      end
      DataCenter.ValentineDataManager:UpdateTargetActivityStarRewardNum(activityId, 0)
      EventManager:GetInstance():Broadcast(EventId.ValentineReceiveStarReward)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

return ValentineReceiveStarRewardMessage
