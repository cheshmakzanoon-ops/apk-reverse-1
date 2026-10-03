local DetectEventHelpEndMessage = BaseClass("DetectEventHelpEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, type)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("eventType", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

DetectEventHelpEndMessage.OnCreate = OnCreate
DetectEventHelpEndMessage.HandleMessage = HandleMessage
return DetectEventHelpEndMessage
