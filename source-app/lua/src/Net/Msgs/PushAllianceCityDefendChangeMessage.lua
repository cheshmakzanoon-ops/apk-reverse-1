local PushAllianceCityDefendChangeMessage = BaseClass("PushAllianceCityDefendChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

PushAllianceCityDefendChangeMessage.OnCreate = OnCreate
PushAllianceCityDefendChangeMessage.HandleMessage = HandleMessage
return PushAllianceCityDefendChangeMessage
