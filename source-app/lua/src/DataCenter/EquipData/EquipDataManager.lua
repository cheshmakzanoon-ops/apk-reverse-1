local EquipDataManager = BaseClass("EquipDataManager")
local EquipUtil = require("DataCenter.EquipData.EquipUtil")
local TOP_N_COUNT = 5

local function __init(self)
  self.inited = false
  self.allEquip = {}
  self.slotEquipMap = {}
  self.smithShopUid = nil
  self.needSmithShopLevel = nil
  self.totalLv = {}
  self.totalLv[HeroEquipQuality.Green] = 0
  self.totalLv[HeroEquipQuality.Blue] = 0
  self.totalLv[HeroEquipQuality.Purple] = 0
  self.totalLv[HeroEquipQuality.Orange] = 0
  self.totalLv[HeroEquipQuality.Red] = 0
  self.slotHeroTypePowerMap = {}
  self.slotHeroTypeDirtyMap = {}
  self.powerCache = {}
  self.propertiesCache = {}
end

local function __delete(self)
  self.inited = nil
  self.allEquip = nil
  self.slotEquipMap = nil
  self.smithShopUid = nil
  self.needSmithShopLevel = nil
  self.totalLv = nil
  self.slotHeroTypePowerMap = nil
  self.slotHeroTypeDirtyMap = nil
  self.powerCache = nil
  self.propertiesCache = nil
end

local function InitData(self, message)
  self.inited = false
  if message.heroEquips ~= nil then
    self.allEquip = {}
    self.slotEquipMap = {}
    self.slotHeroTypePowerMap = {}
    self.slotHeroTypeDirtyMap = {}
    self:UpdateManyEquip(message.heroEquips.list, true)
  end
  if message.equip_ur_level_sum then
    local totalLv = tonumber(message.equip_ur_level_sum)
    Logger.Log("InitData           total equip Lv:  " .. totalLv)
    self:UpdateTotalLevel(HeroEquipQuality.Orange, totalLv)
  end
  self.inited = true
end

local function GetNewEquipsCount(self)
  return 0
end

local function UpdateManyEquip(self, array, isInit)
  if array ~= nil then
    for k, v in pairs(array) do
      self:UpdateOneEquip(v, isInit)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.EquipDataUpdate)
end

local function UpdateOneEquip(self, message, isInit)
  if message == nil then
    return
  end
  local uuid = message.uid
  if uuid == nil then
    return false
  end
  local one = self:GetEquipByUuid(uuid)
  local hasEquip = tonumber(message.count) > 0
  if one ~= nil then
    if not hasEquip then
      self:RemoveOneEquipByUuid(uuid)
      return
    end
    one:UpdateInfo(message, isInit)
  else
    if not hasEquip then
      return
    end
    one = EquipInfo.New()
    one:UpdateInfo(message, isInit)
    if one.config == nil then
      Logger.LogError("\232\163\133\229\164\135\233\133\141\231\189\174\228\184\186\231\169\186:" .. tostring(one.cfgId))
      return
    end
    self.allEquip[uuid] = one
    if self.slotEquipMap[one.config.slot] == nil then
      self.slotEquipMap[one.config.slot] = {}
    end
    self.slotEquipMap[one.config.slot][uuid] = one
  end
  self:UpdateHighestPowerFreeEquip(one)
end

local function RemoveOneEquipByUuid(self, uuid)
  if self.allEquip[uuid] ~= nil then
    local equipData = self.allEquip[uuid]
    if equipData ~= nil then
      self.slotEquipMap[equipData.config.slot][uuid] = nil
    end
    self.allEquip[uuid] = nil
    self:RemoveHighestPowerFreeEquip(equipData)
  end
end

function EquipDataManager:UpdateHighestPowerFreeEquip(equip)
  local slot = equip.config.slot
  local power = equip.power
  local isFree = equip.heroUuid == nil or equip.heroUuid <= 0
  local listIndex
  if self.slotHeroTypePowerMap[slot] ~= nil then
    for i, v in ipairs(self.slotHeroTypePowerMap[slot]) do
      if v.uuid == equip.uuid then
        listIndex = i
        break
      end
    end
  end
  if listIndex ~= nil and not isFree then
    table.remove(self.slotHeroTypePowerMap[slot], listIndex)
    if #self.slotHeroTypePowerMap[slot] == 0 then
      self.slotHeroTypeDirtyMap[slot] = true
    end
  elseif listIndex ~= nil then
    for i = 1, listIndex do
      if power > self.slotHeroTypePowerMap[slot][i].power then
        table.remove(self.slotHeroTypePowerMap[slot], listIndex)
        table.insert(self.slotHeroTypePowerMap[slot], i, equip)
        break
      end
    end
  elseif isFree then
    if self.slotHeroTypeDirtyMap[slot] == true then
      return
    end
    local insertIndex
    if self.slotHeroTypePowerMap[slot] then
      local length = #self.slotHeroTypePowerMap[slot]
      if 0 < length and power > self.slotHeroTypePowerMap[slot][length].power then
        for i = 1, length do
          if power > self.slotHeroTypePowerMap[slot][i].power then
            insertIndex = i
            break
          end
        end
      end
    end
    if insertIndex then
      if not self.slotHeroTypePowerMap[slot] then
        self.slotHeroTypePowerMap[slot] = {}
      end
      table.insert(self.slotHeroTypePowerMap[slot], insertIndex, equip)
    elseif not self.slotHeroTypePowerMap[slot] or #self.slotHeroTypePowerMap[slot] < TOP_N_COUNT then
      if not self.slotHeroTypePowerMap[slot] then
        self.slotHeroTypePowerMap[slot] = {}
      end
      table.insert(self.slotHeroTypePowerMap[slot], equip)
    end
    if #self.slotHeroTypePowerMap[slot] > TOP_N_COUNT then
      table.remove(self.slotHeroTypePowerMap[slot])
    end
  end
end

function EquipDataManager:RemoveHighestPowerFreeEquip(equip)
  local slot = equip.config.slot
  if self.slotHeroTypePowerMap[slot] == nil then
    return
  end
  local listIndex
  for i, v in ipairs(self.slotHeroTypePowerMap[slot]) do
    if v.uuid == equip.uuid then
      listIndex = i
      break
    end
  end
  if listIndex ~= nil then
    table.remove(self.slotHeroTypePowerMap[slot], listIndex)
    if #self.slotHeroTypePowerMap[slot] == 0 then
      self.slotHeroTypeDirtyMap[slot] = true
    end
  end
end

function EquipDataManager:RebuildHighestPowerFreeEquip(slot)
  self.slotHeroTypePowerMap[slot] = {}
  if self.slotEquipMap[slot] ~= nil then
    for _, equip in pairs(self.slotEquipMap[slot]) do
      local isFree = equip.heroUuid == nil or equip.heroUuid <= 0
      if isFree then
        local insertIndex
        if #self.slotHeroTypePowerMap[slot] > 0 then
          for i = 1, #self.slotHeroTypePowerMap[slot] do
            if self.slotHeroTypePowerMap[slot][i].power < equip.power then
              insertIndex = i
              break
            end
          end
        end
        if insertIndex then
          table.insert(self.slotHeroTypePowerMap[slot], insertIndex, equip)
        elseif #self.slotHeroTypePowerMap[slot] < TOP_N_COUNT then
          table.insert(self.slotHeroTypePowerMap[slot], equip)
        end
        if #self.slotHeroTypePowerMap[slot] > TOP_N_COUNT * 2 then
          table.remove(self.slotHeroTypePowerMap[slot])
        end
      end
    end
  end
  local exceedCount = #self.slotHeroTypePowerMap[slot] - TOP_N_COUNT
  if 0 < exceedCount then
    for i = 1, exceedCount do
      table.remove(self.slotHeroTypePowerMap[slot])
    end
  end
  self.slotHeroTypeDirtyMap[slot] = false
end

local function RemoveEquipes(self, uuids)
  for _, uuid in pairs(uuids) do
    self:RemoveOneEquipByUuid(uuid)
  end
end

local function GetEquipByUuid(self, uuid)
  return self.allEquip[uuid]
end

local function GetEquipUuidByHeroId(self, id)
  local equipId = tonumber(id)
  for _, v in pairs(self.allEquip) do
    if equipId == v.cfgId then
      return v.uuid
    end
  end
  return ""
end

local function GetAllEquipList(self)
  return self.allEquip
end

local function GetEquipSortList(self)
  local equipList = {}
  table.walksort(self.allHero, function(leftKey, rightKey)
    local heroA = self.allHero[leftKey]
    local heroB = self.allHero[rightKey]
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    return heroA.heroId < heroB.heroId
  end, function(k, v)
    if not v.isMaster then
    else
      equipList[#equipList + 1] = v
    end
  end)
  return equipList
end

local function GetAllEquipListBySlotType(self, slotType)
  return self.slotEquipMap[slotType]
end

local function GetAllEquipListBySlotTypeAndHeroType(self, slotType, heroType, includeUsed)
  local equipList = {}
  if self.slotEquipMap[slotType] == nil then
    return equipList
  end
  for _, equip in pairs(self.slotEquipMap[slotType]) do
    if equip.config.heroType == heroType or equip.config.heroType == HeroType.All then
      if includeUsed == false then
        if equip.heroUuid == nil or equip.heroUuid <= 0 then
          equipList[equip.uuid] = equip
        end
      else
        equipList[equip.uuid] = equip
      end
    end
  end
  return equipList
end

local function DoActionForAllEquipSlotAndHeroType(self, slotType, heroType, includeUsed, action)
  if self.slotEquipMap[slotType] == nil then
    return
  end
  for _, equip in pairs(self.slotEquipMap[slotType]) do
    if equip.config.heroType == heroType or equip.config.heroType == HeroType.All then
      if includeUsed == false then
        if (equip.heroUuid == nil or equip.heroUuid <= 0) and action(equip) then
          break
        end
      elseif action(equip) then
        break
      end
    end
  end
end

local function GetAllUnusedEquipList(self)
  local equipList = {}
  for _, equip in pairs(self.allEquip) do
    if equip.heroUuid == nil or equip.heroUuid <= 0 then
      equipList[equip.uuid] = equip
    end
  end
  return equipList
end

local function GetBetterEquipBySlotAndHeroType(self, slot, heroType, power)
  if self.slotHeroTypeDirtyMap[slot] then
    self:RebuildHighestPowerFreeEquip(slot)
  end
  if self.slotHeroTypePowerMap[slot] and #self.slotHeroTypePowerMap[slot] > 0 then
    if power >= self.slotHeroTypePowerMap[slot][1].power then
      return nil
    end
    return self.slotHeroTypePowerMap[slot][1]
  end
  return nil
end

function EquipDataManager:HasBetterEquipBySlotAndHeroType(slot, heroType, power)
  local betterEquip = GetBetterEquipBySlotAndHeroType(self, slot, heroType, power)
  return betterEquip ~= nil
end

local function GetHeroBetterEquip(self, heroData)
  if heroData == nil then
    return nil
  end
  if heroData:IsUnlockEquipFunction() == false then
    return nil
  end
  for i = 1, 4 do
    local equipData = heroData:GetEquipBySlotType(i)
    local power = 0
    if equipData ~= nil then
      power = equipData.power
    end
    local betterEquip = GetBetterEquipBySlotAndHeroType(self, i, heroData.heroType, power)
    if betterEquip ~= nil then
      return betterEquip
    end
  end
  return nil
end

local function IsPromoteFunctionOpen(self)
  if self.smithShopUid == nil then
    local smithShopBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SMITH_SHOP)
    if smithShopBuild ~= nil then
      self.smithShopUid = smithShopBuild.uuid
    end
  end
  if self.smithShopUid == nil then
    return false
  end
  if self.needSmithShopLevel == nil then
    self.needSmithShopLevel = LuaEntry.DataConfig:TryGetNum("equip_promote_unlock", "k1", 0)
  end
  local build = DataCenter.BuildManager:GetBuildingDataByUuid(self.smithShopUid)
  if build == nil or build.level < self.needSmithShopLevel then
    if build == nil then
      self.smithShopUid = nil
    end
    return false
  end
  return true
end

local function CanShowEquipStar(self, equipData)
  if equipData == nil then
    return false
  end
  if equipData.config == nil then
    return false
  end
  if not equipData:CanStartPromote() then
    return false
  end
  return true
end

local function GetAllCanPromoteEquip(self, heroUuids)
  local equipUids = {}
  if not DataCenter.EquipDataManager:IsPromoteFunctionOpen() then
    return equipUids
  end
  for _, heroUid in pairs(heroUuids) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUid)
    if heroData ~= nil then
      for i = 1, 4 do
        local equipData = heroData:GetEquipBySlotType(i)
        if equipData ~= nil and equipData:CanStartPromote() then
          table.insert(equipUids, equipData.uuid)
        end
      end
    end
  end
  return equipUids
end

local function GetAllWearingEquip(self, heroUuids)
  local equipUids = {}
  for _, heroUid in pairs(heroUuids) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUid)
    if heroData ~= nil then
      for i = 1, 4 do
        local equipData = heroData:GetEquipBySlotType(i)
        if equipData ~= nil then
          table.insert(equipUids, equipData.uuid)
        end
      end
    end
  end
  return equipUids
end

local function GetAllEquipListByEquipId(self, equipId)
  local equipList = {}
  for _, equip in pairs(self.allEquip) do
    if equip.config.id == equipId then
      table.insert(equipList, equip)
    end
  end
  return equipList
end

local function UpdateTotalLevel(self, quality, lv)
  self.totalLv[quality] = lv
end

local function GetTotalLevelByQuality(self, quality)
  return self.totalLv[quality]
end

local function CheckRedEquipOpen(self)
  local totalLevel = GetTotalLevelByQuality(self, HeroEquipQuality.Orange)
  local limitLevel = LuaEntry.DataConfig:TryGetNum("red_equip_open", "k1")
  return totalLevel >= limitLevel
end

local function GetEquipCountByQuality(self, quality)
  local res = 0
  if self.allEquip then
    for _, equip in pairs(self.allEquip) do
      if equip.config and equip.config.quality == quality then
        res = res + 1
      end
    end
  end
  return res
end

local function GetPowerByTemplateId(self, templateId, lv, promoteLv)
  if self.powerCache[templateId] and self.powerCache[templateId][lv] and self.powerCache[templateId][lv][promoteLv] then
    return self.powerCache[templateId][lv][promoteLv]
  end
  local power = EquipUtil.CalculatePower(templateId, lv, promoteLv) or 0
  self.powerCache[templateId] = self.powerCache[templateId] or {}
  self.powerCache[templateId][lv] = self.powerCache[templateId][lv] or {}
  self.powerCache[templateId][lv][promoteLv] = power
  return power
end

local function GetPropertiesByTemplateIdReadOnly(self, templateId, lv, promoteLv)
  if self.propertiesCache[templateId] and self.propertiesCache[templateId][lv] and self.propertiesCache[templateId][lv][promoteLv] then
    return self.propertiesCache[templateId][lv][promoteLv]
  end
  local properties = EquipUtil.CalculateProperties(templateId, lv, promoteLv)
  self.propertiesCache[templateId] = self.propertiesCache[templateId] or {}
  self.propertiesCache[templateId][lv] = self.propertiesCache[templateId][lv] or {}
  self.propertiesCache[templateId][lv][promoteLv] = properties
  return properties
end

local function CheckHeroesEquipQualityBelowFreeEquip(self, team)
  if not team or #team == 0 then
    return false
  end
  local heroRecord = {}
  local equipRecord = {}
  for _, heroUnit in pairs(team) do
    local heroData = heroUnit.hero
    if heroData and heroData:IsUnlockEquipFunction() then
      for i = 1, 4 do
        local equipData = heroData:GetEquipBySlotType(i)
        local freeEquips = self:GetAllEquipListBySlotTypeAndHeroType(i, heroData.heroType, false)
        for _, equip in pairs(freeEquips) do
          if (equipData == nil or equip.config.quality > equipData.config.quality) and not equipRecord[equip.uuid] then
            equipRecord[equip.uuid] = true
            heroRecord[heroData.uuid] = heroData
            break
          end
        end
      end
    end
  end
  local equipCount = table.count(equipRecord)
  if 2 <= equipCount then
    local heroDataList = {}
    for i, v in pairs(heroRecord) do
      table.insert(heroDataList, v)
    end
    local isHighlight = 5 <= equipCount
    return true, heroDataList, isHighlight
  end
  return false
end

EquipDataManager.__init = __init
EquipDataManager.__delete = __delete
EquipDataManager.InitData = InitData
EquipDataManager.UpdateOneEquip = UpdateOneEquip
EquipDataManager.GetEquipByUuid = GetEquipByUuid
EquipDataManager.UpdateManyEquip = UpdateManyEquip
EquipDataManager.RemoveOneEquipByUuid = RemoveOneEquipByUuid
EquipDataManager.RemoveEquipes = RemoveEquipes
EquipDataManager.GetAllEquipList = GetAllEquipList
EquipDataManager.GetEquipUuidByHeroId = GetEquipUuidByHeroId
EquipDataManager.GetEquipSortList = GetEquipSortList
EquipDataManager.GetAllEquipListBySlotType = GetAllEquipListBySlotType
EquipDataManager.GetAllEquipListBySlotTypeAndHeroType = GetAllEquipListBySlotTypeAndHeroType
EquipDataManager.GetAllUnusedEquipList = GetAllUnusedEquipList
EquipDataManager.GetBetterEquipBySlotAndHeroType = GetBetterEquipBySlotAndHeroType
EquipDataManager.GetHeroBetterEquip = GetHeroBetterEquip
EquipDataManager.GetNewEquipsCount = GetNewEquipsCount
EquipDataManager.CanShowEquipStar = CanShowEquipStar
EquipDataManager.IsPromoteFunctionOpen = IsPromoteFunctionOpen
EquipDataManager.GetAllCanPromoteEquip = GetAllCanPromoteEquip
EquipDataManager.GetAllWearingEquip = GetAllWearingEquip
EquipDataManager.GetAllEquipListByEquipId = GetAllEquipListByEquipId
EquipDataManager.GetTotalLevelByQuality = GetTotalLevelByQuality
EquipDataManager.CheckRedEquipOpen = CheckRedEquipOpen
EquipDataManager.UpdateTotalLevel = UpdateTotalLevel
EquipDataManager.GetEquipCountByQuality = GetEquipCountByQuality
EquipDataManager.GetPowerByTemplateId = GetPowerByTemplateId
EquipDataManager.GetPropertiesByTemplateIdReadOnly = GetPropertiesByTemplateIdReadOnly
EquipDataManager.CheckHeroesEquipQualityBelowFreeEquip = CheckHeroesEquipQualityBelowFreeEquip
return EquipDataManager
