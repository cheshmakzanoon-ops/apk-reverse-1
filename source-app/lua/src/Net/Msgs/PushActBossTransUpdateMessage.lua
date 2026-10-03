local PushActBossTransUpdateMessage = BaseClass("PushActBossTransUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActBossDataManager:RefreshTransTime(t)
  DataCenter.LWSeasonBossLoginDataManager:RefreshTransTime(t)
  EventManager:GetInstance():Broadcast(EventId.SeasonVirusBossReddot)
end

PushActBossTransUpdateMessage.OnCreate = OnCreate
PushActBossTransUpdateMessage.HandleMessage = HandleMessage
return PushActBossTransUpdateMessage
