local PushAlScienceUpdateMessage = BaseClass("PushAlScienceUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.AllianceScienceDataManager:EndRefreshAllScienceNum(t)
  DataCenter.AllianceScienceDataManager:UpdateOneAllianceScience(t)
  EventManager:GetInstance():Broadcast(EventId.AllianceTechnology)
end

PushAlScienceUpdateMessage.OnCreate = OnCreate
PushAlScienceUpdateMessage.HandleMessage = HandleMessage
return PushAlScienceUpdateMessage
