local PushCityPointRefreshMessage = BaseClass("PushCityPointRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.GuideCityManager:PushCityPointRefreshHandle(message)
end

PushCityPointRefreshMessage.OnCreate = OnCreate
PushCityPointRefreshMessage.HandleMessage = HandleMessage
return PushCityPointRefreshMessage
