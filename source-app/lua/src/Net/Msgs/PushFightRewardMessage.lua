local PushFightRewardMessage = BaseClass("PushFightRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.RewardManager:AddRewardsAndRes(t)
end

PushFightRewardMessage.OnCreate = OnCreate
PushFightRewardMessage.HandleMessage = HandleMessage
return PushFightRewardMessage
