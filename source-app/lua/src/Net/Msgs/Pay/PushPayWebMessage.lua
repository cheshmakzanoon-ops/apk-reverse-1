local PushPayWebMessage = BaseClass("PushPayWebMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.PayManager:PushPayWebMessageHandle(t)
end

PushPayWebMessage.OnCreate = OnCreate
PushPayWebMessage.HandleMessage = HandleMessage
return PushPayWebMessage
