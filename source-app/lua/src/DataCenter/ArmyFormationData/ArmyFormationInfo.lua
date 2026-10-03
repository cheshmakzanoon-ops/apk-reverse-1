local ArmyFormationInfo = BaseClass("ArmyFormationInfo")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")

local function __init(self)
  self.uuid = 0
  self.ownerUid = ""
  self.index = 0
  self.state = 0
  self.maxNum = 0
  self.name = ""
  self.supply = {}
  self.heroes = {}
  self.slots = 0
  self.buildingUuid = 0
  self.type = 0
  self.remoteIndexToHeroDic = {}
  self.localIndexToHeroDic = {}
  self.localHeroes = {}
  self.soldiers = {}
  self.totalSupply = 0
  self.canMarch = false
  self.totalSoldierCapacity = 0
  self.totalSoldierBurden = 0
  self.totalSoldierNum = 0
  self.defencePriority = 0
  self.twSkillChipSetId = 1
  self.localChipSetId = 1
  self.dominatorUuid = nil
  self.localDominatorUuid = nil
  self.positionType = nil
end

local function __delete(self)
  self.uuid = nil
  self.ownerUid = nil
  self.index = nil
  self.state = nil
  self.maxNum = nil
  self.name = nil
  self.supply = nil
  self.heroes = nil
  self.slots = nil
  self.buildingUuid = nil
  self.type = nil
  self.remoteIndexToHeroDic = nil
  self.localIndexToHeroDic = nil
  self.localHeroes = nil
  self.soldiers = nil
  self.canMarch = nil
  self.totalSupply = nil
  self.totalSoldierCapacity = nil
  self.totalSoldierBurden = nil
  self.totalSoldierNum = nil
  self.defencePriority = nil
  self.twSkillChipSetId = nil
  self.localChipSetId = nil
  self.dominatorUuid = nil
  self.localDominatorUuid = nil
  self.positionType = nil
end

local function ParseData(self, message, isDefence)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.ownerUid ~= nil then
    self.ownerUid = message.ownerUid
  end
  if message.index ~= nil then
    self.index = message.index
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.maxNum ~= nil then
    self.maxNum = message.maxNum
  end
  if message.name ~= nil then
    self:SetName(message.name)
  end
  if message.soldiers ~= nil then
  end
  if not message.heroes and message.heros then
    message.heroes = message.heros
  end
  if message.heroes ~= nil then
    self.heroes = {}
    self.remoteIndexToHeroDic = {}
    self.dominatorUuid = nil
    table.walk(message.heroes, function(k, v)
      local heroUuid = v.heroUuid
      local index = v.index
      if index <= 5 then
        if self.remoteIndexToHeroDic[index] ~= nil then
          self.heroes[self.remoteIndexToHeroDic[index]] = nil
        end
        self.heroes[heroUuid] = index
        self.remoteIndexToHeroDic[index] = heroUuid
      elseif index == ArmyFormationSlot.Dominator then
        self.dominatorUuid = heroUuid
      end
    end)
    self.localIndexToHeroDic = DeepCopy(self.remoteIndexToHeroDic)
    self.localHeroes = DeepCopy(self.heroes)
    self.localDominatorUuid = self.dominatorUuid
  end
  if isDefence and message.tmpHeroes ~= nil then
    self.heroes = {}
    self.remoteIndexToHeroDic = {}
    self.dominatorUuid = nil
    table.walk(message.tmpHeroes, function(k, v)
      local heroUuid = v.heroUuid
      local index = v.index
      if index <= 5 then
        if self.remoteIndexToHeroDic[index] ~= nil then
          self.heroes[self.remoteIndexToHeroDic[index]] = nil
        end
        self.heroes[heroUuid] = index
        self.remoteIndexToHeroDic[index] = heroUuid
      elseif index == ArmyFormationSlot.Dominator then
        self.dominatorUuid = heroUuid
      end
    end)
    self.localIndexToHeroDic = DeepCopy(self.remoteIndexToHeroDic)
    self.localHeroes = DeepCopy(self.heroes)
    self.localDominatorUuid = self.dominatorUuid
  end
  if message.slots ~= nil then
    self.slots = message.slots
  end
  if message.buildingUuid ~= nil then
    self.buildingUuid = message.buildingUuid
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.defencePriority ~= nil then
    self.defencePriority = message.defencePriority
  end
  if message.chipEquipGroup then
    self.twSkillChipSetId = message.chipEquipGroup
    self.localChipSetId = self.twSkillChipSetId
  end
  if self.twSkillChipSetId <= 0 then
    self.localChipSetId = self.index or 1
    self.twSkillChipSetId = self.index or 1
  end
end

local function SetName(self, name)
  if name ~= nil and name ~= "" then
    self.name = name
  end
end

local function GetTotalSupplyNum(self)
  local count = 0
  table.walk(self.supply, function(k, v)
    count = count + v
  end)
  return count
end

local function GetAllHeroSoldierCapacity(self)
  return self.heroTotalSoldierCapacity or 0
end

local function GetAllHeroes(self)
  return DeepCopy(self.remoteIndexToHeroDic)
end

local function GetLocalAllHeroes(self)
  return self.localIndexToHeroDic
end

function ArmyFormationInfo:GetLocalHeroesCount()
  local count = 0
  for _, v in pairs(self.localIndexToHeroDic) do
    count = count + 1
  end
  return count
end

local function HasLocalHero(self, heroUuid)
  return self.localHeroes[heroUuid] ~= nil
end

local function GetLocalHeroIndex(self, heroUuid)
  local hasHero = self:HasLocalHero(heroUuid)
  if not hasHero then
    return nil
  else
    for k, v in pairs(self.localIndexToHeroDic) do
      if v == heroUuid then
        return k
      end
    end
  end
  return nil
end

local function GetLocalHeroAtSlotIndex(self, slotIndex)
  return self.localIndexToHeroDic[slotIndex]
end

local function GetEmptySlotIndex(self)
  local function IsCanUseSlotIndex(index)
    if self.positionType == nil then
      return true
    end
    local showSlotIndexList = ArmyFormationSlotPositionType[self.positionType]
    if showSlotIndexList then
      for _, v in ipairs(showSlotIndexList) do
        if v == index then
          return true
        end
      end
      return false
    end
    return true
  end
  
  local emptyIndex = {}
  for i = 1, ArmyFormationSlot.Hero5 do
    if IsCanUseSlotIndex(i) and self.localIndexToHeroDic[i] == nil then
      return i
    end
  end
  return nil
end

local function SetLocalHero(self, slotIndex, heroUuid)
  if not slotIndex then
    return
  end
  if slotIndex == ArmyFormationSlot.Dominator then
    self:SetLocalDominator(heroUuid)
    return
  end
  if self.localIndexToHeroDic[slotIndex] ~= nil then
    self.localHeroes[self.localIndexToHeroDic[slotIndex]] = nil
  end
  if heroUuid ~= nil then
    self.localHeroes[heroUuid] = slotIndex
  end
  self.localIndexToHeroDic[slotIndex] = heroUuid
end

local function ResetLocalData(self)
  self.localIndexToHeroDic = DeepCopy(self.remoteIndexToHeroDic)
  self.localHeroes = DeepCopy(self.heroes)
  self.localChipSetId = self.twSkillChipSetId
  if self.localChipSetId <= 0 then
    self.localChipSetId = self.index or 1
  end
  self.localDominatorUuid = self.dominatorUuid
end

local function CheckLoacalRemoteDiff(self)
  local diff = false
  for k, v in pairs(self.remoteIndexToHeroDic) do
    if self.localIndexToHeroDic[k] ~= v then
      diff = true
      break
    end
  end
  if not diff then
    for k, v in pairs(self.localIndexToHeroDic) do
      if self.remoteIndexToHeroDic[k] ~= v then
        diff = true
        break
      end
    end
  end
  if not diff and self.localChipSetId ~= self.twSkillChipSetId then
    diff = true
  end
  if not diff and self.localDominatorUuid ~= self.dominatorUuid then
    diff = true
  end
  return diff
end

local function GetAllSupply(self)
  return DeepCopy(self.supply)
end

local function RefreshFormationSoldier(self, message)
  if message.canMarch ~= nil then
    self.canMarch = message.canMarch
  end
  if message.soldiers ~= nil then
    self.soldiers = {}
    self.totalSupply = 0
    self.totalSoldierCapacity = 0
    self.totalSoldierBurden = 0
    self.totalSoldierNum = 0
    table.walk(message.soldiers, function(k, v)
      if not self.soldiers[v.index] then
        self.soldiers[v.index] = {}
        self.soldiers[v.index].supply = 0
      end
      self.soldiers[v.index][v.soldier] = v.count
      local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(v.soldier)
      local supply = soldierMeta.restoreHp * v.count
      local capacity = soldierMeta.power * v.count
      local burden = soldierMeta.burden * v.count
      self.soldiers[v.index].supply = self.soldiers[v.index].supply + supply
      self.totalSupply = self.totalSupply + supply
      self.totalSoldierCapacity = self.totalSoldierCapacity + capacity
      self.totalSoldierBurden = self.totalSoldierBurden + burden
      self.totalSoldierNum = self.totalSoldierNum + v.count
    end)
    self.serverSoldiers = message.soldiers
  end
  EventManager:GetInstance():Broadcast(EventId.FormationSoldierUpdate)
end

local function ConscriptSoldierNew(self)
  self.soldiers = {}
  self.totalSupply = 0
  self.totalSoldierCapacity = 0
  self.totalSoldierBurden = 0
  self.totalSoldierNum = 0
  self.soldiersLv = {}
  if not self:HasHero() then
    return
  end
  local totalSoldierHp = 0
  local insideSoldier = DataCenter.SoldierDataManager:GetInsideSoldiers()
  table.sort(insideSoldier, function(a, b)
    return a.lv > b.lv
  end)
  for _, v in pairs(insideSoldier) do
    v.meta = DataCenter.SoldierDataManager:GetTemplate(v.id)
    totalSoldierHp = totalSoldierHp + v.meta.restoreHp * v.count
  end
  local totalFormationHp = 0
  for uuid, index in pairs(self.heroes) do
    self.soldiers[index] = {}
    self.soldiers[index].supply = 0
    local maxHp = DataCenter.HeroDataManager:GetHeroByUuid(uuid):GetMaxHp()
    self.soldiers[index].heroMaxHp = maxHp
    totalFormationHp = totalFormationHp + maxHp
  end
  if self.dominatorUuid then
    self.soldiers[ArmyFormationSlot.Dominator] = {}
    self.soldiers[ArmyFormationSlot.Dominator].supply = 0
    local maxHp = DataCenter.DominatorManager:GetInfoByUuid(self.dominatorUuid):GetMaxHp()
    self.soldiers[ArmyFormationSlot.Dominator].heroMaxHp = maxHp
    totalFormationHp = totalFormationHp + maxHp
  end
  local percent = math.min(totalSoldierHp / totalFormationHp, 1)
  
  local function CaculateSoldierForIndex(index)
    local health = self.soldiers[index].heroMaxHp
    local addUpHealth = math.floor(health * percent)
    if addUpHealth <= 0 then
      addUpHealth = 1
    end
    for _, v in ipairs(insideSoldier) do
      if addUpHealth <= 0 then
        break
      end
      local soldierId = v.meta.id
      local soldierHp = v.meta.restoreHp
      local soldierNum = v.count
      local soldierLv = v.lv
      local soldierNumUsed = math.min(math.floor((addUpHealth + soldierHp - 1) / soldierHp), soldierNum)
      if 0 < soldierNumUsed then
        v.count = soldierNum - soldierNumUsed
        self.soldiers[index][soldierId] = soldierNumUsed
        local supply = soldierHp * soldierNumUsed
        addUpHealth = addUpHealth - supply
        local capacity = v.meta.power * soldierNumUsed
        local burden = v.meta.burden * soldierNumUsed
        self.soldiers[index].supply = self.soldiers[index].supply + supply
        self.totalSupply = self.totalSupply + supply
        self.totalSoldierCapacity = self.totalSoldierCapacity + capacity
        self.totalSoldierBurden = self.totalSoldierBurden + burden
        self.totalSoldierNum = self.totalSoldierNum + soldierNumUsed
        if self.soldiersLv[v.lv] then
          self.soldiersLv[v.lv].count = self.soldiersLv[v.lv].count + soldierNumUsed
        else
          self.soldiersLv[v.lv] = {}
          self.soldiersLv[v.lv].count = soldierNumUsed
          self.soldiersLv[v.lv].id = soldierId
          self.soldiersLv[v.lv].lv = soldierLv
        end
      end
    end
  end
  
  for uuid, index in pairs(self.heroes) do
    CaculateSoldierForIndex(index)
  end
  if self.dominatorUuid then
    CaculateSoldierForIndex(ArmyFormationSlot.Dominator)
  end
end

function ArmyFormationInfo:ConscriptSoldier(isUseLocalHero, theSoldierType)
  self.soldiers = {}
  self.totalSupply = 0
  self.totalSoldierCapacity = 0
  self.totalSoldierBurden = 0
  self.totalSoldierNum = 0
  self.soldiersLv = {}
  self.heroTotalSoldierCapacity = 0
  if not (not isUseLocalHero or self:HasAnyLocalHero()) or not isUseLocalHero and not self:HasHero() then
    return
  end
  local SoldierCapacity = 0
  local insideSoldier = DataCenter.SoldierDataManager:GetInsideSoldiers(theSoldierType)
  table.sort(insideSoldier, function(a, b)
    return a.lv > b.lv
  end)
  for _, v in pairs(insideSoldier) do
    v.meta = DataCenter.SoldierDataManager:GetTemplate(v.id)
    SoldierCapacity = SoldierCapacity + v.count
  end
  local s3_mummy_config_k7 = SeasonUtil.GetMummyConfigNum("k7", 1)
  local heroes = isUseLocalHero and self.localHeroes or self.heroes
  for uuid, index in pairs(heroes) do
    self.soldiers[index] = {}
    self.soldiers[index].supply = 0
    local maxCapacity = 0
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    if heroData ~= nil then
      maxCapacity = heroData:GetSoldierCapacity()
      if theSoldierType == SoldierType.Mummy and s3_mummy_config_k7 ~= 0 and s3_mummy_config_k7 ~= 1 then
        maxCapacity = math.ceil(maxCapacity / s3_mummy_config_k7)
      end
    end
    self.soldiers[index].heroMaxCapacity = maxCapacity
    self.heroTotalSoldierCapacity = self.heroTotalSoldierCapacity + maxCapacity
  end
  if self.dominatorUuid then
    self.soldiers[ArmyFormationSlot.Dominator] = {}
    self.soldiers[ArmyFormationSlot.Dominator].supply = 0
    local maxCapacity = DataCenter.DominatorManager:GetInfoByUuid(self.dominatorUuid):GetSoldierCapacity()
    if theSoldierType == SoldierType.Mummy and s3_mummy_config_k7 ~= 0 and s3_mummy_config_k7 ~= 1 then
      maxCapacity = math.ceil(maxCapacity / s3_mummy_config_k7)
    end
    self.soldiers[ArmyFormationSlot.Dominator].heroMaxCapacity = maxCapacity
    self.heroTotalSoldierCapacity = self.heroTotalSoldierCapacity + maxCapacity
  end
  local percent = math.min(SoldierCapacity / self.heroTotalSoldierCapacity, 1)
  local maxHeroCapacity = 0
  
  local function CalculateSoldier(index)
    local capacity = self.soldiers[index].heroMaxCapacity
    maxHeroCapacity = maxHeroCapacity + capacity
    local addUpHealth = math.floor(capacity * percent)
    if addUpHealth <= 0 then
      addUpHealth = 1
    end
    for _, v in ipairs(insideSoldier) do
      if addUpHealth <= 0 then
        break
      end
      local soldierId = v.meta.id
      local soldierNum = v.count
      local soldierLv = v.lv
      local soldierNumUsed = math.min(math.floor(addUpHealth), soldierNum)
      if 0 < soldierNumUsed then
        v.count = soldierNum - soldierNumUsed
        self.soldiers[index][soldierId] = soldierNumUsed
        local supply = soldierNumUsed
        addUpHealth = addUpHealth - supply
        local soldierPower = DataCenter.SoldierDataManager:CalcSoldierPower(v.meta, soldierNumUsed)
        local burden = v.meta.burden * soldierNumUsed
        self.soldiers[index].supply = self.soldiers[index].supply + supply
        self.totalSupply = self.totalSupply + supply
        self.totalSoldierCapacity = self.totalSoldierCapacity + soldierPower
        self.totalSoldierBurden = self.totalSoldierBurden + burden
        self.totalSoldierNum = self.totalSoldierNum + soldierNumUsed
        if self.soldiersLv[v.lv] then
          self.soldiersLv[v.lv].count = self.soldiersLv[v.lv].count + soldierNumUsed
        else
          self.soldiersLv[v.lv] = {}
          self.soldiersLv[v.lv].count = soldierNumUsed
          self.soldiersLv[v.lv].id = soldierId
          self.soldiersLv[v.lv].lv = soldierLv
        end
      end
    end
  end
  
  for uuid, index in pairs(heroes) do
    CalculateSoldier(index)
  end
  if self.dominatorUuid then
    CalculateSoldier(ArmyFormationSlot.Dominator)
  end
  local superSoldierPower = 0
  local curElevenNum = 0
  local keys = table.keys(self.soldiersLv)
  for _, v in ipairs(keys) do
    if T11Util.IsSuperSoldier(v) and self.soldiersLv[v].count then
      curElevenNum = curElevenNum + self.soldiersLv[v].count
    end
  end
  superSoldierPower = T11Util.GetAttributePower(curElevenNum / maxHeroCapacity)
  self.totalSoldierCapacity = self.totalSoldierCapacity + superSoldierPower
end

local function GetHeroesCapacity(self)
  local ret = 0
  for k, v in pairs(self.heroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
    if heroData then
      ret = ret + heroData.power
    end
  end
  return ret
end

function ArmyFormationInfo:GetDominatorCapacity()
  if self.dominatorUuid then
    local dominatorData = DataCenter.DominatorManager:GetInfoByUuid(self.dominatorUuid)
    if dominatorData then
      return dominatorData.power or 0
    end
  end
  return 0
end

function ArmyFormationInfo:GetLocalDominatorCapacity()
  if self.localDominatorUuid then
    local dominatorData = DataCenter.DominatorManager:GetInfoByUuid(self.localDominatorUuid)
    if dominatorData then
      return dominatorData.power or 0
    end
  end
  return 0
end

local function GetLocalHeroesCapacity(self)
  local ret = 0
  for k, v in pairs(self.localHeroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
    if heroData then
      ret = ret + heroData.power
    end
  end
  return ret
end

local function GetSoldiersCapacity(self)
  return self.totalSoldierCapacity
end

local function GetEquipCapacity(self)
  local equips = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfos()
  if not table.IsNullOrEmpty(equips) then
    for _, v in pairs(equips) do
      return v:GetSkillPower()
    end
  end
  return 0
end

local function GetTWSkillChipCapacity(self)
  local setId = self.localChipSetId
  if setId <= 0 then
    return self.index or 1
  end
  local power = DataCenter.TWSkillChipManager:GetSetSkillPower(setId)
  return power
end

local function GetTotalCapacity(self)
  return self:GetHeroesCapacity() + self:GetSoldiersCapacity() + self:GetEquipCapacity() + self:GetTWSkillChipCapacity() + self:GetDominatorCapacity()
end

function ArmyFormationInfo:GetParkingTotalCapacity()
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
  if self.localDominatorUuid then
    local dominatorData = DataCenter.DominatorManager:GetInfoByUuid(self.localDominatorUuid)
    if dominatorData then
      totalCombatPower = totalCombatPower + dominatorData.power or 0
    end
  end
  totalCombatPower = totalCombatPower + self:GetEquipCapacity() + self:GetTWSkillChipCapacity() + self:GetVirtualConscriptSoldierPower()
  return totalCombatPower
end

function ArmyFormationInfo:GetSeasonTowerTotalCapacity()
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
  if self.localDominatorUuid then
    local dominatorData = DataCenter.DominatorManager:GetInfoByUuid(self.localDominatorUuid)
    if dominatorData then
      totalCombatPower = totalCombatPower + dominatorData.power or 0
    end
  end
  totalCombatPower = totalCombatPower + self:GetEquipCapacity() + self:GetTWSkillChipCapacity() + self:GetVirtualConscriptSoldierPower()
  return totalCombatPower
end

local function GetPVETotalCapacity(self)
  return self:GetLocalHeroesCapacity() + self:GetEquipCapacity() + self:GetTWSkillChipCapacity() + self:GetLocalDominatorCapacity()
end

function ArmyFormationInfo:GetPVPTotalCapacity(squadIndex)
  self:ConscriptSoldier()
  local buildUid = DataCenter.LW3V3Manager:GetCurrentTeamBuffBuildingUuid(squadIndex)
  return self:GetPVPHeroesCapacity() + self:GetSoldiersCapacity() + self:GetPVPEquipCapacity(buildUid) + self:GetTWSkillChipCapacity() + self:GetLocalDominatorCapacity()
end

function ArmyFormationInfo:GetPVPEquipCapacity(buildUid)
  local equips = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfos()
  if not table.IsNullOrEmpty(equips) then
    for _, v in pairs(equips) do
      return v:GetSkillPower()
    end
  end
  return 0
end

function ArmyFormationInfo:GetPVPHeroesCapacity()
  local ret = 0
  for k, v in pairs(self.localHeroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
    if heroData then
      ret = ret + heroData.power
    end
  end
  return ret
end

local function GetVirtualConscriptSoldierPower(self)
  self.soldiers = {}
  self.totalSupply = 0
  self.totalSoldierCapacity = 0
  self.totalSoldierBurden = 0
  self.totalSoldierNum = 0
  if table.IsNullOrEmpty(self.localHeroes) then
    return self.totalSoldierCapacity
  end
  local soldierType
  local maxLevelSoldier = DataCenter.SoldierDataManager:GetCanTrainHighestLevelSoldier()
  if maxLevelSoldier then
    soldierType = maxLevelSoldier.id
  end
  if not soldierType then
    return self.totalSoldierCapacity
  end
  local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(soldierType)
  if soldierMeta == nil then
    return self.totalSoldierCapacity
  end
  for uuid, index in pairs(self.localHeroes) do
    self.soldiers[index] = {}
    self.soldiers[index].supply = 0
    local heroInfo = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    local leaderShip = 0
    if heroInfo then
      leaderShip = heroInfo:GetSoldierCapacity()
    end
    self.soldiers[index].heroLeaderShip = leaderShip
  end
  if self.localDominatorUuid then
    self.soldiers[ArmyFormationSlot.Dominator] = {}
    self.soldiers[ArmyFormationSlot.Dominator].supply = 0
    local heroInfo = DataCenter.DominatorManager:GetInfoByUuid(self.localDominatorUuid)
    local leaderShip = 0
    if heroInfo then
      leaderShip = heroInfo:GetSoldierCapacity()
    end
    self.soldiers[ArmyFormationSlot.Dominator].heroLeaderShip = leaderShip
  end
  for _, index in pairs(self.localHeroes) do
    local leaderShip = self.soldiers[index].heroLeaderShip
    local needCount = math.floor(leaderShip)
    if needCount <= 0 then
      return 0
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
  if self.localDominatorUuid then
    local leaderShip = self.soldiers[ArmyFormationSlot.Dominator].heroLeaderShip
    local needCount = math.floor(leaderShip)
    if needCount <= 0 then
      return 0
    end
    local soldierNumUsed = needCount
    if 0 < soldierNumUsed then
      self.soldiers[ArmyFormationSlot.Dominator][soldierMeta.id] = soldierNumUsed
      local supply = soldierNumUsed
      local capacity = DataCenter.SoldierDataManager:CalcSoldierPower(soldierMeta, soldierNumUsed)
      local burden = soldierMeta.burden * soldierNumUsed
      self.soldiers[ArmyFormationSlot.Dominator].supply = supply
      self.totalSupply = self.totalSupply + supply
      self.totalSoldierCapacity = self.totalSoldierCapacity + capacity
      self.totalSoldierBurden = self.totalSoldierBurden + burden
      self.totalSoldierNum = self.totalSoldierNum + soldierNumUsed
    end
  end
  return self.totalSoldierCapacity + T11Util.GetAttributePower()
end

local function GetHighestQualityHero(self)
  local ret
  for k, v in pairs(self.heroes) do
    if ret then
      local cur = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if cur then
        if ret.quality < cur.quality then
          ret = cur
        elseif ret.quality == cur.quality and v < self.heroes[ret.uuid] then
          ret = cur
        end
      end
    else
      ret = DataCenter.HeroDataManager:GetHeroByUuid(k)
    end
  end
  return ret
end

local function GetHeroesBurden(self)
  local ret = 0
  for k, v in pairs(self.heroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
    ret = ret + heroData:GetEffectNum(EffectDefine.HERO_FINAL_BURDEN)
  end
  return ret
end

local function GetSoldiersBurden(self)
  local LW_71014 = DataCenter.ArmyFormationDataManager:GetEffectResult(self.uuid, EffectDefine.HERO_LOAD_ADD_71014)
  local LW_71032 = DataCenter.ArmyFormationDataManager:GetEffectResult(self.uuid, EffectDefine.MARCH_LOAD_ADD_71032)
  local LW_91078 = DataCenter.ArmyFormationDataManager:GetEffectResult(self.uuid, EffectDefine.SOLDIER_LOAD_ADD_91078)
  return (1 + LW_71014 + LW_71032 + LW_91078) * self.totalSoldierBurden
end

local function GetTotalBurden(self)
  return self:GetHeroesBurden() + self:GetSoldiersBurden()
end

local function HasHero(self)
  return table.count(self.heroes) > 0
end

local function HasAnyLocalHero(self)
  return table.count(self.localHeroes) > 0
end

local function SetLocalHeroes(self, heroMap)
  self.localIndexToHeroDic = heroMap
  local dominator
  if heroMap[ArmyFormationSlot.Dominator] then
    dominator = heroMap[ArmyFormationSlot.Dominator]
    heroMap[ArmyFormationSlot.Dominator] = nil
    self:SetLocalDominator(dominator)
  end
  for k, v in pairs(heroMap) do
    self.localHeroes[v] = k
  end
end

local function ClearLocalHeroes(self)
  self.localIndexToHeroDic = {}
  self.localHeroes = {}
end

local function SetIndex(self, index)
  self.index = index
end

local function GetUsingTWSkillChipSetId(self)
  return self.twSkillChipSetId
end

local function SetLocalTWSkillChipSetId(self, setId)
  if setId <= 0 then
    return
  end
  self.localChipSetId = setId
end

local function GetLocalTWSkillChipSetId(self)
  return self.localChipSetId
end

local function IsFree(self)
  return self.state == 0
end

local function RemoveOneHeroByUuid(self, uuid)
  local index = self.heroes[uuid]
  self.heroes[uuid] = nil
  self.localHeroes[uuid] = nil
  if index then
    self.remoteIndexToHeroDic[index] = nil
    self.localIndexToHeroDic[index] = nil
  end
end

function ArmyFormationInfo:SetLocalDominator(dominatorUuid)
  if not dominatorUuid then
    return
  end
  self.localDominatorUuid = dominatorUuid
end

function ArmyFormationInfo:GetDominatorUuid()
  return self.dominatorUuid
end

function ArmyFormationInfo:GetLocalDominatorUuid()
  return self.localDominatorUuid
end

function ArmyFormationInfo:UnsetLocalDominator()
  self.localDominatorUuid = nil
end

function ArmyFormationInfo:GenerateServerHeroArray()
  return ArmyFormationUtils.GenerateServerHeroArray(self:GetLocalAllHeroes(), self.localDominatorUuid)
end

function ArmyFormationInfo:SetFormationPositionType(positionType)
  self.positionType = positionType
end

function ArmyFormationInfo:SyncLocalData(armyFormationData)
  if not armyFormationData then
    return
  end
  self.localHeroes = DeepCopy(armyFormationData.localHeroes)
  self.localDominatorUuid = armyFormationData.localDominatorUuid
  self.localChipSetId = armyFormationData.localChipSetId
  self.localIndexToHeroDic = DeepCopy(armyFormationData.localIndexToHeroDic)
end

ArmyFormationInfo.__init = __init
ArmyFormationInfo.__delete = __delete
ArmyFormationInfo.ParseData = ParseData
ArmyFormationInfo.SetName = SetName
ArmyFormationInfo.SetIndex = SetIndex
ArmyFormationInfo.SetLocalHeroes = SetLocalHeroes
ArmyFormationInfo.GetTotalSupplyNum = GetTotalSupplyNum
ArmyFormationInfo.GetAllHeroes = GetAllHeroes
ArmyFormationInfo.GetAllSupply = GetAllSupply
ArmyFormationInfo.GetLocalAllHeroes = GetLocalAllHeroes
ArmyFormationInfo.HasLocalHero = HasLocalHero
ArmyFormationInfo.SetLocalHero = SetLocalHero
ArmyFormationInfo.GetLocalHeroIndex = GetLocalHeroIndex
ArmyFormationInfo.GetEmptySlotIndex = GetEmptySlotIndex
ArmyFormationInfo.ResetLocalData = ResetLocalData
ArmyFormationInfo.RefreshFormationSoldier = RefreshFormationSoldier
ArmyFormationInfo.GetHeroesCapacity = GetHeroesCapacity
ArmyFormationInfo.GetSoldiersCapacity = GetSoldiersCapacity
ArmyFormationInfo.GetTotalCapacity = GetTotalCapacity
ArmyFormationInfo.GetHighestQualityHero = GetHighestQualityHero
ArmyFormationInfo.GetHeroesBurden = GetHeroesBurden
ArmyFormationInfo.GetSoldiersBurden = GetSoldiersBurden
ArmyFormationInfo.GetTotalBurden = GetTotalBurden
ArmyFormationInfo.HasHero = HasHero
ArmyFormationInfo.HasAnyLocalHero = HasAnyLocalHero
ArmyFormationInfo.CheckLoacalRemoteDiff = CheckLoacalRemoteDiff
ArmyFormationInfo.GetLocalHeroAtSlotIndex = GetLocalHeroAtSlotIndex
ArmyFormationInfo.GetEquipCapacity = GetEquipCapacity
ArmyFormationInfo.GetAllHeroSoldierCapacity = GetAllHeroSoldierCapacity
ArmyFormationInfo.GetUsingTWSkillChipSetId = GetUsingTWSkillChipSetId
ArmyFormationInfo.SetLocalTWSkillChipSetId = SetLocalTWSkillChipSetId
ArmyFormationInfo.GetLocalTWSkillChipSetId = GetLocalTWSkillChipSetId
ArmyFormationInfo.GetTWSkillChipCapacity = GetTWSkillChipCapacity
ArmyFormationInfo.IsFree = IsFree
ArmyFormationInfo.GetVirtualConscriptSoldierPower = GetVirtualConscriptSoldierPower
ArmyFormationInfo.RemoveOneHeroByUuid = RemoveOneHeroByUuid
ArmyFormationInfo.ClearLocalHeroes = ClearLocalHeroes
ArmyFormationInfo.GetLocalHeroesCapacity = GetLocalHeroesCapacity
ArmyFormationInfo.GetPVETotalCapacity = GetPVETotalCapacity
return ArmyFormationInfo
