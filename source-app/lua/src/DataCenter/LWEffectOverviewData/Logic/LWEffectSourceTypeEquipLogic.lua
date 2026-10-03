local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeEquipLogic = BaseClass("LWEffectSourceTypeEquipLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeEquipLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeEquipLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeEquipLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.Equip)
  local showHeroUuid = DataCenter.HeroDataManager:GetShowHeroUuidCache()
  if showHeroUuid == nil then
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(showHeroUuid)
  if heroData == nil then
    return
  end
  for i = 1, 4 do
    local equipData = heroData:GetEquipBySlotType(i)
    if equipData ~= nil then
      local list = equipData:GetAllProperty()
      for effectId, effectValue in pairs(list) do
        DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Equip, effectId, effectValue)
      end
    end
  end
end

return LWEffectSourceTypeEquipLogic
