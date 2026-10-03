local PushAddBuildingMessage = BaseClass("PushAddBuildingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildManager:PushAddBuildingHandle(t)
end

PushAddBuildingMessage.OnCreate = OnCreate
PushAddBuildingMessage.HandleMessage = HandleMessage
return PushAddBuildingMessage
