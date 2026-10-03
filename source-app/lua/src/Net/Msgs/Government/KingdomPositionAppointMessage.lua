local KingdomPositionAppointMessage = BaseClass("KingdomPositionAppointMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, targetUid, positionId, type)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutUtfString("positionId", tostring(positionId))
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:KingdomPositionAppointHandler(t)
end

KingdomPositionAppointMessage.OnCreate = OnCreate
KingdomPositionAppointMessage.HandleMessage = HandleMessage
return KingdomPositionAppointMessage
