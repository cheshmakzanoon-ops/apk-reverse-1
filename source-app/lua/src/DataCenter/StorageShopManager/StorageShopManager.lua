local StorageShopManager = BaseClass("StorageShopManager")
local Localization = CS.GameEntry.Localization
local StorageShopHistoryRecord = require("DataCenter.StorageShopManager.StorageShopHistoryRecord")

local function __init(self)
  self.EXTRA_SLOT_INDEX = 10000
  self.selfSlotList = {}
  self.otherShopInfo = nil
  self.slotUnlockCostDic = {}
  self.cacheWorldShopList = nil
  self.cacheAlShopList = nil
  self.refreshCdEndT = 0
  self.lastRefreshTime = 0
  self.remainRefreshTimes = -1
  self.lastTabIndex = 1
  self.nextGolloesBuyTime = 0
  self.lastGolloesBuyTime = 0
  self.golloesBuyTimer = nil
  self.soldHistory = {}
  self:InitUnlockCost()
  self:AddListener()
end

local function __delete(self)
  self.selfSlotList = nil
  self.otherShopInfo = nil
  self.slotUnlockCostDic = nil
  self.cacheWorldShopList = nil
  self.cacheAlShopList = nil
  self.refreshCdEndT = nil
  self.lastTabIndex = nil
  self.nextGolloesBuyTime = nil
  self.lastGolloesBuyTime = nil
  if self.golloesBuyTimer ~= nil then
    self.golloesBuyTimer:Stop()
    self.golloesBuyTimer = nil
  end
  self.soldHistory = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function InitShopData(self, t)
  self.selfSlotList = {}
  if t.tradeBankUnit then
    local tempList = t.tradeBankUnit.slotArr
    for i, v in pairs(tempList) do
      local newData = StorageShopSlotData.New()
      newData:ParseData(v)
      table.insert(self.selfSlotList, newData)
    end
  end
  if t.lastTradeBankRandTime then
    self.lastRefreshTime = t.lastTradeBankRandTime
  end
  if t.tradeBankRandNum then
    self.remainRefreshTimes = t.tradeBankRandNum
  end
  self:ResetNextGolloesBuyTime()
end

local function OnRecvSoldSucc(self, t)
  local newInfo = t.tradeBankSlot
  if not newInfo then
    return
  end
  self:UpdateOneSelfSlotInfo(newInfo)
  if t.resource then
    LuaEntry.Resource:UpdateResource(t.resource)
  end
  if t.accPoint ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint)
  end
  EventManager:GetInstance():Broadcast(EventId.StorageShopSoldSucc)
  self:ResetNextGolloesBuyTime()
end

local function OnRecvShopsList(self, t)
  local tempType = t.type
  if tempType == StorageShopListType.World then
    local isRefresh = false
    if t.lastTradeBankRandTime then
      isRefresh = true
      self.lastRefreshTime = t.lastTradeBankRandTime
    end
    if t.tradeBankRandNum then
      isRefresh = true
      self.remainRefreshTimes = t.tradeBankRandNum
    end
    if isRefresh then
      UIUtil.ShowTipsId(372335)
    end
    self.cacheWorldShopList = {}
    if t.showInfos then
      for i, v in pairs(t.showInfos) do
        if v.pointId and v.pointId > 0 then
          local newShop = StorageShopData.New()
          newShop:ParseData(v)
          if newShop.uid ~= LuaEntry.Player.uid then
            table.insert(self.cacheWorldShopList, newShop)
          end
        end
      end
    end
  else
    self.cacheAlShopList = {}
    if t.showInfos then
      for i, v in pairs(t.showInfos) do
        if v.pointId and v.pointId > 0 then
          local newShop = StorageShopData.New()
          newShop:ParseData(v)
          if newShop.uid ~= LuaEntry.Player.uid then
            table.insert(self.cacheAlShopList, newShop)
          end
        end
      end
      table.sort(self.cacheAlShopList, function(a, b)
        if a.uid ~= b.uid then
          return a.uid < b.uid
        else
          return false
        end
      end)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.StorageShopGetShopList)
end

local function OnRecvUnlcokSlot(self, t)
  if t.remainGold then
    LuaEntry.Player.gold = t.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  if t.tradeBankSlot then
    self:UpdateOneSelfSlotInfo(t.tradeBankSlot)
    EventManager:GetInstance():Broadcast(EventId.StorageShopUnlockSlotSucc)
  end
end

local function OnRecvAddGoods(self, t)
  if t.tradeBankSlot then
    self:UpdateOneSelfSlotInfo(t.tradeBankSlot)
    EventManager:GetInstance():Broadcast(EventId.StorageShopAddGoods)
  end
  if t.resource_items then
    DataCenter.ResourceItemDataManager:RefreshItemList(t)
  end
  self:ResetNextGolloesBuyTime()
end

local function OnRecvRemoveGoods(self, t)
  if t.resource_items then
    DataCenter.ResourceItemDataManager:RefreshItemList(t)
  end
  if t.tradeBankSlot then
    self:UpdateOneSelfSlotInfo(t.tradeBankSlot)
    EventManager:GetInstance():Broadcast(EventId.StorageShopRemoveGoods)
  end
  self:ResetNextGolloesBuyTime()
end

local function OnRecvBuySucc(self, t)
  self.buyFailCallBack = nil
  if t.tradeBankSlot and t.tradeBankSlot.uuid then
    EventManager:GetInstance():Broadcast(EventId.StorageShopShowBuySuccEff, t.tradeBankSlot.uuid)
  end
  if t.resource_items then
    DataCenter.ResourceItemDataManager:RefreshItemList(t)
  end
  if t.tradeBankSlot then
    self:UpdateOneOtherSlotInfo(t.tradeBankSlot)
    EventManager:GetInstance():Broadcast(EventId.StorageShopBuyGoodsSucc)
  end
  if t.resource ~= nil then
    LuaEntry.Resource:UpdateResource(t.resource)
  end
  if t.accPoint ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint)
  end
end

local function OnRecvBuyFail(self)
  if self.buyFailCallBack then
    self.buyFailCallBack()
  end
  self.buyFailCallBack = nil
end

local function OnGetOtherPlayerShop(self, t)
  self.otherShopInfo = StorageShopData.New()
  self.otherShopInfo:ParseData(t)
  EventManager:GetInstance():Broadcast(EventId.StorageShopGetOtherShopInfo)
end

local function OnRecvClaimMoneyBack(self, t)
  if t.resource ~= nil then
    LuaEntry.Resource:UpdateResource(t.resource)
  end
  if t.tradeBankSlot then
    self:UpdateOneSelfSlotInfo(t.tradeBankSlot)
    EventManager:GetInstance():Broadcast(EventId.StorageShopClaimMoneyBack)
  end
  if t.accPoint ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint)
  end
end

local function OnRecvShareCheckResult(self, t)
  if t.canSend then
    if self.cacheShareParam then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, self.cacheShareParam)
    end
  else
    UIUtil.ShowTipsId(141080)
  end
  self.cacheShareParam = nil
end

local function UpdateOneSelfSlotInfo(self, tempInfo)
  local updatedOne
  for i, v in ipairs(self.selfSlotList) do
    if v.index == tempInfo.index then
      v:ParseData(tempInfo)
      updatedOne = v
      break
    end
  end
  if not updatedOne then
    local newSlot = StorageShopSlotData.New()
    newSlot:ParseData(tempInfo)
    table.insert(self.selfSlotList, newSlot)
    updatedOne = newSlot
  end
  EventManager:GetInstance():Broadcast(EventId.StorageShopBubbleStatusChange)
  self:ResetNextGolloesBuyTime()
  return updatedOne
end

local function UpdateOneOtherSlotInfo(self, tempInfo)
  if not self.otherShopInfo or not self.otherShopInfo.slotList then
    return
  end
  for i, v in ipairs(self.otherShopInfo.slotList) do
    if v.uuid == tempInfo.uuid then
      v:ParseData(tempInfo)
      break
    end
  end
end

local function InitUnlockCost(self)
  local unlockConf = LuaEntry.DataConfig:TryGetStr("tradingbank_para", "k1")
  if unlockConf and unlockConf ~= "" then
    local tempTb = string.split(unlockConf, "|")
    for i, v in ipairs(tempTb) do
      local tempCost = string.split(v, ";")
      self.slotUnlockCostDic[tonumber(tempCost[1])] = tonumber(tempCost[2])
    end
  end
end

local function GetSelfSlotsInfo(self)
  local list = {}
  for _, v in pairs(self.selfSlotList) do
    if v.index < self.EXTRA_SLOT_INDEX + LuaEntry.Effect:GetGameEffect(EffectDefine.STORAGESHOP_EXTRA_SLOT) or v.state == StorageShopSlotState.SoldOut then
      table.insert(list, v)
    end
  end
  table.sort(list, function(a, b)
    return a.index < b.index
  end)
  return list
end

local function GetCurOtherShopInfo(self)
  return self.otherShopInfo
end

local function GetUnlockSlotCost(self, index)
  return self.slotUnlockCostDic[index]
end

local function GetRefreshCdEndT(self)
  return self.refreshCdEndT
end

local function GetWorldShopList(self)
  if not self.cacheWorldShopList then
    SFSNetwork.SendMessage(MsgDefines.StorageShopGetShopList, StorageShopListType.World)
    return nil
  end
  local retList = {}
  local showCount = LuaEntry.DataConfig:TryGetStr("tradingbank_para", "k19")
  for i, v in ipairs(self.cacheWorldShopList) do
    if #retList < tonumber(showCount) then
      local tempSlots = v:GetOnSaleSlots()
      if 0 < #tempSlots then
        table.insert(retList, v)
      end
    end
  end
  return retList
end

local function GetAlShopList(self, needUpdate)
  if LuaEntry.Player:IsInAlliance() then
    if not self.cacheAlShopList or needUpdate then
      SFSNetwork.SendMessage(MsgDefines.StorageShopGetShopList, StorageShopListType.Alliance)
      return nil
    else
      local showCount = LuaEntry.DataConfig:TryGetStr("tradingbank_para", "k19")
      local retList = {}
      for i, v in ipairs(self.cacheAlShopList) do
        if #retList < tonumber(showCount) then
          local tempSlots = v:GetOnSaleSlots()
          if 0 < #tempSlots then
            table.insert(retList, v)
          end
        end
      end
      return retList
    end
  else
    return nil
  end
end

local function CheckIfHasGoodsOnSell(self, playerUid)
  if self.otherShopInfo and self.otherShopInfo.uid == playerUid then
    local onSellSlots = self.otherShopInfo:GetOnSaleSlots()
    if onSellSlots and #onSellSlots == 0 then
      return false
    end
  end
  return true
end

local function CheckIfIsActive(self)
  local isOpen = LuaEntry.DataConfig:CheckSwitch("tradingbank_switch")
  return isOpen
end

local function CheckIfHasUnclaimedMoney(self)
  for i, v in ipairs(self.selfSlotList) do
    if v.state == StorageShopSlotState.SoldOut then
      return true
    end
  end
end

local function IsHaveCanShopItem(self)
  return DataCenter.ResourceItemDataManager:IsHaveCanShopResourceItem(UICapacityTableTab.Farming)
end

local function CheckIfIsFirstOpen(self)
  if not self:CheckIfIsActive() then
    return false
  end
  local isFirstOpen = Setting:GetBool("StorageShop_FirstOpen_" .. LuaEntry.Player.uid, true)
  if isFirstOpen then
    return true
  end
end

local function TryBuyGoods(self, param, slotInfo)
  function self.buyFailCallBack()
    if slotInfo then
      slotInfo.state = StorageShopSlotState.SoldOut
    end
    EventManager:GetInstance():Broadcast(EventId.StorageShopBuyGoodsSucc)
  end
  
  SFSNetwork.SendMessage(MsgDefines.StorageShopBuyGoods, param)
end

local function SetLastTabIndex(self, tabIndex)
  self.lastTabIndex = tabIndex
end

local function GetLastTabIndex(self)
  return self.lastTabIndex
end

local function ResetNextGolloesBuyTime(self)
  local minT = LongMaxValue
  if not LuaEntry.DataConfig:CheckSwitch("tradingbank_recover") then
    return
  end
  local durTime = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k11")
  for i, v in ipairs(self.selfSlotList) do
    if v.state == StorageShopSlotState.OnSell then
      local tempT = v.startTime + durTime * 1000
      if minT > tempT and tempT > self.lastGolloesBuyTime then
        minT = tempT
      end
    end
  end
  self.nextGolloesBuyTime = minT
  if self.golloesBuyTimer ~= nil then
    self.golloesBuyTimer:Stop()
    self.golloesBuyTimer = nil
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.nextGolloesBuyTime then
    EventManager:GetInstance():Broadcast(EventId.StorageShopBubbleStatusChange)
  else
    local delayS = (self.nextGolloesBuyTime - curTime) / 1000 + 2
    if self.golloesBuyTimer ~= nil then
      self.golloesBuyTimer:Stop()
      self.golloesBuyTimer = nil
    end
    self.golloesBuyTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.golloesBuyTimer = nil
      EventManager:GetInstance():Broadcast(EventId.StorageShopBubbleStatusChange)
    end, delayS)
  end
end

local function CheckIfHasGolloesBuy(self)
  if not LuaEntry.DataConfig:CheckSwitch("tradingbank_recover") then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.nextGolloesBuyTime then
    return true
  else
    return false
  end
end

local function SetLastGolloesBuyTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.lastGolloesBuyTime = curTime
  self:ResetNextGolloesBuyTime()
end

local function TryShareStorageShop(self, param)
  self.cacheShareParam = param
  SFSNetwork.SendMessage(MsgDefines.ShareCdCheck, ShareCheckType.StorageShop)
end

local function SendUserGetTradeBankRecords(self)
  SFSNetwork.SendMessage(MsgDefines.UserGetTradeBankRecords)
end

local function UserGetTradeBankRecordsHandle(self, message)
  if message.errorCode == nil then
    if message.records ~= nil then
      self.soldHistory = {}
      for k, v in ipairs(message.records) do
        local info = StorageShopHistoryRecord.New()
        info:ParseData(v)
        table.insert(self.soldHistory, info)
      end
      table.sort(self.soldHistory, function(a, b)
        if a.time > b.time then
          return true
        end
        return false
      end)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshStorageShopHistory)
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function GetHistoryList(self)
  return self.soldHistory
end

local function GetRemainRefreshTimes(self)
  local cdInterval = LuaEntry.DataConfig:TryGetStr("tradingbank_para", "k8")
  local effNUm = LuaEntry.Effect:GetGameEffect(EffectDefine.STORAGE_SHOP_REFRESH_TIME_REDUCE)
  cdInterval = math.max(cdInterval - effNUm, 1)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local tempTimes = math.modf((serverTime - self.lastRefreshTime) / 1000 / cdInterval)
  local nextRecoverTime = self.lastRefreshTime + (tempTimes + 1) * cdInterval * 1000
  local maxTimes = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k18")
  local retTimes = tempTimes + self.remainRefreshTimes
  retTimes = math.min(maxTimes, retTimes)
  return retTimes, nextRecoverTime
end

local function SetOtherShopBase(self, playerUid, playerName, sid)
  self.otherShopInfo = StorageShopData.New()
  self.otherShopInfo.uid = playerUid
  self.otherShopInfo.name = playerName
  self.otherShopInfo.serverId = sid
end

local function GetOtherShopServer(self)
  if self.otherShopInfo and self.otherShopInfo.serverId > 0 then
    return self.otherShopInfo.serverId
  end
  return LuaEntry.Player.serverId
end

StorageShopManager.__init = __init
StorageShopManager.__delete = __delete
StorageShopManager.AddListener = AddListener
StorageShopManager.RemoveListener = RemoveListener
StorageShopManager.InitShopData = InitShopData
StorageShopManager.InitUnlockCost = InitUnlockCost
StorageShopManager.GetCurOtherShopInfo = GetCurOtherShopInfo
StorageShopManager.GetUnlockSlotCost = GetUnlockSlotCost
StorageShopManager.OnRecvSoldSucc = OnRecvSoldSucc
StorageShopManager.OnRecvShopsList = OnRecvShopsList
StorageShopManager.OnRecvUnlcokSlot = OnRecvUnlcokSlot
StorageShopManager.UpdateOneSelfSlotInfo = UpdateOneSelfSlotInfo
StorageShopManager.OnRecvAddGoods = OnRecvAddGoods
StorageShopManager.OnRecvRemoveGoods = OnRecvRemoveGoods
StorageShopManager.OnRecvBuySucc = OnRecvBuySucc
StorageShopManager.OnRecvBuyFail = OnRecvBuyFail
StorageShopManager.OnRecvShareCheckResult = OnRecvShareCheckResult
StorageShopManager.OnGetOtherPlayerShop = OnGetOtherPlayerShop
StorageShopManager.GetSelfSlotsInfo = GetSelfSlotsInfo
StorageShopManager.UpdateOneOtherSlotInfo = UpdateOneOtherSlotInfo
StorageShopManager.OnRecvClaimMoneyBack = OnRecvClaimMoneyBack
StorageShopManager.GetWorldShopList = GetWorldShopList
StorageShopManager.GetAlShopList = GetAlShopList
StorageShopManager.GetRefreshCdEndT = GetRefreshCdEndT
StorageShopManager.CheckIfHasGoodsOnSell = CheckIfHasGoodsOnSell
StorageShopManager.CheckIfIsActive = CheckIfIsActive
StorageShopManager.CheckIfHasUnclaimedMoney = CheckIfHasUnclaimedMoney
StorageShopManager.IsHaveCanShopItem = IsHaveCanShopItem
StorageShopManager.CheckIfIsFirstOpen = CheckIfIsFirstOpen
StorageShopManager.TryBuyGoods = TryBuyGoods
StorageShopManager.SetLastTabIndex = SetLastTabIndex
StorageShopManager.GetLastTabIndex = GetLastTabIndex
StorageShopManager.CheckIfHasGolloesBuy = CheckIfHasGolloesBuy
StorageShopManager.ResetNextGolloesBuyTime = ResetNextGolloesBuyTime
StorageShopManager.SetLastGolloesBuyTime = SetLastGolloesBuyTime
StorageShopManager.TryShareStorageShop = TryShareStorageShop
StorageShopManager.SendUserGetTradeBankRecords = SendUserGetTradeBankRecords
StorageShopManager.UserGetTradeBankRecordsHandle = UserGetTradeBankRecordsHandle
StorageShopManager.GetHistoryList = GetHistoryList
StorageShopManager.GetRemainRefreshTimes = GetRemainRefreshTimes
StorageShopManager.SetOtherShopBase = SetOtherShopBase
StorageShopManager.GetOtherShopServer = GetOtherShopServer
return StorageShopManager
