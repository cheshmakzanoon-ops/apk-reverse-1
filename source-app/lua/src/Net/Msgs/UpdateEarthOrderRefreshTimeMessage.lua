local UpdateEarthOrderRefreshTimeMessage = BaseClass("UpdateEarthOrderRefreshTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.EarthOrderDataManager:PushEarthOrderRefreshTimeHandle(t)
end

UpdateEarthOrderRefreshTimeMessage.OnCreate = OnCreate
UpdateEarthOrderRefreshTimeMessage.HandleMessage = HandleMessage
return UpdateEarthOrderRefreshTimeMessage
