local PveSkillTestTemplateManager = BaseClass("PveSkillTestTemplateManager")
local PveSkillTestTemplate = require("DataCenter.PveSkillTest.PveSkillTestTemplate")

local function __init(self)
  self.templateDict = {}
  LocalController:instance():visitTable(TableName.LW_Skill_Test, function(_, line)
    local template = PveSkillTestTemplate.New()
    template:InitData(line)
    self.templateDict[template.id] = template
  end)
end

local function __delete(self)
end

local function GetTemplate(self, id)
  return self.templateDict[tonumber(id)]
end

PveSkillTestTemplateManager.__init = __init
PveSkillTestTemplateManager.__delete = __delete
PveSkillTestTemplateManager.GetTemplate = GetTemplate
return PveSkillTestTemplateManager
