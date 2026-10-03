local DesertTemplateManager = BaseClass("DesertTemplateManager")
local DesertTemplate = require("DataCenter.DesertData.DesertTemplate")

local function __init(self)
  self.templateDict = nil
  self.sortList = {}
  self:InitTemplateDict()
end

local function __delete(self)
  self.templateDict = nil
end

local function StartUp(self)
end

local function InitTemplateDict(self)
  local maxLevel = 1
  self.templateDict = {}
  self.sortList = {}
  LocalController:instance():visitTable(TableName.Desert, function(id, lineData)
    local template = DesertTemplate.New()
    template:InitData(lineData)
    if template.desert_level ~= nil then
      self.sortList[template.desert_level] = template.force
    end
    self.templateDict[tostring(id)] = template
    maxLevel = math.max(maxLevel, template.desert_level)
  end)
  self.desertMaxLevel = maxLevel
end

local function GetTemplate(self, id)
  return self.templateDict[tostring(id)]
end

local function GetTemplateByLevelAndType(self, level, desert_type)
  for _, v in pairs(self.templateDict) do
    if v and v.level == level and v.desert_type == desert_type then
      return v
    end
  end
  return nil
end

local function GetAllTemplate(self)
  return self.templateDict
end

local function GetSortList(self)
  return self.sortList
end

local function GetDesertMaxLevel(self)
  return self.desertMaxLevel or 15
end

DesertTemplateManager.__init = __init
DesertTemplateManager.__delete = __delete
DesertTemplateManager.StartUp = StartUp
DesertTemplateManager.InitTemplateDict = InitTemplateDict
DesertTemplateManager.GetTemplate = GetTemplate
DesertTemplateManager.GetAllTemplate = GetAllTemplate
DesertTemplateManager.GetSortList = GetSortList
DesertTemplateManager.GetDesertMaxLevel = GetDesertMaxLevel
DesertTemplateManager.GetTemplateByLevelAndType = GetTemplateByLevelAndType
return DesertTemplateManager
