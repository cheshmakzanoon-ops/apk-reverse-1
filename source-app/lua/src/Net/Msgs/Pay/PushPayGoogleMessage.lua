local PushPayGoogleMessage = BaseClass("PushPayGoogleMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.PayManager:PayMessageHandle(t)
end

PushPayGoogleMessage.OnCreate = OnCreate
PushPayGoogleMessage.HandleMessage = HandleMessage
return PushPayGoogleMessage
