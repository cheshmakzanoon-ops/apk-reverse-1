local PushUserKingdomPositionUpdate = BaseClass("PushUserKingdomPositionUpdate", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:PushPositionUpdate(t)
end

PushUserKingdomPositionUpdate.OnCreate = OnCreate
PushUserKingdomPositionUpdate.HandleMessage = HandleMessage
return PushUserKingdomPositionUpdate
