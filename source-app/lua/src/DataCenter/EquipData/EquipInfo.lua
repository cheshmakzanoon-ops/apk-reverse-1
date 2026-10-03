local EquipInfo = BaseClass("EquipInfo")
local Localization = CS.GameEntry.Localization
local propertyData = require("DataCenter.HeroData.HeroPropertyData")

local function __init(self)
  self.uuid = 0
  self.configId = 0
  self.level = nil
  self.count = 0
  self.heroUuid = 0
  self.slot = 0
  self.makeEndTime = 0
  self.config = nil
  self.baseWordId = 0
  self.upgradeTemplate = nil
  self.maxLevel = 0
  self.promoteLevel = 0
  self.maxPromoteLevel = 0
  self.newCount = 0
end

local function __delete(self)
  self.uuid = nil
  self.configId = nil
  self.level = nil
  self.count = nil
  self.heroUuid = nil
  self.slot = nil
  self.makeEndTime = nil
  self.config = nil
  self.baseWordId = nil
  self.upgradeTemplate = nil
  self.maxLevel = nil
  self.promoteLevel = nil
  self.maxPromoteLevel = nil
end

local function CollectProperty(self)
  if not self._propertyData then
    self._propertyData = propertyData.New()
  end
  if self.config == nil then
    return
  end
  if self.propertyCachedLevel and self.propertyCachedPromoteLevel and self.propertyCachedConfigId and self.propertyCachedLevel == self.level and self.propertyCachedPromoteLevel == self.promoteLevel and self.propertyCachedConfigId == self.configId then
    return
  end
  self._propertyData:Clear()
  local properties = DataCenter.EquipDataManager:GetPropertiesByTemplateIdReadOnly(self.configId, self.level, self.promoteLevel)
  for k, v in pairs(properties) do
    self._propertyData:SetProperty(k, v)
  end
  self.propertyCachedLevel = self.level
  self.propertyCachedPromoteLevel = self.promoteLevel
  self.propertyCachedConfigId = self.configId
end

local function CalcPower(self)
  if self.cachedPower and self.cachedLevel and self.cachedPromoteLevel and self.cachedConfigId and self.cachedLevel == self.level and self.cachedPromoteLevel == self.promoteLevel and self.cachedConfigId == self.configId then
    return self.cachedPower
  end
  if self.config == nil then
    return 0
  end
  local power = DataCenter.EquipDataManager:GetPowerByTemplateId(self.configId, self.level, self.promoteLevel)
  if 0 < power then
    power = math.floor(power)
  end
  self.cachedPower = power
  self.cachedLevel = self.level
  self.cachedPromoteLevel = self.promoteLevel
  self.cachedConfigId = self.configId
  return power
end

local function GetPower(self)
  return CalcPower(self)
end

EquipInfo.getters.power = GetPower

local function GetPropertyData(self)
  CollectProperty(self)
  return self._propertyData
end

EquipInfo.getters.propertyData = GetPropertyData

local function CollectWords(self)
  if self.config == nil then
    return
  end
  self.baseWordId = self.config:GetBaseWordIdByLevel(self.level)
end

local function UpdateInfo(self, message, isInit)
  local lastCount = 0
  if message == nil then
    return
  end
  if message.uid ~= nil then
    self.uuid = message.uid
  end
  if message.cfgId ~= nil then
    local prevConfigId = self.configId
    self.configId = message.cfgId
    if prevConfigId ~= self.configId then
      self.config = DataCenter.EquipTemplateManager:GetTemplate(self.configId)
      self.maxPromoteLevel = self.config.maxPromoteLevel
    end
  end
  if message.level ~= nil then
    local prevLevel = self.level
    self.level = message.level
    if prevLevel ~= self.level then
      CollectWords(self)
      if self.config ~= nil then
        self.upgradeTemplate = DataCenter.EquipUpgradeTemplateManager:GetTemplateBySlotQualityHeroType(self.config.slot, self.config.quality, self.config.heroType)
        if self.upgradeTemplate ~= nil then
          self.maxLevel = self.upgradeTemplate.maxLevel
        else
          self.maxLevel = self.level
        end
      end
    end
  end
  if message.count ~= nil then
    lastCount = self.count
    self.count = message.count
  end
  if message.heroUid ~= nil then
    self.heroUuid = message.heroUid
  end
  if message.slot ~= nil then
    self.slot = message.slot
  end
  if message.makeEndTime ~= nil then
    self.makeEndTime = message.makeEndTime
  end
  if message.promote ~= nil then
    local prevPromoteLevel = self.promoteLevel
    self.promoteLevel = message.promote
    if prevPromoteLevel ~= self.promoteLevel then
      CollectWords(self)
    end
  end
end

local function SetNewCount(self)
  CommonUtil.PlayerPrefsSetInt(self.uuid, 0)
  self.newCount = 0
  EventManager:GetInstance():Broadcast(EventId.RefreshBagRedDot)
end

local function CreateFromTemplate(self, templateId, lv, promoteLv)
  if templateId == nil then
    return
  end
  local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(templateId)
  if equipTemplate == nil then
    self.config = nil
    return
  end
  self.uuid = 0
  self.configId = templateId
  self.config = equipTemplate
  self.upgradeTemplate = DataCenter.EquipUpgradeTemplateManager:GetTemplateBySlotQualityHeroType(self.config.slot, self.config.quality, self.config.heroType)
  if self.upgradeTemplate ~= nil then
    self.maxLevel = self.upgradeTemplate.maxLevel
  else
    self.maxLevel = lv or 0
  end
  self.maxPromoteLevel = self.config.maxPromoteLevel
  if not lv then
    self.level = 0
  else
    self.level = lv > self.maxLevel and self.maxLevel or lv
  end
  if not promoteLv then
    self.promoteLevel = 0
  else
    self.promoteLevel = promoteLv > self.maxPromoteLevel and self.maxPromoteLevel or promoteLv
  end
  CollectWords(self)
  self.count = 1
  self.heroUuid = nil
  self.cachedPower = nil
  self.cachedLevel = nil
  self.cachedPromoteLevel = nil
  self.cachedConfigId = nil
  self.propertyCachedLevel = nil
  self.propertyCachedPromoteLevel = nil
  self.propertyCachedConfigId = nil
end

local function GetAllWords(self)
  local baseWordData = self:GetBasicAttr()
  local upgradeWords = self:GetAdditionAttr()
  table.sort(upgradeWords, function(a, b)
    if a.needPromoteLv and b.needPromoteLv then
      return a.needPromoteLv < b.needPromoteLv
    else
      return a.unlockLevel < b.unlockLevel
    end
  end)
  return baseWordData, upgradeWords
end

local function GetAllProperty(self)
  return self.propertyData:GetAllProperty()
end

local function CanUpgrade(self)
  if self.level >= self.maxLevel then
    return false
  end
  local costGold = self.upgradeTemplate:GetCostResourceValueByLevel(self.level)
  local costType = self.upgradeTemplate:GetCostResourceTypeByLevel(self.level)
  local hasGold = CommonUtil.GetResOrItemCount(costType)
  if costGold > hasGold then
    return false
  end
  local costStone = self.upgradeTemplate:GetCostStoneByLevel(self.level)
  local hasStone = DataCenter.ResourceItemDataManager:GetCountByItemId(ResourceItemId.EquipStrengtheningStone)
  if costStone > hasStone then
    return false
  end
  return true
end

local function CanShowRedPoint(self)
  local canUpgrade = self:CanUpgrade()
  if canUpgrade then
    return true
  end
  return false
end

local function GetAllWordProperties(self)
  if self.config == nil then
    return {}
  end
  local baseWord, upgradeWords = self:GetAllWordPropertiesSeperate()
  local result = {}
  table.insertto(result, baseWord)
  table.insertto(result, upgradeWords)
  return result
end

local function GetBreakReturnMaterialAndItems(self)
  local material = {}
  local items = 0
  if self.config ~= nil then
    material = DeepCopy(self.config.return_Items)
  end
  items = DataCenter.EquipUpgradeTemplateManager:GetEquipUsedItem(self.config.slot, self.config.quality, self.config.heroType, self.level)
  local promoteReturn = DataCenter.EquipPromoteTemplateManager:GetEquipUsedItem(self.promoteLevel)
  if not table.IsNullOrEmpty(promoteReturn) then
    local stoneReturn = promoteReturn[ResourceItemId.EquipStrengtheningStone]
    if stoneReturn ~= nil then
      items = items + stoneReturn
      promoteReturn[ResourceItemId.EquipStrengtheningStone] = nil
    end
    for k, v in pairs(promoteReturn) do
      if material[k] == nil then
        material[k] = 0
      end
      material[k] = material[k] + v
    end
  end
  return material, items
end

local function GetProperty(self, propertyType)
  if self.propertyData == nil then
    return 0
  end
  return self.propertyData:GetProperty(propertyType)
end

local function SupportPromote(self)
  if self.config then
    return self.config.target_promote ~= 0
  end
  return false
end

local function IsMaxLevel(self)
  if self.level >= self.maxLevel then
    return true
  end
  return false
end

local function CanStartPromote(self)
  if not self:SupportPromote() then
    return false
  end
  if not self:IsMaxLevel() then
    return false
  end
  if self:IsMaxPromoteLevel() then
    return false
  end
  return true
end

local function CanPromote(self)
  if not DataCenter.EquipDataManager:IsPromoteFunctionOpen() then
    return false
  end
  if not self:CanStartPromote() then
    return false
  end
  if self:IsMaxPromoteLevel() then
    return false
  end
  local promoteCostTemplate = DataCenter.EquipPromoteTemplateManager:GetTemplate(self.promoteLevel + 1)
  if promoteCostTemplate == nil then
    return false
  end
  local costDatas = promoteCostTemplate:ParseData()
  for _, data in pairs(costDatas) do
    if data.isResource then
      local resourceType = data.id
      local haveCount = LuaEntry.Resource:GetCntByResType(resourceType)
      local needCount = data.value
      if haveCount < needCount then
        return false
      end
    else
      local haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(data.id)
      local needCount = data.value
      if haveCount < needCount then
        return false
      end
    end
  end
  return true
end

local function IsMaxPromoteLevel(self)
  if not self:SupportPromote() and self.promoteLevel < 0 then
    return false
  end
  if self.promoteLevel >= self.config.maxPromoteLevel then
    return true
  end
  return false
end

local function GetAllWordPropertiesSeperate(self)
  if self.config == nil then
    return {}
  end
  local baseWord, upgradeWords = self:GetAllWords()
  local baseArray = {}
  if baseWord ~= nil then
    for id, value in pairs(baseWord.effects) do
      local propertyData = {}
      propertyData.id = id
      propertyData.value = value
      propertyData.isBaseWord = true
      propertyData.unlockLevel = baseWord.unlockLevel
      table.insert(baseArray, propertyData)
    end
  end
  table.sort(baseArray, function(a, b)
    local aTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(a.id)
    local bTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(b.id)
    if aTemplate == nil and bTemplate ~= nil then
      return false
    end
    if aTemplate ~= nil and bTemplate == nil then
      return true
    end
    if aTemplate == nil and bTemplate == nil then
      return true
    end
    return aTemplate.sequence < bTemplate.sequence
  end)
  local additionArray = {}
  if upgradeWords ~= nil then
    for id, value in pairs(upgradeWords) do
      local toolArray = {}
      for k, v in pairs(value.effects) do
        local propertyData = {}
        propertyData.id = k
        propertyData.value = v
        propertyData.unlockLevel = value.unlockLevel
        propertyData.needPromoteLv = value.needPromoteLv
        propertyData.isBaseWord = false
        table.insert(toolArray, propertyData)
      end
      table.sort(toolArray, function(a, b)
        local aTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(a.id)
        local bTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(b.id)
        return aTemplate.sequence < bTemplate.sequence
      end)
      table.insertto(additionArray, toolArray)
    end
  end
  return baseArray, additionArray
end

local function CollectBasicAttr(self, level, promoteLevel)
  local baseWordData = {}
  if not self.config or not level then
    return baseWordData
  end
  local baseWordId = self.config:GetBaseWordIdByLevel(level)
  if baseWordId ~= nil and 0 < baseWordId then
    baseWordData.unlockLevel = level
    baseWordData.effects = {}
    local wordTemplate = DataCenter.EquipWordTemplateManager:GetTemplate(baseWordId)
    if wordTemplate ~= nil then
      for id, value in pairs(wordTemplate.effects) do
        baseWordData.effects[id] = value
      end
    end
    if promoteLevel and 0 < promoteLevel then
      local promoteWordId = self.config:GetBaseAttrByPromoteLevel(promoteLevel)
      if 0 < promoteWordId then
        local promoteWord = DataCenter.EquipWordTemplateManager:GetTemplate(promoteWordId)
        if promoteWord.effects ~= nil then
          for k, v in pairs(promoteWord.effects) do
            local prevValue = baseWordData.effects[k] or 0
            baseWordData.effects[k] = prevValue + v
          end
        end
      end
    end
  end
  return baseWordData
end

local function GetBasicAttr(self)
  return self:CollectBasicAttr(self.level, self.promoteLevel)
end

local function CollectAdditionAttr(self, level, promoteLevel)
  if not self.config then
    return {}
  end
  local attrWords = self.config:GeRealAddsByLvs(level, promoteLevel)
  local wordsData = {}
  for i, wordData in ipairs(attrWords) do
    local wordTemplate = DataCenter.EquipWordTemplateManager:GetTemplate(wordData.id)
    if wordTemplate ~= nil then
      local attrData = {}
      attrData.unlockLevel = wordData.unlockLevel
      attrData.needPromoteLv = wordData.needPromoteLv
      attrData.effects = {}
      for id, value in pairs(wordTemplate.effects) do
        attrData.effects[id] = value
      end
      table.insert(wordsData, attrData)
    end
  end
  return wordsData
end

local function GetAdditionAttr(self)
  return self:CollectAdditionAttr(self.level, self.promoteLevel)
end

local function IsBeingWeared(self)
  return self.heroUuid and self.heroUuid > 0
end

EquipInfo.__init = __init
EquipInfo.__delete = __delete
EquipInfo.UpdateInfo = UpdateInfo
EquipInfo.CreateFromTemplate = CreateFromTemplate
EquipInfo.GetAllWords = GetAllWords
EquipInfo.GetAllProperty = GetAllProperty
EquipInfo.CanUpgrade = CanUpgrade
EquipInfo.CanShowRedPoint = CanShowRedPoint
EquipInfo.GetAllWordProperties = GetAllWordProperties
EquipInfo.GetBreakReturnMaterialAndItems = GetBreakReturnMaterialAndItems
EquipInfo.GetProperty = GetProperty
EquipInfo.GetNewCount = GetNewCount
EquipInfo.SetNewCount = SetNewCount
EquipInfo.SupportPromote = SupportPromote
EquipInfo.IsMaxLevel = IsMaxLevel
EquipInfo.CanStartPromote = CanStartPromote
EquipInfo.IsMaxPromoteLevel = IsMaxPromoteLevel
EquipInfo.GetAllWordPropertiesSeperate = GetAllWordPropertiesSeperate
EquipInfo.CollectBasicAttr = CollectBasicAttr
EquipInfo.GetBasicAttr = GetBasicAttr
EquipInfo.CanPromote = CanPromote
EquipInfo.CollectAdditionAttr = CollectAdditionAttr
EquipInfo.GetAdditionAttr = GetAdditionAttr
EquipInfo.IsBeingWeared = IsBeingWeared
return EquipInfo
