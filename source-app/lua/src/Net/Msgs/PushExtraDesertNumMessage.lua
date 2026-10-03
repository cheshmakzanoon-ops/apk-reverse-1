local PushExtraDesertNumMessage = BaseClass("PushExtraDesertNumMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

PushExtraDesertNumMessage.OnCreate = OnCreate
PushExtraDesertNumMessage.HandleMessage = HandleMessage
return PushExtraDesertNumMessage
