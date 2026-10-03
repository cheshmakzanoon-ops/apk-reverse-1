local LWBeginnerPushCityEventMessage = BaseClass("LWBeginnerPushCityEventMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.LWBeginnerDirectorManager:HandleBeginnerCityEvent(t)
  end
end

LWBeginnerPushCityEventMessage.OnCreate = OnCreate
LWBeginnerPushCityEventMessage.HandleMessage = HandleMessage
return LWBeginnerPushCityEventMessage
