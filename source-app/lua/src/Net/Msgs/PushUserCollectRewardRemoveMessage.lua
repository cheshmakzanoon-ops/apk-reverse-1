local PushUserCollectRewardRemoveMessage = BaseClass("PushUserCollectRewardRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.uuid ~= nil then
    DataCenter.CollectRewardDataManager:RemoveOneReward(t.uuid)
    EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
  end
end

PushUserCollectRewardRemoveMessage.OnCreate = OnCreate
PushUserCollectRewardRemoveMessage.HandleMessage = HandleMessage
return PushUserCollectRewardRemoveMessage
