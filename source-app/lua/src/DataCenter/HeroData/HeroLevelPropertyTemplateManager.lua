local HeroLevelPropertyTemplateManager = BaseClass("HeroLevelPropertyTemplateManager")
local HeroLevelPropertyTemplate = require("DataCenter.HeroData.HeroLevelPropertyTemplate")

local function __init(self)
  self.typeAndLevelDict = {}
  self.templateDict = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.typeAndLevelDict = nil
  self.templateDict = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.LW_Template_Property, function(id, lineData)
    local template = HeroLevelPropertyTemplate.New()
    template:InitData(lineData)
    if self.typeAndLevelDict[template.type] == nil then
      self.typeAndLevelDict[template.type] = {}
    end
    self.typeAndLevelDict[template.type][template.level] = template
    self.templateDict[tonumber(id)] = template
  end)
end

local function GetTemplateByTypeAndLevel(self, type, level, hpFactor, atkFactor, defFactor, accFactor, critFactor)
  if self.typeAndLevelDict[type] ~= nil and self.typeAndLevelDict[type][level] ~= nil then
    return self:GetPropertyTableFromTemplate(self.typeAndLevelDict[type][level], hpFactor, atkFactor, defFactor, accFactor, critFactor)
  end
  return {}
end

local function GetTemplateHp(self, type, level)
  if self.typeAndLevelDict[type] ~= nil and self.typeAndLevelDict[type][level] ~= nil then
    return self.typeAndLevelDict[type][level].hp
  end
  return 0
end

local function GetTemplateAtk(self, type, level)
  if self.typeAndLevelDict[type] ~= nil and self.typeAndLevelDict[type][level] ~= nil then
    return self.typeAndLevelDict[type][level].atk
  end
  return 0
end

local function GetTemplateDef(self, type, level)
  if self.typeAndLevelDict[type] ~= nil and self.typeAndLevelDict[type][level] ~= nil then
    return self.typeAndLevelDict[type][level].def
  end
  return 0
end

function HeroLevelPropertyTemplateManager:GetTemplateSc(type, level)
  if self.typeAndLevelDict[type] ~= nil and self.typeAndLevelDict[type][level] ~= nil then
    return self.typeAndLevelDict[type][level].sc
  end
  return 0
end

local function GetPropertyTableFromTemplate(self, template, hpFactor, atkFactor, defFactor, accFactor, critFactor)
  local dataTable = {}
  if template == nil then
    return dataTable
  end
  dataTable[HeroEffectDefine.HealthPoint] = template.hp * hpFactor
  dataTable[HeroEffectDefine.PhysicalAttack] = template.atk * atkFactor
  dataTable[HeroEffectDefine.PhysicalDefense] = template.def * defFactor
  dataTable[HeroEffectDefine.ChanceToHit_Result] = template.acc * accFactor
  dataTable[HeroEffectDefine.CriticalRate_Result] = template.crit * critFactor
  dataTable[HeroEffectDefine.HeroSoldierCapacity] = template.sc
  return dataTable
end

HeroLevelPropertyTemplateManager.__init = __init
HeroLevelPropertyTemplateManager.__delete = __delete
HeroLevelPropertyTemplateManager.InitAllTemplate = InitAllTemplate
HeroLevelPropertyTemplateManager.GetTemplateByTypeAndLevel = GetTemplateByTypeAndLevel
HeroLevelPropertyTemplateManager.GetPropertyTableFromTemplate = GetPropertyTableFromTemplate
HeroLevelPropertyTemplateManager.GetTemplateHp = GetTemplateHp
HeroLevelPropertyTemplateManager.GetTemplateAtk = GetTemplateAtk
HeroLevelPropertyTemplateManager.GetTemplateDef = GetTemplateDef
return HeroLevelPropertyTemplateManager
