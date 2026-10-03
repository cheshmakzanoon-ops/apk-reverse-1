local PushInitRoadMessage = BaseClass("PushInitRoadMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BoardManager:PushInitRoadHandle(t)
end

PushInitRoadMessage.OnCreate = OnCreate
PushInitRoadMessage.HandleMessage = HandleMessage
return PushInitRoadMessage
