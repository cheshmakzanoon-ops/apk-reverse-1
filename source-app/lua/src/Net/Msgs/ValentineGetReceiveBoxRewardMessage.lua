local ValentineGetReceiveBoxRewardMessage = BaseClass("ValentineGetReceiveBoxRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineGetReceiveBoxRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function ValentineGetReceiveBoxRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:AddRewardsAndRes(t)
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if t.activityId then
      local activityId = toInt(t.activityId)
      if t.boxId then
        DataCenter.ValentineDataManager:UpdateReceiveActivityBoxId(activityId, t.boxId)
        local rewardData
        if t.reward then
          rewardData = DataCenter.RewardManager:ReturnRewardParamForMessage(t.reward)
        end
        EventManager:GetInstance():Broadcast(EventId.ValentineReceiveBoxChipReward, rewardData)
      end
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

return ValentineGetReceiveBoxRewardMessage
