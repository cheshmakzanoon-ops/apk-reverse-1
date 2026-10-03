local CommonEquipDataManager = BaseClass("CommonEquipDataManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.inited = false
  self.equipDataMap = {}
  self.equipDataTypeMap = {}
  self.equipOwnerMap = {}
end

local function __delete(self)
  self.inited = nil
  self.equipDataMap = nil
  self.equipDataTypeMap = nil
  self.equipOwnerMap = nil
  self:ClearEquipResearchCacheFeed()
end

local function GetEquipClass(self, type)
  if type == CommonEquipType.SquadEquip then
    return CommonEquipInfo
  end
end

local function InitData(self, message)
  self.inited = false
  if message.equipList then
    self.equipDataMap = {}
    self.equipDataTypeMap = {}
    self.equipOwnerMap = {}
    self:UpdateEquipInfos(message.equipList)
  end
  self.inited = true
end

local function AddToOwnerMap(self, equipInfo)
  if not equipInfo then
    return
  end
  local cfgType = equipInfo:GetConfigType()
  if not self.equipOwnerMap[cfgType] then
    self.equipOwnerMap[cfgType] = {}
  end
  if not self.equipOwnerMap[cfgType][equipInfo.ownerUid] then
    self.equipOwnerMap[cfgType][equipInfo.ownerUid] = {}
  end
  self.equipOwnerMap[cfgType][equipInfo.ownerUid][equipInfo.uuid] = equipInfo
end

local function RemoveFromOwnerMap(self, equipInfo)
  if not equipInfo then
    return
  end
  local cfgType = equipInfo:GetConfigType()
  if self.equipOwnerMap[cfgType] and self.equipOwnerMap[cfgType][equipInfo.ownerUid] then
    self.equipOwnerMap[cfgType][equipInfo.ownerUid][equipInfo.uuid] = nil
    if self.equipOwnerMap[cfgType][equipInfo.ownerUid] and table.count(self.equipOwnerMap[cfgType][equipInfo.ownerUid]) == 0 then
      self.equipOwnerMap[cfgType][equipInfo.ownerUid] = nil
    end
  end
end

local function RemoveEquipInfo(self, equipUuid, broadcast)
  if not equipUuid then
    return
  end
  local equipInfo = self:GetEquipInfo(equipUuid)
  if equipInfo then
    self.equipDataMap[equipUuid] = nil
    local cfgType = equipInfo:GetConfigType()
    if cfgType ~= CommonEquipType.None then
      if self.equipDataTypeMap[cfgType] then
        self.equipDataTypeMap[cfgType][equipUuid] = nil
      end
      if equipInfo:IsBeingWeared() then
        self:RemoveFromOwnerMap(equipInfo, true)
      end
    end
  end
  if broadcast or broadcast == nil then
    EventManager:GetInstance():Broadcast(EventId.CommonEquipDataChanged)
  end
end

local function AddEquipInfo(self, equipData)
  if not equipData then
    return
  end
  local equipId = equipData.cfgId
  if not equipId then
    return
  end
  local equipCfg = DataCenter.CommonEquipTemplateManager:GetTemplate(equipId)
  if not equipCfg then
    return
  end
  local equipType = equipCfg.type
  local cls = GetEquipClass(self, equipType)
  if cls then
    local info = cls.New()
    info:UpdateInfo(equipData)
    self.equipDataMap[info.uuid] = info
    local cfgType = info:GetConfigType()
    if cfgType ~= CommonEquipType.None then
      if not self.equipDataTypeMap[cfgType] then
        self.equipDataTypeMap[cfgType] = {}
      end
      self.equipDataTypeMap[cfgType][info.uuid] = info
      if info:IsBeingWeared() then
        self:AddToOwnerMap(info)
      end
    end
  end
end

local function GetEquipInfo(self, equipUuid)
  if not equipUuid then
    return nil
  end
  return self.equipDataMap[equipUuid]
end

local function UpdateEquipInfo(self, equipData)
  if not equipData then
    return
  end
  local equipInfo = self:GetEquipInfo(equipData.equipUid)
  if equipInfo and equipData.num <= 0 then
    self:RemoveEquipInfo(equipData.equipUid)
    return
  end
  if equipInfo then
    local cfgType = equipInfo:GetConfigType()
    if cfgType ~= CommonEquipType.None and equipInfo:IsBeingWeared() then
      self:RemoveFromOwnerMap(equipInfo, false)
    end
    if equipData.cfgId ~= equipInfo.cfgId then
      local newConfig = DataCenter.CommonEquipTemplateManager:GetTemplate(equipData.cfgId)
      local oldConfig = DataCenter.CommonEquipTemplateManager:GetTemplate(equipInfo.cfgId)
      if newConfig and oldConfig and newConfig.level > oldConfig.level then
        EventManager:GetInstance():Broadcast(EventId.TacticalEquipUpgrade, newConfig)
      end
    elseif equipData.exp > equipInfo.exp then
      EventManager:GetInstance():Broadcast(EventId.TacticalEquipResearchUpdate)
    end
    equipInfo:UpdateInfo(equipData)
    if cfgType ~= CommonEquipType.None and equipInfo:IsBeingWeared() then
      self:AddToOwnerMap(equipInfo)
    end
  else
    self:AddEquipInfo(equipData)
  end
end

local function UpdateEquipInfos(self, equipDatas, broadcast)
  if not equipDatas then
    return
  end
  for _, v in pairs(equipDatas) do
    self:UpdateEquipInfo(v)
  end
  if broadcast or broadcast == nil then
    EventManager:GetInstance():Broadcast(EventId.CommonEquipDataChanged)
  end
end

local function GetAllWearingEquipsByOwnerUid(self, type, ownerUid)
  local equips = {}
  if not type or not ownerUid then
    return equips
  end
  local ownerUidStr = tostring(ownerUid)
  if self.equipOwnerMap[type] and self.equipOwnerMap[type][ownerUidStr] and type == CommonEquipType.SquadEquip then
    for _, v in pairs(self.equipOwnerMap[type][ownerUidStr]) do
      local configSlot = v:GetConfigSlot()
      equips[configSlot] = v
    end
  end
  return equips
end

local function GetWearingEquipByOwnerIdAndSlot(self, type, ownerUid, slot)
  local equip
  if not (type and ownerUid) or not slot then
    return equip
  end
  local ownerUidStr = tostring(ownerUid)
  if self.equipOwnerMap[type] and self.equipOwnerMap[type][ownerUidStr] and type == CommonEquipType.SquadEquip then
    for _, v in pairs(self.equipOwnerMap[type][ownerUidStr]) do
      local configSlot = v:GetConfigSlot()
      if configSlot == slot then
        return v
      end
    end
  end
  return equip
end

local CommonEquipMaxSlotCount = {}
CommonEquipMaxSlotCount[CommonEquipType.SquadEquip] = 6

local function GetAllFreeEqiups(self, type, slot, needSort)
  local equips = {}
  if not type then
    return equips
  end
  if self.equipDataTypeMap[type] then
    for _, v in pairs(self.equipDataTypeMap[type]) do
      local configSlot = v:GetConfigSlot()
      if configSlot == slot and not v:IsBeingWeared() then
        table.insert(equips, v)
      end
    end
  end
  if needSort == nil or needSort == true then
    table.sort(equips, function(a, b)
      return a:GetConfigLevel() > b:GetConfigLevel()
    end)
  end
  return equips
end

local function GetAllFreeEqiupsByCfgId(self, cfgId)
  local equips = {}
  if not cfgId then
    return equips
  end
  if not table.IsNullOrEmpty(self.equipDataMap) then
    for _, v in pairs(self.equipDataMap) do
      if v.cfgId == cfgId and not v:IsBeingWeared() then
        table.insert(equips, v)
      end
    end
  end
  return equips
end

local function GetAllEquipsByCfgId(self, cfgId)
  local equips = {}
  if not cfgId then
    return equips
  end
  if not table.IsNullOrEmpty(self.equipDataMap) then
    for _, v in pairs(self.equipDataMap) do
      if v.cfgId == cfgId then
        table.insert(equips, v)
      end
    end
  end
  return equips
end

local function IsHasBetterCommonEquip(self, type, ownerUid)
  if not type or not ownerUid then
    return nil
  end
  if type == CommonEquipType.SquadEquip then
    local betterEquips = {}
    local maxCount = CommonEquipMaxSlotCount[type]
    local equips = self:GetAllWearingEquipsByOwnerUid(type, ownerUid)
    for i = 1, maxCount do
      local freeEquips = self:GetAllFreeEqiups(type, i)
      local equip = equips[i]
      if equip then
        if equip.exp <= 0 then
          local power = equip:GetPower()
          for _, v in pairs(freeEquips) do
            if power < v:GetPower() then
              betterEquips[i] = v
              power = v:GetPower()
            end
          end
        end
      else
        local power = 0
        for _, v in pairs(freeEquips) do
          if power < v:GetPower() then
            betterEquips[i] = v
            power = v:GetPower()
          end
        end
      end
    end
    return betterEquips
  end
  return nil
end

local function IsHasBetterCommonEquipSlot(self, type, ownerUid, slotId)
  if type == CommonEquipType.SquadEquip then
    local equip = self:GetWearingEquipByOwnerIdAndSlot(type, ownerUid, slotId)
    local freeEquips = self:GetAllFreeEqiups(type, slotId, false)
    if equip then
      for _, v in pairs(freeEquips) do
        if v:GetPower() > equip:GetPower() then
          return true
        end
      end
    elseif table.count(freeEquips) > 0 then
      return true
    end
  end
  return false
end

function CommonEquipDataManager:HasReplaceBatterEquip(curEquip, slotId)
  if curEquip.exp > 0 then
    return false
  end
  local freeEquips = self:GetAllFreeEqiups(CommonEquipType.SquadEquip, slotId)
  if curEquip and freeEquips then
    for _, v in pairs(freeEquips) do
      if v:GetPower() > curEquip:GetPower() then
        return true
      end
    end
  elseif 0 < table.count(freeEquips) then
    return true
  end
  return false
end

local function CollectEquipsEffectByOwnerUid(self, type, ownerUid)
  local effects = {}
  if not type or not ownerUid then
    return effects
  end
  local wearingEquips = self:GetAllWearingEquipsByOwnerUid(type, ownerUid)
  for _, v in pairs(wearingEquips) do
    local effect = v:GetEffects()
    if v.config.upgrade_switch == 1 and v.exp > 0 then
      effect = self:GetAttributeAndTotalPercent(v, v.exp)
    end
    if effect then
      for _, v in ipairs(effect) do
        if effects[v.key] then
          effects[v.key] = effects[v.key] + v.value
        else
          effects[v.key] = v.value
        end
      end
    end
  end
  return effects
end

local function GetAllEquipsByType(self, type)
  local equips = {}
  if not type then
    return equips
  end
  if self.equipDataTypeMap[type] then
    for _, v in pairs(self.equipDataTypeMap[type]) do
      table.insert(equips, v)
    end
  end
  return equips
end

local function CreateFakeEquipFromTemplate(self, templateId, num)
  if not templateId then
    return nil
  end
  local equipCfg = DataCenter.CommonEquipTemplateManager:GetTemplate(templateId)
  if not equipCfg then
    return nil
  end
  local equipType = equipCfg.type
  local cls = GetEquipClass(self, equipType)
  if cls then
    local info = cls.New()
    local equipData = {}
    equipData.num = num
    equipData.cfgId = templateId
    equipData.equipUid = templateId
    info:UpdateInfo(equipData)
    return info
  end
end

local function GetAddPowerForOwnerUid(self, type, ownerUid)
  local power = 0
  if not type or not ownerUid then
    return power
  end
  local wearingEquips = self:GetAllWearingEquipsByOwnerUid(type, ownerUid)
  for _, v in pairs(wearingEquips) do
    power = power + v:GetPower()
  end
  return power
end

local function IsCommonEquipCanUpgrade(self, cfgId, curNum)
  local sameEquips = self:GetAllFreeEqiupsByCfgId(cfgId)
  local sameEquipCount = 0
  if not table.IsNullOrEmpty(sameEquips) then
    for _, v in pairs(sameEquips) do
      sameEquipCount = sameEquipCount + v.num
    end
  end
  local equipTemplate = DataCenter.CommonEquipTemplateManager:GetTemplate(cfgId)
  if not equipTemplate then
    return false
  end
  local equipCanUpgrade = 0 < equipTemplate.target_id
  if not equipCanUpgrade then
    return false
  end
  local equipUpgradeCost = equipTemplate:GetUpgradeCost()
  local equipUpgradeCostNum = 3
  if not table.IsNullOrEmpty(equipUpgradeCost) then
    for id, num in pairs(equipUpgradeCost) do
      if id == cfgId then
        equipUpgradeCostNum = num
        break
      end
    end
  end
  return sameEquipCount >= equipUpgradeCostNum - curNum
end

local function IsCommonEquipCanUpgradeByOwner(self, type, ownerUid)
  if not type or not ownerUid then
    return nil
  end
  if type == CommonEquipType.SquadEquip then
    local maxCount = CommonEquipMaxSlotCount[type]
    local equips = self:GetAllWearingEquipsByOwnerUid(type, ownerUid)
    for i = 1, maxCount do
      local equip = equips[i]
      if equip then
        local canUpgrade = self:IsCommonEquipCanUpgrade(equip.cfgId, equip.num)
        if canUpgrade then
          return true
        end
      end
    end
    return false
  end
  return false
end

local function IsCommonEquipCanUpgradeByOwnerSlot(self, type, ownerUid, slotId)
  if type == CommonEquipType.SquadEquip then
    local equip = self:GetWearingEquipByOwnerIdAndSlot(type, ownerUid, slotId)
    if equip then
      local canUpgrade = self:IsCommonEquipCanUpgrade(equip.cfgId, equip.num)
      if canUpgrade then
        return true
      end
    end
  end
  return false
end

function CommonEquipDataManager:GetAllFreeEquipBagData(slotId)
  local allEquips = self:GetAllFreeEqiups(CommonEquipType.SquadEquip, slotId)
  local list = {}
  local dataCount = 0
  if allEquips and 0 < #allEquips then
    for i, v in ipairs(allEquips) do
      table.insert(list, v)
      dataCount = dataCount + 1
    end
  end
  return list, dataCount
end

function CommonEquipDataManager:GetOwnMaxLvFreeEquip(slotId)
  local allEquips = self:GetAllFreeEqiups(CommonEquipType.SquadEquip, slotId)
  local maxEquip
  if allEquips and 0 < #allEquips then
    for i, v in ipairs(allEquips) do
      if v and (not maxEquip or v:GetConfigLevel() > maxEquip:GetConfigLevel()) then
        maxEquip = v
      end
    end
  end
  return maxEquip
end

function CommonEquipDataManager:CanAutoMerge(slot)
  local allEquips = self:GetAllFreeEqiups(CommonEquipType.SquadEquip, slot)
  if not table.IsNullOrEmpty(allEquips) then
    for _, v in pairs(allEquips) do
      local equipUpgradeCost = v:GetUpgrdaeCost()
      local equipUpgradeCostNum = 3
      if not table.IsNullOrEmpty(equipUpgradeCost) then
        for id, num in pairs(equipUpgradeCost) do
          if id == v.cfgId then
            equipUpgradeCostNum = num
            break
          end
        end
      end
      if equipUpgradeCostNum <= v.num and v:GetCanUpgrade() then
        return true
      end
    end
  else
    return false
  end
  return false
end

function CommonEquipDataManager:GetEquipFeedList(slotId)
  local list = {}
  local exp = 0
  local freeEquipList = self:GetAllFreeEqiups(CommonEquipType.SquadEquip, slotId)
  for i, v in ipairs(freeEquipList) do
    if v then
      local feedData = {}
      feedData.equip = v
      feedData.useNum = 0
      if self.cacheEquipResearchFeed then
        for _, cacheFeed in ipairs(self.cacheEquipResearchFeed) do
          if cacheFeed and cacheFeed.equip.cfgId == v.cfgId then
            feedData.useNum = cacheFeed.useNum
            exp = exp + feedData.equip.config.growth_value * feedData.useNum
          end
        end
      end
      table.insert(list, feedData)
    end
  end
  return list, exp
end

function CommonEquipDataManager:GetEquipResearchCacheFeed()
  return self.cacheEquipResearchFeed
end

function CommonEquipDataManager:ClearEquipResearchCacheFeed()
  self.cacheEquipResearchFeed = nil
end

function CommonEquipDataManager:SetEquipResearchCacheFeed(feedArray)
  self.cacheEquipResearchFeed = feedArray
end

function CommonEquipDataManager:QuickFillEquipResearchCacheFeed(slot)
  if self.cacheEquipResearchFeed then
    table.clear(self.cacheEquipResearchFeed)
  else
    self.cacheEquipResearchFeed = {}
  end
  local allEquips = self:GetAllFreeEqiups(CommonEquipType.SquadEquip, slot)
  if allEquips then
    for _, v in pairs(allEquips) do
      if v then
        local feedData = {}
        feedData.equip = v
        feedData.useNum = v.num
        table.insert(self.cacheEquipResearchFeed, feedData)
      end
    end
  end
  return self.cacheEquipResearchFeed
end

function CommonEquipDataManager:GetCacheEquipResearchFeedExp()
  if not self.cacheEquipResearchFeed or #self.cacheEquipResearchFeed == 0 then
    return 0
  end
  local totalExp = 0
  for i, v in ipairs(self.cacheEquipResearchFeed) do
    if v then
      totalExp = totalExp + v.equip.config.growth_value * v.useNum
    end
  end
  return totalExp
end

function CommonEquipDataManager:GetPowerByPercent(basePower, groupId, percent)
  local record = math.floor(percent * 100)
  local group = DataCenter.CommonEquipTemplateManager:GetResearchTemplateGroup(groupId)
  if group == nil or #group <= 0 then
    Logger.LogError("group id is nil!!  groupId:" .. groupId)
    return
  end
  local power = basePower
  for i, v in ipairs(group) do
    if v then
      if record >= v.rangeMax then
        power = power + (v.rangeMax - v.rangeMin + 1) / v.small_percent_point * v.small_percent_power + v.big_percent_power
      else
        power = power + (record - v.rangeMin + 1) / v.small_percent_point * v.small_percent_power
        break
      end
    end
  end
  power = math.floor(power + 0.5)
  return power
end

function CommonEquipDataManager:GetAttributeAndTotalPercent(equipData, exp)
  local baseEffects = equipData:GetEffects()
  local curConfig = equipData.config
  local percent = 0
  local fullPercentCount = -1
  local resideExp = exp
  if curConfig:IsMax() then
    return baseEffects
  end
  repeat
    local curGroupId = curConfig.lv_group
    percent = math.min(1, resideExp / curConfig.upgrade_value)
    local effectResult = self:GetAttributeByPercentInner(baseEffects, curGroupId, percent)
    baseEffects = effectResult
    resideExp = resideExp - curConfig.upgrade_value
    curConfig = DataCenter.CommonEquipTemplateManager:GetTemplate(curConfig.target_id)
    fullPercentCount = fullPercentCount + 1
  until resideExp < 0 or curConfig:IsMax()
  local totalPercent = fullPercentCount + percent
  return baseEffects, totalPercent, resideExp
end

function CommonEquipDataManager:GetAttributeByPercentInner(baseEffects, groupId, percent)
  local record = math.floor(percent * 100)
  local group = DataCenter.CommonEquipTemplateManager:GetResearchTemplateGroup(groupId)
  if group == nil or #group <= 0 then
    Logger.LogError("group id is nil!!  groupId:" .. groupId)
    return
  end
  local sortMap = {}
  local totalEffectValue = {}
  if baseEffects then
    for i, v in ipairs(baseEffects) do
      totalEffectValue[v.key] = v.value
      sortMap[v.key] = i
    end
  end
  for i, v in ipairs(group) do
    if v then
      if record >= v.rangeMax then
        for effectId, value in pairs(v.smallEffectPercent) do
          if totalEffectValue[effectId] == nil then
            totalEffectValue[effectId] = 0
          end
          totalEffectValue[effectId] = totalEffectValue[effectId] + (v.rangeMax - v.rangeMin + 1) / v.small_percent_point * value
        end
        for effectId, value in pairs(v.big_percent_effect) do
          if totalEffectValue[effectId] == nil then
            totalEffectValue[effectId] = 0
          end
          totalEffectValue[effectId] = totalEffectValue[effectId] + value
        end
      else
        for effectId, value in pairs(v.smallEffectPercent) do
          if totalEffectValue[effectId] == nil then
            totalEffectValue[effectId] = 0
          end
          totalEffectValue[effectId] = totalEffectValue[effectId] + (record - v.rangeMin + 1) / v.small_percent_point * value
        end
        break
      end
    end
  end
  local list = {}
  for k, v in pairs(totalEffectValue) do
    local param = {}
    param.key = k
    param.value = v
    local index = sortMap[k]
    if index and index <= #list then
      table.insert(list, index, param)
    else
      table.insert(list, param)
    end
  end
  return list
end

function CommonEquipDataManager:GetStageAttribute(groupId, percentValue)
  local group = DataCenter.CommonEquipTemplateManager:GetResearchTemplateGroup(groupId)
  if group == nil or #group <= 0 then
    Logger.LogError("group id is nil!!  groupId:" .. groupId)
    return
  end
  local targetTemplate
  for i, v in ipairs(group) do
    if v and percentValue == v.rangeMax then
      targetTemplate = v
    end
  end
  if targetTemplate == nil then
    Logger.LogError("targetTemplate is nil  groupId:" .. groupId .. "  percentValue:" .. percentValue)
    return {}
  end
  return targetTemplate.stagePercentEffect
end

function CommonEquipDataManager:GetAttributePairsDataList(curAttribute, nextEffects)
  local list = {}
  if nextEffects then
    for _, v in ipairs(nextEffects) do
      local key = v.key
      local value = v.value
      local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(key)
      local formattedEffectValueStr = HeroUtils.GetFormattedPropertyValue(key, value)
      local param = {}
      param.effectId = key
      param.title = effectName
      param.nextValue = formattedEffectValueStr
      param.nextValueNumber = value
      local curValue = 0
      if curAttribute then
        for _, pair in ipairs(curAttribute) do
          if pair.key == key then
            curValue = pair.value
            break
          end
        end
      end
      local valueStr = HeroUtils.GetFormattedPropertyValue(key, curValue)
      param.curValue = valueStr
      param.curValueNumber = curValue
      param.valueChange = value ~= curValue
      table.insert(list, param)
    end
  else
    for _, v in ipairs(curAttribute) do
      local key = v.key
      local value = v.value
      local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(key)
      local formattedEffectValueStr = HeroUtils.GetFormattedPropertyValue(key, value)
      local param = {}
      param.effectId = key
      param.title = effectName
      param.curValue = formattedEffectValueStr
      param.curValueNumber = value
      table.insert(list, param)
    end
  end
  return list
end

function CommonEquipDataManager:CanResearch(slotId)
  local equip = self:GetWearingEquipByOwnerIdAndSlot(CommonEquipType.SquadEquip, BuildingTypes.LW_BUILD_TACTICAL_CENTER, slotId)
  local freeEquipList = self:GetAllFreeEqiups(CommonEquipType.SquadEquip, slotId)
  if equip and equip.config.upgrade_switch == 1 and equip.config.target_id > 0 and 0 < #freeEquipList then
    return true
  end
  return false
end

function CommonEquipDataManager:ExistResearch()
  for i = 1, 6 do
    if self:CanResearch(i) then
      return true
    end
  end
  return false
end

function CommonEquipDataManager:GetEquipName(slotId)
  local template
  if slotId == 1 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1101)
  elseif slotId == 2 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1201)
  elseif slotId == 3 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1301)
  elseif slotId == 4 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1401)
  elseif slotId == 5 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1501)
  elseif slotId == 6 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1601)
  end
  if template then
    return CS.GameEntry.Localization:GetString(template.name)
  end
  return ""
end

CommonEquipDataManager.__init = __init
CommonEquipDataManager.__delete = __delete
CommonEquipDataManager.InitData = InitData
CommonEquipDataManager.RemoveEquipInfo = RemoveEquipInfo
CommonEquipDataManager.AddEquipInfo = AddEquipInfo
CommonEquipDataManager.GetEquipInfo = GetEquipInfo
CommonEquipDataManager.UpdateEquipInfo = UpdateEquipInfo
CommonEquipDataManager.UpdateEquipInfos = UpdateEquipInfos
CommonEquipDataManager.GetAllWearingEquipsByOwnerUid = GetAllWearingEquipsByOwnerUid
CommonEquipDataManager.GetAllFreeEqiups = GetAllFreeEqiups
CommonEquipDataManager.GetAllEquipsByCfgId = GetAllEquipsByCfgId
CommonEquipDataManager.GetAllFreeEqiupsByCfgId = GetAllFreeEqiupsByCfgId
CommonEquipDataManager.IsHasBetterCommonEquip = IsHasBetterCommonEquip
CommonEquipDataManager.IsHasBetterCommonEquipSlot = IsHasBetterCommonEquipSlot
CommonEquipDataManager.CollectEquipsEffectByOwnerUid = CollectEquipsEffectByOwnerUid
CommonEquipDataManager.GetWearingEquipByOwnerIdAndSlot = GetWearingEquipByOwnerIdAndSlot
CommonEquipDataManager.AddToOwnerMap = AddToOwnerMap
CommonEquipDataManager.RemoveFromOwnerMap = RemoveFromOwnerMap
CommonEquipDataManager.GetAllEquipsByType = GetAllEquipsByType
CommonEquipDataManager.CreateFakeEquipFromTemplate = CreateFakeEquipFromTemplate
CommonEquipDataManager.GetAddPowerForOwnerUid = GetAddPowerForOwnerUid
CommonEquipDataManager.IsCommonEquipCanUpgrade = IsCommonEquipCanUpgrade
CommonEquipDataManager.IsCommonEquipCanUpgradeByOwner = IsCommonEquipCanUpgradeByOwner
CommonEquipDataManager.IsCommonEquipCanUpgradeByOwnerSlot = IsCommonEquipCanUpgradeByOwnerSlot
return CommonEquipDataManager
