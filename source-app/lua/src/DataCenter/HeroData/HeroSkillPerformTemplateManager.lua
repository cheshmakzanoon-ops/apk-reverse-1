local HeroSkillPerformTemplateManager = BaseClass("HeroSkillPerformTemplateManager")
local HeroSkillPerformTemplate = require("DataCenter.HeroData.HeroSkillPerformTemplate")

local function __init(self)
  self.performDic = {}
end

local function __delete(self)
  self.performDic = nil
end

local function GetTemplate(self, id)
  id = tonumber(id)
  if table.containsKey(self.performDic, id) then
    return self.performDic[id]
  end
  local lineData = LocalController:instance():getLine(TableName.LW_Hero_Skill_Perform, id)
  if lineData == nil then
    Logger.LogError("HeroSkillPerform GetTemplate lineData is nil id:" .. id)
    return nil
  end
  local template = HeroSkillPerformTemplate.New()
  template:InitData(lineData)
  self.performDic[id] = template
  return template
end

HeroSkillPerformTemplateManager.__init = __init
HeroSkillPerformTemplateManager.__delete = __delete
HeroSkillPerformTemplateManager.GetTemplate = GetTemplate
return HeroSkillPerformTemplateManager
