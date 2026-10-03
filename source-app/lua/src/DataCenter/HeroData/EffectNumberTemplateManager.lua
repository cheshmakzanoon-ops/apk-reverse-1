local EffectNumberTemplateManager = BaseClass("EffectNumberTemplateManager")
local EffectNumberTemplate = require("DataCenter.HeroData.EffectNumberTemplate")

local function __init(self)
  self.effectNumberGroupDic = {}
  self.sortedEffectNumberGroup = {}
  self.effectNumberDic = {}
  self.equipEffectNumberGroupDic = {}
  self.sortedEquipEffectNumberGroup = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.effectNumberGroupDic = nil
  self.sortedEffectNumberGroup = nil
  self.effectNumberDic = nil
  self.equipEffectNumberGroupDic = nil
  self.sortedEquipEffectNumberGroup = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.LW_Effect_Number, function(id, lineData)
    if id ~= nil and lineData ~= nil then
      local effectNumberTemplate = EffectNumberTemplate.New()
      effectNumberTemplate:InitData(lineData)
      local effectGroup = effectNumberTemplate.category
      if 0 < effectGroup then
        if self.effectNumberGroupDic[effectGroup] == nil then
          self.effectNumberGroupDic[effectGroup] = {}
        end
        table.insert(self.effectNumberGroupDic[effectGroup], effectNumberTemplate)
      end
      local equipEffectGroup = effectNumberTemplate.equip_category
      if 0 < equipEffectGroup then
        if self.equipEffectNumberGroupDic[equipEffectGroup] == nil then
          self.equipEffectNumberGroupDic[equipEffectGroup] = {}
        end
        table.insert(self.equipEffectNumberGroupDic[equipEffectGroup], effectNumberTemplate)
      end
      self.effectNumberDic[effectNumberTemplate.id] = effectNumberTemplate
    end
  end)
  for k in pairs(self.effectNumberGroupDic) do
    table.insert(self.sortedEffectNumberGroup, k)
  end
  table.sort(self.sortedEffectNumberGroup)
  for k in pairs(self.equipEffectNumberGroupDic) do
    table.insert(self.sortedEquipEffectNumberGroup, k)
  end
  table.sort(self.sortedEquipEffectNumberGroup)
end

local function GetSortedAllEffectNumberGroup(self)
  return self.sortedEffectNumberGroup
end

local function GetSortedAllEquipEffectNumberGroup(self)
  return self.sortedEquipEffectNumberGroup
end

local function GetNumberEffectGroup(self, group)
  return self.effectNumberGroupDic[group]
end

local function GetEquipNumberEffectGroup(self, group)
  return self.equipEffectNumberGroupDic[group]
end

local function GetEffectNumberTemplateById(self, id)
  return self.effectNumberDic[id]
end

local function GetTemplate(self, id)
  return self.effectNumberDic[id]
end

local function GetEffectNumberName(self, id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return template:GetNameKey()
  end
  return ""
end

local function GetEffectNumberIcon(self, id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return template.icon
  end
  return ""
end

local function GetEffectNumberType(self, id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return template.type
  end
  return 0
end

local function GetEffectNumberDesc(self, id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return template:GetDescKey()
  end
  return ""
end

local function GetDecorationEffectIdListByType(self, type)
  local retList = {}
  table.walk(self.effectNumberDic, function(k, v)
    local template = self:GetTemplate(id)
    if template.display_type_gallery == type then
      table.insert(retList, template.id)
    end
  end)
  return retList
end

local function GetEffectNumberTemplateSequence(self, id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return template.sequence
  end
  return 0
end

local function GetEffectNumberPower(self, id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return template.power
  end
  return 0
end

local function GetEffectNumberExtraPower(self, id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return template.power_extra
  end
  return 0
end

EffectNumberTemplateManager.__init = __init
EffectNumberTemplateManager.__delete = __delete
EffectNumberTemplateManager.InitAllTemplate = InitAllTemplate
EffectNumberTemplateManager.GetSortedAllEffectNumberGroup = GetSortedAllEffectNumberGroup
EffectNumberTemplateManager.GetNumberEffectGroup = GetNumberEffectGroup
EffectNumberTemplateManager.GetEffectNumberTemplateById = GetEffectNumberTemplateById
EffectNumberTemplateManager.GetTemplate = GetTemplate
EffectNumberTemplateManager.GetSortedAllEquipEffectNumberGroup = GetSortedAllEquipEffectNumberGroup
EffectNumberTemplateManager.GetEquipNumberEffectGroup = GetEquipNumberEffectGroup
EffectNumberTemplateManager.GetEffectNumberName = GetEffectNumberName
EffectNumberTemplateManager.GetEffectNumberIcon = GetEffectNumberIcon
EffectNumberTemplateManager.GetEffectNumberType = GetEffectNumberType
EffectNumberTemplateManager.GetEffectNumberDesc = GetEffectNumberDesc
EffectNumberTemplateManager.GetDecorationEffectIdListByType = GetDecorationEffectIdListByType
EffectNumberTemplateManager.GetEffectNumberTemplateSequence = GetEffectNumberTemplateSequence
EffectNumberTemplateManager.GetEffectNumberPower = GetEffectNumberPower
EffectNumberTemplateManager.GetEffectNumberExtraPower = GetEffectNumberExtraPower
return EffectNumberTemplateManager
