local HeroUniqueWeaponTemplateManager = BaseClass("HeroUniqueWeaponTemplateManager", CEventable)
local Localization = CS.GameEntry.Localization
local HeroUniqueWeaponTemplate = require("DataCenter.HeroUniqueWeaponDataManager.HeroUniqueWeaponTemplate")

local function AddListener(self)
end

local function __init(self)
  self.templateDict = nil
end

local function __delete(self)
  self.templateDict = nil
end

local function InitLine(self, lineData)
  if not lineData then
    return
  end
  local id = lineData.id
  if self.templateDict and self.templateDict[id] then
    return
  end
  local template = HeroUniqueWeaponTemplate.New()
  template:InitData(lineData)
  if not self.templateDict then
    self.templateDict = {}
  end
  self.templateDict[tonumber(id)] = template
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.Hero_Unique_Weapon, function(id, lineData)
    InitLine(self, lineData)
  end)
end

function HeroUniqueWeaponTemplateManager:GetTemplate(id)
  if not id then
    return
  end
  if self.templateDict and self.templateDict[id] then
    return self.templateDict[id]
  end
  local lineData = LocalController:instance():getLine(TableName.Hero_Unique_Weapon, id)
  InitLine(self, lineData)
  if not self.templateDict then
    return nil
  end
  return self.templateDict[id]
end

function HeroUniqueWeaponTemplateManager:GetWeaponIdByHeroId(heroId, weaponLv)
  if weaponLv == nil or weaponLv <= 0 then
    return nil
  end
  return heroId * 1000 + weaponLv
end

function HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, weaponLv)
  if weaponLv == nil or weaponLv <= 0 then
    return nil
  end
  local weaponId = self:GetWeaponIdByHeroId(heroId, weaponLv)
  return self:GetTemplate(weaponId)
end

function HeroUniqueWeaponTemplateManager:GetMaxLevelTemplate(heroId)
  if not heroId then
    return
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if not heroTemplate then
    return nil
  end
  local maxUniqueWeaponLv = heroTemplate:GetUniqueWeaponMaxLv()
  if maxUniqueWeaponLv == 0 then
    return nil
  end
  return self:GetTemplateByHeroId(heroId, maxUniqueWeaponLv)
end

function HeroUniqueWeaponTemplateManager:GetMaxLevel(heroId)
  if not heroId then
    return
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if not heroTemplate then
    return nil
  end
  local maxUniqueWeaponLv = heroTemplate:GetUniqueWeaponMaxLv()
  return maxUniqueWeaponLv
end

function HeroUniqueWeaponTemplateManager:GetLevelWeaponoResults(heroId, level, addSkillContainNotShow)
  if self.heroesPreview and self.heroesPreview[heroId] and self.heroesPreview[heroId][level] then
    local previewData = self.heroesPreview[heroId][level]
    return previewData.attr, previewData.effects, previewData.previewSkills, previewData.weapon
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if not heroTemplate then
    return nil, nil, nil
  end
  local heroMaxRank = heroTemplate.maxRank
  local rankTemplate = DataCenter.HeroRankTemplateManager:GetTemplate(heroMaxRank)
  if not rankTemplate then
    return nil, nil, nil
  end
  local rankRatio = rankTemplate:GetEffectRatio()
  local weaponMaxLv = self:GetMaxLevel(heroId)
  if weaponMaxLv == 0 then
    return nil, nil, nil
  end
  local upLevel = level
  if weaponMaxLv < upLevel then
    upLevel = weaponMaxLv
  end
  local maxLevel = 0
  local maxLevelTemplate
  local effects = {}
  local previewSkills = {}
  for i = 1, upLevel do
    local template = self:GetTemplateByHeroId(heroId, i)
    if template then
      if not string.IsNullOrEmpty(template.effect_desc) then
        effects[#effects + 1] = {
          name = template.effect_name,
          desc = template.effect_desc,
          icon = template.effect_icon,
          displaySkillId = template.effect_preview,
          weaponLv = i,
          desc_para = template.desc_para
        }
      end
      if 0 < template.skill_preview_list then
        previewSkills[#previewSkills + 1] = template.skill_preview_list
      end
      if maxLevel < template.lv then
        maxLevel = template.lv
        maxLevelTemplate = template
      end
    end
  end
  if maxLevelTemplate then
    local attr = maxLevelTemplate:GetSortedAttrs()
    
    local function processData(id, value)
      if not value then
        return 0
      end
      if not id then
        return value
      end
      if id == HeroEffectDefine.UniqueWeaponHp or id == HeroEffectDefine.UniqueWeaponAtk or id == HeroEffectDefine.UniqueWeaponDef then
        if id == HeroEffectDefine.UniqueWeaponHp then
          value = value * rankRatio * heroTemplate.hpFactor
        elseif id == HeroEffectDefine.UniqueWeaponAtk then
          value = value * rankRatio * heroTemplate.atkFactor
        elseif id == HeroEffectDefine.UniqueWeaponDef then
          value = value * rankRatio * heroTemplate.defFactor
        end
        return value
      else
        return value
      end
    end
    
    local processedAttr = {}
    for i = 1, #attr do
      local attrData = attr[i]
      processedAttr[i] = {
        key = attrData.key,
        value = processData(attrData.key, attrData.value)
      }
    end
    self.heroesPreview = self.heroesPreview or {}
    if not self.heroesPreview[heroId] then
      self.heroesPreview[heroId] = {}
    end
    self.heroesPreview[heroId][level] = {
      attr = processedAttr,
      effects = effects,
      previewSkills = previewSkills,
      weapon = maxLevelTemplate
    }
    return processedAttr, effects, previewSkills, maxLevelTemplate
  end
  return nil, nil, nil
end

function HeroUniqueWeaponTemplateManager:GetMaxLevelWeaponoEffects(heroId, addSkillContainNotShow)
  local weaponMaxLv = self:GetMaxLevel(heroId)
  if weaponMaxLv == 0 then
    return nil, nil, nil
  end
  if self.heroesPreview and self.heroesPreview[heroId] and self.heroesPreview[heroId][weaponMaxLv] then
    local previewData = self.heroesPreview[heroId][weaponMaxLv]
    return previewData.attr, previewData.effects, previewData.previewSkills, previewData.weapon
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if not heroTemplate then
    return nil, nil, nil
  end
  local heroMaxRank = heroTemplate.maxRank
  local rankTemplate = DataCenter.HeroRankTemplateManager:GetTemplate(heroMaxRank)
  if not rankTemplate then
    return nil, nil, nil
  end
  return self:GetLevelWeaponoResults(heroId, weaponMaxLv, addSkillContainNotShow)
end

HeroUniqueWeaponTemplateManager.__init = __init
HeroUniqueWeaponTemplateManager.__delete = __delete
return HeroUniqueWeaponTemplateManager
