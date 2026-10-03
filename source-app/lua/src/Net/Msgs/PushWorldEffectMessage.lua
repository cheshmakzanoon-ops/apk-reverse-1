local PushWorldEffectMessage = BaseClass("PushWorldEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.status ~= nil then
    local status = t.status
    for i, v in ipairs(status) do
      LuaEntry.Effect:UpdateEffectWorldStatus(tonumber(v.effVal), tonumber(v.effNum), tonumber(v.stateId), tonumber(v.endTime), tonumber(v.startTime))
    end
    EventManager:GetInstance():Broadcast(EventId.MSG_ITME_STATUS_TIME_CHANGE)
  end
end

PushWorldEffectMessage.OnCreate = OnCreate
PushWorldEffectMessage.HandleMessage = HandleMessage
return PushWorldEffectMessage
