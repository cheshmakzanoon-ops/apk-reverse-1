local PushHeroGlobalDataMessage = BaseClass("PushHeroGlobalDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.HeroDataManager:UpdateGlobalData(message)
end

PushHeroGlobalDataMessage.OnCreate = OnCreate
PushHeroGlobalDataMessage.HandleMessage = HandleMessage
return PushHeroGlobalDataMessage
