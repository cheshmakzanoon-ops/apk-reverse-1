local EquipTemplate = BaseClass("HeroTemplate")

local function __init(self)
  self.id = 0
  self.unlock_Level = 0
  self.cost_Time = 0
  self.name = ""
  self.quality = 0
  self.slot = 0
  self.heroType = 0
  self.icon = ""
  self.baseWord = {}
  self.upgradeWords = {}
  self.cost_Items = {}
  self.cost_Resource = nil
  self.return_Items = {}
  self.power = 0
  self.desc = ""
  self.canCraft = false
  self.target_promote = 0
  self.target_level = 0
  self.basic_attributes = {}
  self.addition_attributes = {}
  self.maxPromoteLevel = 0
end

local function __delete(self)
  self.id = nil
  self.unlock_Level = nil
  self.cost_Time = nil
  self.name = nil
  self.quality = nil
  self.slot = nil
  self.heroType = nil
  self.icon = nil
  self.baseWord = nil
  self.upgradeWords = nil
  self.cost_Items = nil
  self.cost_Resource = nil
  self.return_Items = nil
  self.power = nil
  self.desc = nil
  self.canCraft = nil
  self.target_promote = nil
  self.basic_attributes = nil
  self.addition_attributes = nil
  self.maxPromoteLevel = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.unlock_Level = tonumber(row:getValue("unlock_level")) or 0
  self.cost_Time = tonumber(row:getValue("time")) or 0
  self.name = row:getValue("name") or ""
  self.quality = tonumber(row:getValue("quality")) or 0
  self.slot = tonumber(row:getValue("slot")) or 0
  self.heroType = tonumber(row:getValue("army_type")) or 0
  self.icon = row:getValue("icon") or ""
  self.baseWord = row:getValue("basic_attributes") or {}
  self.upgradeWords = row:getValue("addition_attributes") or {}
  self.cost_Items = row:getValue("craft_materials") or {}
  local cost_ResourceStr = row:getValue("coins")
  if not string.IsNullOrEmpty(cost_ResourceStr) then
    local cost_Resource = string.split(cost_ResourceStr, ";")
    if 2 <= #cost_Resource then
      self.cost_Resource = {
        type = tonumber(cost_Resource[1]),
        num = tonumber(cost_Resource[2])
      }
    end
  end
  self.return_Items = row:getValue("break_material") or {}
  self.power = tonumber(row:getValue("power")) or 0
  self.desc = row:getValue("desc") or ""
  local canCraft = tonumber(row:getValue("is_craft")) or 0
  self.canCraft = canCraft == 1
  self.target_promote = 0
  self.target_level = 0
  local target = row:getValue("target_promote") or {}
  if not table.IsNullOrEmpty(target) and 2 <= #target then
    self.target_level = tonumber(target[1])
    self.target_promote = tonumber(target[2])
  end
  self.basic_attributes = row:getValue("basic_attributes_promote") or {}
  self.addition_attributes = row:getValue("addition_attributes__promote") or {}
  self.maxPromoteLevel = #self.basic_attributes
end

local function GetBaseWordIdByLevel(self, level)
  if self.baseWord == nil then
    return 0
  end
  return self.baseWord[level + 1]
end

local function GetAllUpgradeWords(self)
  return DeepCopy(self.upgradeWords)
end

local function GetCostResourceType(self)
  if self.cost_Resource ~= nil then
    return self.cost_Resource.type
  end
  return 0
end

local function GetCostResourceNum(self)
  if self.cost_Resource ~= nil then
    return self.cost_Resource.num
  end
  return 0
end

local function CanCraft(self, buildLevel)
  if buildLevel < self.unlock_Level then
    return false
  end
  local costResourceType = self:GetCostResourceType()
  local costResourceNum = self:GetCostResourceNum()
  local haveResourceCount = CommonUtil.GetResOrItemCount(costResourceType)
  if costResourceNum > haveResourceCount then
    return false
  end
  local costItems = self.cost_Items
  for k, v in pairs(costItems) do
    local haveItemCount = DataCenter.ResourceItemDataManager:GetCountByItemId(k)
    if v > haveItemCount then
      return false
    end
  end
  return true
end

local function GetBaseAttrByPromoteLevel(self, level)
  if level <= 0 then
    return 0
  end
  if self.basic_attributes ~= nil and self.basic_attributes[level] then
    return self.basic_attributes[level]
  end
  return 0
end

local function GetSortedUpgradeWords(self)
  if self.sortedUpgradeWords ~= nil then
    return self.sortedUpgradeWords
  end
  local sortedUpgradeWords = {}
  for k, v in pairs(self.upgradeWords) do
    table.insert(sortedUpgradeWords, {k, v})
  end
  table.sort(sortedUpgradeWords, function(a, b)
    return a[1] < b[1]
  end)
  self.sortedUpgradeWords = sortedUpgradeWords
  return sortedUpgradeWords
end

local function GetSortedAdditionAttributes(self)
  if self.sortedAdditionAttributes ~= nil then
    return self.sortedAdditionAttributes
  end
  local sortedAdditionAttributes = {}
  if not table.IsNullOrEmpty(self.addition_attributes) then
    for k, v in pairs(self.addition_attributes) do
      table.insert(sortedAdditionAttributes, {k, v})
    end
    table.sort(sortedAdditionAttributes, function(a, b)
      return a[1] < b[1]
    end)
  end
  self.sortedAdditionAttributes = sortedAdditionAttributes
  return sortedAdditionAttributes
end

local TABLE_IS_NULL_OR_EMPTY = table.IsNullOrEmpty

local function GetUnlockWordsByLevel(self, level, promoteLevel)
  local unlockWords = {}
  if self.upgradeWords ~= nil then
    local sortedUpgradeWords = GetSortedUpgradeWords(self)
    local sortedAdditionAttributes = GetSortedAdditionAttributes(self)
    if not TABLE_IS_NULL_OR_EMPTY(sortedAdditionAttributes) then
      for k, v in pairs(sortedAdditionAttributes) do
        local needPromoteLv = v[1]
        local promoteUnlcokWordId = v[2]
        if promoteLevel >= needPromoteLv then
          table.insert(unlockWords, promoteUnlcokWordId)
        else
          local upgradeWord = sortedUpgradeWords[k]
          if upgradeWord ~= nil then
            local needLevel = upgradeWord[1]
            local unlockWordId = upgradeWord[2]
            if level >= needLevel then
              table.insert(unlockWords, unlockWordId)
            end
          end
        end
      end
    else
      for k, v in pairs(sortedUpgradeWords) do
        local needLevel = v[1]
        local unlockWordId = v[2]
        if level >= needLevel then
          table.insert(unlockWords, unlockWordId)
        end
      end
    end
  end
  return unlockWords
end

local function GeRealAddsByLvs(self, level, promoteLevel, containPromoteAdd)
  local words = {}
  if self.upgradeWords ~= nil then
    local sortedUpgradeWords = GetSortedUpgradeWords(self)
    local sortedAdditionAttributes = GetSortedAdditionAttributes(self)
    if not table.IsNullOrEmpty(sortedAdditionAttributes) then
      for k, v in pairs(sortedAdditionAttributes) do
        local needPromoteLv = v[1]
        local promoteUnlcokWordId = v[2]
        local upgradeWord = sortedUpgradeWords[k]
        if promoteLevel >= needPromoteLv then
          local wordData = {}
          wordData.id = promoteUnlcokWordId
          wordData.unlockLevel = 0
          if upgradeWord then
            wordData.unlockLevel = upgradeWord[1]
          else
            wordData.isPromoteAdd = true
          end
          wordData.needPromoteLv = needPromoteLv
          table.insert(words, wordData)
        elseif upgradeWord ~= nil then
          local wordData = {}
          wordData.id = upgradeWord[2]
          wordData.unlockLevel = upgradeWord[1]
          wordData.needPromoteLv = needPromoteLv
          table.insert(words, wordData)
        elseif containPromoteAdd then
          local wordData = {}
          wordData.id = promoteUnlcokWordId
          wordData.unlockLevel = 0
          wordData.needPromoteLv = needPromoteLv
          wordData.isPromoteAdd = true
          table.insert(words, wordData)
        end
      end
    else
      for k, v in pairs(sortedUpgradeWords) do
        local wordData = {}
        wordData.id = v[2]
        wordData.unlockLevel = v[1]
        wordData.needPromoteLv = 0
        table.insert(words, wordData)
      end
    end
  end
  return words
end

EquipTemplate.__init = __init
EquipTemplate.__delete = __delete
EquipTemplate.InitData = InitData
EquipTemplate.GetBaseWordIdByLevel = GetBaseWordIdByLevel
EquipTemplate.GetUnlockWordsByLevel = GetUnlockWordsByLevel
EquipTemplate.GetAllUpgradeWords = GetAllUpgradeWords
EquipTemplate.GetCostResourceType = GetCostResourceType
EquipTemplate.GetCostResourceNum = GetCostResourceNum
EquipTemplate.CanCraft = CanCraft
EquipTemplate.GetBaseAttrByPromoteLevel = GetBaseAttrByPromoteLevel
EquipTemplate.GeRealAddsByLvs = GeRealAddsByLvs
return EquipTemplate
