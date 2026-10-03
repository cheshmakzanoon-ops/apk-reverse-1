local ResidentOrderDataManager = BaseClass("ResidentOrderDataManager")
local Localization = CS.GameEntry.Localization
local get_order_time_gap = 15000
local get_order_time_gap_new_player = 12000
local use_new_player_time_level = 2
local bubble_must_show_lv = 3

local function __init(self)
  self.residentOrderDic = {}
  self.selectUuid = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:CheckAllOrderTimeFinish()
  end
  
  self:AddListener()
  self.lastGetOrderRewardTime = 0
  self.isRefreshOrder = true
  self.tempExp = 0
  self.oldMoneyCache = {}
  self.maxNumPerDay = 0
  self.currentNum = 0
  self.nextDayTimer = nil
end

local function __delete(self)
  self.residentOrderDic = nil
  self.selectUuid = nil
  self.timer_action = nil
  self.isRefreshOrder = nil
  self.tempExp = nil
  self.lastGetOrderRewardTime = nil
  self.oldMoneyCache = nil
  self.maxNumPerDay = nil
  self.currentNum = nil
  if self.nextDayTimer ~= nil then
    self.nextDayTimer:Stop()
    self.nextDayTimer = nil
  end
  self:DeleteTimer()
  self:RemoveListener()
end

local function GetOrderTimeGap()
  local player = LuaEntry.Player
  if player ~= nil and player.level < use_new_player_time_level then
    return get_order_time_gap_new_player
  end
  return get_order_time_gap
end

local function Startup()
end

local function InitResidentOrderDataList(self, message)
  if message.purchaseOrderList ~= nil then
    self.residentOrderDic = {}
    table.walk(message.purchaseOrderList, function(k, v)
      self:UpdateResidentOrderData(v)
    end)
  end
  if message.end_purchase_order_times ~= nil then
    self.currentNum = message.end_purchase_order_times
  end
  if self.timer == nil then
    self:AddTimer()
  end
end

local function PurchaseOrderRefreshTime(self, message)
end

local function UpdateResidentOrderData(self, message)
  if message == nil then
    return
  end
  if message.uuid == nil then
    return
  end
  if message.orderId ~= nil then
    local uuid = message.uuid
    if self.residentOrderDic[uuid] == nil then
      local residentOrderInfo = ResidentOrderInfo.New()
      self.residentOrderDic[uuid] = residentOrderInfo
      self.residentOrderDic[uuid]:ParseData(message)
    else
      self.residentOrderDic[uuid]:ParseData(message)
    end
    DataCenter.ResidentOrderDataManager.isRefreshOrder = true
  end
end

local function GetRandomBuildUuid(self)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_CONDOMINIUM)
  if list ~= nil then
    local count = table.count(list)
    if 0 < count then
      local randomCount = math.random(1, count)
      return list[randomCount].uuid
    end
  end
  return 0
end

local function RemoveResidentOrderData(self, uuid)
  if self.residentOrderDic[uuid] ~= nil then
    self.residentOrderDic[uuid] = nil
    EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder)
  end
end

local function GetResidentOrderByUuid(self, uuid)
  return self.residentOrderDic[uuid]
end

local function PurchaseOrderFinishHandle(self, message)
  if message.errorCode == nil then
    local uuid = message.uuid
    if message.order ~= nil then
      self:UpdateResidentOrderData(message.order)
    end
    EventManager:GetInstance():Broadcast(EventId.DelayRefreshResource, EffectFlyResourceTime)
    if message.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(message.accPoint)
    end
    if message.remainGold ~= nil then
      LuaEntry.Player.gold = message.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    DataCenter.RewardManager:AddRewardsAndRes(message)
    if message.end_purchase_order_times ~= nil then
      self.currentNum = message.end_purchase_order_times
    end
    DataCenter.ResourceItemDataManager:RefreshItemList(message)
    local param = {}
    param.type = BusinessRereshType.PurchaseOrderFinish
    param.uuid = uuid
    param.exp = self.tempExp
    EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder, param)
    UIUtil.ShowTipsId(GameDialogDefine.ORDER_HAS_SUBMIT)
    self:SetOldMoney(uuid, nil)
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  end
end

local function DeleteOrderFinishHandle(self, message)
  if message.errorCode == nil then
    local uuid = message.uuid
    if message.order ~= nil then
      self:UpdateResidentOrderData(message.order)
    end
    local param = {}
    param.type = BusinessRereshType.DeleteOrderFinish
    param.uuid = uuid
    EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder, param)
    self:SetOldMoney(uuid, nil)
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  end
end

local function ImmediateRefreshHandle(self, message)
  if message.errorCode == nil then
    local uuid = message.uuid
    if message.order ~= nil then
      self:UpdateResidentOrderData(message.order)
    end
    if message.remainGold ~= nil then
      LuaEntry.Player.gold = message.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    local param = {}
    param.type = BusinessRereshType.ImmediateRefresh
    param.uuid = uuid
    EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder, param)
    self:SetOldMoney(uuid, nil)
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
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
  BusinessCenterAnimationController:GetInstance():RefreshState()
  for k, v in pairs(self.residentOrderDic) do
    if now >= v.expTime and v.orderId > 0 and v.state ~= PurchaseOrderState.LOCKED and self.isRefreshOrder then
      self.isRefreshOrder = false
    end
  end
  if self.nextDayTimer == nil then
    local resTime = UITimeManager:GetInstance():GetResSecondsTo24() + 1
    self.nextDayTimer = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.ResidentOrderDataManager:ResetCurrentNumAtOOclock()
      if DataCenter.ResidentOrderDataManager.nextDayTimer ~= nil then
        DataCenter.ResidentOrderDataManager.nextDayTimer:Stop()
        DataCenter.ResidentOrderDataManager.nextDayTimer = nil
      end
    end, resTime)
  end
end

local function GetResidentOrder(self)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if list ~= nil and table.count(list) > 0 and 0 >= table.count(DataCenter.ResidentOrderDataManager.residentOrderDic) then
    EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder)
  end
end

local function PushPurchaseOrderHandle(self, message)
  self:UpdateResidentOrderData(message.orderObj)
  EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder)
  self:SetOldMoney(uuid, nil)
end

local function GetOrderStateByOrderUuid(self, uuid)
  local info = self:GetResidentOrderByUuid(uuid)
  local needDiamond = 0
  if info ~= nil then
    if 0 >= info.orderId or info.state == PurchaseOrderState.LOCKED or info.state == PurchaseOrderState.DELETE or info.state == PurchaseOrderState.FINISH then
      return ResidentOrderState.No
    end
    local template = DataCenter.OrderTemplateManager:GetOrderTemplate(info.orderId)
    if template ~= nil then
      local need = template:GetNeedResourceItem()
      if need ~= nil then
        for k, v in ipairs(need) do
          local result, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(v.needId, v.count)
          if result == false then
            return ResidentOrderState.No
          end
          needDiamond = needDiamond + diamondNum
        end
      end
    end
  end
  if 0 < needDiamond then
    return ResidentOrderState.CanBuy
  end
  return ResidentOrderState.Yes
end

local function GetMoney(self, money, isRandom, random)
  return money
end

local function GetExp(self, exp, isRandom, random)
  return exp
end

local function SendOrderFinish(self, uuid)
  local info = self:GetResidentOrderByUuid(uuid)
  if info then
    local orderTemplate = DataCenter.OrderTemplateManager:GetOrderTemplate(info.orderId)
    self.tempExp = self:GetExp(orderTemplate.exp, info.random ~= nil, info.random)
  end
  if self:GetOrderSendLeftTime() > 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.PurchaseOrderFinish, {uuid = uuid})
  self:SetLastGetOrderRewardTime()
end

local function OnBuildDataUpdate(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if not buildData or buildData.itemId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER or buildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
  end
end

local function IsOrderType(self, orderId, orderType)
  local template = DataCenter.OrderTemplateManager:GetOrderTemplate(orderId)
  if template ~= nil and template.type == orderType then
    return true
  end
  return false
end

local function GetOrderList(self)
  local result = {}
  for k, v in pairs(self.residentOrderDic) do
    local template = DataCenter.OrderTemplateManager:GetOrderTemplate(v.orderId)
    if template ~= nil then
      local param = {}
      param.uuid = v.uuid
      param.id = template.id
      param.prior_show = template.prior_show
      param.startTime = v.expTime - template.time * SecToMilSec
      param.index = v.index
      param.expTime = v.expTime
      table.insert(result, param)
    else
      local param = {}
      param.uuid = v.uuid
      param.id = -1
      param.prior_show = nil
      param.startTime = LongMaxValue
      param.index = v.index
      param.expTime = v.expTime
      table.insert(result, param)
    end
  end
  table.sort(result, function(a, b)
    return a.index < b.index
  end)
  return result
end

local function GetBusinessBubbleState(self)
  if self:IsGuideSpecialBubbleShow() == false then
    return BusinessBubbleState.No
  end
  for k, v in pairs(self.residentOrderDic) do
    local state = self:GetOrderStateByOrderUuid(k)
    if state == ResidentOrderState.Yes then
      return BusinessBubbleState.Yes
    end
  end
  if table.count(self.residentOrderDic) > 0 then
    return BusinessBubbleState.NoSubmit
  end
  return BusinessBubbleState.No
end

local function GetOrderUuidByOrderIds(self, list)
  for k, v in pairs(self.residentOrderDic) do
    for k1, v1 in ipairs(list) do
      if v1 == v.orderId then
        return k
      end
    end
  end
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.CreatedResidentOrder, self.GetResidentOrder)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.OnBuildDataUpdate)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.CreatedResidentOrder, self.GetResidentOrder)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.OnBuildDataUpdate)
end

local function GetOrderSendLeftTime(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local left = math.floor(self.lastGetOrderRewardTime + self:GetOrderTimeGap() - now)
  left = math.min(self:GetOrderTimeGap(), math.max(0, left))
  return left
end

local function SetLastGetOrderRewardTime(self)
  self.lastGetOrderRewardTime = math.ceil(UITimeManager:GetInstance():GetServerTime())
end

local function IsGuideSpecialAnimationShow(self)
  return DataCenter.GuideManager:IsShowBusinessPlane()
end

local function IsGuideSpecialBubbleShow(self)
  return DataCenter.BuildManager.MainLv >= bubble_must_show_lv or DataCenter.GuideManager:IsShowBusinessBubble()
end

local function DoWhenAnimationGuideFinish(self)
  self.lastGetOrderRewardTime = math.ceil(UITimeManager:GetInstance():GetServerTime() - self:GetOrderTimeGap() - 1000)
  BusinessCenterAnimationController:GetInstance():RefreshState()
end

local function DoWhenBubbleGuideFinish(self)
  EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder)
end

local function GetOldMoney(self, uuid)
  return self.oldMoneyCache[uuid]
end

local function SetOldMoney(self, uuid, money)
  self.oldMoneyCache[uuid] = money
end

local function IsReachMax(self)
  if self.maxNumPerDay == 0 then
    self.maxNumPerDay = toInt(LuaEntry.DataConfig:TryGetStr("purchase_order_config", "k6"))
  end
  return self.currentNum >= self.maxNumPerDay
end

local function ResetCurrentNumAtOOclock(self)
  self.currentNum = 0
end

local function CheckRefreshOrder(self)
  if self.residentOrderDic == nil or table.count(self.residentOrderDic) == 0 then
  end
end

ResidentOrderDataManager.__init = __init
ResidentOrderDataManager.__delete = __delete
ResidentOrderDataManager.Startup = Startup
ResidentOrderDataManager.DeleteTimer = DeleteTimer
ResidentOrderDataManager.AddTimer = AddTimer
ResidentOrderDataManager.InitResidentOrderDataList = InitResidentOrderDataList
ResidentOrderDataManager.UpdateResidentOrderData = UpdateResidentOrderData
ResidentOrderDataManager.GetResidentOrderByUuid = GetResidentOrderByUuid
ResidentOrderDataManager.PurchaseOrderFinishHandle = PurchaseOrderFinishHandle
ResidentOrderDataManager.CheckAllOrderTimeFinish = CheckAllOrderTimeFinish
ResidentOrderDataManager.RemoveResidentOrderData = RemoveResidentOrderData
ResidentOrderDataManager.PushPurchaseOrderHandle = PushPurchaseOrderHandle
ResidentOrderDataManager.GetOrderStateByOrderUuid = GetOrderStateByOrderUuid
ResidentOrderDataManager.SendOrderFinish = SendOrderFinish
ResidentOrderDataManager.IsOrderType = IsOrderType
ResidentOrderDataManager.GetOrderList = GetOrderList
ResidentOrderDataManager.GetRandomBuildUuid = GetRandomBuildUuid
ResidentOrderDataManager.GetBusinessBubbleState = GetBusinessBubbleState
ResidentOrderDataManager.GetOrderUuidByOrderIds = GetOrderUuidByOrderIds
ResidentOrderDataManager.PurchaseOrderRefreshTime = PurchaseOrderRefreshTime
ResidentOrderDataManager.DeleteOrderFinishHandle = DeleteOrderFinishHandle
ResidentOrderDataManager.ImmediateRefreshHandle = ImmediateRefreshHandle
ResidentOrderDataManager.AddListener = AddListener
ResidentOrderDataManager.RemoveListener = RemoveListener
ResidentOrderDataManager.GetResidentOrder = GetResidentOrder
ResidentOrderDataManager.GetOrderSendLeftTime = GetOrderSendLeftTime
ResidentOrderDataManager.SetLastGetOrderRewardTime = SetLastGetOrderRewardTime
ResidentOrderDataManager.GetMoney = GetMoney
ResidentOrderDataManager.GetExp = GetExp
ResidentOrderDataManager.IsGuideSpecialAnimationShow = IsGuideSpecialAnimationShow
ResidentOrderDataManager.IsGuideSpecialBubbleShow = IsGuideSpecialBubbleShow
ResidentOrderDataManager.DoWhenAnimationGuideFinish = DoWhenAnimationGuideFinish
ResidentOrderDataManager.DoWhenBubbleGuideFinish = DoWhenBubbleGuideFinish
ResidentOrderDataManager.GetOldMoney = GetOldMoney
ResidentOrderDataManager.SetOldMoney = SetOldMoney
ResidentOrderDataManager.IsReachMax = IsReachMax
ResidentOrderDataManager.ResetCurrentNumAtOOclock = ResetCurrentNumAtOOclock
ResidentOrderDataManager.GetOrderTimeGap = GetOrderTimeGap
ResidentOrderDataManager.CheckRefreshOrder = CheckRefreshOrder
ResidentOrderDataManager.OnBuildDataUpdate = OnBuildDataUpdate
return ResidentOrderDataManager
