local PushFoldCrossWormTimeMessage = BaseClass("PushFoldCrossWormTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  LuaEntry.Player:SetFoldCrossWormHoleTime(t)
  EventManager:GetInstance():Broadcast(EventId.FoldCrossWormHoleTimeUpdate)
end

PushFoldCrossWormTimeMessage.OnCreate = OnCreate
PushFoldCrossWormTimeMessage.HandleMessage = HandleMessage
return PushFoldCrossWormTimeMessage
