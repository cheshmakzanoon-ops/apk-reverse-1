local WonderGiftTemplateManager = BaseClass("WonderGiftTemplateManager")
local WonderGiftTemplate = require("DataCenter.WonderGiftTemplateManager.WonderGiftTemplate")

function WonderGiftTemplateManager:__init()
  self.templateDic = nil
end

function WonderGiftTemplateManager:__delete()
  if self.templateDic then
    for _, v in pairs(self.templateDic) do
      v:Delete()
    end
  end
  self.templateDic = {}
end

function WonderGiftTemplateManager:InitTemplate()
  if self.templateDic == nil then
    self.templateDic = {}
    LocalController:instance():visitTable(TableName.WonderGift, function(id, lineData)
      local template = WonderGiftTemplate.New()
      template:InitData(lineData)
      self.templateDic[tostring(id)] = template
    end)
  end
end

function WonderGiftTemplateManager:GetTemplate(id)
  self:InitTemplate()
  if self.templateDic ~= nil then
    return self.templateDic[tostring(id)]
  end
  return nil
end

function WonderGiftTemplateManager:GetTemplateByType(theType, actType)
  self:InitTemplate()
  local season = DataCenter.SeasonDataManager:GetSeason() or 0
  for _, template in pairs(self.templateDic) do
    if template.season == season and template.type == theType and template.act_type == actType then
      return template
    end
  end
end

return WonderGiftTemplateManager
