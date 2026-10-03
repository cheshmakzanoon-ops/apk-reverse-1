local FindMainBuildInitPositionMessage = BaseClass("FindMainBuildInitPositionMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BuildManager:FindMainBuildInitPositionHandle(message)
end

FindMainBuildInitPositionMessage.OnCreate = OnCreate
FindMainBuildInitPositionMessage.HandleMessage = HandleMessage
return FindMainBuildInitPositionMessage
