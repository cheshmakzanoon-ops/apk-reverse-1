local base = ArmyFormationInfo
local ArenaArmyFormationInfo = BaseClass("ArenaArmyFormationInfo", ArmyFormationInfo)

local function __init(self)
  base.__init(self)
  self.squadNo = 0
  self.heroDataMap = {}
  self.localSquadNo = 0
  self.skillChipArr = {}
  self.dominatorData = nil
end

local function __delete(self)
  base.__delete(self)
  self.squadNo = nil
  self.heroDataMap = nil
  self.localSquadNo = nil
  self.skillChipArr = nil
end

local function ConscriptSoldier(self)
  self.soldiers = {}
  self.totalSupply = 0
  self.totalSoldierCapacity = 0
  self.totalSoldierBurden = 0
  self.totalSoldierNum = 0
  if table.IsNullOrEmpty(self.localHeroes) then
    return
  end
  if not self.soldierType then
    return
  end
  local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(self.soldierType)
  if soldierMeta == nil then
    return
  end
  for uuid, index in pairs(self.localHeroes) do
    self.soldiers[index] = {}
    self.soldiers[index].supply = 0
    local heroInfo = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    local leaderShip = 0
    if heroInfo then
      leaderShip = heroInfo:GetSoldierCapacity()
    else
      local heroData = self.heroDataMap[uuid]
      if heroData then
        leaderShip = heroData.effect_50079
        if leaderShip == nil then
          return
        end
      end
    end
    self.soldiers[index].heroLeaderShip = leaderShip
  end
  if self.localDominatorUuid then
    local leaderShip = 0
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(self.localDominatorUuid)
    if dominatorInfo then
      leaderShip = dominatorInfo:GetSoldierCapacity()
    else
      local dominatorData = self.dominatorData
      if dominatorData then
        leaderShip = dominatorData.effect_50079
        if leaderShip == nil then
          return
        end
      end
    end
    self.soldiers[ArmyFormationSlot.Dominator] = {}
    self.soldiers[ArmyFormationSlot.Dominator].supply = 0
    self.soldiers[ArmyFormationSlot.Dominator].heroLeaderShip = leaderShip
  end
  
  local function CalculateSoldier(index)
    local leaderShip = self.soldiers[index].heroLeaderShip
    local needCount = math.floor(leaderShip)
    if needCount <= 0 then
      return
    end
    local soldierNumUsed = needCount
    if 0 < soldierNumUsed then
      self.soldiers[index][soldierMeta.id] = soldierNumUsed
      local supply = soldierNumUsed
      local capacity = DataCenter.SoldierDataManager:CalcSoldierPower(soldierMeta, soldierNumUsed)
      local burden = soldierMeta.burden * soldierNumUsed
      self.soldiers[index].supply = supply
      self.totalSupply = self.totalSupply + supply
      self.totalSoldierCapacity = self.totalSoldierCapacity + capacity
      self.totalSoldierBurden = self.totalSoldierBurden + burden
      self.totalSoldierNum = self.totalSoldierNum + soldierNumUsed
    end
  end
  
  for _, index in pairs(self.localHeroes) do
    CalculateSoldier(index)
  end
  if self.localDominatorUuid then
    CalculateSoldier(ArmyFormationSlot.Dominator)
  end
  self.totalSoldierCapacity = self.totalSoldierCapacity + T11Util.GetAttributePower()
end

local function ParseData(self, message)
  base.ParseData(self, message)
  if message == nil then
    return
  end
  if message.heroes ~= nil then
    self.heroDataMap = {}
    self.dominatorData = nil
    table.walk(message.heroes, function(k, v)
      local index = v.index
      if index == nil then
        index = k
      end
      if index == ArmyFormationSlot.Dominator then
        self.dominatorData = v
      else
        local heroUuid = v.heroUuid
        self.heroDataMap[heroUuid] = v
      end
    end)
  end
  if message.squadNo ~= nil then
    self.squadNo = message.squadNo
    self.localSquadNo = self.squadNo
  end
  if message.soldierType then
    self.soldierType = message.soldierType
    self:ConscriptSoldier()
  else
    self:RecalculateMaxLevelSoldier()
  end
  if message.skillChipArr then
    self.skillChipArr = message.skillChipArr
  end
end

local function GetHeroesCapacity(self)
  local ret = 0
  for k, v in pairs(self.localHeroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
    if heroData then
      ret = ret + toInt(heroData.power)
    else
      heroData = self.heroDataMap[k]
      if heroData then
        ret = ret + toInt(heroData.power)
      end
    end
  end
  return ret
end

function ArenaArmyFormationInfo:GetDominatorsCapacity()
  local ret = 0
  if self.localDominatorUuid then
    local dominatorData = DataCenter.DominatorManager:GetInfoByUuid(self.localDominatorUuid)
    if dominatorData then
      ret = ret + toInt(dominatorData.power)
    elseif self.dominatorData then
      ret = ret + toInt(self.dominatorData.power)
    end
  end
  return ret
end

local function GetHeroDataByUuid(self, uuid)
  return self.heroDataMap[uuid]
end

local function GetDominatorData(self)
  return self.dominatorData
end

local function CheckLoacalRemoteDiff(self)
  local diff = base.CheckLoacalRemoteDiff(self)
  diff = diff or self.squadNo ~= self.localSquadNo
  return diff
end

local function GetTotalCapacity(self)
  self:ConscriptSoldier()
  return self:GetHeroesCapacity() + self:GetSoldiersCapacity() + self:GetEquipCapacity() + self:GetTWSkillChipCapacity() + self:GetDominatorsCapacity()
end

local function GetParkingTotalCapacity(self)
  local heroes = self:GetLocalAllHeroes()
  local totalCombatPower = 0
  for i = 1, 5 do
    local hasHero = heroes[i] ~= nil
    if hasHero then
      local heroUuid = heroes[i]
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData ~= nil then
        totalCombatPower = totalCombatPower + heroData.power
      end
    end
  end
  totalCombatPower = totalCombatPower + self:GetEquipCapacity() + self:GetTWSkillChipCapacity() + self:GetVirtualConscriptSoldierPower()
  return totalCombatPower
end

local function SetHighestSolderData(self, highestSolderId)
  self.soldierType = highestSolderId
end

function ArenaArmyFormationInfo:RecalculateMaxLevelSoldier()
  local maxLevelSoldier = DataCenter.SoldierDataManager:GetCanTrainHighestLevelSoldier()
  if maxLevelSoldier then
    self.soldierType = maxLevelSoldier.id
    self:ConscriptSoldier()
  end
end

ArenaArmyFormationInfo.__init = __init
ArenaArmyFormationInfo.__delete = __delete
ArenaArmyFormationInfo.ParseData = ParseData
ArenaArmyFormationInfo.GetHeroDataByUuid = GetHeroDataByUuid
ArenaArmyFormationInfo.GetDominatorData = GetDominatorData
ArenaArmyFormationInfo.CheckLoacalRemoteDiff = CheckLoacalRemoteDiff
ArenaArmyFormationInfo.GetHeroesCapacity = GetHeroesCapacity
ArenaArmyFormationInfo.GetTotalCapacity = GetTotalCapacity
ArenaArmyFormationInfo.ConscriptSoldier = ConscriptSoldier
ArenaArmyFormationInfo.SetHighestSolderData = SetHighestSolderData
ArenaArmyFormationInfo.GetParkingTotalCapacity = GetParkingTotalCapacity
return ArenaArmyFormationInfo
