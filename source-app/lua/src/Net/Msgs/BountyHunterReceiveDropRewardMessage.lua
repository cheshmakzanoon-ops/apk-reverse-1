local BountyHunterReceiveDropRewardMessage = BaseClass("BountyHunterReceiveDropRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterReceiveDropRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function BountyHunterReceiveDropRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
    if t.historyReward then
      local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
      actData:UpdateHistoryReward(t.historyReward)
      actData:ClearStashReward()
      EventManager:GetInstance():Broadcast(EventId.BountyHunterSuccessGetStashReward)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return BountyHunterReceiveDropRewardMessage
