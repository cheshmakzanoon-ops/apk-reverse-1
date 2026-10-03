local LWBeginnerGetCityEventMessage = BaseClass("LWBeginnerGetCityEventMessage", SFSBaseMessage)
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

LWBeginnerGetCityEventMessage.OnCreate = OnCreate
LWBeginnerGetCityEventMessage.HandleMessage = HandleMessage
return LWBeginnerGetCityEventMessage
