local SunriseReceiveRewardMessage = BaseClass("SunriseReceiveRewardMessage", SFSBaseMessage)
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
  DataCenter.ActSunriseFoundationDataManager:RefreshActDetailData(t)
  EventManager:GetInstance():Broadcast(EventId.SunriseInfoUpdate, t.activityId)
  EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

SunriseReceiveRewardMessage.OnCreate = OnCreate
SunriseReceiveRewardMessage.HandleMessage = HandleMessage
return SunriseReceiveRewardMessage
