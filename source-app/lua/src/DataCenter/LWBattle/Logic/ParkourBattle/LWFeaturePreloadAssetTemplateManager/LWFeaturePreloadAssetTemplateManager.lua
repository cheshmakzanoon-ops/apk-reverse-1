local LWFeaturePreloadAssetTemplateManager = BaseClass("LWFeaturePreloadAssetTemplateManager")
local LWFeaturePreloadAssetTemplate = require("DataCenter/LWBattle/Logic/ParkourBattle/LWFeaturePreloadAssetTemplateManager/LWFeaturePreloadAssetTemplate")

function LWFeaturePreloadAssetTemplateManager:__init()
  self.templateDic = nil
end

function LWFeaturePreloadAssetTemplateManager:__delete()
  self.templateDic = nil
end

function LWFeaturePreloadAssetTemplateManager:GetTemplate(id)
  if self.templateDic == nil then
    self.templateDic = {}
  end
  if self.templateDic[id] then
    return self.templateDic[id]
  end
  local rowData = LocalController:instance():getLine(TableName.FEATURE_PRELOAD_ASSET, id)
  if rowData == nil then
    return nil
  end
  local item = LWFeaturePreloadAssetTemplate.New()
  item:UpdateData(rowData)
  self.templateDic[id] = item
  return item
end

return LWFeaturePreloadAssetTemplateManager
