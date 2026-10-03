local PushAlScienceUpdateMessage1 = BaseClass("PushAlScienceUpdateMessage1", SFSBaseMessage)
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

PushAlScienceUpdateMessage1.OnCreate = OnCreate
PushAlScienceUpdateMessage1.HandleMessage = HandleMessage
return PushAlScienceUpdateMessage1
