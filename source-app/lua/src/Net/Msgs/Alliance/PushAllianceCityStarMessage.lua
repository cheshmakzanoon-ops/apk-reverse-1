local PushAllianceCityStarMessage = BaseClass("PushAllianceCityStarMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.SiegeDataManager:AddSiegeEvent(t)
end

PushAllianceCityStarMessage.OnCreate = OnCreate
PushAllianceCityStarMessage.HandleMessage = HandleMessage
return PushAllianceCityStarMessage
