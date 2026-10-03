local PushSunriseUnlockMessage = BaseClass("PushSunriseUnlockMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
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

PushSunriseUnlockMessage.OnCreate = OnCreate
PushSunriseUnlockMessage.HandleMessage = HandleMessage
return PushSunriseUnlockMessage
