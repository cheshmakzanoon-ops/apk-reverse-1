local PushUserRoadRemoveMessage = BaseClass("PushUserRoadRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BoardManager:PushUserRoadRemoveHandle(t)
end

PushUserRoadRemoveMessage.OnCreate = OnCreate
PushUserRoadRemoveMessage.HandleMessage = HandleMessage
return PushUserRoadRemoveMessage
