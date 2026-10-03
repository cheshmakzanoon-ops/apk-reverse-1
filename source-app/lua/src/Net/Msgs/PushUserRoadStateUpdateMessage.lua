local PushUserRoadStateUpdateMessage = BaseClass("PushUserRoadStateUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BoardManager:PushUserRoadStateUpdateHandle(t)
end

PushUserRoadStateUpdateMessage.OnCreate = OnCreate
PushUserRoadStateUpdateMessage.HandleMessage = HandleMessage
return PushUserRoadStateUpdateMessage
