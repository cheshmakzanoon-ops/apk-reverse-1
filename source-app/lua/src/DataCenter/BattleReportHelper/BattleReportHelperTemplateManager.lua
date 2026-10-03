local BattleReportHelperTemplateManager = BaseClass("BattleReportHelperTemplateManager")
local BattleReportHelperTemplate = require("DataCenter.BattleReportHelper.BattleReportHelperTemplate")

local function __init(self)
  self.templateDic = nil
end

local function __delete(self)
  self.templateDic = nil
end

local function InitAllTemplate(self)
  self.templateDic = {}
  LocalController:instance():visitTable(TableName.LW_Report_Helper, function(id, lineData)
    local item = BattleReportHelperTemplate.New()
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

BattleReportHelperTemplateManager.__init = __init
BattleReportHelperTemplateManager.__delete = __delete
BattleReportHelperTemplateManager.InitAllTemplate = InitAllTemplate
BattleReportHelperTemplateManager.GetAllTemplate = GetAllTemplate
BattleReportHelperTemplateManager.GetTemplate = GetTemplate
return BattleReportHelperTemplateManager
