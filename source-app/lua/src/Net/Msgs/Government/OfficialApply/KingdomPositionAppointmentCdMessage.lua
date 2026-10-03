local KingdomPositionAppointmentCdMessage = BaseClass("KingdomPositionAppointmentCdMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      EventManager:GetInstance():Broadcast(EventId.OfficialGetPositionCd, t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

KingdomPositionAppointmentCdMessage.OnCreate = OnCreate
KingdomPositionAppointmentCdMessage.HandleMessage = HandleMessage
return KingdomPositionAppointmentCdMessage
