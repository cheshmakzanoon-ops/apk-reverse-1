local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeHonorWallLogic = BaseClass("LWEffectSourceTypeHonorWallLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeHonorWallLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeHonorWallLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeHonorWallLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.HonorWall)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  for i, heroInfo in pairs(allHeroes) do
    if heroInfo:IsReachMaxRank() or heroInfo.honorLevel and heroInfo.honorLevel > 0 then
      local unlockEffects = heroInfo:CollectHonorEffect()
      if not table.IsNullOrEmpty(unlockEffects) then
        for effectId, effectValue in pairs(unlockEffects) do
          DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.HonorWall, effectId, effectValue)
        end
      end
    end
  end
end

return LWEffectSourceTypeHonorWallLogic
