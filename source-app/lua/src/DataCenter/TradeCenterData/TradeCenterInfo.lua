local TradeCenterInfo = BaseClass("TradeCenterInfo")

local function __init(self)
  self.buyInfo = nil
  self.freeSpeed = 0
  self.buyOffPriceType = 0
  self.resourceExchangeST = 0
  self.resourceExchangeET = 0
  self.nextResourceExchangeST = 0
  self.totalRes = nil
  self.nextCallNeedItemCount = 0
  self.priceInfo = nil
  self.userItemTimes = 0
  self.maxUseItemTimes = 0
  self.callCostItemId = 210154
  self.curPrice = nil
  self.sellRecord = nil
  self.leftTotalMoney = 0
  self.callPlaneTimes = 0
  self.isBaseRate = false
end

local function __delete(self)
  self.buyInfo = nil
  self.freeSpeed = nil
  self.buyOffPriceType = nil
  self.resourceExchangeST = nil
  self.resourceExchangeET = nil
  self.nextResourceExchangeST = nil
  self.totalRes = nil
  self.nextCallNeedItemCount = nil
  self.priceInfo = nil
  self.userItemTimes = nil
  self.maxUseItemTimes = nil
  self.callCostItemId = nil
  self.curPrice = nil
  self.sellRecord = nil
  self.leftTotalMoney = nil
  self.callPlaneTimes = nil
  self.isBaseRate = nil
end

local function UpdateInfo(self, message)
  if message.buyInfo ~= nil then
    self.buyInfo = message.buyInfo
  end
  if message.freeSpeed ~= nil then
    self.freeSpeed = message.freeSpeed
  end
  if message.buyOffPriceType ~= nil then
    self.buyOffPriceType = message.buyOffPriceType
  end
  if message.resourceExchangeST ~= nil then
    self.resourceExchangeST = message.resourceExchangeST
  end
  if message.resourceExchangeET ~= nil then
    self.resourceExchangeET = message.resourceExchangeET
  end
  if message.nextResourceExchangeST ~= nil then
    self.nextResourceExchangeST = message.nextResourceExchangeST
  end
  if message.totalRes ~= nil then
    self.totalRes = message.totalRes
  end
  if message.priceInfo ~= nil then
    self.priceInfo = message.priceInfo
  end
  if message.userItemTimes ~= nil then
    self.userItemTimes = message.userItemTimes
  end
  if message.maxUseItemTimes ~= nil then
    self.maxUseItemTimes = message.maxUseItemTimes
  end
  if message.nextCallNeedItemCount ~= nil then
    self.nextCallNeedItemCount = message.nextCallNeedItemCount
  end
  if message.sellRecord ~= nil then
    self.sellRecord = message.sellRecord
  end
  if message.leftTotalMoney ~= nil then
    self.leftTotalMoney = message.leftTotalMoney
  end
  if message.callPlaneTimes ~= nil then
    self.callPlaneTimes = message.callPlaneTimes
  end
  if message.isBaseRate ~= nil then
    self.isBaseRate = message.isBaseRate
  end
  if self.priceInfo.buyPriceInfo ~= nil then
    self.curPrice = self.priceInfo.buyPriceInfo
  end
end

TradeCenterInfo.__init = __init
TradeCenterInfo.__delete = __delete
TradeCenterInfo.UpdateInfo = UpdateInfo
return TradeCenterInfo
