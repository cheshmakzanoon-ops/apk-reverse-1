local LWDevelopRecommendPowerConfigTemplate = BaseClass("LWDevelopRecommendPowerConfigTemplate")

function LWDevelopRecommendPowerConfigTemplate:__init()
  self.id = 0
  self.level = 0
  self.dayRange = ""
  self.totalPower = 0
  self.heroLevel = 0
  self.heroStar = 0
  self.heroSkill = 0
  self.heroEquip = 0
  self.decoration = 0
  self.honor = 0
  self.skillChips = 0
  self.decoration = 0
  self.droneEquip = 0
  self.droneLevel = 0
  self.soldier = 0
  self.science = 0
  self.worker = 0
  self.building = 0
  self.minOpenDay = 0
  self.maxOpenDay = 0
end

function LWDevelopRecommendPowerConfigTemplate:__delete()
  self.id = nil
  self.level = nil
  self.dayRange = nil
  self.totalPower = nil
  self.heroLevel = nil
  self.heroStar = nil
  self.heroSkill = nil
  self.heroEquip = nil
  self.decoration = nil
  self.honor = nil
  self.skillChips = nil
  self.decoration = nil
  self.droneEquip = nil
  self.droneLevel = nil
  self.soldier = nil
  self.science = nil
  self.worker = nil
  self.building = nil
  self.minOpenDay = nil
  self.maxOpenDay = nil
end

function LWDevelopRecommendPowerConfigTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id")
  self.level = row:getValue("hqLevel")
  self.dayRange = row:getValue("dayRange") or ""
  self.totalPower = row:getValue("totalPower")
  self.heroLevel = row:getValue("heroLevel")
  self.heroStar = row:getValue("heroStar")
  self.heroSkill = row:getValue("heroSkill")
  self.heroEquip = row:getValue("heroEquip")
  self.decoration = row:getValue("decoration")
  self.honor = row:getValue("honor")
  self.skillChips = row:getValue("skillChips")
  self.droneEquip = row:getValue("droneEquip")
  self.droneLevel = row:getValue("droneLevel")
  self.soldier = row:getValue("soldier")
  self.science = row:getValue("science")
  self.worker = row:getValue("worker")
  self.building = row:getValue("building")
  if self.level ~= nil then
    local strs = string.split(self.dayRange, ",")
    if strs ~= nil and 2 <= #strs then
      self.minOpenDay = checknumber(strs[1])
      self.maxOpenDay = checknumber(strs[2])
    end
  end
end

function LWDevelopRecommendPowerConfigTemplate:IsHqLevelValid(level)
  return checknumber(self.level) == level
end

function LWDevelopRecommendPowerConfigTemplate:IsServerOpenDayValid(openDay)
  return openDay >= checknumber(self.minOpenDay) and openDay <= checknumber(self.maxOpenDay)
end

function LWDevelopRecommendPowerConfigTemplate:GetRecommendPowerValue(sourceType)
  if sourceType == PowerOverviewPowerSourceType.heroLevelPower then
    return self.heroLevel
  elseif sourceType == PowerOverviewPowerSourceType.heroRankPower then
    return self.heroStar
  elseif sourceType == PowerOverviewPowerSourceType.heroSkillPower then
    return self.heroSkill
  elseif sourceType == PowerOverviewPowerSourceType.heroEquipPower then
    return self.heroEquip
  elseif sourceType == PowerOverviewPowerSourceType.heroDecoPower then
    return self.decoration
  elseif sourceType == PowerOverviewPowerSourceType.heroHonorPower then
    return self.honor
  elseif sourceType == PowerOverviewPowerSourceType.weaponChipPower then
    return self.skillChips
  elseif sourceType == PowerOverviewPowerSourceType.weaponEquipPower then
    return self.droneEquip
  elseif sourceType == PowerOverviewPowerSourceType.weaponLevelPower then
    return self.droneLevel
  elseif sourceType == PowerOverviewPowerSourceType.armyPower then
    return self.soldier
  elseif sourceType == PowerOverviewPowerSourceType.sciencePower then
    return self.science
  elseif sourceType == PowerOverviewPowerSourceType.buildingWorkerPower then
    return self.worker
  elseif sourceType == PowerOverviewPowerSourceType.buildingDecoPower then
    return self.building
  elseif sourceType == PowerOverviewPowerSourceType.playerPower then
    return self.totalPower
  end
  return -1
end

function LWDevelopRecommendPowerConfigTemplate:IsShowInRecommendGuide(sourceType)
  if sourceType == PowerOverviewPowerSourceType.playerPower then
    return false
  end
  local recommendValue = self:GetRecommendPowerValue(sourceType)
  return checknumber(recommendValue) > 0
end

function LWDevelopRecommendPowerConfigTemplate:IsShowInRecommendRate(sourceType)
  local recommendValue = self:GetRecommendPowerValue(sourceType)
  return checknumber(recommendValue) > 0
end

return LWDevelopRecommendPowerConfigTemplate
