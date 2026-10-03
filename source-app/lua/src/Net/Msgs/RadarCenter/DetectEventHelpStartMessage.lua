local DetectEventHelpStartMessage = BaseClass("DetectEventHelpStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, type)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("eventType", type)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
end

DetectEventHelpStartMessage.OnCreate = OnCreate
DetectEventHelpStartMessage.HandleMessage = HandleMessage
return DetectEventHelpStartMessage
