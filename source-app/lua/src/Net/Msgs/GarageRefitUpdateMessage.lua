local GarageRefitUpdateMessage = BaseClass("GarageRefitUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.GarageRefitUpdate, t)
end

GarageRefitUpdateMessage.OnCreate = OnCreate
GarageRefitUpdateMessage.HandleMessage = HandleMessage
return GarageRefitUpdateMessage
