local PushPveStaminaUpdateMessage = BaseClass("PushPveStaminaUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushPveStaminaUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PushPveStaminaUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  LuaEntry.Player:SetPveStaminaData(t)
  EventManager:GetInstance():Broadcast(EventId.PveStaminaUpdate)
end

return PushPveStaminaUpdateMessage
