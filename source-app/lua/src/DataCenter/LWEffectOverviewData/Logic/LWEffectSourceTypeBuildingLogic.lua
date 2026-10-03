local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeBuildingLogic = BaseClass("LWEffectSourceTypeBuildingLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeBuildingLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeBuildingLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeBuildingLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.Building)
  local effectTypeMap = DataCenter.BuildManager:GetAllDecoPropertyMap()
  for _, v in pairs(effectTypeMap) do
    for effectId, effectValue in pairs(v) do
      DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Building, effectId, effectValue)
    end
  end
  local allianceBuildingDataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_SMITHY)
  for i, data in pairs(allianceBuildingDataList) do
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
    if buildTemplate then
      for effectId, effectValue in pairs(buildTemplate.building_effect_last) do
        if DataCenter.LWEffectOverviewManager:IsContainsSourcePointData(EffectOverviewSourcePoint.Building, effectId) then
          DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Building, effectId, effectValue)
        end
      end
    end
  end
  local workerHouseBuildingDataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_WORKER_HOUSE)
  for i, data in pairs(workerHouseBuildingDataList) do
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
    if buildTemplate then
      for effectId, effectValue in pairs(buildTemplate.building_effect_last) do
        if DataCenter.LWEffectOverviewManager:IsContainsSourcePointData(EffectOverviewSourcePoint.Building, effectId) then
          DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Building, effectId, effectValue)
        end
      end
    end
  end
  local gateBuildingDataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_GATE)
  for i, data in pairs(gateBuildingDataList) do
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
    if buildTemplate then
      for effectId, effectValue in pairs(buildTemplate.building_effect_last) do
        if DataCenter.LWEffectOverviewManager:IsContainsSourcePointData(EffectOverviewSourcePoint.Building, effectId) then
          DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Building, effectId, effectValue)
        end
      end
    end
  end
end

return LWEffectSourceTypeBuildingLogic
