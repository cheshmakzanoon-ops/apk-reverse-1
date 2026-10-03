local ThanksgivingReceiveGiveRewardeMessage = BaseClass("ThanksgivingReceiveGiveRewardeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("index", index)
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
  DataCenter.ActGiftGivingDataManager:ReceiveGiveRewardeMsg(t)
  EventManager:GetInstance():Broadcast(EventId.ActGiftGivingReceiveGiveReward)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

ThanksgivingReceiveGiveRewardeMessage.OnCreate = OnCreate
ThanksgivingReceiveGiveRewardeMessage.HandleMessage = HandleMessage
return ThanksgivingReceiveGiveRewardeMessage
