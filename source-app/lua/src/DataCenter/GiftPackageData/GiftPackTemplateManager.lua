local GiftPackTemplateManager = BaseClass("GiftPackTemplateManager")
local GiftPackTemplate = require("DataCenter.GiftPackageData.GiftPackTemplate")

function GiftPackTemplateManager:__init()
  self.giftPackTemplates = {}
end

function GiftPackTemplateManager:__delete()
  self.giftPackTemplates = nil
end

function GiftPackTemplateManager:GetGiftPackInfo(giftPackID)
  if not self.giftPackTemplates[giftPackID] then
    if not self.giftPackTemplates then
      self.giftPackTemplates = {}
    end
    local lineData = LocalController:instance():getLine(TableName.Exchange, giftPackID)
    if not lineData then
      Logger.LogError("GiftPackTemplateManager GetGiftPackInfo lineData is nil id:" .. giftPackID)
      return nil
    end
    local template = GiftPackTemplate.New()
    template:InitConfig(lineData)
    self.giftPackTemplates[giftPackID] = template
  end
  return self.giftPackTemplates[giftPackID]
end

return GiftPackTemplateManager
