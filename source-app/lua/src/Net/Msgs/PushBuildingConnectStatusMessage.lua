local PushBuildingConnectStatusMessage = BaseClass("PushBuildingConnectStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildManager:PushBuildingConnectStatusHandle(t)
end

PushBuildingConnectStatusMessage.OnCreate = OnCreate
PushBuildingConnectStatusMessage.HandleMessage = HandleMessage
return PushBuildingConnectStatusMessage
