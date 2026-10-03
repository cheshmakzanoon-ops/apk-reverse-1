local RichManDayRewardMessage = BaseClass("RichManDayRewardMessage", SFSBaseMessage)
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
    DataCenter.ActMonopolyDataManager:UpdateDailyRewardData(t)
    EventManager:GetInstance():Broadcast(EventId.ActMonopolyDailyRewardUpdate)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

RichManDayRewardMessage.OnCreate = OnCreate
RichManDayRewardMessage.HandleMessage = HandleMessage
return RichManDayRewardMessage
