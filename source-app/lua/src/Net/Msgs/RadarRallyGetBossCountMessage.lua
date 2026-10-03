local RadarRallyGetBossCountMessage = BaseClass("RadarRallyGetBossCountMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.RadarRallyGetBossCount, t)
end

RadarRallyGetBossCountMessage.OnCreate = OnCreate
RadarRallyGetBossCountMessage.HandleMessage = HandleMessage
return RadarRallyGetBossCountMessage
