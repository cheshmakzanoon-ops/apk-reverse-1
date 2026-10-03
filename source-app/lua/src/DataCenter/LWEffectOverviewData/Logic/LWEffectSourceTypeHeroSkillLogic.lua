local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeHeroSkillLogic = BaseClass("LWEffectSourceTypeHeroSkillLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeHeroSkillLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeHeroSkillLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeHeroSkillLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.HeroSkill)
  local showHeroUuid = DataCenter.HeroDataManager:GetShowHeroUuidCache()
  if showHeroUuid == nil then
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(showHeroUuid)
  if heroData == nil then
    return
  end
  local skill = heroData:GetHeroSkillBySlotIndex(4)
  if skill == nil then
    return
  end
  if skill:IsUnlock() then
    local skillProperties = skill:GetPropertiesOutOfBattle()
    if skillProperties then
      for i, v in ipairs(skillProperties) do
        DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.HeroSkill, v.id, v.value)
      end
    end
  end
end

return LWEffectSourceTypeHeroSkillLogic
