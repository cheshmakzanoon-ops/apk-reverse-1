local PushPayIOSMessage = BaseClass("PushPayIOSMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.PayManager:PayMessageHandle(t)
end

PushPayIOSMessage.OnCreate = OnCreate
PushPayIOSMessage.HandleMessage = HandleMessage
return PushPayIOSMessage
