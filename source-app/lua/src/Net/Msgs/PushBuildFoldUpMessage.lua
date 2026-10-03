local PushBuildFoldUpMessage = BaseClass("PushBuildFoldUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildManager:PushBuildFoldUpHandle(t)
end

PushBuildFoldUpMessage.OnCreate = OnCreate
PushBuildFoldUpMessage.HandleMessage = HandleMessage
return PushBuildFoldUpMessage
