local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeSurvivorLogic = BaseClass("LWEffectSourceTypeSurvivorLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeSurvivorLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeSurvivorLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeSurvivorLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.Survivor)
  local allWorkerData = DataCenter.WorkerDataManager:GetAllWorkerData()
  if allWorkerData then
    for i, workerData in pairs(allWorkerData) do
      if workerData.state == WorkerState.WORKER then
        for effectId, effectValue in pairs(workerData.effectDict) do
          DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Survivor, effectId, effectValue)
        end
      end
    end
  end
end

return LWEffectSourceTypeSurvivorLogic
