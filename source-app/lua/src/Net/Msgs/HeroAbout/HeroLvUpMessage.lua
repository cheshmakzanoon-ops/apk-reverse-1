local HeroLvUpMessage = BaseClass("HeroLvUpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("heroUid", heroUuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Hero_Upgrade3, false)
  local res = message.resource
  if res ~= nil then
    LuaEntry.Resource:UpdateResource(res)
  end
  local heroUuid = message.hero.uuid
  DataCenter.HeroDataManager:UpdateOneHero(message.hero)
  EventManager:GetInstance():Broadcast(EventId.HeroLvUpSuccess, heroUuid)
end

HeroLvUpMessage.OnCreate = OnCreate
HeroLvUpMessage.HandleMessage = HandleMessage
return HeroLvUpMessage
