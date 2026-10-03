local PushUserGetDesertMessage = BaseClass("PushUserGetDesertMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.DesertDataManager:UpdateOneDesertData(t)
  EventManager:GetInstance():Broadcast(EventId.UserGetDesert)
  if t.uuid ~= nil then
    local uuid = t.uuid
    WorldDesertEffectManager:GetInstance():CheckShowDesert(uuid)
  end
end

PushUserGetDesertMessage.OnCreate = OnCreate
PushUserGetDesertMessage.HandleMessage = HandleMessage
return PushUserGetDesertMessage
