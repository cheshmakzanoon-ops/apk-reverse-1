local SeasonDesertShopTemplateManager = BaseClass("SeasonDesertShopTemplateManager")
local SeasonDesertShopTemplate = require("DataCenter.SeasonManager.SeasonDesertShopTemplate")

function SeasonDesertShopTemplateManager:__init()
  self.shopMap = nil
end

function SeasonDesertShopTemplateManager:__delete()
  self.shopMap = nil
end

function SeasonDesertShopTemplateManager:GetDataList(shopId)
  if self.shopMap == nil and LocalController:instance():getTable(TableName.SeasonDesertShop) ~= nil then
    self.shopMap = {}
    LocalController:instance():visitTable(TableName.SeasonDesertShop, function(id, line)
      local tData = SeasonDesertShopTemplate.New(line)
      local shopIds = string.split_ss_array(tData.shop_id, ";")
      for _, eachId in ipairs(shopIds) do
        local tList = self.shopMap[toInt(eachId)]
        if tList == nil then
          tList = {}
          self.shopMap[toInt(eachId)] = tList
        end
        table.insert(tList, tData)
      end
    end)
  end
  return self.shopMap[shopId]
end

return SeasonDesertShopTemplateManager
