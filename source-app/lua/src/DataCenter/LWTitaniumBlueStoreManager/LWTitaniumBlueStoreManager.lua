local LWTitaniumBlueStoreManager = BaseClass("LWTitaniumBlueStoreManager")
local LWTitaniumBlueBoxRewardInfo = require("DataCenter.LWTitaniumBlueStoreManager.LWTitaniumBlueBoxRewardInfo")
local LWTitaniumBlueProductInfo = require("DataCenter.LWTitaniumBlueStoreManager.LWTitaniumBlueProductInfo")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")

function LWTitaniumBlueStoreManager:__init()
  self.startTime = 0
  self.endTime = 0
  self.endViewTime = 0
  self.activityId = 0
  self.activityType = 0
  self.productList = {}
  self.boxReceiveList = {}
  self.boxRewardsList = {}
  self.dayRewardNextRefreshTime = 0
  self.dayRewardLastReceiveFreeTime = 0
  self.dayRewardReceiveState = 0
  self.dayRewardList = {}
  self.totalScore = 0
  self.activityFreeRewardData = ActivityFreeRewardData.New()
end

function LWTitaniumBlueStoreManager:__delete()
  self.startTime = nil
  self.endTime = nil
  self.endViewTime = nil
  self.activityId = nil
  self.activityType = nil
  self.productList = nil
  self.boxReceiveList = nil
  self.boxRewardsList = nil
  self.dayRewardNextRefreshTime = nil
  self.dayRewardLastReceiveFreeTime = nil
  self.dayRewardReceiveState = nil
  self.dayRewardList = nil
  self.totalScore = nil
  self.activityFreeRewardData = nil
end

function LWTitaniumBlueStoreManager:Startup()
end

function LWTitaniumBlueStoreManager:ParseTitaniumBlueStoreMessage(message)
  if message.id then
    self.activityId = message.id
  end
  if message.activityType then
    self.activityType = message.activityType
  end
  if message.startTime then
    self.startTime = message.startTime
  end
  if message.endViewTime then
    self.endViewTime = message.endViewTime
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  if message.totalScore then
    self.totalScore = message.totalScore
  end
  if message.nextRefreshTime then
    self.dayRewardNextRefreshTime = message.nextRefreshTime
  end
  if message.lastReceiveFreeTime then
    self.dayRewardLastReceiveFreeTime = message.lastReceiveFreeTime
  end
  if message.receiveState then
    self.dayRewardReceiveState = message.receiveState
  end
  if message.dayReward then
    self.dayRewardList = DataCenter.RewardManager:ReturnRewardParamForView(message.dayReward)
  end
  self:UpdateActivityFreeRewardData()
  if message.boxReceive then
    self.boxReceiveList = message.boxReceive
  end
  if message.boxRewards then
    self.boxRewardsList = {}
    for i, v in pairs(message.boxRewards) do
      local boxRewardInfo = LWTitaniumBlueBoxRewardInfo.New()
      boxRewardInfo:InitData(v)
      table.insert(self.boxRewardsList, boxRewardInfo)
    end
    table.sort(self.boxRewardsList, function(a, b)
      if a.index < b.index then
        return true
      end
    end)
  end
  if message.shopArr then
    self.productList = {}
    for i, v in pairs(message.shopArr) do
      local productInfo = LWTitaniumBlueProductInfo.New()
      productInfo:InitData(v)
      table.insert(self.productList, productInfo)
    end
    table.sort(self.productList, function(a, b)
      if a.displayOrder < b.displayOrder then
        return true
      end
    end)
  end
end

function LWTitaniumBlueStoreManager:UpdateProductDataAfterBuy(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  local id = message.shopId
  for i = 1, #self.productList do
    local productInfo = self.productList[i]
    if productInfo.id == id then
      local buyTimes, buyTimeLimit = 0, 0
      if message.buyTimes then
        buyTimes = message.buyTimes
      end
      if message.buyTimeLimit then
        buyTimeLimit = message.buyTimeLimit
      end
      productInfo:UpdateBuyTimes(buyTimes, buyTimeLimit)
      EventManager:GetInstance():Broadcast(EventId.RefreshTitaniumBlueOneProductData, productInfo)
      return
    end
  end
end

function LWTitaniumBlueStoreManager:UpdateBoxRewardData(message)
  local index = 0
  if message.index then
    index = message.index
    table.insert(self.boxReceiveList, index)
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  EventManager:GetInstance():Broadcast(EventId.RefreshTitaniumBlueBoxRewardData, index)
end

function LWTitaniumBlueStoreManager:UpdateDailyRewardData(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  if message.nextRefreshTime then
    self.dayRewardNextRefreshTime = message.nextRefreshTime
  end
  if message.lastReceiveFreeTime then
    self.dayRewardLastReceiveFreeTime = message.lastReceiveFreeTime
  end
  if message.receiveState then
    self.dayRewardReceiveState = message.receiveState
  end
  self:UpdateActivityFreeRewardData()
  EventManager:GetInstance():Broadcast(EventId.RefreshTitaniumBlueDailyRewardData)
end

function LWTitaniumBlueStoreManager:UpdateTotalScoreData(message)
  local addScore = 0
  if message.totalScore then
    self.totalScore = message.totalScore
  end
  if message.addScore then
    addScore = message.addScore
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshTitaniumBlueTotalScoreData, addScore)
end

function LWTitaniumBlueStoreManager:UpdateActivityFreeRewardData()
  self.activityFreeRewardData.activityId = self.activityId
  self.activityFreeRewardData.freeReward = self.dayRewardList
  self.activityFreeRewardData.lastReceiveFreeTime = self.dayRewardLastReceiveFreeTime * 1000
  self.activityFreeRewardData.nextRefreshTime = self.dayRewardNextRefreshTime * 1000
end

function LWTitaniumBlueStoreManager:GetGiftPackId()
  local rewardPackGroupId = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  rewardPackGroupId = tonumber(activityInfo.para_4)
  return rewardPackGroupId
end

function LWTitaniumBlueStoreManager:CanGetFreePack()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime < self.endTime then
    local result = not UITimeManager:GetInstance():IsSameDayForServer(self.dayRewardLastReceiveFreeTime, curTime)
    return result
  end
  return false
end

function LWTitaniumBlueStoreManager:GetRedNum()
  return 0
end

function LWTitaniumBlueStoreManager:GetBoxRewardState(targetIndex)
  for i = 1, #self.boxReceiveList do
    if self.boxReceiveList[i] == targetIndex then
      return TitaniumBlueBoxRewardState.Received
    end
  end
  local curCount = self.totalScore
  for i = 1, #self.boxRewardsList do
    if self.boxRewardsList[i].index == targetIndex then
      if curCount >= self.boxRewardsList[i].targetCount then
        do return TitaniumBlueBoxRewardState.CanReceive end
        break
      end
      do return TitaniumBlueBoxRewardState.NoComplete end
      break
    end
  end
  return TitaniumBlueBoxRewardState.NoComplete
end

function LWTitaniumBlueStoreManager:GetBoxRewardMaxValue()
  local maxValue = 0
  for i = 1, #self.boxRewardsList do
    if maxValue < self.boxRewardsList[i].targetCount then
      maxValue = self.boxRewardsList[i].targetCount
    end
  end
  return maxValue
end

return LWTitaniumBlueStoreManager
