local PushNewEntrustMessage = BaseClass("PushNewEntrustMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.HeroEntrustManager:PushNewEntrustHandle(t)
end

PushNewEntrustMessage.OnCreate = OnCreate
PushNewEntrustMessage.HandleMessage = HandleMessage
return PushNewEntrustMessage
