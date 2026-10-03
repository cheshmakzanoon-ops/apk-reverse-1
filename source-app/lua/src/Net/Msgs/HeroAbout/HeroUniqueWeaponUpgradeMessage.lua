local HeroUniqueWeaponUpgradeMessage = BaseClass("HeroUniqueWeaponUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid, useComItem)
  base.OnCreate(self)
  self.sfsObj:PutLong("heroUuid", heroUuid)
  local _useComItem = false
  if useComItem then
    _useComItem = useComItem
  end
  self.sfsObj:PutBool("exchange", _useComItem)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.HeroDataManager:UpdateOneHero(message.hero)
  EventManager:GetInstance():Broadcast(EventId.HeroUniqueWeaponUpgrade, message.hero.uuid)
  if message.hero.uuid then
    local prevModelId
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(message.hero.uuid)
    if not heroData then
      return
    end
    local prevWeaponLv = heroData:GetUniqueWeaponLv() - 1
    if 0 < prevWeaponLv then
      local weaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroData.heroId, prevWeaponLv)
      if weaponTemplate then
        prevModelId = weaponTemplate.modelId
      end
    elseif heroData.meta then
      prevModelId = heroData.meta.appearance
    end
    if prevModelId then
      local modelId = heroData.modelId
      if modelId == prevModelId then
        return
      end
      EventManager:GetInstance():Broadcast(EventId.HeroModelChange, message.hero.heroId)
    end
  end
end

HeroUniqueWeaponUpgradeMessage.OnCreate = OnCreate
HeroUniqueWeaponUpgradeMessage.HandleMessage = HandleMessage
return HeroUniqueWeaponUpgradeMessage
