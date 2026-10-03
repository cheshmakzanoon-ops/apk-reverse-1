local UserStartFixBuildingMessage = BaseClass("UserStartFixBuildingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildManager:FreeBuildingStartFixHandle(t)
end

UserStartFixBuildingMessage.OnCreate = OnCreate
UserStartFixBuildingMessage.HandleMessage = HandleMessage
return UserStartFixBuildingMessage
