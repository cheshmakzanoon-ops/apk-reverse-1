local WinterStormActInfoMessage = BaseClass("WinterStormActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

WinterStormActInfoMessage.OnCreate = OnCreate
WinterStormActInfoMessage.HandleMessage = HandleMessage
return WinterStormActInfoMessage
