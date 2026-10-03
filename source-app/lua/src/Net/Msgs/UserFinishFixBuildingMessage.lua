local UserFinishFixBuildingMessage = BaseClass("UserFinishFixBuildingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildManager:FreeBuildingFinishFixHandle(t)
end

UserFinishFixBuildingMessage.OnCreate = OnCreate
UserFinishFixBuildingMessage.HandleMessage = HandleMessage
return UserFinishFixBuildingMessage
