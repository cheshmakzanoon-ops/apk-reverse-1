local PushEditHeroMessage = BaseClass("PushEditHeroMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

PushEditHeroMessage.OnCreate = OnCreate
PushEditHeroMessage.HandleMessage = HandleMessage
return PushEditHeroMessage
