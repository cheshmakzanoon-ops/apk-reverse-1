local LWBeginnerPushCityEventTaskMessage = BaseClass("LWBeginnerPushCityEventTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.LWBeginnerDirectorManager:UpdateCityEventTasks(t)
  end
end

LWBeginnerPushCityEventTaskMessage.OnCreate = OnCreate
LWBeginnerPushCityEventTaskMessage.HandleMessage = HandleMessage
return LWBeginnerPushCityEventTaskMessage
