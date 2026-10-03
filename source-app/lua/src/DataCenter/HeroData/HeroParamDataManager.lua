local HeroParamDataManager = BaseClass("HeroParamDataManager")
local HeroParamId = {
  DefaultCriticialDamage = 12,
  DispatchQuality1HeroReturnSkillPoint = 13,
  DispatchQuality2HeroReturnSkillPoint = 14,
  DispatchQuality3HeroReturnSkillPoint = 15,
  DispatchQuality4HeroReturnSkillPoint = 16,
  DispatchQuality5HeroReturnSkillPoint = 17,
  DispatchHeroReturnSkillPointRatio = 18,
  DispatchHeroReturnExpRatio = 19,
  FreeResetWeaponCdTime = 20,
  CommonHeroFragmentId = 21,
  ResetWeaponItemId = 22,
  HeroSkillPointItemId = 23,
  ChangeFateCostDiamondCount = 24,
  HpPowerFactor = 26,
  PhysicalAttackPowerFactor = 27,
  PhysicalDefensePowerFactor = 28,
  AccuracyPowerFactor = 31,
  CritPowerFactor = 32,
  HeroLevelLimitByCityLevel = 34,
  Quality1CommonHeroFragmentId = 35,
  Quality2CommonHeroFragmentId = 36,
  Quality3CommonHeroFragmentId = 37,
  Quality4CommonHeroFragmentId = 38,
  Quality5CommonHeroFragmentId = 39,
  ReturnEquipStoneRatio = 40,
  EquipHeroQualityLimit = 41,
  EquipHeroLevelLimit = 42,
  SkillPreviewStartDelay = 43,
  Hero_Skill_Preview_Properties = 44,
  EquipMainCityLevelLimit = 45
}

local function __init(self)
  self.paramDict = {}
  self.defaultCriticialDamage = 0
  self.dispatchQuality1HeroReturnSkillPoint = 0
  self.dispatchQuality2HeroReturnSkillPoint = 0
  self.dispatchQuality3HeroReturnSkillPoint = 0
  self.dispatchQuality4HeroReturnSkillPoint = 0
  self.dispatchQuality5HeroReturnSkillPoint = 0
  self.dispatchHeroReturnSkillPointRatio = 0
  self.dispatchHeroReturnExpRatio = 0
  self.freeResetWeaponCdTime = 0
  self.commonHeroFragmentId = 0
  self.resetWeaponItemId = 0
  self.heroSkillPointItemId = 0
  self.changeFateCostDiamondCount = 0
  self.hpPowerFactor = 0
  self.pAttackPowerFactor = 0
  self.pDefensePowerFactor = 0
  self.accPowerFactor = 0
  self.critPowerFactor = 0
  self.heroLevelLimitByCityLevel = 0
  self.quality1CommonHeroFragmentId = 0
  self.quality2CommonHeroFragmentId = 0
  self.quality3CommonHeroFragmentId = 0
  self.quality4CommonHeroFragmentId = 0
  self.quality5CommonHeroFragmentId = 0
  self.ReturnEquipStoneRatio = 0
  self.equipHeroQualityLimit = 0
  self.equipHeroLevelLimit = 0
  self.skillPreviewStartDelay = 0
  self.heroSkillPreviewProperties = {}
  self.equipMainCityLevelLimit = 0
  self:InitAllParam()
end

local function __delete(self)
  self.paramDict = nil
  self.defaultCriticialDamage = nil
  self.dispatchQuality1HeroReturnSkillPoint = nil
  self.dispatchQuality2HeroReturnSkillPoint = nil
  self.dispatchQuality3HeroReturnSkillPoint = nil
  self.dispatchQuality4HeroReturnSkillPoint = nil
  self.dispatchQuality5HeroReturnSkillPoint = nil
  self.dispatchHeroReturnSkillPointRatio = nil
  self.dispatchHeroReturnExpRatio = nil
  self.freeResetWeaponCdTime = nil
  self.commonHeroFragmentId = nil
  self.resetWeaponItemId = nil
  self.heroSkillPointItemId = nil
  self.changeFateCostDiamondCount = nil
  self.hpPowerFactor = nil
  self.pAttackPowerFactor = nil
  self.pDefensePowerFactor = nil
  self.accPowerFactor = nil
  self.critPowerFactor = nil
  self.physicalAttackPowerFactor = nil
  self.physicalDefensePowerFactor = nil
  self.heroLevelLimitByCityLevel = nil
  self.quality1CommonHeroFragmentId = nil
  self.quality2CommonHeroFragmentId = nil
  self.quality3CommonHeroFragmentId = nil
  self.quality4CommonHeroFragmentId = nil
  self.quality5CommonHeroFragmentId = nil
  self.qualityCommonHeroFragmentId = nil
  self.ReturnEquipStoneRatio = nil
  self.equipHeroQualityLimit = nil
  self.equipHeroLevelLimit = nil
  self.skillPreviewStartDelay = nil
  self.heroSkillPreviewProperties = nil
  self.equipMainCityLevelLimit = nil
end

local function InitAllParam(self)
  LocalController:instance():visitTable(TableName.LW_Hero_Para, function(id, lineData)
    if id == HeroParamId.DefaultCriticialDamage then
      self.defaultCriticialDamage = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.DispatchQuality1HeroReturnSkillPoint then
      self.dispatchQuality1HeroReturnSkillPoint = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.DispatchQuality2HeroReturnSkillPoint then
      self.dispatchQuality2HeroReturnSkillPoint = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.DispatchQuality3HeroReturnSkillPoint then
      self.dispatchQuality3HeroReturnSkillPoint = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.DispatchQuality4HeroReturnSkillPoint then
      self.dispatchQuality4HeroReturnSkillPoint = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.DispatchQuality5HeroReturnSkillPoint then
      self.dispatchQuality5HeroReturnSkillPoint = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.DispatchHeroReturnSkillPointRatio then
      self.dispatchHeroReturnSkillPointRatio = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.DispatchHeroReturnExpRatio then
      self.dispatchHeroReturnExpRatio = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.FreeResetWeaponCdTime then
      self.freeResetWeaponCdTime = tonumber(lineData:getValue("value")) or 0
      self.freeResetWeaponCdTime = self.freeResetWeaponCdTime * 24 * 60 * 60 * 1000
    elseif id == HeroParamId.CommonHeroFragmentId then
      self.commonHeroFragmentId = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.ResetWeaponItemId then
      self.resetWeaponItemId = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.HeroSkillPointItemId then
      self.heroSkillPointItemId = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.ChangeFateCostDiamondCount then
      self.changeFateCostDiamondCount = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.HpPowerFactor then
      self.hpPowerFactor = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.PhysicalAttackPowerFactor then
      self.pAttackPowerFactor = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.PhysicalDefensePowerFactor then
      self.pDefensePowerFactor = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.AccuracyPowerFactor then
      self.accPowerFactor = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.CritPowerFactor then
      self.critPowerFactor = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.HeroLevelLimitByCityLevel then
      self.heroLevelLimitByCityLevel = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.Quality1CommonHeroFragmentId then
      self.quality1CommonHeroFragmentId = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.Quality2CommonHeroFragmentId then
      self.quality2CommonHeroFragmentId = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.Quality3CommonHeroFragmentId then
      self.quality3CommonHeroFragmentId = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.Quality4CommonHeroFragmentId then
      self.quality4CommonHeroFragmentId = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.Quality5CommonHeroFragmentId then
      self.quality5CommonHeroFragmentId = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.ReturnEquipStoneRatio then
      self.ReturnEquipStoneRatio = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.EquipHeroQualityLimit then
      self.equipHeroQualityLimit = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.EquipHeroLevelLimit then
      self.equipHeroLevelLimit = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.SkillPreviewStartDelay then
      self.skillPreviewStartDelay = tonumber(lineData:getValue("value")) or 0
    elseif id == HeroParamId.Hero_Skill_Preview_Properties then
      local str = lineData:getValue("value") or ""
      if not string.IsNullOrEmpty(str) then
        self.heroSkillPreviewProperties = {}
        local strList = string.split(str, "|")
        for _, v in pairs(strList) do
          if not string.IsNullOrEmpty(v) then
            local property = string.split(v, ";")
            if #property == 2 then
              local propertyId = tonumber(property[1])
              local propertyValue = tonumber(property[2])
              if propertyId ~= nil and propertyValue ~= nil then
                self.heroSkillPreviewProperties[propertyId] = propertyValue
              end
            end
          end
        end
      end
    elseif id == HeroParamId.EquipMainCityLevelLimit then
      self.equipMainCityLevelLimit = tonumber(lineData:getValue("value")) or 0
    end
  end)
  self.qualityCommonHeroFragmentId = {
    [1] = self.quality1CommonHeroFragmentId,
    [2] = self.quality2CommonHeroFragmentId,
    [3] = self.quality3CommonHeroFragmentId,
    [4] = self.quality4CommonHeroFragmentId,
    [5] = self.quality5CommonHeroFragmentId
  }
end

local function GetQualityFragmentIdByQuality(self, heroData)
  local commonFragId = heroData:GetHeroCommonFragId()
  if string.IsNullOrEmpty(commonFragId) then
    return self.qualityCommonHeroFragmentId[heroData.quality]
  end
  return commonFragId
end

HeroParamDataManager.__init = __init
HeroParamDataManager.__delete = __delete
HeroParamDataManager.InitAllParam = InitAllParam
HeroParamDataManager.GetQualityFragmentIdByQuality = GetQualityFragmentIdByQuality
return HeroParamDataManager
