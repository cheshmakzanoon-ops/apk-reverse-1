local PushHeroLevelUpMessage = BaseClass("PushHeroLevelUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

PushHeroLevelUpMessage.OnCreate = OnCreate
PushHeroLevelUpMessage.HandleMessage = HandleMessage
return PushHeroLevelUpMessage
