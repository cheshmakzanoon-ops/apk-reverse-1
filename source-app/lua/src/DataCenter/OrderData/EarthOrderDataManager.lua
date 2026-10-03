local EarthOrderDataManager = BaseClass("EarthOrderDataManager")
local Localization = CS.GameEntry.Localization
local auto_request_gap_time = 10000.0

local function __init(self)
  self.earthOrderDic = {}
  self.nextEarthOrderTime = LongMaxValue
  self.timer = nil
  
  function self.timer_action(temp)
    self:CheckAllOrderTimeFinish()
  end
  
  self.recall = false
  self.expTime = nil
  self.isRefreshbublle = true
  self.removeEarthOrder = false
  self.refreshTime = LongMaxValue
  self.lastAutoRecallTime = 0
  self.earthOrderNum = 0
  self.isInit = false
  self:AddTimer()
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.earthOrderDic = nil
  self.nextEarthOrderTime = nil
  self.timer_action = nil
  self.recall = nil
  self.expTime = nil
  self.isRefreshbublle = nil
  self.removeEarthOrder = nil
  self.lastAutoRecallTime = nil
  self.isInit = nil
  self.earthOrderNum = nil
  self:DeleteTimer()
end

local function Startup()
end

local function InitEarthOrderDataList(self, message)
  if message.earthOrderList ~= nil then
    self.earthOrderDic = {}
    table.walk(message.earthOrderList, function(k, v)
      self:UpdateEarthOrderData(v)
    end)
    self.isInit = true
  end
  if message.nextEarthOrderTime ~= nil then
    self.nextEarthOrderTime = message.nextEarthOrderTime
  end
  if message.earthOrderNum then
    self.earthOrderNum = message.earthOrderNum
  end
end

local function UpdateEarthOrderData(self, message)
  if message == nil then
    return
  end
  if message.uuid == nil then
    return
  end
  local uuid = message.uuid
  if self.earthOrderDic[uuid] == nil then
    local earthOrderInfo = EarthOrderInfo.New()
    self.earthOrderDic[uuid] = earthOrderInfo
    self.earthOrderDic[uuid]:ParseData(message)
  else
    self.earthOrderDic[uuid]:ParseData(message)
  end
end

local function RemoveEarthOrderData(self, uuid)
  if self.earthOrderDic[uuid] ~= nil then
    self.earthOrderDic[uuid] = nil
    self.isRefreshbublle = true
  end
end

local function GetEarthOrderByUuid(self, uuid)
  return self.earthOrderDic[uuid]
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
  if self.isInit ~= true then
    return
  end
  if not CS.SceneManager:IsInWorld() and not CS.SceneManager:IsInCity() then
    return
  end
  if CS.SceneManager.World == nil or CS.SceneManager:IsSceneBuildFninsh() == false then
    return
  end
  local num = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(BuildingTypes.FUN_BUILD_TRADING_CENTER)
  if num <= 0 then
    return
  end
  local now = math.floor(UITimeManager:GetInstance():GetServerTime())
  local exist = false
  for k, v in pairs(self.earthOrderDic) do
    self.expTime = v.expTime
    if now >= v.expTime and self.isRefreshbublle then
      EventManager:GetInstance():Broadcast(EventId.RefreshEarthOrder)
      self.isRefreshbublle = false
    else
    end
    exist = true
  end
  if (not exist or self:IsPreviewStatus()) and now >= self.nextEarthOrderTime then
    if self.recall == false then
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_TRADING_CENTER)
      if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and BuildingUtils.IsRocketPlayingArrive(buildData.pointId) == false then
        self.recall = true
        EventManager:GetInstance():Broadcast(EventId.RefreshEarthOrder)
      end
    end
    if now > self.lastAutoRecallTime + auto_request_gap_time then
      SFSNetwork.SendMessage(MsgDefines.GetEarthOrder, {type = 0})
      self.lastAutoRecallTime = now
    end
  end
  if self.nextEarthOrderTime == LongMaxValue then
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_TRADING_CENTER)
    if list ~= nil and 0 < table.count(list) and self.recall == false then
      self.recall = true
      EventManager:GetInstance():Broadcast(EventId.RefreshEarthOrder)
    end
  end
end

local function checkIsRecall(self)
  return self.recall
end

local function GetOrderExpTime(self)
  return self.expTime
end

local function PushEarthOrderHandle(self, message)
  if message.orderObj ~= nil then
    self:UpdateEarthOrderData(message.orderObj)
    EventManager:GetInstance():Broadcast(EventId.GetNewEarthOrder)
  end
  if message.nextEarthOrderTime ~= nil then
    self.nextEarthOrderTime = message.nextEarthOrderTime
  end
  if message.earthOrderNum then
    self.earthOrderNum = message.earthOrderNum
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshEarthOrder)
end

local function PushEarthOrderRefreshTimeHandle(self, message)
  if message.nextEarthOrderTime ~= nil then
    self.nextEarthOrderTime = message.nextEarthOrderTime
  end
  if message.earthOrderNum then
    self.earthOrderNum = message.earthOrderNum
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshEarthOrder)
end

local function GetOrderStateByOrderUuid(self, uuid)
  local info = self:GetEarthOrderByUuid(uuid)
  local needDiamond = 0
  if info ~= nil then
    for k, v in pairs(info.orderItemArr) do
      local rocketOrderItem = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Rocket_Order), tostring(v.orderId))
      local result, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(rocketOrderItem.productId, rocketOrderItem.productNum)
      if result == false then
        return ResidentOrderState.No
      end
      needDiamond = needDiamond + diamondNum
    end
  end
  if 0 < needDiamond then
    return ResidentOrderState.CanBuy
  end
  return ResidentOrderState.Yes
end

local function GetOrderIndexStateByOrderUuid(self, uuid, index)
  local info = self:GetEarthOrderByUuid(uuid)
  if info ~= nil then
    for k, v in pairs(info.orderItemArr) do
      if v.index == index then
        local rocketOrderItem = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Rocket_Order), tostring(v.orderId))
        local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(rocketOrderItem.productId)
        if data == nil or data.number < rocketOrderItem.productNum then
          return ResidentOrderState.No
        end
      end
    end
  end
  return ResidentOrderState.Yes
end

local function GetOrderExtraMoneyByOrderUuid(self, uuid)
  local money = 0
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
  if buildLevelTemplate ~= nil then
    money = Mathf.Floor(buildLevelTemplate.para1)
  end
  return money
end

local function GetOrderExtraItemIconAndNumByOrderUuid(self)
  if self:NeedShowAddReward() then
    local data = self:GetOneEarthOrder()
    if data == nil then
      return nil
    end
    local rewards = DataCenter.RewardManager:ReturnRewardParamForView(data.addReward)
    if rewards == nil or table.count(rewards) == 0 then
      return nil
    end
    local reward = rewards[1]
    local num = reward.count or 0
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId or 0)
    if goods ~= nil then
      return string.format(LoadPath.ItemPath, goods.icon), num
    end
  end
  return nil
end

local function SendEarthOrderFillOne(self, uuid, resourceItemUuid, index)
  if self:IsPreviewStatus() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EarthOrderFillOne, {
    uuid = uuid,
    resourceItemUuid = resourceItemUuid,
    index = index
  })
end

local function SendGetEarthOrder(self)
  self.nextEarthOrderTime = LongMaxValue
  SFSNetwork.SendMessage(MsgDefines.GetEarthOrder, {type = 0})
end

local function SendEarthOrderEnd(self, uuid)
  if self:IsPreviewStatus() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EarthOrderEnd, {uuid = uuid})
end

local function EarthOrderEndHandle(self, message)
  if message.uuid ~= nil then
    self:RemoveEarthOrderData(message.uuid)
    if message.nextEarthOrderTime ~= nil then
      self.nextEarthOrderTime = message.nextEarthOrderTime
    end
    if message.earthOrderNum ~= nil then
      self.earthOrderNum = message.earthOrderNum
    end
    if message.addReward ~= nil then
      DataCenter.RewardManager:AddRewards(message.addReward)
    end
    if message.orderObj ~= nil then
      self:UpdateEarthOrderData(message.orderObj)
    end
    EventManager:GetInstance():Broadcast(EventId.EndEarthOrder)
  end
end

local function EarthOrderFillOneHandle(self, message)
  if message.errorCode == nil then
    EventManager:GetInstance():Broadcast(EventId.DelayRefreshResource, EffectFlyResourceTime)
    if message.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(message.accPoint)
    end
    DataCenter.RewardManager:AddRewardsAndRes(message)
    local orderObj = message.orderObj
    local allFinished = message.allFinished
    if allFinished == OrderAllFinished.Yes then
      if orderObj ~= nil and orderObj.uuid then
        self:RemoveEarthOrderData(orderObj.uuid)
      end
    elseif orderObj ~= nil then
      self:UpdateEarthOrderData(orderObj)
    end
    if message.remainGold ~= nil then
      LuaEntry.Player.gold = message.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    DataCenter.ResourceItemDataManager:RefreshItemList(message)
    EventManager:GetInstance():Broadcast(EventId.RefreshEarthOrder)
    UIUtil.ShowTipsId(GameDialogDefine.ORDER_HAS_SUBMIT)
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    EventManager:GetInstance():Broadcast(EventId.RefreshEarthOrder)
  end
end

local function GetEarthOrderHandle(self, message)
  if message.errorCode == nil then
    self.recall = false
    local haveOrderInfo = false
    if message.orderObj ~= nil then
      haveOrderInfo = true
      self:UpdateEarthOrderData(message.orderObj)
      EventManager:GetInstance():Broadcast(EventId.GetNewEarthOrder)
    end
    if message.nextEarthOrderTime ~= nil then
      self.nextEarthOrderTime = message.nextEarthOrderTime
    end
    if message.earthOrderNum then
      self.earthOrderNum = message.earthOrderNum
    end
    if not haveOrderInfo then
      local now = UITimeManager:GetInstance():GetServerTime()
      if now > self.nextEarthOrderTime then
        self.nextEarthOrderTime = LongMaxValue
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshEarthOrder)
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshEarthOrder)
  end
end

local function GetOneEarthOrder(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.earthOrderDic ~= nil then
    for k, v in pairs(self.earthOrderDic) do
      return v
    end
  end
end

local function CheckShowTipAfterInit(self)
  local info = self:GetOneEarthOrder()
  if info ~= nil then
    local currentTime = UITimeManager:GetInstance():GetTimeToMD(UITimeManager:GetInstance():GetServerSeconds())
    local popTime = Setting:GetString("UIEarthOrderTipTime", "")
    if popTime ~= currentTime then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIEarthOrderTip)
      Setting:SetString("UIEarthOrderTipTime", currentTime)
    end
  end
end

local function IsShowEarthOrder()
  return DataCenter.EarthOrderDataManager:GetOneEarthOrder() ~= nil and not DataCenter.EarthOrderDataManager:IsPreviewStatus()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function HasCanSubmitOrder(self)
  local info = self:GetOneEarthOrder()
  if info == nil or self:IsPreviewStatus() then
    return false
  end
  if info.expTime < UITimeManager:GetInstance():GetServerTime() then
    return false
  end
  local needResource = info:GetNeedItem()
  local count = table.count(needResource)
  for i = 1, count do
    local needId = needResource[i].needId
    if not info:IsSubmit(needId, i) then
      local resourceId = needResource[i].needId
      local resourceNum = needResource[i].count
      local own = 0
      local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(resourceId)
      if data ~= nil then
        own = data.number
      end
      if resourceNum <= own then
        return true
      end
    end
  end
  return false
end

local function GetUnfinishedOrderCount(self)
  local info = self:GetOneEarthOrder()
  if info == nil then
    return 0, 0
  end
  local vipEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_VIP)
  if info.expTime < UITimeManager:GetInstance():GetServerTime() and vipEffect <= 0 then
    return 0, 0
  end
  local unfinishedCount = 0
  local canSubmitCount = 0
  local needResource = info:GetNeedItem()
  local count = table.count(needResource)
  for i = 1, count do
    local needId = needResource[i].needId
    if not info:IsSubmit(needId, i) then
      unfinishedCount = unfinishedCount + 1
      local resourceId = needResource[i].needId
      local resourceNum = needResource[i].count
      local own = 0
      local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(resourceId)
      if data ~= nil then
        own = data.number
      end
      if resourceNum <= own then
        canSubmitCount = canSubmitCount + 1
      end
    end
  end
  return unfinishedCount, canSubmitCount
end

local function GetNextEarthOrderTime(self)
  return self.nextEarthOrderTime
end

local function GetLeftFireTime(self)
  local numPerDay = 2 + LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_ROCKET_NUM)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.nextEarthOrderTime and not UITimeManager:GetInstance():IsSameDayForServer(curTime, self.nextEarthOrderTime) then
    return 1
  end
  return numPerDay - self.earthOrderNum
end

local function NeedShowAddReward(self)
  local data = self:GetOneEarthOrder()
  if data == nil then
    return false
  end
  if data.addReward == nil or table.count(data.addReward) == 0 then
    return false
  end
  local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_ROCKET_NUM)
  local leftNum = self:GetLeftFireTime()
  return effectNum < leftNum
end

local function IsPreviewStatus(self)
  local info = self:GetOneEarthOrder()
  return info ~= nil and info.status == RocketStatus.RocketStatus_Preview
end

EarthOrderDataManager.IsPreviewStatus = IsPreviewStatus
EarthOrderDataManager.__init = __init
EarthOrderDataManager.__delete = __delete
EarthOrderDataManager.Startup = Startup
EarthOrderDataManager.DeleteTimer = DeleteTimer
EarthOrderDataManager.AddTimer = AddTimer
EarthOrderDataManager.InitEarthOrderDataList = InitEarthOrderDataList
EarthOrderDataManager.UpdateEarthOrderData = UpdateEarthOrderData
EarthOrderDataManager.GetEarthOrderByUuid = GetEarthOrderByUuid
EarthOrderDataManager.CheckAllOrderTimeFinish = CheckAllOrderTimeFinish
EarthOrderDataManager.RemoveEarthOrderData = RemoveEarthOrderData
EarthOrderDataManager.PushEarthOrderHandle = PushEarthOrderHandle
EarthOrderDataManager.GetOrderStateByOrderUuid = GetOrderStateByOrderUuid
EarthOrderDataManager.SendEarthOrderFillOne = SendEarthOrderFillOne
EarthOrderDataManager.GetOrderIndexStateByOrderUuid = GetOrderIndexStateByOrderUuid
EarthOrderDataManager.EarthOrderEndHandle = EarthOrderEndHandle
EarthOrderDataManager.EarthOrderFillOneHandle = EarthOrderFillOneHandle
EarthOrderDataManager.GetEarthOrderHandle = GetEarthOrderHandle
EarthOrderDataManager.SendGetEarthOrder = SendGetEarthOrder
EarthOrderDataManager.SendEarthOrderEnd = SendEarthOrderEnd
EarthOrderDataManager.GetOneEarthOrder = GetOneEarthOrder
EarthOrderDataManager.CheckShowTipAfterInit = CheckShowTipAfterInit
EarthOrderDataManager.IsShowEarthOrder = IsShowEarthOrder
EarthOrderDataManager.AddListener = AddListener
EarthOrderDataManager.RemoveListener = RemoveListener
EarthOrderDataManager.checkIsRecall = checkIsRecall
EarthOrderDataManager.GetOrderExpTime = GetOrderExpTime
EarthOrderDataManager.GetOrderExtraMoneyByOrderUuid = GetOrderExtraMoneyByOrderUuid
EarthOrderDataManager.HasCanSubmitOrder = HasCanSubmitOrder
EarthOrderDataManager.GetNextEarthOrderTime = GetNextEarthOrderTime
EarthOrderDataManager.GetOrderExtraItemIconAndNumByOrderUuid = GetOrderExtraItemIconAndNumByOrderUuid
EarthOrderDataManager.PushEarthOrderRefreshTimeHandle = PushEarthOrderRefreshTimeHandle
EarthOrderDataManager.GetLeftFireTime = GetLeftFireTime
EarthOrderDataManager.NeedShowAddReward = NeedShowAddReward
EarthOrderDataManager.GetUnfinishedOrderCount = GetUnfinishedOrderCount
return EarthOrderDataManager
