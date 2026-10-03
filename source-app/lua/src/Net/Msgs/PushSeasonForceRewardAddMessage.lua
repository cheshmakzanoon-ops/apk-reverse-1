local PushSeasonForceRewardAddMessage = BaseClass("PushSeasonForceRewardAddMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.DesertForceRefresh)
end

PushSeasonForceRewardAddMessage.OnCreate = OnCreate
PushSeasonForceRewardAddMessage.HandleMessage = HandleMessage
return PushSeasonForceRewardAddMessage
