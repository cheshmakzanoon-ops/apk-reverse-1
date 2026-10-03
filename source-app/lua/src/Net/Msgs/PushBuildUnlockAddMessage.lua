local PushBuildUnlockAddMessage = BaseClass("PushBuildUnlockAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildQueueManager:InitQueueList(t)
end

PushBuildUnlockAddMessage.OnCreate = OnCreate
PushBuildUnlockAddMessage.HandleMessage = HandleMessage
return PushBuildUnlockAddMessage
