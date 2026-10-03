local GroceryStoreOrderDataManager = BaseClass("GroceryStoreOrderDataManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.groceryStoreOrderDic = {}
  self.selectUuid = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:CheckAllOrderTimeFinish()
  end
  
  self.isRefreshOrder = true
  self.currentSelectDataIndex = -1
  self.maxNumPerDay = 0
  self.currentNum = 0
  self.nextDayTimer = nil
end

local function __delete(self)
  self.groceryStoreOrderDic = nil
  self.timer_action = nil
  self.selectUuid = nil
  self.isRefreshOrder = nil
  self.currentSelectDataIndex = nil
  self.maxNumPerDay = nil
  self.currentNum = nil
  if self.nextDayTimer ~= nil then
    self.nextDayTimer:Stop()
    self.nextDayTimer = nil
  end
  self:DeleteTimer()
end

local function InitGroceryStoreOrderDataList(self, message)
  if message.groceryOrderList ~= nil then
    self.groceryStoreOrderDic = {}
    table.walk(message.groceryOrderList, function(k, v)
      self:UpdateGroceryStoreOrderData(v)
    end)
  end
  if message.end_grocery_order_times ~= nil then
    self.currentNum = message.end_grocery_order_times
  end
  if self.timer == nil then
    self:AddTimer()
  end
end

local function UpdateGroceryStoreOrderData(self, message)
  if message == nil then
    return
  end
  if message.uuid == nil then
    return
  end
  local uuid = message.uuid
  if self.groceryStoreOrderDic[uuid] == nil then
    local info = GroceryStoreOrderInfo.New()
    self.groceryStoreOrderDic[uuid] = info
  end
  self.isRefreshOrder = true
  self.groceryStoreOrderDic[uuid]:ParseData(message)
end

local function GetGroceryStoreOrderByUuid(self, uuid)
  return self.groceryStoreOrderDic[uuid]
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function CheckAllOrderTimeFinish(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.groceryStoreOrderDic) do
    if now >= v.expTime and v.orderId > 0 and (v.state == PurchaseOrderState.FINISH or v.state == PurchaseOrderState.DELETE) and self.isRefreshOrder then
      self:SendGetGroceryStoreOrder()
      self.isRefreshOrder = false
    end
  end
  if self.nextDayTimer == nil then
    local resTime = UITimeManager:GetInstance():GetResSecondsTo24() + 1
    self.nextDayTimer = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.GroceryStoreOrderDataManager:ResetCurrentNumAtOOclock()
      if DataCenter.GroceryStoreOrderDataManager.nextDayTimer ~= nil then
        DataCenter.GroceryStoreOrderDataManager.nextDayTimer:Stop()
        DataCenter.GroceryStoreOrderDataManager.nextDayTimer = nil
      end
    end, resTime)
  end
end

local function SendGroceryStoreOrderFillOne(self, uuid)
  SFSNetwork.SendMessage(MsgDefines.PurchaseOrderFinish, {
    uuid = uuid,
    type = PurchaseOrderType.GROCERY_ORDER
  })
end

local function DeleteOrderFinishHandle(self, message)
  if message.errorCode == nil then
    local uuid = message.uuid
    if message.order ~= nil then
      self:UpdateGroceryStoreOrderData(message.order)
      EventManager:GetInstance():Broadcast(EventId.RefreshGroceryStoreOrder)
    end
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  end
end

local function SendGetGroceryStoreOrder(self)
end

local function DeleteOneOrder(self, uuid)
  SFSNetwork.SendMessage(MsgDefines.PurchaseOrderDelete, {
    uuid = uuid,
    type = PurchaseOrderType.GROCERY_ORDER
  })
end

local function GroceryStoreOrderFillOneHandle(self, message)
  if message.errorCode == nil then
    EventManager:GetInstance():Broadcast(EventId.DelayRefreshResource, EffectFlyResourceTime)
    if message.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(message.accPoint)
    end
    local orderObj = message.order
    if orderObj ~= nil then
      self:UpdateGroceryStoreOrderData(orderObj)
    end
    if message.itemInfos ~= nil then
      DataCenter.ItemData:UpdateItems(message.itemInfos)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    end
    if message.end_grocery_order_times ~= nil then
      self.currentNum = message.end_grocery_order_times
    end
    DataCenter.RewardManager:AddRewardsAndRes(message)
    if message.remainGold ~= nil then
      LuaEntry.Player.gold = message.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    DataCenter.ResourceItemDataManager:RefreshItemList(message)
    EventManager:GetInstance():Broadcast(EventId.RefreshGroceryStoreOrder)
    UIUtil.ShowTipsId(GameDialogDefine.ORDER_HAS_SUBMIT)
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.SubmitGolloesOrder, SaveGuideDoneValue)
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshGroceryStoreOrder)
  end
end

local function GetGroceryStoreOrderHandle(self, message)
  if message.errorCode == nil then
    local haveOrderInfo = false
    if message.groceryOrderList ~= nil then
      haveOrderInfo = true
      table.walk(message.groceryOrderList, function(k, v)
        self:UpdateGroceryStoreOrderData(v)
      end)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshGroceryStoreOrder)
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    EventManager:GetInstance():Broadcast(EventId.RefreshGroceryStoreOrder)
  end
end

local function DoWhenUpdateHandle(self, message)
  if message.errorCode == nil then
    if message.orders ~= nil then
      table.walk(message.orders, function(_, v)
        self:UpdateGroceryStoreOrderData(v)
      end)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshGroceryStoreOrder)
  else
  end
end

local function HasCanSubmitOrder(self)
  if self:IsReachMax() == true then
    return false
  end
  for k, v in pairs(self.groceryStoreOrderDic) do
    if v:CanSend() == true then
      return true
    end
  end
  return false
end

local function GetOrderTypeOrder(self, guideOrderType, orderState, orderType, productId)
  for k, v in pairs(self.groceryStoreOrderDic) do
    if v:HasOrderTypeOrder(guideOrderType, orderState, orderType, productId) then
      return v
    end
  end
end

local function IsReachMax(self)
  if self.maxNumPerDay == 0 then
    self.maxNumPerDay = toInt(LuaEntry.DataConfig:TryGetStr("pve_farm", "k4"))
  end
  return self.currentNum >= self.maxNumPerDay
end

local function ResetCurrentNumAtOOclock(self)
  self.currentNum = 0
end

GroceryStoreOrderDataManager.__init = __init
GroceryStoreOrderDataManager.__delete = __delete
GroceryStoreOrderDataManager.DeleteTimer = DeleteTimer
GroceryStoreOrderDataManager.AddTimer = AddTimer
GroceryStoreOrderDataManager.InitGroceryStoreOrderDataList = InitGroceryStoreOrderDataList
GroceryStoreOrderDataManager.UpdateGroceryStoreOrderData = UpdateGroceryStoreOrderData
GroceryStoreOrderDataManager.GetGroceryStoreOrderByUuid = GetGroceryStoreOrderByUuid
GroceryStoreOrderDataManager.CheckAllOrderTimeFinish = CheckAllOrderTimeFinish
GroceryStoreOrderDataManager.SendGroceryStoreOrderFillOne = SendGroceryStoreOrderFillOne
GroceryStoreOrderDataManager.GroceryStoreOrderFillOneHandle = GroceryStoreOrderFillOneHandle
GroceryStoreOrderDataManager.GetGroceryStoreOrderHandle = GetGroceryStoreOrderHandle
GroceryStoreOrderDataManager.SendGetGroceryStoreOrder = SendGetGroceryStoreOrder
GroceryStoreOrderDataManager.HasCanSubmitOrder = HasCanSubmitOrder
GroceryStoreOrderDataManager.DoWhenUpdateHandle = DoWhenUpdateHandle
GroceryStoreOrderDataManager.DeleteOrderFinishHandle = DeleteOrderFinishHandle
GroceryStoreOrderDataManager.DeleteOneOrder = DeleteOneOrder
GroceryStoreOrderDataManager.GetOrderTypeOrder = GetOrderTypeOrder
GroceryStoreOrderDataManager.IsReachMax = IsReachMax
GroceryStoreOrderDataManager.ResetCurrentNumAtOOclock = ResetCurrentNumAtOOclock
return GroceryStoreOrderDataManager
