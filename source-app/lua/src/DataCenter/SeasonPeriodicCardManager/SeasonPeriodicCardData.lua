local SeasonPeriodicCardData = BaseClass("SeasonPeriodicCardData")

function SeasonPeriodicCardData:__init()
  self.cardId = nil
  self.buyTime = nil
  self.endTime = nil
  self.dailyRewardTime = nil
  self.freeRewardTime = nil
  self.packageId = nil
  self.giftId = nil
end

function SeasonPeriodicCardData:__delete()
  self.cardId = nil
  self.buyTime = nil
  self.endTime = nil
  self.dailyRewardTime = nil
  self.freeRewardTime = nil
  self.packageId = nil
  self.giftId = nil
end

function SeasonPeriodicCardData:ParseData(message)
  if not message then
    return
  end
  if message.card_id then
    self.cardId = message.card_id
    local weekConfig = LocalController:instance():getLine(TableName.Season_Week_Card, self.cardId)
    self.giftId = weekConfig.gift
  end
  if message.buy_time then
    self.buyTime = message.buy_time
  else
    self.buyTime = 0
  end
  if message.end_time then
    self.endTime = message.end_time
  else
    self.endTime = 0
  end
  if message.daily_reward then
    self.dailyRewardTime = message.daily_reward
  else
    self.dailyRewardTime = nil
  end
  if message.free_reward then
    self.freeRewardTime = message.free_reward
  else
    self.freeRewardTime = nil
  end
end

function SeasonPeriodicCardData:GetId()
  return self.cardId
end

function SeasonPeriodicCardData:GetProductID()
  local packageData = self:GetPackageData()
  return packageData and packageData.product_id_google
end

function SeasonPeriodicCardData:GetPrice()
  local packageData = self:GetPackageData()
  return packageData and packageData.dollar or 0
end

function SeasonPeriodicCardData:GetPriceText()
  local packageData = self:GetPackageData()
  if packageData then
    local productId = packageData:getProductID()
    local price = packageData:getPrice()
    return DataCenter.PayManager:GetDollarText(price, productId)
  end
  return ""
end

function SeasonPeriodicCardData:IsBought()
  if not self.endTime then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now < self.endTime
end

function SeasonPeriodicCardData:IsTimeValid()
  local packageData = self:GetPackageData()
  if not packageData then
    return false
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= packageData:getStartTime() and serverTime <= packageData:getEndTime()
end

function SeasonPeriodicCardData:IsTodayClaimed()
  if self.dailyRewardTime then
    local lastTimeS = math.modf(self.dailyRewardTime / 1000)
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local todayClaimed = UITimeManager:GetInstance():IsSameDayForServer(lastTimeS, serverTime)
    return todayClaimed
  end
end

function SeasonPeriodicCardData:IsTodayClaimedFree()
  if self.freeRewardTime then
    local lastTimeS = math.modf(self.freeRewardTime / 1000)
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local todayClaimed = UITimeManager:GetInstance():IsSameDayForServer(lastTimeS, serverTime)
    return todayClaimed
  end
end

function SeasonPeriodicCardData:GetPackageData()
  local data = GiftPackageData.get(self.giftId)
  if data == nil then
    Logger.Log("\232\181\155\229\173\163\229\145\168\229\141\161\230\149\176\230\141\174\228\184\141\229\173\152\229\156\168 " .. self.giftId)
  end
  return data
end

return SeasonPeriodicCardData
