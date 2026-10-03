local HeroUniqueWeaponTemplate = BaseClass("HeroUniqueWeaponTemplate")

local function __init(self)
  self.id = 0
  self.heroId = 0
  self.lv = 0
  self.item_cost = {}
  self.attr = {}
  self.modelId = 0
  self.skill_change = {}
  self.skill_add = {}
  self.skill_desc = ""
  self.effect_name = ""
  self.effect_desc = ""
  self.effect_icon = ""
  self.effect_preview = 0
  self.skill_preview_list = 0
  self.model_icon = ""
  self.desc_para = ""
end

local function __delete(self)
  self.id = nil
  self.heroId = nil
  self.lv = nil
  self.item_cost = nil
  self.attr = nil
  self.modelId = nil
  self.skill_change = nil
  self.skill_add = nil
  self.skill_desc = nil
  self.effect_name = nil
  self.effect_desc = nil
  self.effect_icon = nil
  self.effect_preview = nil
  self.skill_preview_list = nil
  self.model_icon = ""
  slef.desc_para = nil
end

local function InitData(self, lineData)
  if not lineData then
    return
  end
  self.id = tonumber(lineData:getValue("id")) or 0
  self.heroId = tonumber(lineData:getValue("hero")) or 0
  self.lv = tonumber(lineData:getValue("lv")) or 0
  self.item_cost = lineData:getValue("item_cost") or {}
  self.attr = lineData:getValue("attr") or {}
  self.model = tonumber(lineData:getValue("model")) or 0
  self.modelId = self.model
  self.skill_add = lineData:getValue("skill_add") or {}
  local skill_change = lineData:getValue("skill_change") or {}
  self.skill_change = {}
  for sourceSkillId, targetSkillId in pairs(skill_change) do
    self.skill_change[#self.skill_change + 1] = {src = sourceSkillId, dst = targetSkillId}
  end
  table.sort(self.skill_change, function(a, b)
    return a.src < b.src
  end)
  self.skill_desc = lineData:getValue("skill_desc") or ""
  self.skill_level = 0
  for k, v in pairs(self.attr) do
    if k == HeroEffectDefine.HeroSkillMaxLevelAdd then
      self.skill_level = v
      break
    end
  end
  self.effect_name = lineData:getValue("effect_name") or ""
  self.effect_desc = lineData:getValue("effect_desc") or ""
  self.effect_icon = lineData:getValue("effect_icon") or ""
  self.effect_preview = tonumber(lineData:getValue("effect_preview")) or 0
  self.skill_preview_list = tonumber(lineData:getValue("skill_preview_list")) or 0
  self.model_icon = lineData:getValue("model_icon_path") or ""
  self.desc_para = lineData:getValue("desc_para")
end

local function GetSortedAttrs(self)
  if not self.sortedAttr then
    self.sortedAttr = {}
    local count = 1
    for k, v in pairs(self.attr) do
      self.sortedAttr[count] = {key = k, value = v}
      count = count + 1
    end
    table.sort(self.sortedAttr, function(a, b)
      local aSeq = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(a.key)
      local bSeq = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(b.key)
      if aSeq == bSeq then
        return a.key < b.key
      else
        return aSeq < bSeq
      end
    end)
  end
  return self.sortedAttr
end

local function GetAttrs(self)
  return self.attr or {}
end

local function GetCosts(self)
  return self.item_cost or {}
end

local function GetSortedCosts(self)
  if not self.sortedCost then
    self.sortedCost = {}
    local count = 1
    for k, v in pairs(self.item_cost) do
      self.sortedCost[count] = {itemId = k, itemNum = v}
      count = count + 1
    end
    table.sort(self.sortedCost, function(a, b)
      return a.itemId < b.itemId
    end)
  end
  return self.sortedCost
end

local function IsMaxLevel(self)
  local heroMaxLevelTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevelTemplate(self.heroId)
  if heroMaxLevelTemplate then
    return self.lv >= heroMaxLevelTemplate.lv
  end
  return false
end

local function GetNewSkills(self)
  if not self.newSkillList then
    self.newSkillList = {}
    for k, v in pairs(self.skill_add) do
      if v == 1 then
        self.newSkillList[#self.newSkillList + 1] = k
      end
    end
  end
  return self.skill_change, self.newSkillList
end

local function GetSkillIdBeforeChange(self, skillIdAfterChange)
  if not self.skill_change then
    return false, skillIdAfterChange
  end
  for k, v in pairs(self.skill_change) do
    if v.dst == skillIdAfterChange then
      return true, v.src
    end
  end
  return false, skillIdAfterChange
end

local function IsExistReplaceSkill(self)
  return self.skill_change and #self.skill_change > 0
end

HeroUniqueWeaponTemplate.__init = __init
HeroUniqueWeaponTemplate.__delete = __delete
HeroUniqueWeaponTemplate.InitData = InitData
HeroUniqueWeaponTemplate.GetSortedAttrs = GetSortedAttrs
HeroUniqueWeaponTemplate.GetAttrs = GetAttrs
HeroUniqueWeaponTemplate.GetCosts = GetCosts
HeroUniqueWeaponTemplate.GetSortedCosts = GetSortedCosts
HeroUniqueWeaponTemplate.IsMaxLevel = IsMaxLevel
HeroUniqueWeaponTemplate.GetNewSkills = GetNewSkills
HeroUniqueWeaponTemplate.GetSkillIdBeforeChange = GetSkillIdBeforeChange
HeroUniqueWeaponTemplate.IsExistReplaceSkill = IsExistReplaceSkill
return HeroUniqueWeaponTemplate
