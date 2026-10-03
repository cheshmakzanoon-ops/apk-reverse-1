local ActAllianceOrderManager = BaseClass("ActAllianceOrderManager")
local Localization = CS.GameEntry.Localization
local OrderInfoData = {
  orderList,
  token,
  tokenAdded,
  tokenRefreshTime,
  tokenMax,
  finish,
  allianceFinish,
  stage,
  stageRewardList
}
local OrderData = {
  uuid,
  allianceId,
  orderId,
  fill,
  ownerUid,
  ownerName,
  cdTime,
  state,
  reward,
  money
}
local StageRewardData = {
  stage,
  needAllianceFinish,
  needFinish,
  rewards
}
local RankInfoData = {
  rankList,
  alAbbr,
  selfRank,
  selfFinish,
  selfMoney
}
local RankData = {
  rank,
  uid,
  name,
  picVer,
  pic,
  money,
  finish
}
local OrderInfo = DataClass("OrderInfo", OrderInfoData)
local Order = DataClass("Order", OrderData)
local StageReward = DataClass("StageReward", StageRewardData)
local RankInfo = DataClass("RankInfo", RankInfoData)
local Rank = DataClass("Rank", RankData)

function ActAllianceOrderManager:__init()
  self.TOKEN_ADD_MAX = LuaEntry.DataConfig:TryGetNum("activity_alliance_order", "k1") or 0
  self.actData = nil
  self.orderInfo = nil
  self.rankInfo = nil
  self.redDotData = {
    checkedOrder = false,
    checkedStageReward = false,
    canGetStageReward = false
  }
end

function ActAllianceOrderManager:__delete()
  self.TOKEN_ADD_MAX = nil
  self.actData = nil
  self.orderInfo = nil
  self.rankInfo = nil
  self.redDotData = nil
end

function ActAllianceOrderManager:SetActivityData(actData)
  self.actData = actData
end

function ActAllianceOrderManager:SendMessageGetInfo()
  SFSNetwork.SendMessage(MsgDefines.AllianceOrderGetInfo)
end

function ActAllianceOrderManager:SendMessageGetRank()
  SFSNetwork.SendMessage(MsgDefines.AllianceOrderGetRank)
end

function ActAllianceOrderManager:SendMessageReceive(orderUuid)
  SFSNetwork.SendMessage(MsgDefines.AllianceOrderReceive, orderUuid)
end

function ActAllianceOrderManager:SendMessageGiveUp(orderUuid)
  SFSNetwork.SendMessage(MsgDefines.AllianceOrderGiveUp, orderUuid)
end

function ActAllianceOrderManager:SendMessageFill(resUuid, uuid, num)
  SFSNetwork.SendMessage(MsgDefines.AllianceOrderFill, resUuid, uuid, num)
end

function ActAllianceOrderManager:SendMessageGetReward(stage)
  SFSNetwork.SendMessage(MsgDefines.AllianceOrderGetReward, stage)
end

function ActAllianceOrderManager:SendMessageReceiveAndFill(uuid)
  SFSNetwork.SendMessage(MsgDefines.AllianceOrderReceiveAndFill, uuid)
end

function ActAllianceOrderManager:SendMessageAddToken(itemId, num)
  SFSNetwork.SendMessage(MsgDefines.AllianceOrderAddToken, itemId, num)
end

function ActAllianceOrderManager:HandleMessageGetInfo(message)
  if message.orderList then
    local orderInfo = OrderInfo.New()
    orderInfo.orderList = {}
    for k, v in pairs(message.orderList) do
      orderInfo.orderList[k] = self:ParseOrder(v)
    end
    orderInfo.token = message.getOrderNum
    orderInfo.tokenAdded = message.tokenAdd or 0
    orderInfo.tokenRefreshTime = message.orderNumRefreshTime
    orderInfo.tokenMax = message.tokenMax or 3
    orderInfo.finish = message.finishOrderNum
    orderInfo.allianceFinish = message.allianceFinishNum
    orderInfo.stage = #message.stageRewardedList + 1
    orderInfo.stageRewardList = self:ParseStageRewardList(message.stageRewardList)
    self.orderInfo = orderInfo
    EventManager:GetInstance():Broadcast(EventId.AllianceOrderGetInfo)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function ActAllianceOrderManager:HandleMessageGetRank(message)
  local rankInfo = RankInfo.New()
  rankInfo.rankList = {}
  for k, v in pairs(message.rankList) do
    rankInfo.rankList[k] = self:ParseRank(v)
  end
  rankInfo.alAbbr = message.alAbbr
  rankInfo.selfRank = message.selfRank
  rankInfo.selfFinish = message.selfFinishNum
  rankInfo.selfMoney = message.selfMoney
  self.rankInfo = rankInfo
  EventManager:GetInstance():Broadcast(EventId.AllianceOrderGetRank)
end

function ActAllianceOrderManager:HandleMessageReceive(message)
  self:UpdateOrder(self:ParseOrder(message.order))
  self.orderInfo.token = message.getOrderNum
  self.orderInfo.tokenRefreshTime = message.orderNumRefreshTime
  EventManager:GetInstance():Broadcast(EventId.AllianceOrderReceive, message.order.uuid)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActAllianceOrderManager:HandleMessageGiveUp(message)
  self:UpdateOrder(self:ParseOrder(message.order))
  EventManager:GetInstance():Broadcast(EventId.AllianceOrderGiveUp, message.order.uuid)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActAllianceOrderManager:HandleMessageFill(message)
  if message.order then
    self:UpdateOrder(self:ParseOrder(message.order))
    DataCenter.ResourceItemDataManager:RefreshItemList(message)
    if message.isAllFill then
      self.orderInfo.finish = message.finishOrderNum
      self.orderInfo.allianceFinish = message.allianceFinishNum
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    self.redDotData.checkedOrder = false
    EventManager:GetInstance():Broadcast(EventId.AllianceOrderFill, message.order.uuid)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
  if message.remainGold ~= nil then
    LuaEntry.Player.gold = message.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

function ActAllianceOrderManager:HandleMessageGetReward(message)
  if message.stageRewardedList ~= nil then
    self.orderInfo.stage = #message.stageRewardedList + 1
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    DataCenter.RewardManager:ShowGiftReward(message, Localization:GetString("128027"))
    EventManager:GetInstance():Broadcast(EventId.AllianceOrderGetReward)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
end

function ActAllianceOrderManager:HandleMessageReceiveAndFill(message)
  self:UpdateOrder(self:ParseOrder(message.order))
  self.orderInfo.token = message.getOrderNum
  self.orderInfo.tokenRefreshTime = message.orderNumRefreshTime
  self.orderInfo.finish = message.finishOrderNum
  self.orderInfo.allianceFinish = message.allianceFinishNum
  DataCenter.ResourceItemDataManager:RefreshItemList(message)
  LuaEntry.Resource:UpdateResource(message.resource)
  EventManager:GetInstance():Broadcast(EventId.AllianceOrderFill, message.order.uuid)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActAllianceOrderManager:HandleMessageUpdateStage(message)
  if not message.stage or self.orderInfo.stage < message.stage then
    self.redDotData.canGetStageReward = true
    EventManager:GetInstance():Broadcast(EventId.AllianceOrderUpdateStage)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function ActAllianceOrderManager:HandleMessageAddToken(message)
  self.orderInfo.tokenAdded = message.tokenAdd
  self.orderInfo.token = message.getOrderNum
  self.orderInfo.tokenRefreshTime = message.orderNumRefreshTime
  EventManager:GetInstance():Broadcast(EventId.AllianceOrderAddToken)
  UIUtil.ShowTipsId(120089)
end

function ActAllianceOrderManager:GetOrderTemplate(orderId)
  local orderTemplate = {}
  local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Rocket_Order), orderId)
  if lineData == nil then
    Logger.LogError("ActAllianceOrderManager GetOrderTemplate lineData = nil, orderId: " .. orderId)
  end
  for k, _ in pairs(lineData._indexData) do
    orderTemplate[k] = lineData:getValue(k)
  end
  return orderTemplate
end

function ActAllianceOrderManager:GetOrderTemplateByUuid(uuid)
  if self.orderInfo then
    for _, order in pairs(self.orderInfo.orderList) do
      if order.uuid == uuid then
        return self:GetOrderTemplate(order.orderId)
      end
    end
  end
  return nil
end

function ActAllianceOrderManager:GetOrder(uuid)
  for _, order in pairs(self.orderInfo.orderList) do
    if order.uuid == uuid then
      return order
    end
  end
  return nil
end

function ActAllianceOrderManager:GetMyOrder()
  if self.orderInfo then
    for _, order in pairs(self.orderInfo.orderList) do
      if order.ownerUid == LuaEntry.Player.uid and order.state == 1 then
        return order
      end
    end
  end
  return nil
end

function ActAllianceOrderManager:GetMyOrderTemplate()
  if self.orderInfo then
    for _, order in pairs(self.orderInfo.orderList) do
      if order.ownerUid == LuaEntry.Player.uid and order.state == 1 then
        return self:GetOrderTemplate(order.orderId)
      end
    end
  end
  return nil
end

function ActAllianceOrderManager:GetOrderIndex(uuid)
  for i, order in pairs(self.orderInfo.orderList) do
    if order.uuid == uuid then
      return i - 1
    end
  end
  return -1
end

function ActAllianceOrderManager:GetStageReward()
  return self.orderInfo.stageRewardList[self.orderInfo.stage]
end

function ActAllianceOrderManager:ParseOrder(data)
  local order = Order.New()
  order.uuid = data.uuid
  order.allianceId = data.allianceId
  order.orderId = data.orderId
  order.fill = data.fillNum
  order.ownerUid = data.ownerUid
  order.ownerName = data.ownerName
  order.cdTime = data.cdTime
  order.state = data.state
  order.reward = data.reward
  order.money = data.money
  return order
end

function ActAllianceOrderManager:ParseStageRewardList(data)
  local stageRewardList = {}
  for k, v in pairs(data) do
    local stageReward = StageReward.New()
    stageReward.stage = v.stage
    stageReward.needAllianceFinish = v.allianceFinish
    stageReward.needFinish = v.finish
    stageReward.rewards = v.reward
    stageRewardList[k] = stageReward
  end
  return stageRewardList
end

function ActAllianceOrderManager:ParseRank(data)
  local rank = Rank.New()
  rank.rank = data.rank
  rank.uid = data.uid
  rank.name = data.name
  rank.picVer = data.picVer
  rank.pic = data.pic
  rank.money = data.money
  rank.finish = data.finishNum
  rank.icon = data.icon
  rank.monthCardEndTime = data.monthCardEndTime
  
  function rank:GetHeadBgImg()
    local headBgImg
    local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
    if self.monthCardEndTime and serverTimeS < self.monthCardEndTime then
      headBgImg = "Common_playerbg_golloes"
    end
    if headBgImg and headBgImg ~= "" then
      return string.format(LoadPath.CommonNewPath, headBgImg)
    end
  end
  
  return rank
end

function ActAllianceOrderManager:HasFinishedAlliance()
  local stageReward = self:GetStageReward()
  return stageReward and self.orderInfo.allianceFinish >= stageReward.needAllianceFinish
end

function ActAllianceOrderManager:HasFinishedSelf()
  local stageReward = self:GetStageReward()
  return self.orderInfo.finish >= stageReward.needFinish
end

function ActAllianceOrderManager:UpdateOrder(updateOrder)
  for k, order in pairs(self.orderInfo.orderList) do
    if order.uuid == updateOrder.uuid then
      self.orderInfo.orderList[k] = updateOrder
      break
    end
  end
end

function ActAllianceOrderManager:GetRedDotCount()
  if not self.orderInfo then
    return 0
  end
  local count = 0
  local orderTemplate = self:GetMyOrderTemplate()
  if orderTemplate and not self.redDotData.checkedOrder then
    local resData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(orderTemplate.product_id)
    local haveCount = resData and resData.number or 0
    if 0 < haveCount then
      count = count + 1
    end
  end
  if not self.redDotData.checkedStageReward and (self.redDotData.canGetStageReward or self:HasFinishedAlliance()) then
    count = count + 1
  end
  return count
end

return ActAllianceOrderManager
