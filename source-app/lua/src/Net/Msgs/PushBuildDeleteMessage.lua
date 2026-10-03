local PushBuildDeleteMessage = BaseClass("PushBuildDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildManager:PushBuildDeleteHandle(t)
end

PushBuildDeleteMessage.OnCreate = OnCreate
PushBuildDeleteMessage.HandleMessage = HandleMessage
return PushBuildDeleteMessage
