local PushCustomerEntranceMessage = BaseClass("PushCustomerEntranceMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.LWCustomerServiceManager:OpenGMPushRed()
end

PushCustomerEntranceMessage.OnCreate = OnCreate
PushCustomerEntranceMessage.HandleMessage = HandleMessage
return PushCustomerEntranceMessage
