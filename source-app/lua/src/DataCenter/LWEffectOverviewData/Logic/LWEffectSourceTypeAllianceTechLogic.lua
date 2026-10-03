local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeAllianceTechLogic = BaseClass("LWEffectSourceTypeAllianceTechLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeAllianceTechLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeAllianceTechLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeAllianceTechLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.AllianceTech)
  local effectData = DataCenter.LWEffectOverviewManager:GetEffectDataByEffectOverviewSourcePoint(EffectOverviewSourcePoint.AllianceTech)
  if effectData then
    for effectId, configIds in pairs(effectData) do
      local effectValue = DataCenter.AllianceScienceDataManager:GetAllianceScienceEffectById(effectId)
      DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.AllianceTech, effectId, effectValue)
    end
  end
end

return LWEffectSourceTypeAllianceTechLogic
