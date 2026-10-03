local SkillEffectPvpTemplateManager = BaseClass("SkillEffectPvpTemplateManager")
local LwHeroSkillEffectPvpTemplate = require("DataCenter.HeroSkillTemplateManager.LwHeroSkillEffectPvpTemplate")

function SkillEffectPvpTemplateManager:__init()
  self.templateDic = {}
end

function SkillEffectPvpTemplateManager:__delete()
  self.templateDic = nil
end

function SkillEffectPvpTemplateManager:GetTemplate(id)
  if not self.templateDic[id] then
    local lineData = LocalController:instance():getLine(TableName.LW_Skill_Effect_PVP, id)
    if lineData then
      local template = LwHeroSkillEffectPvpTemplate.New()
      template:UpdateData(lineData)
      self.templateDic[id] = template
    end
  end
  return self.templateDic[id]
end

return SkillEffectPvpTemplateManager
