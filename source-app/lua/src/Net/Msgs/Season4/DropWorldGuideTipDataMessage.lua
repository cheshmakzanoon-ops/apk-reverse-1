local DropWorldGuideTipDataMessage = BaseClass("DropWorldGuideTipDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DropWorldGuideTipDataMessage:OnCreate(eventKey, eventType)
  base.OnCreate(self)
  self.sfsObj:PutInt("eventType", eventType)
  self.sfsObj:PutUtfString("eventKey", eventKey)
end

function DropWorldGuideTipDataMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return DropWorldGuideTipDataMessage
