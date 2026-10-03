local KingdomPositionAppointmentListMessage = BaseClass("KingdomPositionAppointmentListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, positionId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("positionId", positionId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.OfficialApplyManager:UpdateAppointmentList(t)
      EventManager:GetInstance():Broadcast(EventId.OfficialApplyDownRefresh)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

KingdomPositionAppointmentListMessage.OnCreate = OnCreate
KingdomPositionAppointmentListMessage.HandleMessage = HandleMessage
return KingdomPositionAppointmentListMessage
