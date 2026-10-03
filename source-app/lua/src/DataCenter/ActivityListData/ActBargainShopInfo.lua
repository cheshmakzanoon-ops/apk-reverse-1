local ActBargainShopInfo = BaseClass("ActBargainShopInfo")
local ActBargainShopProductInfo = require("DataCenter.ActivityListData.ActBargainShopProductInfo")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")

function ActBargainShopInfo:__init()
  self.id = nil
  self.startTime = nil
  self.endTime = nil
  self.endViewTime = nil
  self.productList = {}
  self.nextRefreshTime = 0
  self.totalPurchases = 0
  self.activityId = 0
  self.cd_end_time = 0
  self.historyList = {}
  self.activityFreeRewardData = ActivityFreeRewardData.New()
end

function ActBargainShopInfo:__delete()
  self.id = nil
  self.startTime = nil
  self.endTime = nil
  self.endViewTime = nil
  self.productList = nil
  self.nextRefreshTime = nil
  self.totalPurchases = nil
  self.activityId = nil
  self.cd_end_time = nil
  self.historyList = nil
  if self.nextRefreshTimeDelay then
    self.nextRefreshTimeDelay:Stop()
    self.nextRefreshTimeDelay = nil
  end
end

function ActBargainShopInfo:ParseInfo(message)
  if message.startTime then
    self.startTime = message.startTime
  end
  if message.id then
    self.id = message.id
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  if message.endViewTime then
    self.endViewTime = message.endViewTime
  end
  if message.nextRefreshTime then
    self.nextRefreshTime = message.nextRefreshTime
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  if message.extra and message.extra.cd_end_time then
    self.cd_end_time = message.extra.cd_end_time
  end
  if message.historys and message.historys then
    self.historyList = message.historys
  end
  if message.receiveState then
    self.receiveState = message.receiveState
  end
  if message.lastReceiveFreeTime then
    self.lastReceiveFreeTime = message.lastReceiveFreeTime
  end
  if message.nextRefreshTime then
    self.nextRefreshTime = message.nextRefreshTime
  end
  if message.dayReward then
    self.dayReward = message.dayReward
  end
  if message.shopArr then
    local shopProductList = message.shopArr
    local productItem
    self.productList = {}
    self.productDic = {}
    self.totalPurchases = 0
    for i = 1, #shopProductList do
      productItem = ActBargainShopProductInfo:New()
      self.totalPurchases = self.totalPurchases + shopProductList[i].buyNum
      shopProductList[i].activityId = self.activityId
      productItem:ParseInfo(shopProductList[i])
      table.insert(self.productList, productItem)
    end
    table.sort(self.productList, function(a, b)
      local isABack = a:GetIsPersistent() == true and a.expire == 1
      local isBBack = b:GetIsPersistent() == true and b.expire == 1
      if isABack ~= isBBack then
        return not isABack
      end
      return a.template.order < b.template.order
    end)
  end
  self:UpdateActivityFreeRewardData()
end

function ActBargainShopInfo:UpdateDailyRewardData(message)
  if message.lastReceiveFreeTime ~= nil then
    self.lastReceiveFreeTime = message.lastReceiveFreeTime
  end
  self:UpdateActivityFreeRewardData()
end

function ActBargainShopInfo:RefreshShopPropDelay()
  if self.nextRefreshTimeDelay then
    self.nextRefreshTimeDelay:Stop()
    self.nextRefreshTimeDelay = nil
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local time = (self.nextRefreshTime - curTime) / 1000
    self.nextRefreshTimeDelay = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityid))
    end, time)
  end
end

function ActBargainShopInfo:CanGetDailyReward()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local result = not UITimeManager:GetInstance():IsSameDayForServer(self.lastReceiveFreeTime, curTime)
  return result
end

function ActBargainShopInfo:GetProductByUuid(uuid)
  for i = 1, #self.productList do
    if self.productList[i].uuid == uuid then
      return self.productList[i]
    end
  end
end

function ActBargainShopInfo:GetShieldChatKey()
  return "BargainShopShowChat" .. self.activityId
end

function ActBargainShopInfo:UpdateActivityFreeRewardData()
  self.activityFreeRewardData.activityId = self.activityId
  self.activityFreeRewardData.freeReward = DataCenter.RewardManager:ReturnRewardParamForView(self.dayReward)
  self.activityFreeRewardData.lastReceiveFreeTime = self.lastReceiveFreeTime * 1000
  self.rewardPackGroupId = self:GetGiftPackId()
end

function ActBargainShopInfo:GetGiftPackId()
  local rewardPackGroupId = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local dataStr = activityInfo.para_6
  local dataArr = string.string2array_i_oneSep(dataStr, ";")
  if #dataArr == 2 then
    rewardPackGroupId = dataArr[2]
  end
  return rewardPackGroupId
end

function ActBargainShopInfo:RedNum()
  return self:CanGetDailyReward() and 1 or 0
end

function ActBargainShopInfo:GetShieldChatIsOn()
  return CommonUtil.PlayerPrefsGetBool(self:GetShieldChatKey(), false)
end

function ActBargainShopInfo:SetShieldChatIsOn(isOn)
  local localIsOn = self:GetShieldChatIsOn()
  if localIsOn ~= isOn then
    CommonUtil.PlayerPrefsSetBool(self:GetShieldChatKey(), isOn)
    EventManager:GetInstance():Broadcast(EventId.RefreshBargainShopMessageSetting)
  end
end

function ActBargainShopInfo:GetIsBargain(seqid)
  for i = 1, #self.historyList do
    if self.historyList[i] == seqid then
      return true
    end
  end
end

function ActBargainShopInfo:GetBuyCount()
  local count = 0
  for i = 1, #self.productList do
    count = self.productList[i].buyNum + count
  end
  return count
end

function ActBargainShopInfo:UpdateOneProductData(uuid, data)
  for i = 1, #self.productList do
    if self.productList[i].uuid == uuid then
      self.productList[i]:ParseInfo(data)
      EventManager:GetInstance():Broadcast(EventId.RefreshBargainProp, self.productList[i])
      return
    end
  end
end

function ActBargainShopInfo:GetProductReducePrice(uuid)
  for i = 1, #self.productList do
    if self.productList[i].uuid == uuid then
      return self.productList[i]:GetReducePrice()
    end
  end
end

function ActBargainShopInfo:AddOnBargainToHistoryList(seqid)
  if seqid then
    table.insert(self.historyList, seqid)
  end
end

function ActBargainShopInfo:SetCD(cd)
  if cd then
    self.cd_end_time = cd
  end
end

return ActBargainShopInfo
