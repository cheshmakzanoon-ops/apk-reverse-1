local LottoThanksgivingReceiveRewardMessage = BaseClass("LottoThanksgivingReceiveRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  DataCenter.ActLotteryDataManager:RefreshGetActRewardData(t)
  EventManager:GetInstance():Broadcast(EventId.ActLotteryGetBeSendReward)
end

LottoThanksgivingReceiveRewardMessage.OnCreate = OnCreate
LottoThanksgivingReceiveRewardMessage.HandleMessage = HandleMessage
return LottoThanksgivingReceiveRewardMessage
