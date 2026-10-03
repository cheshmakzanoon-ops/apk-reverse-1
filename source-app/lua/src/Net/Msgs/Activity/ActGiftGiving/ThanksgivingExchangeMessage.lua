local ThanksgivingExchangeMessage = BaseClass("ThanksgivingExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("num", num)
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
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftGivingExchange, t)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

ThanksgivingExchangeMessage.OnCreate = OnCreate
ThanksgivingExchangeMessage.HandleMessage = HandleMessage
return ThanksgivingExchangeMessage
