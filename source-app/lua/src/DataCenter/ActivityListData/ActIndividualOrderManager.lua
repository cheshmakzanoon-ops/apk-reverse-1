local ActIndividualOrderManager = BaseClass("ActIndividualOrderManager")
local Localization = CS.GameEntry.Localization
local OrderInfoData = {
  orderList,
  stageRewardList,
  finish,
  refreshNum
}
local OrderData = {
  uuid,
  orderId,
  fill,
  state,
  reward,
  money
}
local StageRewardData = {
  reward,
  stage,
  state,
  need
}
local OrderInfo = DataClass("OrderInfo", OrderInfoData)
local Order = DataClass("Order", OrderData)
local StageReward = DataClass("StageReward", StageRewardData)

function ActIndividualOrderManager:__init()
  self.actData = nil
  self.orderInfo = nil
  self.lastSelectedOrderUuid = nil
end

function ActIndividualOrderManager:__delete()
  self.actData = nil
  self.orderInfo = nil
  self.lastSelectedOrderUuid = nil
end

function ActIndividualOrderManager:SetActivityData(actData)
  self.actData = actData
end

function ActIndividualOrderManager:SendMessageGetInfo()
  SFSNetwork.SendMessage(MsgDefines.IndividualOrderGetInfo)
end

function ActIndividualOrderManager:SendMessageFill(resUuid, uuid, num)
  SFSNetwork.SendMessage(MsgDefines.IndividualOrderFill, resUuid, uuid, num)
end

function ActIndividualOrderManager:SendMessageGetReward(stage)
  SFSNetwork.SendMessage(MsgDefines.IndividualOrderGetReward, stage)
end

function ActIndividualOrderManager:SendMessageReset()
  SFSNetwork.SendMessage(MsgDefines.IndividualOrderReset)
end

function ActIndividualOrderManager:HandleMessageGetInfo(message)
  if message.orderList then
    local orderInfo = OrderInfo.New()
    orderInfo.orderList = {}
    for k, v in pairs(message.orderList) do
      orderInfo.orderList[k] = self:ParseOrder(v)
    end
    table.sort(orderInfo.orderList, function(orderA, orderB)
      local orderTemplateA = self:GetOrderTemplate(orderA.orderId)
      local orderTemplateB = self:GetOrderTemplate(orderB.orderId)
      if orderTemplateA.group ~= orderTemplateB.group then
        return orderTemplateA.group < orderTemplateB.group
      else
        return orderA.uuid < orderB.uuid
      end
    end)
    orderInfo.stageRewardList = self:ParseStageRewardList(message.stageInfo)
    orderInfo.finish = message.orderFinishNum or 0
    orderInfo.refreshNum = message.refreshNum or 0
    self.orderInfo = orderInfo
    EventManager:GetInstance():Broadcast(EventId.IndividualOrderGetInfo)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function ActIndividualOrderManager:HandleMessageFill(message)
  if message.order then
    self:UpdateOrder(self:ParseOrder(message.order))
    DataCenter.ResourceItemDataManager:RefreshItemList(message)
    if message.isAllFill then
      self.orderInfo.finish = message.orderFinishNum or 0
      self.orderInfo.allianceFinish = message.allianceFinishNum
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    EventManager:GetInstance():Broadcast(EventId.IndividualOrderFill, message.order.uuid)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
  if message.remainGold ~= nil then
    LuaEntry.Player.gold = message.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

function ActIndividualOrderManager:HandleMessageGetReward(message)
  if message.stageInfo ~= nil then
    self.orderInfo.stageRewardList = self:ParseStageRewardList(message.stageInfo)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    DataCenter.RewardManager:ShowGiftReward(message, Localization:GetString("128027"))
    EventManager:GetInstance():Broadcast(EventId.IndividualOrderGetReward)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
end

function ActIndividualOrderManager:HandleMessageReset(message)
  self:HandleMessageGetInfo(message)
end

function ActIndividualOrderManager:GetOrderTemplate(orderId)
  local orderTemplate = {}
  local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Rocket_Order), orderId)
  if lineData == nil then
    Logger.LogError("ActIndividualOrderManager GetOrderTemplate lineData = nil, orderId: " .. orderId)
  end
  for k, _ in pairs(lineData._indexData) do
    orderTemplate[k] = lineData:getValue(k)
  end
  return orderTemplate
end

function ActIndividualOrderManager:GetOrderTemplateByUuid(uuid)
  if self.orderInfo then
    for _, order in pairs(self.orderInfo.orderList) do
      if order.uuid == uuid then
        return self:GetOrderTemplate(order.orderId)
      end
    end
  end
  return nil
end

function ActIndividualOrderManager:GetOrder(uuid)
  for _, order in pairs(self.orderInfo.orderList) do
    if order.uuid == uuid then
      return order
    end
  end
  return nil
end

function ActIndividualOrderManager:GetOrderIndex(uuid)
  for i, order in pairs(self.orderInfo.orderList) do
    if order.uuid == uuid then
      return i - 1
    end
  end
  return -1
end

function ActIndividualOrderManager:GetStageReward()
  return self.orderInfo.stageRewardList[self:GetStageRewardedCount() + 1]
end

function ActIndividualOrderManager:ParseOrder(data)
  local order = Order.New()
  order.uuid = data.uuid
  order.orderId = data.orderId
  order.fill = data.fillNum
  order.state = data.state
  order.reward = data.reward
  order.money = data.money
  return order
end

function ActIndividualOrderManager:ParseStageRewardList(data)
  local stageRewardList = {}
  for k, v in pairs(data) do
    local stageReward = StageReward.New()
    stageReward.reward = v.reward
    stageReward.stage = v.stage
    stageReward.state = v.state
    stageReward.need = v.needNum
    stageRewardList[k] = stageReward
  end
  return stageRewardList
end

function ActIndividualOrderManager:HasFinished()
  local stageReward = self:GetStageReward()
  return stageReward and self.orderInfo.finish >= stageReward.need
end

function ActIndividualOrderManager:GetStageRewardedCount()
  local count = 0
  for _, stageReward in pairs(self.orderInfo.stageRewardList) do
    if stageReward.state == 1 then
      count = count + 1
    end
  end
  return count
end

function ActIndividualOrderManager:UpdateOrder(updateOrder)
  for k, order in pairs(self.orderInfo.orderList) do
    if order.uuid == updateOrder.uuid then
      self.orderInfo.orderList[k] = updateOrder
      break
    end
  end
end

function ActIndividualOrderManager:GetRedDotCount()
  if not self.orderInfo then
    return 0
  end
  local count = 0
  if self:HasFinished() then
    count = count + 1
  end
  return count
end

function ActIndividualOrderManager:GetLastSelectedOrderUuid()
  return self.lastSelectedOrderUuid
end

function ActIndividualOrderManager:SetLastSelectedOrderUuid(uuid)
  self.lastSelectedOrderUuid = uuid
end

return ActIndividualOrderManager
