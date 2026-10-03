local PushUserLostDesertMessage = BaseClass("PushUserLostDesertMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local uuid = t.uuid
  if uuid ~= nil then
    DataCenter.DesertDataManager:RemoveMyDesert(t)
    EventManager:GetInstance():Broadcast(EventId.UserLostDesert, uuid)
  end
end

PushUserLostDesertMessage.OnCreate = OnCreate
PushUserLostDesertMessage.HandleMessage = HandleMessage
return PushUserLostDesertMessage
