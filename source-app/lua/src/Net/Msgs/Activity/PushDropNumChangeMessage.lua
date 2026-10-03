local PushDropNumChangeMessage = BaseClass("PushDropNumChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActLimitedTimeFeastData:RefreshDropNumData(t)
  EventManager:GetInstance():Broadcast(EventId.ActLimitedTimeFeastDataUpdate)
end

PushDropNumChangeMessage.OnCreate = OnCreate
PushDropNumChangeMessage.HandleMessage = HandleMessage
return PushDropNumChangeMessage
