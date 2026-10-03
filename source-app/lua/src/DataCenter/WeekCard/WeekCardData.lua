local WeekCardData = BaseClass("WeekCardData")
local ItemImageType = {
  Resource = 1,
  Goods = 2,
  GoodsParam1 = 3,
  GoodsParam2 = 4,
  ExpAdaptiveBox = 5
}

local function __init(self)
  self.id = 0
  self.type = 0
  self.typeFunction = 0
  self.exchangeId = ""
  self.reward = {}
  self.name = ""
  self.desc = ""
  self.subDesc = ""
  self.image = ""
  self.itemImg = ""
  self.showImg = ""
  self.order = ""
  self.conditionFit = true
  self.discount = 0
  self.validDays = 0
  self.showReward = {}
  self.startTime = 0
  self.endTime = 0
  self.lastRecvTime = 0
  self.status = WeekCardPackageStatus.CannotBuy
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.typeFunction = nil
  self.exchangeId = nil
  self.reward = nil
  self.name = nil
  self.desc = nil
  self.subDesc = nil
  self.image = nil
  self.itemImg = nil
  self.showImg = nil
  self.order = nil
  self.conditionFit = nil
  self.validDays = nil
  self.discount = nil
  self.showReward = nil
  self.startTime = nil
  self.endTime = nil
  self.lastRecvTime = nil
  self.status = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.id then
    self.id = message.id
  end
  if message.type then
    self.type = message.type
  end
  if message.type_function then
    self.typeFunction = message.type_function
  end
  if message.exchange_id then
    self.exchangeId = message.exchange_id
  end
  if message.reward then
    self.reward = message.reward
  end
  if message.name then
    self.name = message.name
  end
  if message.description then
    self.desc = message.description
  end
  if message.description_sub then
    self.subDesc = message.description_sub
  end
  if message.image then
    self.image = message.image
  end
  if message.item_image then
    self.itemImg = message.item_image
  end
  if message.show_image then
    self.showImg = message.show_image
  end
  if message.order then
    self.order = message.order
  end
  if message.condition then
    self.condition = message.condition
  end
  if message.startTime then
    self.startTime = message.startTime
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  if message.lastReceiveTime then
    self.lastRecvTime = message.lastReceiveTime
  end
  if message.percent then
    self.discount = tonumber(message.percent)
  end
  if message.time then
    self.validDays = message.time
    self.validDays = math.floor(self.validDays / 60 / 24)
  end
  if message.reward_show then
    local showRewardStr = message.reward_show or ""
    self.showReward = DataCenter.RewardManager:ParseRewardsStr(showRewardStr)
  end
  if message.isNew then
    self.isNew = message.isNew == 1
  end
end

local function RefreshStatus(self)
  local status = 0
  if self.typeFunction == WeekCardFucntionType.BuildQueue then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    local hasBought = serverTime < self.endTime
    local isValid = self.conditionFit
    if hasBought and isValid then
      status = WeekCardPackageStatus.BuyAgain
    else
      status = WeekCardPackageStatus.CanBuy
    end
  elseif self.typeFunction == WeekCardFucntionType.Collectable then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    local lastClaimT = math.modf(self.lastRecvTime / 1000)
    local serverTimeS = math.modf(serverTime / 1000)
    local hasBought = serverTime < self.endTime
    local todayClaimed = UITimeManager:GetInstance():IsSameDayForServer(lastClaimT, serverTimeS)
    local isValid = self.conditionFit
    if hasBought and not todayClaimed then
      status = WeekCardPackageStatus.CanClaim
    elseif hasBought and todayClaimed then
      status = WeekCardPackageStatus.BuyAgain
    elseif not isValid then
      status = WeekCardPackageStatus.CannotBuy
    else
      status = WeekCardPackageStatus.CanBuy
    end
  end
  self.status = status
  return status
end

local function GetStatus(self)
  return self.status
end

local function GetRewardIconPath(self)
  if not string.IsNullOrEmpty(self.itemImg) then
    local rewardItemStr = self.itemImg
    local rewardItemArr = string.split(rewardItemStr, ";")
    if 3 <= #rewardItemArr then
      local type = tonumber(rewardItemArr[1])
      local id = tonumber(rewardItemArr[2])
      if type == ItemImageType.Resource then
        return DataCenter.RewardManager:GetPicByType(id, id)
      elseif type == ItemImageType.Goods or type == ItemImageType.GoodsParam1 or type == ItemImageType.GoodsParam2 or type == ItemImageType.ExpAdaptiveBox then
        return DataCenter.RewardManager:GetPicByType(RewardType.GOODS, id)
      end
    end
  end
  return ""
end

local function GetDailyRewardCount(self)
  if not string.IsNullOrEmpty(self.itemImg) then
    local rewardItemStr = self.itemImg
    local rewardItemArr = string.split(rewardItemStr, ";")
    if 3 <= #rewardItemArr then
      local type = tonumber(rewardItemArr[1])
      local id = tonumber(rewardItemArr[2])
      local count = tonumber(rewardItemArr[3])
      local dailyClaimCount = 0
      if type == ItemImageType.Goods then
        dailyClaimCount = count
      elseif type == ItemImageType.Resource then
        dailyClaimCount = count
      elseif type == ItemImageType.GoodsParam1 or type == ItemImageType.GoodsParam2 then
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
        if itemTemplate then
          if type == ItemImageType.GoodsParam1 then
            dailyClaimCount = tonumber(itemTemplate.para1) * count
          else
            dailyClaimCount = tonumber(itemTemplate.para2) * count
          end
        end
      elseif type == ItemImageType.ExpAdaptiveBox then
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
        if itemTemplate then
          local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(itemTemplate.para1, DataCenter.BuildManager.MainLv, itemTemplate.para2)
          if returnItem then
            dailyClaimCount = returnItem.num * count
          end
        end
      end
      return dailyClaimCount
    end
  end
  return 0
end

local function GetDailyReward(self)
  return DeepCopy(self.showReward)
end

function WeekCardData:IsRenewWeekCountLimited()
  local weekTime = 604800000
  local timeNow = UITimeManager:GetInstance():GetServerTime()
  local todayZero = UITimeManager:GetInstance():GetTodayZeroServerTime(timeNow // 1000) * 1000
  local endDayZero = UITimeManager:GetInstance():GetTodayZeroServerTime(self.endTime // 1000) * 1000
  local curLeftTime = math.max(0, endDayZero - todayZero)
  local weekLimit = DataCenter.WeekCardManager:GetRenewWeekCountLimit()
  if 0 < weekLimit then
    local weekLimitTimeMS = weekLimit * weekTime
    if weekTime > weekLimitTimeMS - curLeftTime then
      return true
    end
    return false
  end
  return false
end

WeekCardData.__init = __init
WeekCardData.__delete = __delete
WeekCardData.ParseData = ParseData
WeekCardData.RefreshStatus = RefreshStatus
WeekCardData.GetStatus = GetStatus
WeekCardData.GetRewardIconPath = GetRewardIconPath
WeekCardData.GetDailyRewardCount = GetDailyRewardCount
WeekCardData.GetDailyReward = GetDailyReward
return WeekCardData
