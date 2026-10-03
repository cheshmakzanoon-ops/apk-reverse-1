local HeroHonorLvUpMessage = BaseClass("HeroHonorLvUpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid, useCommonFrag)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", heroUuid)
  self.sfsObj:PutInt("exchange", useCommonFrag)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  local heroUuid = message.hero.uuid
  DataCenter.HeroDataManager:UpdateOneHero(message.hero)
  EventManager:GetInstance():Broadcast(EventId.HeroHonorLevelUpgrade, heroUuid)
end

HeroHonorLvUpMessage.OnCreate = OnCreate
HeroHonorLvUpMessage.HandleMessage = HandleMessage
return HeroHonorLvUpMessage
