local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeSeasonBuildingLogic = BaseClass("LWEffectSourceTypeSeasonBuildingLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeSeasonBuildingLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeSeasonBuildingLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeSeasonBuildingLogic:RefreshData()
  self:RecalculateData()
end

function LWEffectSourceTypeBaseLogic:AddEffectList(list, KeySeasonBuilding)
  if not list or not KeySeasonBuilding then
    return
  end
  for _, stateId in pairs(list) do
    local meta = LocalController:instance():getLine(TableName.StatusTab, stateId)
    if meta then
      self:AddEffects(meta.effect, meta.effect_num, KeySeasonBuilding)
    end
  end
end

function LWEffectSourceTypeBaseLogic:AddEffects(effect, effect_num, KeySeasonBuilding)
  if not effect or not effect_num then
    return
  end
  local effectKeyList = string.split_ii_array(effect, "|")
  local effectValueList = string.split_ff_array(effect_num, "|")
  if effectKeyList and effectValueList then
    for index, effectId in ipairs(effectKeyList) do
      local nEffectId = toInt(effectId)
      local theEffectValue = tonumber(effectValueList[index])
      if nEffectId ~= 0 and theEffectValue ~= nil and DataCenter.LWEffectOverviewManager:IsContainsSourcePointData(KeySeasonBuilding, nEffectId) then
        DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(KeySeasonBuilding, nEffectId, theEffectValue)
      end
    end
  end
end

function LWEffectSourceTypeSeasonBuildingLogic:RecalculateData()
  local KeySeasonBuilding = EffectOverviewSourcePoint.SeasonBuilding
  local mgrEffect = DataCenter.LWEffectOverviewManager
  mgrEffect:ResetEffectSourceTotalValue(KeySeasonBuilding)
  if SeasonUtil.IsInSeason() then
    local allBuildingData = DataCenter.BuildManager:GetAllBuildData()
    if allBuildingData then
      for uuid, buildingData in pairs(allBuildingData) do
        local meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingData.itemId, buildingData.level)
        if meta and meta.building_effect_last and (meta.tab_type == UIBuildListTabType.SeasonBuild or meta.tab_type == UIBuildListTabType.SeasonCityBuild) then
          for effectId, effectValue in pairs(meta.building_effect_last) do
            local nEffectId = toInt(effectId)
            local theEffectValue = tonumber(effectValue)
            if nEffectId ~= 0 and theEffectValue ~= nil and mgrEffect:IsContainsSourcePointData(KeySeasonBuilding, nEffectId) then
              mgrEffect:RefreshEffectSourceTotalValue(KeySeasonBuilding, nEffectId, theEffectValue)
            end
          end
        end
      end
    end
    local effectList = DataCenter.SeasonFarmerManager:GetCityAttachmentEffectInfo()
    if effectList and effectList.effect then
      for effectId, effectValue in pairs(effectList.effect) do
        local nEffectId = toInt(effectId)
        local theEffectValue = tonumber(effectValue)
        if nEffectId ~= 0 and theEffectValue ~= nil and mgrEffect:IsContainsSourcePointData(KeySeasonBuilding, nEffectId) then
          mgrEffect:RefreshEffectSourceTotalValue(KeySeasonBuilding, nEffectId, theEffectValue)
        end
      end
    end
    if effectList and effectList.state then
      for _, stateId in pairs(effectList.state) do
        local meta = LocalController:instance():getLine(TableName.StatusTab, stateId)
        if meta and meta.effect and meta.effect_num then
          local effectKeyList = string.split_ii_array(meta.effect, "|")
          local effectValueList = string.split_ff_array(meta.effect_num, "|")
          if effectKeyList and effectValueList then
            for index, effectId in ipairs(effectKeyList) do
              local nEffectId = toInt(effectId)
              local theEffectValue = tonumber(effectValueList[index])
              if nEffectId ~= 0 and theEffectValue ~= nil and mgrEffect:IsContainsSourcePointData(KeySeasonBuilding, nEffectId) then
                mgrEffect:RefreshEffectSourceTotalValue(KeySeasonBuilding, nEffectId, theEffectValue)
              end
            end
          end
        end
      end
    end
    if SeasonUtil.InSeasonBigMapMode(LuaEntry.Player:GetSourceServerId()) then
      local coffeeStateList = DataCenter.MakingCoffeeManager:GetAllActiveStatus()
      self:AddEffectList(coffeeStateList, KeySeasonBuilding)
    end
    local seasonType = SeasonUtil.GetSeasonType(false, true)
    if seasonType == SeasonMapType.NineNationRainforest then
      local s6MilitaryStatus = DataCenter.SeasonMilitaryManager:GetCurLevelStatusList()
      if not table.IsNullOrEmpty(s6MilitaryStatus) then
        self:AddEffectList(s6MilitaryStatus, KeySeasonBuilding)
      end
    end
    local seasonEffects = DataCenter.SeasonCallbackManager:GetAllActiveEffects()
    if seasonEffects then
      for _, item in ipairs(seasonEffects) do
        self:AddEffects(item.effect, item.effect_num, KeySeasonBuilding)
      end
    end
    local GlobalState = DataCenter.SeasonDataManager:GetGlobalStatus()
    if GlobalState then
      for k, v in pairs(GlobalState) do
        if v and v.effects and v.reason and v.stateId then
          for _, effect in pairs(v.effects) do
            if effect.eff and effect.val then
              local nEffectId = toInt(effect)
              local theEffectValue = tonumber(effect.eff)
              if nEffectId ~= 0 and theEffectValue ~= nil and mgrEffect:IsContainsSourcePointData(KeySeasonBuilding, nEffectId) then
                mgrEffect:RefreshEffectSourceTotalValue(KeySeasonBuilding, nEffectId, theEffectValue)
              end
            end
          end
        end
      end
    end
    local lightBuffDict = DataCenter.SeasonLightDataManager:GetAllLightBuff()
    if lightBuffDict then
      for k1, v1 in pairs(lightBuffDict) do
        if v1 and v1.effects then
          for k2, v2 in pairs(v1.effects) do
            if v2.eff and v2.val then
              mgrEffect:RefreshEffectSourceTotalValue(KeySeasonBuilding, v2.eff, v2.val)
            end
          end
        end
      end
    end
  end
end

return LWEffectSourceTypeSeasonBuildingLogic
