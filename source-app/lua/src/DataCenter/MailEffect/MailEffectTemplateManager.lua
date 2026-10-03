local MailEffectTemplateManager = BaseClass("MailEffectTemplateManager")
local MailEffectTemplate = require("DataCenter.MailEffect.MailEffectTemplate")

local function __init(self)
  self.templateDict = {}
  self:InitAllTemplate()
end

local function __delete(self)
end

local function GetAllTemplate(self)
  return self.templateDict
end

local function InitAllTemplate(self)
  self.templateDict = {}
  LocalController:instance():visitTable(TableName.LW_Technical_Report, function(id, lineData)
    if lineData ~= nil then
      local item = MailEffectTemplate.New()
      item:InitData(lineData)
      self.templateDict[id] = item
    end
  end)
end

MailEffectTemplateManager.__init = __init
MailEffectTemplateManager.__delete = __delete
MailEffectTemplateManager.GetAllTemplate = GetAllTemplate
MailEffectTemplateManager.InitAllTemplate = InitAllTemplate
return MailEffectTemplateManager
