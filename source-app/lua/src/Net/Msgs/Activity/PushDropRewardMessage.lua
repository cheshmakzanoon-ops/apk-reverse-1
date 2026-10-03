local PushDropRewardMessage = BaseClass("PushDropRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.RewardManager:AddRewardsAndRes(t)
  DataCenter.RewardManager:ShowCommonReward(t)
  EventManager:GetInstance():Broadcast(EventId.GetPushDropReward)
end

PushDropRewardMessage.OnCreate = OnCreate
PushDropRewardMessage.HandleMessage = HandleMessage
return PushDropRewardMessage
