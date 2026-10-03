local KingdomPositionAppointmentDeleteMessage = BaseClass("KingdomPositionAppointmentDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("positionId", param.positionId)
  self.sfsObj:PutUtfString("uid", param.uid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil or t.errorCode == nil then
  else
    UIUtil.ShowTipsId(t.errorCode)
  end
end

KingdomPositionAppointmentDeleteMessage.OnCreate = OnCreate
KingdomPositionAppointmentDeleteMessage.HandleMessage = HandleMessage
return KingdomPositionAppointmentDeleteMessage
