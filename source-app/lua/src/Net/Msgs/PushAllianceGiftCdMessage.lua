local PushAllianceGiftCdMessage = BaseClass("PushAllianceGiftCdMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

PushAllianceGiftCdMessage.OnCreate = OnCreate
PushAllianceGiftCdMessage.HandleMessage = HandleMessage
return PushAllianceGiftCdMessage
