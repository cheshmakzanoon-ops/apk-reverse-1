local TacticalChipFactoryManager = BaseClass("TacticalChipFactoryManager")
local TWSkillChipTemplate = require("DataCenter.TacticalWeapon.TWSkillChipTemplateManager.TWSkillChipTemplate")

function TacticalChipFactoryManager:__init()
  self.bagChipList = {}
  self.canProductChipTemplateData = {}
  self.chipTemplateDic = {}
end

function TacticalChipFactoryManager:__delete()
  self.bagChipList = nil
  self.canProductChipTemplateData = nil
  self.chipTemplateDic = nil
end

function TacticalChipFactoryManager:GetFactoryStatus(buildingUuid)
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(buildingUuid)
  if buildingData == nil then
    return TacticalChipFactoryStatus.None
  end
  local isCrafting = BuildingUtils.IsBuildingFunctioning(buildingData)
  if not isCrafting then
    return TacticalChipFactoryStatus.Idle
  end
  local isFinish = BuildingUtils.IsBuildingFinishFunctioning(buildingData)
  if isFinish then
    return TacticalChipFactoryStatus.CanGetChip
  else
    return TacticalChipFactoryStatus.Working
  end
  Logger.LogError("amazing!!!!  not exist status!")
  return TacticalChipFactoryStatus.None
end

function TacticalChipFactoryManager:GetCanDecomposeChipDataList(heroType)
  local resultList = {}
  local chipList = DataCenter.TWSkillChipManager:GetAllChips()
  for _, v in pairs(chipList) do
    if v:IsFree() and v:GetQuality() > 3 and v:GetHeroType() == heroType then
      table.insert(resultList, v)
    end
  end
  return resultList
end

function TacticalChipFactoryManager:GetCanProductChipTemplateList(heroType)
  local data = self.canProductChipTemplateData
  if not data.listMap then
    local listMap = {}
    listMap[HeroType.Tank] = {}
    listMap[HeroType.Missile] = {}
    listMap[HeroType.Aircraft] = {}
    LocalController:instance():visitTable(TableName.LW_Drone_Skill, function(id, lineData)
      if lineData ~= nil then
        local template = TWSkillChipTemplate.New()
        template:InitData(lineData)
        if lineData.craft_time > 0 and 0 < lineData.craft_factory_level and listMap[lineData.heroType] then
          table.insert(listMap[lineData.heroType], template)
        end
        self.chipTemplateDic[id] = template
      end
    end)
    for i, v in pairs(listMap) do
      table.sort(v, function(a, b)
        return self:SortCanProductChip(a, b)
      end)
    end
    data.listMap = listMap
    self.canProductChipTemplateList = data
  end
  return data.listMap[heroType] or {}
end

function TacticalChipFactoryManager:GetChipTemplate(id)
  if self.chipTemplateDic[id] == nil then
    local lineData = LocalController:instance():getLine(TableName.LW_Drone_Skill, id)
    if lineData ~= nil then
      local item = TWSkillChipTemplate.New()
      item:InitData(lineData)
      self.chipTemplateDic[id] = item
    end
  end
  return self.chipTemplateDic[id]
end

function TacticalChipFactoryManager:GetChipsData(chipType, sortType)
  local count = #self.bagChipList
  if 0 < count then
    for i = 1, count do
      self.bagChipList[i] = nil
    end
  end
  local allChips
  if chipType == 0 then
    allChips = DataCenter.TWSkillChipManager:GetAllChips()
  else
    allChips = DataCenter.TWSkillChipManager:GetChipsByHeroType(chipType)
  end
  if not allChips then
    return self.bagChipList
  end
  local index = 1
  for k, v in pairs(allChips) do
    self.bagChipList[index] = v
    index = index + 1
  end
  if sortType == TacticalChipBagSortType.ChipType then
    table.sort(self.bagChipList, function(a, b)
      return self:SortByType(a, b)
    end)
  elseif sortType == TacticalChipBagSortType.Star then
    table.sort(self.bagChipList, function(a, b)
      return self:SortByStar(a, b)
    end)
  elseif sortType == TacticalChipBagSortType.Quality then
    table.sort(self.bagChipList, function(a, b)
      return self:SortByQuality(a, b)
    end)
  end
  return self.bagChipList
end

function TacticalChipFactoryManager:SortCanProductChip(a, b)
  if a.craft_factory_level ~= b.craft_factory_level then
    return a.craft_factory_level < b.craft_factory_level
  end
  if a.skill_type ~= b.skill_type then
    return a.skill_type < b.skill_type
  end
  return a.id < b.id
end

function TacticalChipFactoryManager:SortByType(a, b)
  local aType = a:GetType()
  local bType = b:GetType()
  if aType ~= bType then
    return aType < bType
  end
  local aQuality = a:GetQuality()
  local bQuality = b:GetQuality()
  if aQuality ~= bQuality then
    return aQuality > bQuality
  end
  local aStar = a:GetStar()
  local bStar = b:GetStar()
  if aStar ~= bStar then
    return aStar > bStar
  end
  local aId = a:GetId()
  local bId = b:GetId()
  if aId ~= bId then
    return aId < bId
  end
  return a:GetUUID() < b:GetUUID()
end

function TacticalChipFactoryManager:SortByStar(a, b)
  local aStar = a:GetStar()
  local bStar = b:GetStar()
  if aStar ~= bStar then
    return aStar > bStar
  end
  local aQuality = a:GetQuality()
  local bQuality = b:GetQuality()
  if aQuality ~= bQuality then
    return aQuality > bQuality
  end
  local aType = a:GetType()
  local bType = b:GetType()
  if aType ~= bType then
    return aType < bType
  end
  local aId = a:GetId()
  local bId = b:GetId()
  if aId ~= bId then
    return aId < bId
  end
  return a:GetUUID() < b:GetUUID()
end

function TacticalChipFactoryManager:SortByQuality(a, b)
  local aQuality = a:GetQuality()
  local bQuality = b:GetQuality()
  if aQuality ~= bQuality then
    return aQuality > bQuality
  end
  local aStar = a:GetStar()
  local bStar = b:GetStar()
  if aStar ~= bStar then
    return aStar > bStar
  end
  local aType = a:GetType()
  local bType = b:GetType()
  if aType ~= bType then
    return aType < bType
  end
  local aId = a:GetId()
  local bId = b:GetId()
  if aId ~= bId then
    return aId < bId
  end
  return a:GetUUID() < b:GetUUID()
end

function TacticalChipFactoryManager:GetAvailableChipNum(id)
  local allChips = DataCenter.TWSkillChipManager:GetAllChips()
  local number = 0
  for _, chip in pairs(allChips) do
    if chip:GetId() == id and chip:IsFree() and chip:GetStar() == 0 then
      number = number + chip:GetNum()
    end
  end
  return number
end

return TacticalChipFactoryManager
