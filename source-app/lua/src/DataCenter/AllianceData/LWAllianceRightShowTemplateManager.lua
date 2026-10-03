local LWAllianceRightShowTemplateManager = BaseClass("LWAllianceRightShowTemplateManager")
local LWAllianceRightShowTemplate = require("DataCenter.AllianceData.LWAllianceRightShowTemplate")

function LWAllianceRightShowTemplateManager:__init()
  self.templateDict = {}
  self.type2TemplateDict = {}
  self.templateIsTrainRightsDict = {}
end

function LWAllianceRightShowTemplateManager:__delete()
  self.templateDict = nil
  self.type2TemplateDict = nil
  self.templateIsTrainRightsDict = nil
end

function LWAllianceRightShowTemplateManager:GetTemplate(templateId)
  if self.templateDict[templateId] == nil then
    self:GetAllTemplates()
  end
  return self.templateDict[templateId]
end

function LWAllianceRightShowTemplateManager:GetAllTemplates()
  if table.count(self.templateDict) == 0 then
    LocalController:instance():visitTable(TableName.Alliance_Right_Show, function(id, lineData)
      local template = LWAllianceRightShowTemplate.New()
      template:Init(lineData)
      self.templateDict[template.id] = template
    end)
  end
  return self.templateDict
end

function LWAllianceRightShowTemplateManager:GetTemplatesByType(type)
  if table.count(self.type2TemplateDict) == 0 then
    local allTemplateDict = self:GetAllTemplates()
    for k, template in pairs(allTemplateDict) do
      if 0 < template.type then
        if self.type2TemplateDict[template.type] == nil then
          self.type2TemplateDict[template.type] = {}
        end
        table.insert(self.type2TemplateDict[template.type], template)
      end
    end
  end
  if self.type2TemplateDict[type] then
    return self.type2TemplateDict[type]
  end
  return nil
end

function LWAllianceRightShowTemplateManager:GetTemplatesIsTrainRights(IsTrainRight)
  if table.count(self.templateIsTrainRightsDict) == 0 then
    local allTemplateDict = self:GetAllTemplates()
    for k, template in pairs(allTemplateDict) do
      if template.is_train_right == IsTrainRight then
        if self.templateIsTrainRightsDict[template.is_train_right] == nil then
          self.templateIsTrainRightsDict[template.is_train_right] = {}
        end
        table.insert(self.templateIsTrainRightsDict[template.is_train_right], template)
      end
    end
  end
  if self.templateIsTrainRightsDict[IsTrainRight] then
    table.sort(self.templateIsTrainRightsDict[IsTrainRight], function(a, b)
      return a.id < b.id
    end)
    return self.templateIsTrainRightsDict[IsTrainRight]
  end
  return nil
end

function LWAllianceRightShowTemplateManager:GetEffectValueByType(type)
  local value = 0
  local curGiftLevel = DataCenter.AllianceGiftDataManager:GetCurLevel()
  local templates = self:GetTemplatesByType(type)
  local count = table.count(templates)
  for i = 1, count do
    local template = templates[i]
    if curGiftLevel >= template.gift_lv then
      local addValue = template:GetTypeValue()
      value = value + addValue
    end
  end
  return value
end

return LWAllianceRightShowTemplateManager
