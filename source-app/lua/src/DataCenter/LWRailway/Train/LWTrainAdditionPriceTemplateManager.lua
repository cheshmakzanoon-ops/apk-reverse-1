local LWTrainAdditionPriceTemplateManager = BaseClass("LWTrainAdditionPriceTemplateManager")

function LWTrainAdditionPriceTemplateManager:__init()
  self.priceTemplateDict = {}
  self.init = false
end

function LWTrainAdditionPriceTemplateManager:__delete()
  self.priceTemplateDict = nil
  self.init = nil
end

function LWTrainAdditionPriceTemplateManager:Init()
  if self.init then
    return
  end
  self.init = true
  LocalController:instance():visitTable(TableName.TRAIN_ADDITION_PRICE, function(id, lineData)
    local type = lineData.type
    local itemId = lineData.goods_resource_randomtype
    local goods2Price = self.priceTemplateDict[type] or nil
    if goods2Price == nil then
      goods2Price = {}
      self.priceTemplateDict[type] = goods2Price
    end
    goods2Price[itemId] = lineData.price
  end)
end

function LWTrainAdditionPriceTemplateManager:GetPrice(type, itemId)
  if not self.init then
    self:Init()
  end
  local goods2Price = self.priceTemplateDict[type]
  if not goods2Price then
    Logger.LogError(string.format("\231\177\187\229\158\139\228\184\186\239\188\154%s id\228\184\186\239\188\154%s \231\154\132\228\187\183\230\160\188\230\168\161\230\157\191\228\184\141\229\173\152\229\156\168", type, itemId))
    return 0
  end
  local price = goods2Price[itemId]
  if price == nil then
    Logger.LogError(string.format("\231\177\187\229\158\139\228\184\186\239\188\154%s id\228\184\186\239\188\154%s \231\154\132\228\187\183\230\160\188\230\168\161\230\157\191\228\184\141\229\173\152\229\156\168", type, itemId))
    return 0
  end
  return price
end

return LWTrainAdditionPriceTemplateManager
