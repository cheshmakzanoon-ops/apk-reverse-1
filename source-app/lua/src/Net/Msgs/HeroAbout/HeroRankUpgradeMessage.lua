local HeroRankUpgradeMessage = BaseClass("HeroRankUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", heroUuid)
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
  DataCenter.HeroDataManager:UpdateOneHero(message.hero)
  local heroUuid = message.uuid
  EventManager:GetInstance():Broadcast(EventId.HeroRankUpSuccess, heroUuid)
end

HeroRankUpgradeMessage.OnCreate = OnCreate
HeroRankUpgradeMessage.HandleMessage = HandleMessage
return HeroRankUpgradeMessage
