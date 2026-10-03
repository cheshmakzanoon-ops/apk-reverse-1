local TWSkillChipInfo = BaseClass("TWSkillChipInfo")
local Localization = CS.GameEntry.Localization

function TWSkillChipInfo:__init()
  self.id = 0
  self.level = nil
  self.maxLevel = 0
  self.template = nil
  self.maxStar = 0
  self.star = nil
  self.skillInfo = nil
  self.additionalSkillInfo = nil
  self.type = 0
  self.masterSet = 0
  self.exp = 0
  self.uuid = 0
  self.quality = 1
  self.num = 0
end

function TWSkillChipInfo:__delete()
  self.id = nil
  self.level = nil
  self.maxLevel = nil
  self.template = nil
  self.maxStar = nil
  self.star = nil
  self.skillInfo = nil
  self.additionalSkillInfo = nil
  self.type = nil
  self.masterSet = nil
  self.exp = nil
  self.uuid = nil
  self.quality = nil
  self.num = nil
end

function TWSkillChipInfo:UpdateProperty(effectId, effectValue)
  if self.propertyData == nil then
    self.propertyData = HeroPropertyData.New()
  end
  self.propertyData:SetProperty(effectId, effectValue)
end

function TWSkillChipInfo:UpdateInfo(message)
  if message == nil then
    return
  end
  local changed = false
  if message.cfgId ~= nil then
    self.id = message.cfgId
    self.template = nil
    self.maxLevel = nil
    self.maxStar = nil
    self.type = nil
    self.quality = nil
  end
  if message.lv ~= nil then
    local prevLevel = self.level
    self.level = message.lv
    if prevLevel == nil or prevLevel ~= self.level then
      self:CalculateProperty()
      changed = true
    end
  end
  if message.equipGroup ~= nil then
    self.masterSet = message.equipGroup
  end
  if message.exp ~= nil then
    self.exp = message.exp
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.star then
    local prevStar = self.star
    self.star = message.star
    if prevStar == nil or prevStar ~= self.star then
      self.skillInfo = nil
      changed = true
    end
  end
  if message.num then
    self.num = message.num
  end
  if changed then
    self.power = nil
  end
end

function TWSkillChipInfo:CreateFromTemplate(id, level, star)
  if id == nil or id < 0 then
    return
  end
  self.id = id
  self.template = DataCenter.TWSkillChipTemplateManager:GetTemplate(self.id)
  self.maxLevel = 0
  self.maxStar = 0
  if self.template ~= nil then
    self.maxLevel = self.template.maxLevel
    self.maxStar = self.template.maxStar
    self.type = self.template.skill_type
    self.quality = self.template.quality
  else
    return false
  end
  self.level = level ~= nil and level or 1
  if self.level == -1 then
    self.level = self.maxLevel
  end
  self.power = nil
  self.star = star or 0
  if self.star == -1 then
    self.star = self.maxStar
  end
  self.skillInfo = nil
  self.additionalSkillInfo = nil
  self:CalculateProperty()
  return true
end

function TWSkillChipInfo:CalculateProperty()
  if self.propertyData then
    self.propertyData:Clear()
  end
  if not self.template then
    return
  end
  local attributes = self.template:GetAttributes(self.level)
  if table.IsNullOrEmpty(attributes) then
    return
  end
  for key, value in pairs(attributes) do
    local effectId = key
    local effectValue = value
    self:UpdateProperty(effectId, effectValue)
  end
end

function TWSkillChipInfo:CalculateSkillInfo()
  self.skillInfo = nil
end

function TWSkillChipInfo:GetSkillInfo()
  if not self.skillInfo or not self.skillId then
    if not self.template then
      return nil
    end
    self.skillInfo = self.template:GetSkillInfoByStarLevel(self.star)
    if self.skillInfo then
      self.skillId = self.skillInfo.skillId
    end
  end
  return self.skillInfo
end

function TWSkillChipInfo:GetAdditionalSkillInfo()
  if not self.additionalSkillInfo or not self.additionalSkillId then
    if not self.template then
      return nil
    end
    self.additionalSkillInfo = self.template:GetAdditionalSkillInfoByStarLevel(self.star)
    if self.additionalSkillInfo then
      self.additionalSkillId = self.additionalSkillInfo.skillId
    end
  end
  return self.additionalSkillInfo
end

function TWSkillChipInfo:CalculatePower()
  if self.template == nil then
    return 0
  end
  self.power = self.template:GetPower(self.level)
  local skillInfo = self:GetSkillInfo()
  if skillInfo then
    self.power = self.power + skillInfo:GetPower()
  end
  return self.power
end

function TWSkillChipInfo:GetSkillPower()
  local skillInfo = self:GetSkillInfo()
  if skillInfo then
    return skillInfo:GetPower()
  end
  return 0
end

function TWSkillChipInfo:GetPowerV2()
  if self.template == nil then
    return 0
  end
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo == nil then
    return self.template:GetSkillPowerByStarLevel(self:GetStar(), 0)
  end
  local lvTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(weaponInfo.chipLv)
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_UAV_SKILL_CHIP_LEVEL_FINAL)
  if not effectValue then
    effectValue = 0
  else
    effectValue = math.floor(effectValue + 0.1)
  end
  local result = self.template:GetSkillPowerByStarLevel(self:GetStar(), effectValue)
  result = math.floor(result + 0.1)
  return result
end

function TWSkillChipInfo:GetProperty(id)
  if self.propertyData == nil then
    return 0
  end
  return self.propertyData:GetProperty(id)
end

function TWSkillChipInfo:GetPropetyData()
  return self.propertyData
end

function TWSkillChipInfo:GetQuality()
  return self.quality ~= nil and self.quality or 1
end

function TWSkillChipInfo:GetIcon()
  if self.template == nil then
    return ""
  end
  return DataCenter.RewardManager:GetPicByType(RewardType.TWSkillChip, self.template.id)
end

function TWSkillChipInfo:GetType()
  return self.type ~= nil and self.type or 0
end

function TWSkillChipInfo:GetLevel()
  return self.level ~= nil and self.level or 0
end

function TWSkillChipInfo:GetStar()
  return self.star ~= nil and self.star or 0
end

function TWSkillChipInfo:GetUUID()
  return self.uuid ~= nil and self.uuid or 0
end

function TWSkillChipInfo:IsFree()
  return self.masterSet and self.masterSet == 0
end

function TWSkillChipInfo:GetPower()
  return self.power ~= nil and self.power or 0
end

function TWSkillChipInfo:GetMasterSet()
  return self.masterSet ~= nil and self.masterSet or 0
end

function TWSkillChipInfo:IsInMasterSet(id)
  if self.masterSets == nil then
    return false
  end
  for k, v in pairs(self.masterSets) do
    if v == id then
      return true
    end
  end
  return false
end

function TWSkillChipInfo:GetName()
  if self.template == nil then
    return ""
  end
  return Localization:GetString(self.template.name)
end

function TWSkillChipInfo:GetId()
  return self.id ~= nil and self.id or 0
end

function TWSkillChipInfo:GetSelfTotalExp(containSelfExp)
  local totalExp = 0
  if self.template then
    if containSelfExp then
      totalExp = totalExp + self.template.selfExp
    end
    if self.level and self.level > 1 then
      totalExp = totalExp + DataCenter.TWSkillChipTemplateManager:GetTotalNeedExpByTypeAndLevel(self.template.exp_id, self.level - 1)
    end
    totalExp = totalExp + self.exp
  end
  return totalExp
end

function TWSkillChipInfo:GetExpOnFeed()
  if self.template then
    local star = self:GetStar()
    if star <= 0 then
      return self.template.selfExp[1]
    else
      return self.template.selfExp[star + 1]
    end
  end
  return 0
end

local safeMaxLevel = 100000

function TWSkillChipInfo:GetTargetLevelByAddExp(addExp)
  local targetLevel = self.level
  local totalExp = self.exp + addExp
  if self.template then
    local needExp = DataCenter.TWSkillChipTemplateManager:GetNeedExpByTypeAndLevel(self.template.exp_id, targetLevel)
    if totalExp >= needExp then
      local safeCount = 0
      while totalExp >= needExp do
        targetLevel = targetLevel + 1
        totalExp = totalExp - needExp
        needExp = DataCenter.TWSkillChipTemplateManager:GetNeedExpByTypeAndLevel(self.template.exp_id, targetLevel)
        if targetLevel >= self.maxLevel then
          break
        end
        safeCount = safeCount + 1
        if safeCount > safeMaxLevel then
          break
        end
      end
    end
  end
  return targetLevel, totalExp
end

function TWSkillChipInfo:GetTargetLevelNeedExp(targetLevel)
  local totalExp = self.exp
  local needExp = 0
  if self.template then
    needExp = DataCenter.TWSkillChipTemplateManager:GetTotalNeedExpFromLevel(self.template.exp_id, self.level, targetLevel)
    needExp = needExp - totalExp
  end
  return needExp
end

function TWSkillChipInfo:GetExpId()
  if self.template then
    return self.template.exp_id
  end
  return 0
end

function TWSkillChipInfo:GetNum()
  if self.num then
    return self.num
  end
  return 1
end

function TWSkillChipInfo:IsMaxStar()
  return self.star == self.maxStar
end

function TWSkillChipInfo:IsMaxLevel()
  return self.level == self.maxLevel
end

function TWSkillChipInfo:GetStarUpCost()
  if not self.template then
    return
  end
  if self:IsMaxStar() then
    return
  end
  local commonFragId = self.template.upStarReplaceGoods
  local costNum = self.template:GetStarUpCostAtStar(self.star + 1)
  local fragId = self:GetId()
  return commonFragId, fragId, costNum
end

function TWSkillChipInfo:GetReturnItem()
  if not self.template then
    return
  end
  local returnGoods = {}
  local returnChips = {}
  local totalExp = self:GetSelfTotalExp(false)
  if 0 < totalExp then
    local returnItemNeedPerExp = LuaEntry.DataConfig:TryGetNum("TacticalWeapon_config", "k3", 1)
    local returnItemId = LuaEntry.DataConfig:TryGetNum("TacticalWeapon_config", "k4", 0)
    local returnItemCount = math.floor(totalExp / returnItemNeedPerExp)
    if 0 < returnItemCount then
      returnGoods[returnItemId] = returnItemCount
    end
  end
  returnChips[self.id] = 1
  if 0 < self.star then
    for i = 1, self.star do
      local promotedNeedNum = self.template:GetStarUpCostAtStar(i)
      returnChips[self.id] = returnChips[self.id] + promotedNeedNum
    end
  end
  return returnGoods, returnChips
end

function TWSkillChipInfo:GetProperties()
  local properties = {}
  if self.propertyData then
    properties = self.propertyData:GetAllProperty()
  end
  return properties
end

function TWSkillChipInfo:GetSortedProperties()
  local properties = {}
  if self.propertyData then
    local allProperties = self.propertyData:GetAllProperty()
    for k, v in pairs(allProperties) do
      table.insert(properties, {id = k, value = v})
    end
  end
  table.sort(properties, function(a, b)
    local aEffectNumberTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(a.id)
    local bEffectNumberTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(b.id)
    if not aEffectNumberTemplate or not bEffectNumberTemplate then
      return a.id < b.id
    end
    if aEffectNumberTemplate.sequence ~= bEffectNumberTemplate.sequence then
      return aEffectNumberTemplate.sequence < bEffectNumberTemplate.sequence
    end
    return a.id < b.id
  end)
  return properties
end

function TWSkillChipInfo:GetHeroType()
  if self.template then
    return self.template:GetSkillChipHeroType()
  else
    return HeroType.None
  end
end

function TWSkillChipInfo:GetChipSeries()
  if self.template then
    return self.template.chipSeries
  end
  Logger.LogError("template is nil! ")
  return nil
end

local function getter_power(self)
  if self.template == nil then
    return 0
  end
  self.power = self.template:GetPower(self.level)
  local skillInfo = self:GetSkillInfo()
  if skillInfo then
    self.power = self.power + skillInfo:GetPower()
  end
  return self.power
end

local function getter_template(self)
  if self.id then
    self.template = DataCenter.TWSkillChipTemplateManager:GetTemplate(self.id)
  end
  return self.template
end

local function getter_maxLevel(self)
  if self.template then
    self.maxLevel = self.template.maxLevel
  end
  return self.maxLevel
end

local function getter_maxStar(self)
  if self.template then
    self.maxStar = self.template.maxStar
  end
  return self.maxStar
end

local function getter_quality(self)
  if self.template then
    self.quality = self.template.quality
  end
  return self.quality
end

local function getter_skillType(self)
  if self.template then
    self.type = self.template.skill_type
  end
  return self.type
end

TWSkillChipInfo.getters.power = getter_power
TWSkillChipInfo.getters.template = getter_template
TWSkillChipInfo.getters.maxLevel = getter_maxLevel
TWSkillChipInfo.getters.maxStar = getter_maxStar
TWSkillChipInfo.getters.quality = getter_quality
TWSkillChipInfo.getters.type = getter_skillType
return TWSkillChipInfo
