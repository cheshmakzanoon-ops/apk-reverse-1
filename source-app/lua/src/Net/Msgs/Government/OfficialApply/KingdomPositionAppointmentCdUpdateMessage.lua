local KingdomPositionAppointmentCdUpdateMessage = BaseClass("KingdomPositionAppointmentCdUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, cdIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("cdIndex", cdIndex)
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

KingdomPositionAppointmentCdUpdateMessage.OnCreate = OnCreate
KingdomPositionAppointmentCdUpdateMessage.HandleMessage = HandleMessage
return KingdomPositionAppointmentCdUpdateMessage
