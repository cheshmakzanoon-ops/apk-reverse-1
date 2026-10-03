local MonsterLockTemplateManager = BaseClass("MonsterLockTemplateManager")
local MonsterLockTemplate = require("DataCenter.MonsterLock.MonsterLockTemplate")

local function __init(self)
  self.templateDic = nil
end

local function __delete(self)
  self.templateDic = nil
end

local function InitAllTemplate(self)
  self.templateDic = {}
  LocalController:instance():visitTable(TableName.MonsterLock, function(id, lineData)
    local item = MonsterLockTemplate.New()
    item:InitData(lineData)
    self.templateDic[item.id] = item
  end)
end

local function GetAllTemplate(self)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.templateDic
end

local function GetTemplate(self, id)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.templateDic[id]
end

MonsterLockTemplateManager.__init = __init
MonsterLockTemplateManager.__delete = __delete
MonsterLockTemplateManager.InitAllTemplate = InitAllTemplate
MonsterLockTemplateManager.GetAllTemplate = GetAllTemplate
MonsterLockTemplateManager.GetTemplate = GetTemplate
return MonsterLockTemplateManager
