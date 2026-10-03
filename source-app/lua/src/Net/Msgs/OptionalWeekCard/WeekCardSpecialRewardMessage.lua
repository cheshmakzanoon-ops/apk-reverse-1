local WeekCardSpecialRewardMessage = BaseClass("WeekCardSpecialRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function WeekCardSpecialRewardMessage:OnCreate(aid, cardId)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", aid)
  self.sfsObj:PutInt("cardId", cardId)
end

function WeekCardSpecialRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.reward then
      DataCenter.RewardManager:AddRewardsAndRes(message)
      DataCenter.RewardManager:ShowCommonReward(message)
    end
    if message.cardObj then
      DataCenter.LWOptionalWeekCardManager:UpdateWeekCardDataByReceiveReward(message)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

return WeekCardSpecialRewardMessage
