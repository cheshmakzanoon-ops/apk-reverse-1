local PushUserCollectRewardCreateMessage = BaseClass("PushUserCollectRewardCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.CollectRewardDataManager:UpdateOneReward(t)
  EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
end

PushUserCollectRewardCreateMessage.OnCreate = OnCreate
PushUserCollectRewardCreateMessage.HandleMessage = HandleMessage
return PushUserCollectRewardCreateMessage
