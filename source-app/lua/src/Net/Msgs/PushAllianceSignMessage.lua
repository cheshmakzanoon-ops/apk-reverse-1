local PushAllianceSignMessage = BaseClass("PushAllianceSignMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

PushAllianceSignMessage.OnCreate = OnCreate
PushAllianceSignMessage.HandleMessage = HandleMessage
return PushAllianceSignMessage
