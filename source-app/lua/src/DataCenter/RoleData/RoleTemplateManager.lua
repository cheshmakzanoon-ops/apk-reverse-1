local RoleTemplateManager = BaseClass("RoleTemplateManager")
local RoleTemplate = require("DataCenter.RoleData.RoleTemplate")

local function __init(self)
  self.templateDict = {}
  self.templateLevelDict = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.templateDict = nil
  self.templateLevelDict = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.LW_Role, function(id, lineData)
    local template = RoleTemplate.New()
    template:InitData(lineData)
    self.templateDict[tonumber(id)] = template
    self.templateLevelDict[template.level] = template
  end)
end

local function GetTemplate(self, id)
  if table.containsKey(self.templateDict, tonumber(id)) then
    return self.templateDict[tonumber(id)]
  end
end

local function GetTemplateByLevel(self, level)
  if table.containsKey(self.templateLevelDict, tonumber(level)) then
    return self.templateLevelDict[tonumber(level)]
  end
end

RoleTemplateManager.__init = __init
RoleTemplateManager.__delete = __delete
RoleTemplateManager.InitAllTemplate = InitAllTemplate
RoleTemplateManager.GetTemplate = GetTemplate
RoleTemplateManager.GetTemplateByLevel = GetTemplateByLevel
return RoleTemplateManager
