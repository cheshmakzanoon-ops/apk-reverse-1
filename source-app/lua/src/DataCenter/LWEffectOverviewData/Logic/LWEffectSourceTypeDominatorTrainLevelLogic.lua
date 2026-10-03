local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeDominatorTrainLevelLogic = BaseClass("LWEffectSourceTypeDominatorTrainLevelLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeDominatorTrainLevelLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeDominatorTrainLevelLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeDominatorTrainLevelLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.DominatorTrainLevel)
  local dominatorInfoDict = DataCenter.DominatorManager:GetAllInfo()
  for dominatorId, dominatorInfo in pairs(dominatorInfoDict) do
    local allEffects = dominatorInfo:GetTrainLevelAllEffects()
    for i, v in pairs(allEffects) do
      DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.DominatorTrainLevel, v.effectId, v.effectValue)
    end
  end
end

return LWEffectSourceTypeDominatorTrainLevelLogic
