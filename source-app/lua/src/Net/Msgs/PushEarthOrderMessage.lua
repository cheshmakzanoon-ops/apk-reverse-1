local PushEarthOrderMessage = BaseClass("PushEarthOrderMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.EarthOrderDataManager:PushEarthOrderHandle(message)
end

PushEarthOrderMessage.OnCreate = OnCreate
PushEarthOrderMessage.HandleMessage = HandleMessage
return PushEarthOrderMessage
