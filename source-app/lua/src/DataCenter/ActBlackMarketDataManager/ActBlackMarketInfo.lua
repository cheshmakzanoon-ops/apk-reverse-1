local ActBlackMarketInfo = BaseClass("ActBlackMarketInfo")

local function __init(self)
  self.id = 0
  self.refreshTime = 0
  self.refreshNum = 0
  self.products = {}
  self.productIdMap = {}
  self.productUuidMap = {}
  self.nowZeroTime = 0
  self.giftPackGroupId = 0
  self.priceArr = nil
end

local function __delete(self)
  self.id = 0
  self.refreshTime = 0
  self.refreshNum = 0
  self.products = nil
  self.productIdMap = nil
  self.productUuidMap = nil
  self.nowZeroTime = 0
  self.giftPackGroupId = nil
  self.priceArr = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  local actId
  if message.id then
    actId = message.id
  elseif message.activityId then
    actId = message.activityId
  end
  if actId then
    local prevActId = self.id
    actId = tostring(actId)
    self.id = actId
    if prevActId == 0 or prevActId ~= actId then
      self.costDiamonds = {}
      self.totalRefreshTimes = 0
      local costDiamondStr = ""
      local actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
      if actBaseInfo then
        costDiamondStr = actBaseInfo.para_5
        self.totalRefreshTimes = tonumber(actBaseInfo.para_3)
        self.giftPackGroupId = tonumber(actBaseInfo.para_4)
      else
        local activityConfigData = LocalController:instance():getLine(TableName.Activity, toInt(self.id))
        if activityConfigData then
          costDiamondStr = activityConfigData.para_5
          self.totalRefreshTimes = tonumber(activityConfigData.para_3) or 0
          self.giftPackGroupId = tonumber(activityConfigData.para_4)
        end
      end
      if costDiamondStr then
        self.costDiamonds = string.split(costDiamondStr, "|")
        for i, v in pairs(self.costDiamonds) do
          self.costDiamonds[i] = tonumber(v)
        end
      end
    end
  end
  local useServerMaxTimes = LuaEntry.DataConfig:CheckSwitch("blackmarket_get_times")
  if useServerMaxTimes and message.dayRefreshMaxNum then
    local serverMax = tonumber(message.dayRefreshMaxNum)
    if serverMax and 0 < serverMax then
      self.totalRefreshTimes = serverMax
    end
  end
  if message.refreshTime then
    self.refreshTime = message.refreshTime
  end
  if message.refreshNum then
    self.refreshNum = message.refreshNum
  end
  if message.shopArr then
    self.products = message.shopArr
    table.sort(self.products, function(a, b)
      local productA = a
      local productB = b
      local randomPoolIdA = productA.randomPool
      local randomPoolIdB = productB.randomPool
      if randomPoolIdA ~= randomPoolIdB then
        return randomPoolIdA < randomPoolIdB
      end
      local productIdA = productA.shopId
      local productIdB = productB.shopId
      if productIdA ~= productIdB then
        return productIdA < productIdB
      end
      return productA.displayOrder < productB.displayOrder
    end)
    for _, v in ipairs(self.products) do
      v.reward = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
    end
    for i, v in pairs(self.productIdMap) do
      self.productIdMap[i] = nil
    end
    for i, v in ipairs(self.products) do
      self.productIdMap[v.shopId] = v
    end
    for i, v in pairs(self.productUuidMap) do
      self.productUuidMap[i] = nil
    end
    for i, v in ipairs(self.products) do
      self.productUuidMap[v.shopUuid] = v
    end
  end
  if message.nowZeroTime then
    self.nowZeroTime = message.nowZeroTime
  end
  if message.priceArr then
    self.priceArr = {}
    for _, v in ipairs(message.priceArr) do
      table.insert(self.priceArr, tonumber(v) or 0)
    end
  end
end

local function GetProductInfo(self, productId)
  return self.productUuidMap[productId]
end

local function UpdateProductRemainTimes(self, productUuid, times, maxTimes)
  if self.productUuidMap[productUuid] then
    self.productUuidMap[productUuid].num = times
    self.productUuidMap[productUuid].buyTimeLimit = maxTimes
  end
end

local function GetRefreshCost(self)
  local refreshNum = self:GetRefreshNum()
  if LuaEntry.DataConfig:CheckSwitch("blackmarket_get_times") and self.priceArr and #self.priceArr > 0 then
    local cost = self.priceArr[1]
    if cost == nil then
      cost = self.priceArr[#self.priceArr] or IntMaxValue
    else
      cost = tonumber(cost) or 0
    end
    return cost
  end
  local cost = self.costDiamonds[refreshNum + 1]
  cost = cost or self.costDiamonds[#self.costDiamonds] or IntMaxValue
  return cost
end

local function GetRefreshNum(self)
  local nowServerSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local nowZeroTimeSeconds = self.nowZeroTime / 1000
  if not UITimeManager:GetInstance():IsSameDayForServer(nowZeroTimeSeconds, nowServerSeconds) then
    return 0
  end
  return self.refreshNum
end

local function GetRefreshRemainCount(self)
  local nowServerSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local nowZeroTimeSeconds = self.nowZeroTime / 1000
  if not UITimeManager:GetInstance():IsSameDayForServer(nowZeroTimeSeconds, nowServerSeconds) then
    return self.totalRefreshTimes, self.totalRefreshTimes
  end
  local refreshNum = self:GetRefreshNum()
  return self.totalRefreshTimes - refreshNum, self.totalRefreshTimes
end

local function GetRefreshGetCount(self)
  local nowServerSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local nowZeroTimeSeconds = self.nowZeroTime / 1000
  local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(nowZeroTimeSeconds, nowServerSeconds)
  local totalRefreshTimes = 0
  local freeTimes = 0
  local diamondTimes = 0
  local cfgTotal
  local actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.id))
  if actBaseInfo then
    cfgTotal = tonumber(actBaseInfo.para_3)
  else
    local activityConfigData = LocalController:instance():getLine(TableName.Activity, toInt(self.id))
    if activityConfigData then
      cfgTotal = tonumber(activityConfigData.para_3)
    end
  end
  totalRefreshTimes = cfgTotal or 0
  if self.priceArr then
    for _, v in ipairs(self.priceArr) do
      local cost = tonumber(v) or 0
      if cost == 0 then
        freeTimes = freeTimes + 1
      else
        diamondTimes = diamondTimes + 1
      end
    end
  end
  return totalRefreshTimes, freeTimes, diamondTimes
end

local function GetGiftPacks(self)
  return self.giftPackGroupId
end

ActBlackMarketInfo.__init = __init
ActBlackMarketInfo.__delete = __delete
ActBlackMarketInfo.ParseData = ParseData
ActBlackMarketInfo.GetProductInfo = GetProductInfo
ActBlackMarketInfo.UpdateProductRemainTimes = UpdateProductRemainTimes
ActBlackMarketInfo.GetRefreshCost = GetRefreshCost
ActBlackMarketInfo.GetRefreshRemainCount = GetRefreshRemainCount
ActBlackMarketInfo.GetRefreshGetCount = GetRefreshGetCount
ActBlackMarketInfo.GetGiftPacks = GetGiftPacks
ActBlackMarketInfo.GetRefreshNum = GetRefreshNum
return ActBlackMarketInfo
