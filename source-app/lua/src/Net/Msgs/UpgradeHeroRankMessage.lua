local UpgradeHeroRankMessage = BaseClass("UpgradeHeroRankMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid, useCommonFrag)
  base.OnCreate(self)
  if not heroUuid then
    return
  end
  self.sfsObj:PutLong("uuid", heroUuid)
  self.sfsObj:PutInt("exchange", useCommonFrag)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.HeroDataManager:UpdateOneHero(message.hero)
  local heroUuid = message.hero.uuid
  EventManager:GetInstance():Broadcast(EventId.HeroUpgradeRank, heroUuid)
end

UpgradeHeroRankMessage.OnCreate = OnCreate
UpgradeHeroRankMessage.HandleMessage = HandleMessage
return UpgradeHeroRankMessage
