local CitySkinExchangeMessage = BaseClass("CitySkinExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, aid, id, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", aid)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    DataCenter.ActCitySkinDataManager:SetExchangeTimes(t.activityId, t.id, t.curCount)
    EventManager:GetInstance():Broadcast(EventId.CitySkinExchange)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

CitySkinExchangeMessage.OnCreate = OnCreate
CitySkinExchangeMessage.HandleMessage = HandleMessage
return CitySkinExchangeMessage
