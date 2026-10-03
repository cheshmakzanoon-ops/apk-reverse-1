local DecorationSkillTemplateManager = BaseClass("DecorationSkillTemplateManager")
local DecorationSkillTemplate = require("DataCenter.DecorationDataManager.DecorationSkillTemplate")

local function __init(self)
  self.templateDic = nil
  self.initAll = false
end

local function __delete(self)
  self.templateDic = nil
  self.initAll = nil
end

local function InitLineData(self, lineData)
  if not lineData then
    return
  end
  local id = lineData.id
  if self.templateDic and self.templateDic[id] then
    return
  end
  local item = DecorationSkillTemplate.New()
  item:InitData(lineData)
  if not self.templateDic then
    self.templateDic = {}
  end
  self.templateDic[item.id] = item
end

local function InitAllTemplate(self)
  if not self.templateDic then
    self.templateDic = {}
  end
  LocalController:instance():visitTable(TableName.DecorationSkill, function(id, lineData)
    InitLineData(self, lineData)
  end)
  self.initAll = true
end

local function GetAllTemplate(self)
  if not self.initAll then
    self:InitAllTemplate()
  end
  return self.templateDic
end

local function GetTemplate(self, id)
  if id == nil or id <= 0 then
    return nil
  end
  if self.templateDic and self.templateDic[id] then
    return self.templateDic[id]
  end
  local lineData = LocalController:instance():getLine(TableName.DecorationSkill, id)
  if lineData == nil then
    return nil
  end
  if not self.templateDic then
    self.templateDic = {}
  end
  InitLineData(self, lineData)
  return self.templateDic[id]
end

DecorationSkillTemplateManager.__init = __init
DecorationSkillTemplateManager.__delete = __delete
DecorationSkillTemplateManager.InitAllTemplate = InitAllTemplate
DecorationSkillTemplateManager.GetAllTemplate = GetAllTemplate
DecorationSkillTemplateManager.GetTemplate = GetTemplate
return DecorationSkillTemplateManager
