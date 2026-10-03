local EnergyOrderManager = BaseClass("EnergyOrderManager")
local ORDER_MAX_COUNT = 1
local REFRESH_CD = 1
local OrderState = {
  Disabled = 1,
  Ready = 2,
  Deleted = 3,
  Finished = 4,
  Expired = 5,
  Missing = 6,
  Unknown = 7
}

local function __init(self)
  self.dataList = {}
  self.timer = nil
  self.refreshTimer = nil
  self.refreshCd = 0
  self:AddListener()
end

local function __delete(self)
  self.dataList = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  self.refreshCd = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.GuideSaveId, self.OnGuideSaveId)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.OnBuildDataUpdate)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.GuideSaveId, self.OnGuideSaveId)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.OnBuildDataUpdate)
end

local function Startup(self)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  self.timer:Start()
end

local function TimerAction(self)
  if self.refreshCd > 0 then
    self.refreshCd = self.refreshCd - 1
  end
end

local function Enabled(self)
  local mainLv = LuaEntry.DataConfig:TryGetNum("pve_energy_exchange", "k2")
  if 0 <= mainLv and mainLv <= DataCenter.BuildManager.MainLv then
    return true
  end
  local guideId = LuaEntry.DataConfig:TryGetNum("pve_energy_exchange", "k1")
  if 0 <= guideId and DataCenter.GuideManager:IsDoneThisGuide(guideId) then
    return true
  end
  return false
end

local function CheckRefresh(self)
  if not self:Enabled() then
    return
  end
  if self.refreshCd > 0 then
    return
  end
  self.refreshCd = REFRESH_CD
  local needRefresh = false
  local orderCount = self:GetOrderCount()
  if 0 < orderCount then
    for index = 1, orderCount do
      local state = self:GetOrderState(index)
      if state == OrderState.Expired or state == OrderState.Missing then
        self:ClearData(index)
        needRefresh = true
      end
    end
  end
  if needRefresh then
    self:SendRefresh()
  end
end

local function GetOrderCount(self)
  return ORDER_MAX_COUNT
end

local function GetIndexByBuildUuid(self, bUuid)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_FARM)
  local uuids = {}
  for _, buildData in ipairs(list) do
    table.insert(uuids, buildData.uuid)
  end
  table.sort(uuids)
  for i, uuid in ipairs(uuids) do
    if uuid == bUuid then
      return i
    end
  end
  return 0
end

local function GetBuildUuidByIndex(self, index)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_FARM)
  local uuids = {}
  for _, buildData in ipairs(list) do
    table.insert(uuids, buildData.uuid)
  end
  table.sort(uuids)
  for i, uuid in ipairs(uuids) do
    if index == self:GetOrderCount() then
      return uuid
    end
  end
  return 0
end

local function GetLine(self, orderId)
  return LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Order), tostring(orderId))
end

local function InitData(self, message)
  if message.pveStaminaOrderList then
    for _, data in ipairs(message.pveStaminaOrderList) do
      self:UpdateData(data)
    end
  end
  self:CheckRefresh()
  self:ResetTimer()
end

local function UpdateData(self, newData)
  self.dataList[newData.index + 1] = newData
end

local function ClearData(self, index)
  self.dataList[index] = nil
end

local function GetOrderData(self, index)
  return self.dataList[index]
end

local function GetOrderState(self, index)
  if not self:Enabled() then
    return OrderState.Disabled
  end
  local data = self:GetOrderData(index)
  if data == nil or data.orderId < 0 then
    return OrderState.Missing
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > data.refreshTime then
    return OrderState.Expired
  end
  if data.state == PurchaseOrderState.NORMAL then
    return OrderState.Ready
  elseif data.state == PurchaseOrderState.DELETE then
    return OrderState.Deleted
  elseif data.state == PurchaseOrderState.FINISH then
    return OrderState.Finished
  else
    return OrderState.Unknown
  end
end

local function GetOrderRestTime(self, index)
  if index > self:GetOrderCount() then
    return 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local data = self:GetOrderData(index)
  if data ~= nil then
    return data.refreshTime - curTime
  end
  return 0
end

local function GetShowBubbleByBuildUuid(self, bUuid)
  local index = self:GetIndexByBuildUuid(bUuid)
  if index > self:GetOrderCount() then
    return 0
  end
  local state = self:GetOrderState(index)
  if state ~= OrderState.Ready then
    return 0
  else
    local data = self:GetOrderData(index)
    local needList = self:GetOrderNeedList(data.orderId)
    for _, need in ipairs(needList) do
      local haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(need.itemId)
      if haveCount < need.count then
        return 1
      end
    end
    return 2
  end
end

local function GetOrderNeedList(self, orderId)
  local line = self:GetLine(orderId)
  if line == nil then
    Logger.LogError("EnergyOrderManager order line = nil, orderId: " .. data.orderId)
    return {}
  end
  local needList = {}
  local needStr = line:getValue("resource_goods")
  for _, str in ipairs(string.split(needStr, "|")) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      local need = {}
      need.itemId = tonumber(spls[1])
      need.count = tonumber(spls[2])
      table.insert(needList, need)
    end
  end
  return needList
end

local function ResetTimer(self)
  local minTime = IntMaxValue
  for i = 1, self:GetOrderCount() do
    local t = self:GetOrderRestTime(i)
    if 0 < t and minTime > t then
      minTime = t
    end
  end
  if self.refreshTimer then
    self.refreshTimer:Stop()
  end
  self.refreshTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:CheckRefresh()
  end, minTime / 1000)
end

local function OnGuideSaveId()
  if CS.SceneManager.IsInPVE() then
    return
  end
  DataCenter.EnergyOrderManager:CheckRefresh()
end

local function OnBuildDataUpdate(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData and (buildData.itemId == BuildingTypes.APS_BUILD_FARM or buildData.itemId == BuildingTypes.FUN_BUILD_MAIN) then
    DataCenter.EnergyOrderManager:CheckRefresh()
  end
end

local function SendRefresh(self)
end

local function SendDelete(self, uuid)
end

local function SendFinish(self, uuid)
end

local function HandleRefresh(self, message)
  if message.pveStaminaOrderList then
    for _, data in ipairs(message.pveStaminaOrderList) do
      self:UpdateData(data)
    end
  end
  self:ResetTimer()
  EventManager:GetInstance():Broadcast(EventId.EnergyOrderRefresh)
end

local function HandleDelete(self, message)
  if message.order then
    self:UpdateData(message.order)
  end
  self:ResetTimer()
  EventManager:GetInstance():Broadcast(EventId.EnergyOrderRefresh)
end

local function HandleFinish(self, message)
  if message.order then
    self:UpdateData(message.order)
  end
  if message.remainGold then
    LuaEntry.Player.gold = message.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  if message.resource_items then
    DataCenter.ResourceItemDataManager:RefreshItemList(message)
  end
  if message.resource then
    LuaEntry.Resource:UpdateResource(message.resource)
  end
  if message.accPoint ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(message.accPoint)
  end
  self:ResetTimer()
  EventManager:GetInstance():Broadcast(EventId.EnergyOrderRefresh)
end

EnergyOrderManager.__init = __init
EnergyOrderManager.__delete = __delete
EnergyOrderManager.AddListener = AddListener
EnergyOrderManager.RemoveListener = RemoveListener
EnergyOrderManager.Startup = Startup
EnergyOrderManager.TimerAction = TimerAction
EnergyOrderManager.Enabled = Enabled
EnergyOrderManager.CheckRefresh = CheckRefresh
EnergyOrderManager.GetOrderCount = GetOrderCount
EnergyOrderManager.GetIndexByBuildUuid = GetIndexByBuildUuid
EnergyOrderManager.GetBuildUuidByIndex = GetBuildUuidByIndex
EnergyOrderManager.GetLine = GetLine
EnergyOrderManager.InitData = InitData
EnergyOrderManager.UpdateData = UpdateData
EnergyOrderManager.ClearData = ClearData
EnergyOrderManager.GetOrderData = GetOrderData
EnergyOrderManager.GetOrderState = GetOrderState
EnergyOrderManager.GetOrderRestTime = GetOrderRestTime
EnergyOrderManager.GetShowBubbleByBuildUuid = GetShowBubbleByBuildUuid
EnergyOrderManager.GetOrderNeedList = GetOrderNeedList
EnergyOrderManager.ResetTimer = ResetTimer
EnergyOrderManager.OnGuideSaveId = OnGuideSaveId
EnergyOrderManager.OnBuildDataUpdate = OnBuildDataUpdate
EnergyOrderManager.SendRefresh = SendRefresh
EnergyOrderManager.SendDelete = SendDelete
EnergyOrderManager.SendFinish = SendFinish
EnergyOrderManager.HandleRefresh = HandleRefresh
EnergyOrderManager.HandleDelete = HandleDelete
EnergyOrderManager.HandleFinish = HandleFinish
return EnergyOrderManager
