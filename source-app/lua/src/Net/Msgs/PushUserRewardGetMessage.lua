local PushUserRewardGetMessage = BaseClass("PushUserRewardGetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.RewardManager:AddRewardsAndRes(t)
end

PushUserRewardGetMessage.OnCreate = OnCreate
PushUserRewardGetMessage.HandleMessage = HandleMessage
return PushUserRewardGetMessage
