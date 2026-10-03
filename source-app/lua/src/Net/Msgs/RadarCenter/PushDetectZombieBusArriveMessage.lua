local PushDetectZombieBusArriveMessage = BaseClass("PushDetectZombieBusArriveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
  else
    DataCenter.RadarCenterDataManager:UpdateZombieBusTrainArriveCity(message)
  end
end

PushDetectZombieBusArriveMessage.OnCreate = OnCreate
PushDetectZombieBusArriveMessage.HandleMessage = HandleMessage
return PushDetectZombieBusArriveMessage
