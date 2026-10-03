local UnitManager = BaseClass("UnitManager")
local ALL_TYPES = {
  [1] = UnitType.Zombie,
  [2] = UnitType.Member,
  [3] = UnitType.Junk,
  [4] = UnitType.Plot,
  [5] = UnitType.TacticalWeapon,
  [6] = UnitType.Pet
}

function UnitManager:__init(battleMgr)
  self.battleMgr = battleMgr
  self.units = {}
  self.unitsByType = {}
  self.unitsByType[UnitType.Zombie] = {}
  self.unitsByType[UnitType.Member] = {}
  self.unitsByType[UnitType.Junk] = {}
  self.unitsByType[UnitType.Plot] = {}
  self.unitsByType[UnitType.TacticalWeapon] = {}
  self.unitsByType[UnitType.Pet] = {}
  self.morgueUnits = {}
  self.countDown = 1
  self.unitsBySearchType = {}
  self.tauntUnitsBySearchType = nil
end

function UnitManager:__delete()
  self:Destroy()
end

function UnitManager:Destroy()
  for _, v in pairs(self.units) do
    self:RemoveUnit(v)
  end
  for _, v in pairs(self.morgueUnits) do
    v:DestroyData()
  end
  self.morgueUnits = {}
end

function UnitManager:AddUnit(unit)
  self.units[unit.guid] = unit
  self.unitsByType[unit.unitType][unit.guid] = unit
  if unit.searchType then
    if not self.unitsBySearchType[unit.searchType] then
      self.unitsBySearchType[unit.searchType] = {}
    end
    self.unitsBySearchType[unit.searchType][unit.guid] = unit
  end
end

function UnitManager:AddGlobalTauntUnit(unit)
  local unitSearchType = unit.searchType
  if unitSearchType then
    if self.tauntUnitsBySearchType == nil then
      self.tauntUnitsBySearchType = {}
    end
    if not self.tauntUnitsBySearchType[unitSearchType] then
      self.tauntUnitsBySearchType[unitSearchType] = {}
    end
    self.tauntUnitsBySearchType[unitSearchType][unit.guid] = unit
  end
end

function UnitManager:RemoveUnit(unit)
  local unitGuid = unit.guid
  if self.units[unitGuid] then
    self.units[unitGuid] = nil
    self.unitsByType[unit.unitType][unitGuid] = nil
    if self.tauntUnitsBySearchType then
      local unitSearchType = unit.searchType
      if unitSearchType and self.tauntUnitsBySearchType[unitSearchType] then
        self.tauntUnitsBySearchType[unitSearchType][unitGuid] = nil
      end
    end
    if DataCenter.LWBattleManager:IsOpenReturnOpt() and unit.searchType and self.unitsBySearchType[unit.searchType] then
      self.unitsBySearchType[unit.searchType][unitGuid] = nil
    end
    unit:DestroyView()
    table.insert(self.morgueUnits, unit)
  end
end

function UnitManager:RemoveUnitTotal(unit)
  local unitGuid = unit.guid
  if self.units[unitGuid] then
    self.units[unitGuid] = nil
    self.unitsByType[unit.unitType][unitGuid] = nil
    if self.tauntUnitsBySearchType then
      local unitSearchType = unit.searchType
      if unitSearchType and self.tauntUnitsBySearchType[unitSearchType] then
        self.tauntUnitsBySearchType[unitSearchType][unitGuid] = nil
      end
    end
    if DataCenter.LWBattleManager:IsOpenReturnOpt() and unit.searchType and self.unitsBySearchType[unit.searchType] then
      self.unitsBySearchType[unit.searchType][unitGuid] = nil
    end
    unit:DestroyView()
    unit:DestroyData()
    ObjectPool:GetInstance():Save(unit)
  end
end

function UnitManager:OnUpdate()
  local deltaTime = Time.deltaTime
  for _, v in pairs(self.units) do
    v:OnUpdate(deltaTime)
  end
  self.countDown = self.countDown - deltaTime
  if self.countDown < 0 then
    self.countDown = 1
    for i = #self.morgueUnits, 1, -1 do
      local unit = self.morgueUnits[i]
      if unit.morgueDuration >= 3 then
        table.remove(self.morgueUnits, i)
        unit:DestroyData()
        ObjectPool:GetInstance():Save(unit)
      else
        unit.morgueDuration = unit.morgueDuration + 1
      end
    end
  end
end

function UnitManager:RemoveAllUnitByType(type)
  for _, v in pairs(self.unitsByType[type]) do
    self:RemoveUnit(v)
  end
end

function UnitManager:RemoveUnitById(id)
  local unit = self.units[id]
  if unit then
    self:RemoveUnit(unit)
  end
end

function UnitManager:RemoveUnitTotalById(id)
  local unit = self.units[id]
  if unit then
    self:RemoveUnitTotal(unit)
  end
end

function UnitManager:GetUnit(id)
  return self.units[id]
end

function UnitManager:GetAllZombie()
  return self.unitsByType[UnitType.Zombie]
end

function UnitManager:GetAllMember()
  return self.unitsByType[UnitType.Member]
end

function UnitManager:GetAllJunk()
  return self.unitsByType[UnitType.Junk]
end

function UnitManager:ForceFinishFlash()
  for _, unit in pairs(self.units) do
    unit:ForceFinishFlash()
  end
end

local ALL_SEARCH_TYPES

local function GetAllSearchTypes()
  if ALL_SEARCH_TYPES == nil then
    ALL_SEARCH_TYPES = {}
    for _, searchType in pairs(BattleSearchType) do
      if searchType ~= BattleSearchType.All then
        table.insert(ALL_SEARCH_TYPES, searchType)
      end
    end
  end
  return ALL_SEARCH_TYPES
end

function UnitManager:GetAllUnitsBySearchTypes(searchTypes, exclusions)
  local ret = {}
  for _, searchType in ipairs(GetAllSearchTypes()) do
    if 0 < searchTypes & searchType and self.unitsBySearchType[searchType] then
      for _, unit in pairs(self.unitsBySearchType[searchType]) do
        if 0 < unit:GetCurBlood() and (not exclusions or not exclusions[unit.guid]) then
          table.insert(ret, unit)
        end
      end
    end
  end
  return ret
end

function UnitManager:GetNearestUnitBySearchTypes(searchTypes, center, exclusions)
  local nearest
  local minDist = IntMaxValue
  for _, searchType in ipairs(GetAllSearchTypes()) do
    if 0 < searchTypes & searchType and self.unitsBySearchType[searchType] then
      for _, unit in pairs(self.unitsBySearchType[searchType]) do
        if 0 < unit:GetCurBlood() and (not exclusions or not exclusions[unit.guid]) and not unit:IsUntargetable() then
          local dist = Vector3.ManhattanDistanceXZ(center, unit:GetPosition())
          if minDist > dist then
            minDist = dist
            nearest = unit
          end
        end
      end
    end
  end
  return nearest
end

function UnitManager:GetNearestUnitBySearchTypesIncludesNav(searchTypes, center, exclusions, attackRange)
  local nearest
  local minDist = IntMaxValue
  for _, searchType in ipairs(GetAllSearchTypes()) do
    if 0 < searchTypes & searchType and self.unitsBySearchType[searchType] then
      for _, unit in pairs(self.unitsBySearchType[searchType]) do
        if 0 < unit:GetCurBlood() and (not exclusions or not exclusions[unit.guid]) and not unit:IsUntargetable() then
          local dist = Vector3.ManhattanDistanceXZ(center, unit:GetPosition())
          if minDist > dist then
            minDist = dist
            nearest = unit
          end
        end
      end
    end
  end
  if nearest then
    local centerIsInWallArea = self.battleMgr:IsPointInWallArea(center)
    local targetIsInWallArea = self.battleMgr:IsPointInWallArea(nearest:GetPosition())
    local isNotSameSide = centerIsInWallArea ~= targetIsInWallArea
    if isNotSameSide then
      local buildingUnit
      if targetIsInWallArea then
        buildingUnit = self.battleMgr:GetNearestDoor(center)
      else
        buildingUnit = self.battleMgr:GetNearestDoor(nearest:GetPosition())
      end
      if buildingUnit then
        local distance = Vector3.Distance(center, buildingUnit:GetPosition())
        local skillRange = attackRange or 0
        if 0 < distance - skillRange then
          return buildingUnit
        end
      end
    end
  end
  return nearest
end

function UnitManager:GetRandomUnitBySearchTypes(searchTypes, exclusions)
  local randomPool = {}
  for _, searchType in ipairs(GetAllSearchTypes()) do
    if 0 < searchTypes & searchType and self.unitsBySearchType[searchType] then
      for _, unit in pairs(self.unitsBySearchType[searchType]) do
        if 0 < unit:GetCurBlood() and (not exclusions or not exclusions[unit.guid]) and not unit:IsUntargetable() then
          table.insert(randomPool, unit)
        end
      end
    end
  end
  local totalNum = #randomPool
  if totalNum <= 0 then
    return nil
  end
  local rand = math.random(totalNum)
  return randomPool[rand]
end

function UnitManager:GetFarthestUnitBySearchTypes(searchTypes, center, exclusions)
  local farthest
  local maxDist = 0
  for _, searchType in ipairs(GetAllSearchTypes()) do
    if 0 < searchTypes & searchType and self.unitsBySearchType[searchType] then
      for _, unit in pairs(self.unitsBySearchType[searchType]) do
        if 0 < unit:GetCurBlood() and (not exclusions or not exclusions[unit.guid]) and not unit:IsUntargetable() then
          local dist = Vector3.ManhattanDistanceXZ(center, unit:GetPosition())
          if maxDist < dist then
            maxDist = dist
            farthest = unit
          end
        end
      end
    end
  end
  return farthest
end

function UnitManager:GetLowestHPUnitBySearchTypes(searchTypes, exclusions)
  local lowest
  local lowestHP = IntMaxValue
  for _, searchType in ipairs(GetAllSearchTypes()) do
    if 0 < searchTypes & searchType and self.unitsBySearchType[searchType] then
      for _, unit in pairs(self.unitsBySearchType[searchType]) do
        if (not exclusions or not exclusions[unit.guid]) and not unit:IsUntargetable() then
          local curHP = unit:GetCurBlood()
          if 0 < curHP and lowestHP > curHP then
            lowestHP = curHP
            lowest = unit
          end
        end
      end
    end
  end
  return lowest
end

function UnitManager:GetHighestMaxHPUnitBySearchTypes(searchTypes, exclusions)
  local highest
  local highestHP = 0
  for _, searchType in ipairs(GetAllSearchTypes()) do
    if 0 < searchTypes & searchType and self.unitsBySearchType[searchType] then
      for _, unit in pairs(self.unitsBySearchType[searchType]) do
        if (not exclusions or not exclusions[unit.guid]) and not unit:IsUntargetable() then
          local curHP = unit:GetCurBlood()
          if 0 < curHP then
            local maxHp = unit:GetMaxBlood()
            if highestHP < maxHp then
              highestHP = maxHp
              highest = unit
            end
          end
        end
      end
    end
  end
  return highest
end

function UnitManager:GetHighestPropertyUnitBySearchTypes(searchTypes, exclusions, propertyType)
  local highest
  local highestProperty = 0
  for _, searchType in ipairs(GetAllSearchTypes()) do
    if 0 < searchTypes & searchType and self.unitsBySearchType[searchType] then
      for _, unit in pairs(self.unitsBySearchType[searchType]) do
        if (not exclusions or not exclusions[unit.guid]) and not unit:IsUntargetable() and 0 < unit:GetCurBlood() then
          local property = unit:GetProperty(propertyType)
          if highestProperty < property then
            highestProperty = property
            highest = unit
          end
        end
      end
    end
  end
  return highest
end

function UnitManager:GetHighestBuffCountUnitBySearchTypes(searchTypes, exclusions, buffIdList)
  local highest
  local highestBuffCount = 0
  if not table.IsNullOrEmpty(buffIdList) then
    for _, searchType in ipairs(GetAllSearchTypes()) do
      if 0 < searchTypes & searchType and self.unitsBySearchType[searchType] then
        for _, unit in pairs(self.unitsBySearchType[searchType]) do
          if (not exclusions or not exclusions[unit.guid]) and not unit:IsUntargetable() and 0 < unit:GetCurBlood() then
            local buffCountTotal = 0
            for _, buffId in ipairs(buffIdList) do
              local buffCount = unit:GetBuffLevel(buffId)
              buffCountTotal = buffCountTotal + buffCount
            end
            if highest == nil or highestBuffCount < buffCountTotal then
              highestBuffCount = buffCountTotal
              highest = unit
            end
          end
        end
      end
    end
  end
  return highest
end

function UnitManager:GetGlobalTauntUnitBySearchTypes(searchTypes, exclusions)
  if not self.tauntUnitsBySearchType then
    return
  end
  for _, searchType in ipairs(GetAllSearchTypes()) do
    if 0 < searchTypes & searchType and self.tauntUnitsBySearchType[searchType] then
      for _, unit in pairs(self.tauntUnitsBySearchType[searchType]) do
        if (not exclusions or not exclusions[unit.guid]) and not unit:IsUntargetable() then
          local curHP = unit:GetCurBlood()
          if 0 < curHP then
            return unit
          end
        end
      end
    end
  end
  return nil
end

return UnitManager
