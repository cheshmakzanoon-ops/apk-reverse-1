local PushKingOccupyProgressMessage = BaseClass("PushKingOccupyProgressMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:KingOccupyPlayerHandler(t)
end

PushKingOccupyProgressMessage.OnCreate = OnCreate
PushKingOccupyProgressMessage.HandleMessage = HandleMessage
return PushKingOccupyProgressMessage
