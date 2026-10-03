local PushEffectChangeMessage = BaseClass("PushEffectChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local preEarthOrderEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_UNLOCK)
  LuaEntry.Effect:OnEffectChange(t)
  local nowEarthOrderEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_UNLOCK)
  if preEarthOrderEffect ~= nowEarthOrderEffect then
    DataCenter.EarthOrderDataManager:SendGetEarthOrder()
  end
  EventManager:GetInstance():Broadcast(EventId.EffectNumChange)
end

PushEffectChangeMessage.OnCreate = OnCreate
PushEffectChangeMessage.HandleMessage = HandleMessage
return PushEffectChangeMessage
