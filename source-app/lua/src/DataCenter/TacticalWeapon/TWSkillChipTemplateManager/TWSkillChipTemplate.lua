local TWSkillChipTemplate = BaseClass("TWSkillChipTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.name = ""
  self.skill_type = 0
  self.quality = 0
  self.icon = ""
  self.selfExp = 0
  self.maxLevel = 0
  self.attrTemplate_id = {}
  self.maxStar = 0
  self.skillIds = {}
  self.additionalSkillIds = {}
  self.exp_id = 0
  self.promotedNeedChips = {}
  self.upStarReplaceGoods = 0
  self.isShow = false
  self.heroType = HeroType.None
  self.chipSeries = 0
  self.craft_material = nil
  self.craft_time = 0
  self.craft_factory_level = -1
  self.chip_bonus_desc = ""
  self.chip_bonus_desc_para = {}
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.skill_type = nil
  self.quality = nil
  self.icon = nil
  self.selfExp = nil
  self.maxLevel = nil
  self.attrTemplate_id = nil
  self.maxStar = nil
  self.skillIds = nil
  self.additionalSkillIds = nil
  self.exp_id = nil
  self.promotedNeedChips = nil
  self.upStarReplaceGoods = nil
  self.isShow = nil
  self.chipSeries = nil
  self.craft_material = nil
  self.craft_time = nil
  self.craft_factory_level = nil
  self.chip_bonus_desc = nil
  self.chip_bonus_desc_para = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row.id
  self.name = row.name
  self.skill_type = tonumber(row.skill_type)
  self.quality = tonumber(row.quality)
  self.icon = row.icon
  self.selfExp = row.selfExp
  self.maxLevel = tonumber(row.maxLevel)
  self.maxStar = tonumber(row.maxStar)
  self.chipSeries = tonumber(row.chipSeries)
  self.skillIds = row.skill_id
  self.additionalSkillIds = row.additional_skill_id
  self.attrTemplate_id = row.attribute_id
  self.exp_id = tonumber(row.exp_id) or 0
  self.promotedNeedChips = row.promoteNeedChips
  self.upStarReplaceGoods = tonumber(row.upStarReplaceGoods) or 0
  self.isShow = tonumber(row.isShow) == 1
  self.heroType = tonumber(row.heroType) or HeroType.None
  self.craft_material = row.craft_material
  self.craft_time = row.craft_time
  self.craft_factory_level = row.craft_factory_level
  self.chip_bonus_desc = row:getValue("chip_bonus_desc")
  local skill_desc_para = row:getValue("chip_bonus_desc_para")
  self.chip_bonus_desc_para = {}
  local count = 1
  if not string.IsNullOrEmpty(skill_desc_para) then
    local skill_desc_para_array = string.split(skill_desc_para, "|")
    for k, v in pairs(skill_desc_para_array) do
      local skill_desc_para_data = string.split(v, ",")
      if skill_desc_para_data ~= nil and not (table.count(skill_desc_para_data) < 2) then
        local para = {}
        para.formatType = tonumber(skill_desc_para_data[1])
        para.baseValue = tonumber(skill_desc_para_data[2])
        self.chip_bonus_desc_para[count] = para
        count = count + 1
      end
    end
  end
end

local function GetSkillIdByStarLevel(self, starLevel)
  if self.skillIds == nil then
    return 0
  end
  return self.skillIds[starLevel] or 0
end

local function GetAdditionalSkillIdByStarLevel(self, starLevel)
  if self.additionalSkillIds == nil then
    return 0
  end
  return self.additionalSkillIds[starLevel] or 0
end

local function GetSkillInfoByStarLevel(self, starLevel)
  local skillId = self:GetSkillIdByStarLevel(starLevel + 1)
  if skillId == nil or skillId == 0 then
    return nil
  end
  local skillInfo = SkillInfo.New()
  skillInfo:CreateFromTemplate(skillId, true, 1, starLevel)
  return skillInfo
end

local function GetSkillPowerByStarLevel(self, starLevel, tierEffectValue)
  local skillId = self:GetSkillIdByStarLevel(starLevel + 1)
  if skillId == nil or skillId == 0 then
    return 0
  end
  local skillPower = DataCenter.HeroSkillTemplateManager:GetSkillPowerV2(skillId, tierEffectValue)
  return skillPower
end

local function GetAdditionalSkillInfoByStarLevel(self, starLevel)
  local skillId = self:GetAdditionalSkillIdByStarLevel(starLevel + 1)
  if skillId == nil or skillId == 0 then
    return nil
  end
  local skillInfo = SkillInfo.New()
  skillInfo:CreateFromTemplate(skillId, true, 1, starLevel)
  return skillInfo
end

local function GetAttrTemplateId(self, level)
  return self.attrTemplate_id[level] or 0
end

local function GetAttributes(self, level)
  local attrTemplateId = self:GetAttrTemplateId(level)
  if attrTemplateId == nil or attrTemplateId == 0 then
    return {}
  end
  local tabData = LocalController:instance():getLine("lw_drone_skillchip_attribute", attrTemplateId)
  if tabData == nil then
    return {}
  end
  local effectStr = tabData.effects or ""
  local effectStrArr = string.split(effectStr, "|")
  local attributes = {}
  if not table.IsNullOrEmpty(effectStrArr) then
    for i, v in ipairs(effectStrArr) do
      local effectArr = string.split(v, ";")
      if not table.IsNullOrEmpty(effectArr) and #effectArr == 2 then
        local effectId = tonumber(effectArr[1])
        local effectValue = tonumber(effectArr[2])
        attributes[effectId] = effectValue
      end
    end
  end
  return attributes
end

local function GetPower(self, level)
  local attrTemplateId = self:GetAttrTemplateId(level)
  if attrTemplateId == nil or attrTemplateId == 0 then
    return 0
  end
  local tabData = LocalController:instance():getLine("lw_drone_skillchip_attribute", attrTemplateId)
  if tabData == nil then
    return 0
  end
  return tabData.power or 0
end

local function GetStarUpCostAtStar(self, star)
  if self.promotedNeedChips == nil then
    return 0
  end
  return self.promotedNeedChips[star] or 0
end

local function GetSkillChipHeroType(self)
  return self.heroType
end

function TWSkillChipTemplate:CanCraft(buildLevel)
  if self:IsLock(buildLevel) then
    return false
  end
  local id = self.craft_material[1]
  local costCount = self.craft_material[2]
  local haveItemCount = DataCenter.ResourceItemDataManager:GetCountByItemId(id)
  if costCount > haveItemCount then
    return false
  end
  return true
end

function TWSkillChipTemplate:IsLock(buildLevel)
  return buildLevel < self.craft_factory_level
end

function TWSkillChipTemplate:GetTacticalChipDesc(systemTierEffectValue)
  local paras = {}
  local count = 1
  for k, v in pairs(self.chip_bonus_desc_para) do
    local resultValue = v.baseValue * systemTierEffectValue
    local resultValueStr = HeroUtils.GetFormattedValue(v.formatType, resultValue, false)
    paras[count] = resultValueStr
    count = count + 1
  end
  local resultStr = Localization:GetString(self.chip_bonus_desc, SafeUnpack(paras))
  return resultStr
end

TWSkillChipTemplate.__init = __init
TWSkillChipTemplate.__delete = __delete
TWSkillChipTemplate.InitData = InitData
TWSkillChipTemplate.GetSkillIdByStarLevel = GetSkillIdByStarLevel
TWSkillChipTemplate.GetAdditionalSkillIdByStarLevel = GetAdditionalSkillIdByStarLevel
TWSkillChipTemplate.GetSkillInfoByStarLevel = GetSkillInfoByStarLevel
TWSkillChipTemplate.GetSkillPowerByStarLevel = GetSkillPowerByStarLevel
TWSkillChipTemplate.GetAdditionalSkillInfoByStarLevel = GetAdditionalSkillInfoByStarLevel
TWSkillChipTemplate.GetAttrTemplateId = GetAttrTemplateId
TWSkillChipTemplate.GetAttributes = GetAttributes
TWSkillChipTemplate.GetPower = GetPower
TWSkillChipTemplate.GetStarUpCostAtStar = GetStarUpCostAtStar
TWSkillChipTemplate.GetSkillChipHeroType = GetSkillChipHeroType
return TWSkillChipTemplate
