local ValentineReceiveDayRewardMessage = BaseClass("ValentineReceiveDayRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineReceiveDayRewardMessage:OnCreate(activityId, day)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("day", day)
end

function ValentineReceiveDayRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:AddRewardsAndRes(t)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    if t.activityId then
      local activityId = toInt(t.activityId)
      local lastOpenDay = toInt(t.lastOpenDay)
      DataCenter.ValentineDataManager:UpdateReceiveActivityLastOpenDay(activityId, lastOpenDay)
      EventManager:GetInstance():Broadcast(EventId.ValentineSuccessGetChampionReward)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

return ValentineReceiveDayRewardMessage
