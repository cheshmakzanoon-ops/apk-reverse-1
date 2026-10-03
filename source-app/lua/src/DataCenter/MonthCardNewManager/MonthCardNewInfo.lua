local MonthCardNewInfo = BaseClass("MonthCardNewInfo")

local function __init(self)
  self.playerUid = nil
  self.monthCardId = nil
  self.buyTime = nil
  self.endTime = nil
  self.lastClaimTime = nil
  self.totalDays = nil
  self.golloesNum = nil
  self.dailyReward = nil
  self.packageData = nil
  self.monthCardCfg = nil
end

local function __delete(self)
  self.playerUid = nil
  self.monthCardId = nil
  self.buyTime = nil
  self.endTime = nil
  self.lastClaimTime = nil
  self.totalDays = nil
  self.golloesNum = nil
  self.dailyReward = nil
  self.packageData = nil
  self.monthCardCfg = nil
end

local function SetMonthCardId(self, tempID)
  self.monthCardId = tempID
  self.packageData = GiftPackageData.get(self.monthCardId)
end

local function ParseData(self, message)
  if not message then
    return
  end
  if message.uid then
    self.playerUid = message.uid
  end
  if message.itemId then
    self.monthCardId = message.itemId
    self.packageData = GiftPackageData.get(self.monthCardId)
  end
  if message.buyTime then
    self.buyTime = message.buyTime
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  if message.time then
    self.lastClaimTime = message.time
  end
  if message.totalCount then
    self.totalDays = message.totalCount
  end
  if message.golloesNum then
    self.golloesNum = message.golloesNum
  end
  if message.dailyReward then
    self.dailyReward = message.dailyReward
  end
end

local function GetId(self)
  return self.monthCardId
end

local function GetMonthCardCfg(self)
  if self.monthCardId and self.monthCardCfg == nil then
    self.monthCardCfg = DeepCopy(LocalController:instance():getLine("monthcard", self:GetId()))
  end
  return self.monthCardCfg
end

local function GetProductID(self)
  return self.packageData and self.packageData.product_id_google
end

local function GetPrice(self)
  return self.packageData and self.packageData.dollar or 0
end

local function GetPriceText(self)
  local productId = self.packageData:getProductID()
  local price = self.packageData:getPrice()
  return DataCenter.PayManager:GetDollarText(price, productId)
end

local function IsBought(self)
  if not self.endTime then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now < self.endTime
end

local function IsTimeValid(self)
  if not self.packageData then
    return false
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.packageData:getStartTime() and serverTime <= self.packageData:getEndTime()
end

local function IsTodayClaimed(self)
  if self.lastClaimTime then
    local lastTimeS = math.modf(self.lastClaimTime / 1000)
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local todayClaimed = UITimeManager:GetInstance():IsSameDayForServer(lastTimeS, serverTime)
    return todayClaimed
  end
end

local function GetPackageData(self)
  return self.packageData
end

local function GetDailyRewards(self)
  local monthCardConf = LocalController:instance():getLine("monthcard", self:GetId())
  if monthCardConf then
    local strRewards = monthCardConf.reward_show_daily or ""
    return DataCenter.RewardManager:ParseRewardsStr(strRewards)
  else
    return {}
  end
end

MonthCardNewInfo.__init = __init
MonthCardNewInfo.__delete = __delete
MonthCardNewInfo.ParseData = ParseData
MonthCardNewInfo.GetPriceText = GetPriceText
MonthCardNewInfo.GetPrice = GetPrice
MonthCardNewInfo.GetProductID = GetProductID
MonthCardNewInfo.SetMonthCardId = SetMonthCardId
MonthCardNewInfo.IsBought = IsBought
MonthCardNewInfo.GetId = GetId
MonthCardNewInfo.GetMonthCardCfg = GetMonthCardCfg
MonthCardNewInfo.IsTimeValid = IsTimeValid
MonthCardNewInfo.IsTodayClaimed = IsTodayClaimed
MonthCardNewInfo.GetPackageData = GetPackageData
MonthCardNewInfo.GetDailyRewards = GetDailyRewards
return MonthCardNewInfo
