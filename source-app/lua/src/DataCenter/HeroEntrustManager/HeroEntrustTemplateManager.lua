local HeroEntrustTemplateManager = BaseClass("HeroEntrustTemplateManager")
local HeroEntrustTemplate = require("DataCenter.HeroEntrustManager.HeroEntrustTemplate")

function HeroEntrustTemplateManager:__init()
  self.templateDic = {}
end

function HeroEntrustTemplateManager:__delete()
  self.templateDic = {}
end

function HeroEntrustTemplateManager:GetHeroEntrustTemplate(id)
  if id ~= nil then
    local numId = tonumber(id)
    if self.templateDic[numId] == nil then
      local oneTemplate = LocalController:instance():getLine(TableName.HeroEntrust, tostring(id))
      if oneTemplate ~= nil then
        local template = HeroEntrustTemplate.New()
        template:InitData(oneTemplate)
        if template.id ~= nil then
          self.templateDic[template.id] = template
        end
      end
    end
    return self.templateDic[numId]
  end
end

function HeroEntrustTemplateManager:GetHeroEntrustPosition(id)
  local template = self:GetHeroEntrustTemplate(id)
  if template ~= nil then
    return template:GetPosition()
  end
end

return HeroEntrustTemplateManager
