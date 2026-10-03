local PushKingdomPositionAppointmentUpdateMessage = BaseClass("PushKingdomPositionAppointmentUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.OfficialApplyManager:SendKingdomPositionAppointmentList(t.positionId)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

PushKingdomPositionAppointmentUpdateMessage.OnCreate = OnCreate
PushKingdomPositionAppointmentUpdateMessage.HandleMessage = HandleMessage
return PushKingdomPositionAppointmentUpdateMessage
