local PushCrossAlertMessage = BaseClass("PushCrossAlertMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.AllianceWarDataManager:ParseServerId(t)
end

PushCrossAlertMessage.OnCreate = OnCreate
PushCrossAlertMessage.HandleMessage = HandleMessage
return PushCrossAlertMessage
