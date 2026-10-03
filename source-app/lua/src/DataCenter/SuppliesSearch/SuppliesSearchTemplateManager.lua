local SuppliesSearchTemplateManager = BaseClass("SuppliesSearchTemplateManager")
local SuppliesSearchTemplate = require("DataCenter.SuppliesSearch.SuppliesSearchTemplate")

function SuppliesSearchTemplateManager:__init()
  self.tSuppliesSearchTemplateDic = nil
end

function SuppliesSearchTemplateManager:__delete()
  self.tSuppliesSearchTemplateDic = nil
end

function SuppliesSearchTemplateManager:GetConfigData(nConfigId)
  if not nConfigId then
    Logger.LogError("SuppliesSearchTemplateManager:GetConfigData configId is nil")
    return nil
  end
  if not self.tSuppliesSearchTemplateDic then
    self.tSuppliesSearchTemplateDic = {}
  end
  if not self.tSuppliesSearchTemplateDic[nConfigId] then
    local line = LocalController:instance():getLine(TableName.MONOPOLY_SEARCH, nConfigId)
    if line then
      local config = SuppliesSearchTemplate.New()
      config:UpdateData(line)
      self.tSuppliesSearchTemplateDic[nConfigId] = config
    end
  end
  return self.tSuppliesSearchTemplateDic[nConfigId]
end

return SuppliesSearchTemplateManager
