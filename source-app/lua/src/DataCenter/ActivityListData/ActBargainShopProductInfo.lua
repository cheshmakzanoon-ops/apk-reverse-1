local ActBargainShopProductInfo = BaseClass("ActBargainShopProductInfo")

function ActBargainShopProductInfo:__init()
  self.id = nil
  self.buyNum = nil
  self.helpPlayers = nil
  self.discount = nil
  self.shopId = {}
  self.uuid = nil
  self.expire = 0
end

function ActBargainShopProductInfo:ParseInfo(message)
  if message.buyNum then
    self.buyNum = message.buyNum
  end
  if message.helpPlayers then
    self.helpPlayers = message.helpPlayers
  end
  if message.discount then
    self.discount = message.discount
  end
  if message.shopId then
    self.shopId = message.shopId
  end
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  if message.expire then
    self.expire = message.expire
  end
  self.template = DataCenter.ActBargainShopTemplateManagaer:GetActBaragainShopPropTemplate(self.shopId)
end

function ActBargainShopProductInfo:GetCurPrice()
  return self.template.price - self:GetReducePrice()
end

function ActBargainShopProductInfo:GetReducePrice()
  local price = 0
  for i = 1, #self.helpPlayers do
    if 0 < self.helpPlayers[i].reducePrice then
      price = price + self.helpPlayers[i].reducePrice
    end
  end
  return price
end

function ActBargainShopProductInfo:GetIsSuper()
  if self.template.sale_tips and self.template.sale_tips > 0 and self:GetCurPrice() <= self.template.price / 100 * self.template.sale_tips then
    return true
  end
end

function ActBargainShopProductInfo:GetIsBargainCompleted()
  if self.helpPlayers and table.count(self.helpPlayers) >= self.template.bargain_num then
    return true
  end
end

function ActBargainShopProductInfo:GetIsPersistent()
  if self.template.tips and self.template.tips > 0 then
    return true
  end
end

return ActBargainShopProductInfo
