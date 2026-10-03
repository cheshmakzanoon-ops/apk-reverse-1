local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeDominatorRankLevelLogic = BaseClass("LWEffectSourceTypeDominatorRankLevelLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeDominatorRankLevelLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeDominatorRankLevelLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeDominatorRankLevelLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.DominatorRankLevel)
  local dominatorInfoDict = DataCenter.DominatorManager:GetAllInfo()
  for dominatorId, dominatorInfo in pairs(dominatorInfoDict) do
    local allEffects = dominatorInfo:GetRankLevelAllEffects()
    for i, v in pairs(allEffects) do
      DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.DominatorRankLevel, v.effectId, v.effectValue)
    end
  end
end

return LWEffectSourceTypeDominatorRankLevelLogic
