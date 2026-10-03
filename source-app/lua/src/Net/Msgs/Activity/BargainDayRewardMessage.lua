local BargainDayRewardMessage = BaseClass("BargainDayRewardMessage", SFSBaseMessage)
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
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    DataCenter.ActBargainShopData:UpdateDailyRewardData(t)
    EventManager:GetInstance():Broadcast(EventId.BargainDayRewardUpdate)
  end
end

BargainDayRewardMessage.OnCreate = OnCreate
BargainDayRewardMessage.HandleMessage = HandleMessage
return BargainDayRewardMessage
