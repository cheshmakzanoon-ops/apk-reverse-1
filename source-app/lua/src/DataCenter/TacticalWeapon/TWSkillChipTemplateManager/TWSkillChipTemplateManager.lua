local TWSkillChipTemplateManager = BaseClass("TWSkillChipTemplateManager")
local TWSkillChipTemplate = require("DataCenter.TacticalWeapon.TWSkillChipTemplateManager.TWSkillChipTemplate")

local function __init(self)
  self.templateDic = {}
  self.expDic = {}
  self.hasInit = false
end

local function __delete(self)
  self.templateDic = nil
  self.expDic = nil
  self.hasInit = false
end

local function GetTemplate(self, id)
  if self.templateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_Drone_Skill, tostring(id))
    if oneTemplate ~= nil then
      local item = TWSkillChipTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[tonumber(id)]
end

local function GetNeedExpByType(self, type)
  if self.expDic[type] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_Drone_Skillchip_Exp, tostring(type))
    if oneTemplate ~= nil then
      local exps = string.split(oneTemplate.totalExp, ";")
      if exps ~= nil then
        self.expDic[type] = {}
        for i = 1, #exps do
          local exp = tonumber(exps[i])
          table.insert(self.expDic[type], exp)
        end
      end
    end
  end
  return self.expDic[type]
end

local function GetNeedExpByTypeAndLevel(self, type, level)
  local exps = self:GetNeedExpByType(type)
  if exps ~= nil then
    if level >= #exps then
      return exps[#exps]
    else
      return exps[level]
    end
  end
  return 0
end

local function GetTotalNeedExpByTypeAndLevel(self, type, level)
  local exps = self:GetNeedExpByType(type)
  if exps ~= nil then
    local totalExp = 0
    for i = 1, level do
      totalExp = totalExp + exps[i]
    end
    return totalExp
  end
  return 0
end

local function GetQualityById(self, id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return template.quality
  end
  return 0
end

local function GetTypeById(self, id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return template.skill_type
  end
  return 0
end

local function GetAllTemplates(self)
  if not self.hasInit then
    LocalController:instance():visitTable(TableName.LW_Drone_Skill, function(id, lineData)
      if not self.templateDic[tonumber(id)] then
        local item = TWSkillChipTemplate.New()
        item:InitData(lineData)
        if item.id ~= nil then
          self.templateDic[item.id] = item
        end
      end
    end)
    self.hasInit = true
  end
  return self.templateDic
end

local function GetTemplatesByType(self)
  local templates = GetAllTemplates(self)
  local typeDict = {}
  for k, v in pairs(templates) do
    if v.isShow then
      if typeDict[v.skill_type] == nil then
        typeDict[v.skill_type] = {}
      end
      table.insert(typeDict[v.skill_type], v)
    end
  end
  for k, v in pairs(typeDict) do
    table.sort(v, function(a, b)
      if a.quality ~= b.quality then
        return a.quality > b.quality
      end
      return a.id < b.id
    end)
  end
  local typeArray = {}
  for k, v in pairs(typeDict) do
    table.insert(typeArray, {type = k, templates = v})
  end
  table.sort(typeArray, function(a, b)
    return a.type < b.type
  end)
  return typeArray
end

local function GetTotalNeedExpFromLevel(self, type, srcLv, dstLv)
  local exps = self:GetNeedExpByType(type)
  if exps ~= nil then
    local totalExp = 0
    for i = srcLv, dstLv do
      totalExp = totalExp + exps[i]
    end
    return totalExp
  end
  return 0
end

local function GetChipSkillPower(self, chipId, star)
  local template = self:GetTemplate(chipId)
  if template == nil then
    return 0
  end
  star = star or 0
  return template:GetSkillPowerByStarLevel(star)
end

TWSkillChipTemplateManager.__init = __init
TWSkillChipTemplateManager.__delete = __delete
TWSkillChipTemplateManager.GetTemplate = GetTemplate
TWSkillChipTemplateManager.GetNeedExpByType = GetNeedExpByType
TWSkillChipTemplateManager.GetNeedExpByTypeAndLevel = GetNeedExpByTypeAndLevel
TWSkillChipTemplateManager.GetQualityById = GetQualityById
TWSkillChipTemplateManager.GetTypeById = GetTypeById
TWSkillChipTemplateManager.GetTotalNeedExpByTypeAndLevel = GetTotalNeedExpByTypeAndLevel
TWSkillChipTemplateManager.GetAllTemplates = GetAllTemplates
TWSkillChipTemplateManager.GetTemplatesByType = GetTemplatesByType
TWSkillChipTemplateManager.GetTotalNeedExpFromLevel = GetTotalNeedExpFromLevel
TWSkillChipTemplateManager.GetChipSkillPower = GetChipSkillPower
return TWSkillChipTemplateManager
