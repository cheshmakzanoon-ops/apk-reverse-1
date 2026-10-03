local LuckyShopItemData = BaseClass("LuckyShopItemData")

local function __init(self)
  self.shopId = 0
  self.isBuy = 0
  self.rewardType = 0
  self.rewardNum = 0
  self.rewardId = 0
  self.price = 0
  self.costType = 0
  self.costId = 0
  self.costNum = 0
end

local function __delete(self)
  self.shopId = nil
  self.isBuy = nil
  self.rewardType = nil
  self.rewardNum = nil
  self.rewardId = nil
  self.price = nil
  self.costType = nil
  self.costId = nil
  self.costNum = nil
end

local function ParseData(self, param)
  self.shopId = param.shopId
  self.isBuy = param.buyState
  self.rewardType = tonumber(param.rewardType)
  self.rewardNum = tonumber(param.rewardNum)
  self.rewardId = param.rewardId
  self.price = param.price
  local currency = param.currency
  local strArr = string.split(currency, ";")
  if 0 < #strArr then
    self.costType = tonumber(strArr[1])
    self.costId = tonumber(strArr[2])
  end
  self.costNum = tonumber(param.currency_num)
end

local function IsBuy(self)
  return self.isBuy ~= 0
end

LuckyShopItemData.__init = __init
LuckyShopItemData.__delete = __delete
LuckyShopItemData.ParseData = ParseData
LuckyShopItemData.IsBuy = IsBuy
return LuckyShopItemData
