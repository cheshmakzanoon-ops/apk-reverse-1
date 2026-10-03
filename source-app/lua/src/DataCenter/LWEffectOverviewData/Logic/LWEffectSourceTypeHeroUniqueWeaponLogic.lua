local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeHeroUniqueWeaponLogic = BaseClass("LWEffectSourceTypeHeroUniqueWeaponLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeHeroUniqueWeaponLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeHeroUniqueWeaponLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeHeroUniqueWeaponLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.HeroUniqueWeapon)
  local showHeroUuid = DataCenter.HeroDataManager:GetShowHeroUuidCache()
  if showHeroUuid == nil then
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(showHeroUuid)
  if heroData == nil then
    return
  end
  if not heroData:IsUniqueWeaponOpen() then
    return
  end
  if heroData.weaponInfo then
    local list = heroData.weaponInfo:GetSortedAttrs()
    if list then
      for _, v in ipairs(list) do
        DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.HeroUniqueWeapon, v.key, v.value)
      end
    end
  end
end

return LWEffectSourceTypeHeroUniqueWeaponLogic
