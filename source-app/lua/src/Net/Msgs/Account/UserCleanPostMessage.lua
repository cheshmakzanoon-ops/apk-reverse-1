local UserCleanPostMessage = BaseClass("UserCleanPostMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  CS.ApplicationLaunch.Instance:ReloadGame()
end

UserCleanPostMessage.OnCreate = OnCreate
UserCleanPostMessage.HandleMessage = HandleMessage
return UserCleanPostMessage
