local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeCampTechLogic = BaseClass("LWEffectSourceTypeCampTechLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeCampTechLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeCampTechLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeCampTechLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.CampScience)
  local effectData = DataCenter.LWEffectOverviewManager:GetEffectDataByEffectOverviewSourcePoint(EffectOverviewSourcePoint.CampScience)
  if effectData then
    for effectId, configIds in pairs(effectData) do
      local effectValue = DataCenter.CampScienceDataManager:GetCampScienceEffectById(effectId)
      DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.CampScience, effectId, effectValue)
    end
  end
end

return LWEffectSourceTypeCampTechLogic
