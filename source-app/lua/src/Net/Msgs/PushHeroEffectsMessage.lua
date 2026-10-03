local PushHeroEffectsMessage = BaseClass("PushHeroEffectsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  local heroes = message.heros
  if heroes == nil then
    return
  end
  for k, v in pairs(heroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(tonumber(k))
    if heroData then
      heroData:UpdateEffect(v)
    end
  end
end

PushHeroEffectsMessage.OnCreate = OnCreate
PushHeroEffectsMessage.HandleMessage = HandleMessage
return PushHeroEffectsMessage
