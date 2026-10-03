local SeasonBountyShopData = require("UI/LWSeason5/SeasonBountyShop/Common/SeasonBountyShopData")
local RewardUtil = require("Util.RewardUtil")
local SeasonBountyShopManager = BaseClass("SeasonBountyShopManager")

function SeasonBountyShopManager:__init()
  self:InitVars()
end

function SeasonBountyShopManager:__delete()
end

function SeasonBountyShopManager:InitVars()
  self.LOG_ENABLE = false
  self.ActId = nil
  self.ShopDataDict = {}
  self.ShopDataMap = {}
  self.ProductType = {
    GOODS = 1,
    RES = 2,
    TITLE = 3
  }
end

function SeasonBountyShopManager:SetActId(actId)
  self.ActId = actId
end

function SeasonBountyShopManager:GetActData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
end

function SeasonBountyShopManager:GetActCell()
end

function SeasonBountyShopManager:ActCanShow()
  if GMUtils.GetBool(GMConst.S5BountyShopDontCheckBuilding) then
    return true
  end
  local actData = self:GetActData()
  if actData == nil then
    return false
  end
  local pair = string.split(actData.para_4, "|")
  if table.count(pair) == 2 then
    local buildId = checknumber(pair[1])
    local level = checknumber(pair[2])
    return DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, level)
  end
  return true
end

function SeasonBountyShopManager:SendGetList()
  if self.ActId == nil then
    self:Log("SeasonBountyShopManager:SendGetList actId is nil")
    return
  end
  local param = {}
  param.activityId = self.ActId
  SFSNetwork.SendMessage(MsgDefines.BountyShopExchangeRecord, param)
end

function SeasonBountyShopManager:OnGetListCallback(res)
  if res ~= nil then
    self:GenerateShopDataList(res)
    EventManager:GetInstance():Broadcast(EventId.SeasonBountyShopGetListUpdate, data)
  end
end

function SeasonBountyShopManager:GenerateShopDataList(payload)
  self.ShopDataDict = {
    OpenedList = {},
    UnopenedList = {}
  }
  self.ShopDataMap = {}
  if payload == nil then
    self:Log("SeasonBountyShopManager:GenerateShopDataList payload is nil")
    return
  end
  local actData = self:GetActData()
  if actData == nil then
    self:Log("SeasonBountyShopManager:GenerateShopDataList actData is nil")
    return
  end
  local groupId = actData.para
  local now = UITimeManager:GetInstance():GetServerTime()
  local past = math.max(0, now - actData.startTime)
  LocalController:instance():visitTable(TableName.SEASON_BOUNTY_SHOP, function(k, v)
    if groupId == v.group then
      local shopData = SeasonBountyShopData.New()
      shopData:InitData(v.id, actData.startTime)
      self.ShopDataMap[shopData.ShopCell.id] = shopData
      local openTime = checknumber(v.open_time) * 1000
      if openTime == 0 or openTime < past then
        table.insert(self.ShopDataDict.OpenedList, {
          Time = checknumber(v.refresh_time),
          ShopData = shopData
        })
      else
        table.insert(self.ShopDataDict.UnopenedList, {
          Time = checknumber(v.open_time),
          ShopData = shopData
        })
      end
    end
  end)
  if not table.IsNullOrEmpty(payload.recordArr) then
    for _, record in pairs(payload.recordArr) do
      for _, shopGroup in pairs(self.ShopDataDict.OpenedList) do
        if shopGroup.ShopData.ShopCell.id == record.configId then
          shopGroup.ShopData:UpdateRecord(record)
        end
      end
    end
  end
  self:SortShopDataDict()
end

function SeasonBountyShopManager:SortShopDataDict()
  if self.ShopDataDict == nil then
    return
  end
  if table.count(self.ShopDataDict.OpenedList) > 0 then
    table.sort(self.ShopDataDict.OpenedList, function(a, b)
      if a.Time == b.Time then
        local validInfo_a = a.ShopData:ConditionValid()
        local validInfo_b = b.ShopData:ConditionValid()
        if validInfo_a.IsValid ~= validInfo_b.IsValid then
          return validInfo_a.IsValid
        end
        if not validInfo_a.IsValid and not validInfo_b.IsValid then
          return validInfo_a.InvalidSortOrder < validInfo_b.InvalidSortOrder
        end
        local aLeftTimes = a.ShopData:GetLeftBuyTimes()
        local bLeftTimes = b.ShopData:GetLeftBuyTimes()
        if aLeftTimes == 0 and bLeftTimes == 0 then
          return checknumber(a.ShopData.ShopCell.order) < checknumber(b.ShopData.ShopCell.order)
        end
        if aLeftTimes == 0 then
          return false
        end
        if bLeftTimes == 0 then
          return true
        end
        return checknumber(a.ShopData.ShopCell.order) < checknumber(b.ShopData.ShopCell.order)
      end
      return a.Time < b.Time
    end)
  end
  if table.count(self.ShopDataDict.UnopenedList) > 0 then
    table.sort(self.ShopDataDict.UnopenedList, function(a, b)
      if a.Time == b.Time then
        local validInfo_a = a.ShopData:ConditionValid()
        local validInfo_b = b.ShopData:ConditionValid()
        if validInfo_a.IsValid ~= validInfo_b.IsValid then
          return validInfo_a.IsValid
        end
        if not validInfo_a.IsValid and not validInfo_b.IsValid then
          return validInfo_a.InvalidSortOrder < validInfo_b.InvalidSortOrder
        end
        return checknumber(a.ShopData.ShopCell.order) < checknumber(b.ShopData.ShopCell.order)
      end
      return a.Time < b.Time
    end)
  end
end

function SeasonBountyShopManager:GetShopData(shopId)
  if self.ShopDataMap == nil then
    return nil
  end
  return self.ShopDataMap[checknumber(shopId)]
end

function SeasonBountyShopManager:GetNewShopDataList()
  local newList = {}
  local listStr = LuaEntry.Player:GetUserSetting(UserSettingKey.SeasonBountyShopNewItem) or "0"
  local masks = {}
  if string.find(listStr, "_") then
    local maskStrs = string.split(listStr, "_")
    for i, s in ipairs(maskStrs) do
      masks[i] = tonumber(s, 16) or 0
    end
  else
    masks[1] = tonumber(listStr, 16) or 0
  end
  if not table.IsNullOrEmpty(self.ShopDataMap) then
    for _, shopData in pairs(self.ShopDataMap) do
      if shopData:CanShow() then
        local validData = shopData:ConditionValid()
        local isOpen, _ = shopData:IsOpen()
        local isBaseItem = checknumber(shopData.ShopCell.open_time) == 0 and string.IsNullOrEmpty(shopData.ShopCell.buying_condition_type)
        if not isBaseItem and isOpen and validData.IsValid then
          local order = checknumber(shopData.ShopCell.order)
          if 0 < order then
            local chunkIdx = math.floor((order - 1) / 32) + 1
            local bitOffset = (order - 1) % 32
            local mask = masks[chunkIdx] or 0
            local isOld = mask >> bitOffset & 1 == 1
            if not isOld then
              table.insert(newList, shopData.ShopCell.id)
            end
          end
        end
      end
    end
  end
  table.sort(newList, function(a, b)
    return a < b
  end)
  return newList
end

function SeasonBountyShopManager:SaveCurValidShopList()
  local masks = {}
  local maxChunkIdx = 1
  if not table.IsNullOrEmpty(self.ShopDataMap) then
    for _, shopData in pairs(self.ShopDataMap) do
      if shopData:CanShow() then
        local validData = shopData:ConditionValid()
        local isOpen, _ = shopData:IsOpen()
        if validData.IsValid and isOpen then
          local order = checknumber(shopData.ShopCell.order)
          if 0 < order then
            local chunkIdx = math.floor((order - 1) / 32) + 1
            local bitOffset = (order - 1) % 32
            masks[chunkIdx] = (masks[chunkIdx] or 0) | 1 << bitOffset
            if maxChunkIdx < chunkIdx then
              maxChunkIdx = chunkIdx
            end
          end
        end
      end
    end
  end
  local hexStrs = {}
  for i = 1, maxChunkIdx do
    local val = masks[i] or 0
    table.insert(hexStrs, string.format("%X", val))
  end
  local str = table.concat(hexStrs, "_")
  LuaEntry.Player:SetUserSetting(UserSettingKey.SeasonBountyShopNewItem, str)
  SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.SeasonBountyShopNewItem, str)
  EventManager:GetInstance():Broadcast(EventId.SeasonBountyShopDailyRedUpdate)
end

function SeasonBountyShopManager:SendExchange(configId, num)
  if self.ActId == nil then
    self:Log("SeasonBountyShopManager:SendExchange actId is nil")
    return
  end
  local param = {}
  param.activityId = self.ActId
  param.configId = configId
  param.num = num
  SFSNetwork.SendMessage(MsgDefines.BountyShopExchange, param)
end

function SeasonBountyShopManager:OnExchangeCallback(res)
  self:HandleExchangePayloadRecord(res.recordInfo)
  self:HandleExchangePayloadProduct(res)
end

function SeasonBountyShopManager:HandleExchangePayloadRecord(record)
  local needSort = false
  if self.ShopDataDict ~= nil and not table.IsNullOrEmpty(self.ShopDataDict.OpenedList) then
    for _, shopGroup in pairs(self.ShopDataDict.OpenedList) do
      if checknumber(shopGroup.ShopData.ShopCell.id) == record.configId then
        shopGroup.ShopData:UpdateRecord(record)
        if shopGroup.ShopData:GetLeftBuyTimes() <= 0 then
          needSort = true
        end
        break
      end
    end
  end
  if needSort then
    self:SortShopDataDict()
  end
end

function SeasonBountyShopManager:HandleExchangePayloadProduct(res)
  if res == nil or res.productInfo == nil then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonBountyShopExchangeUpdate, res)
end

function SeasonBountyShopManager:HandleRecordPush(payload)
  if payload == nil then
    return nil
  end
  local record = payload.recordInfo
  if record == nil then
    return nil
  end
  local shopData = self:GetShopData(record.configId)
  if shopData ~= nil then
    shopData:UpdateRecord(record)
    if shopData:GetLeftBuyTimes() <= 0 then
      self:SortShopDataDict()
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonBountyShopForceRefresh)
  end
end

function SeasonBountyShopManager:Log(msg, ...)
  if self.LOG_ENABLE then
    Logger.LogError(msg)
  end
end

function SeasonBountyShopManager:HasSoldOut()
  if self.ShopDataDict == nil then
    return false
  end
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest and not table.IsNullOrEmpty(self:GetNewShopDataList()) then
    return false
  end
  if table.count(self.ShopDataDict.OpenedList) > 0 then
    for _, shopGroup in pairs(self.ShopDataDict.OpenedList) do
      if seasonType == SeasonMapType.NineNation then
        if 0 < shopGroup.ShopData:GetLeftBuyTimes() then
          return false
        end
      elseif seasonType == SeasonMapType.NineNationRainforest and shopGroup.ShopData:IsShortSale() and 0 < shopGroup.ShopData:GetLeftBuyTimes() then
        return false
      end
    end
    return true
  end
  return false
end

function SeasonBountyShopManager:ShowDailyRed()
  if not self:ActCanShow() then
    return false
  end
  if self:HasSoldOut() then
    return false
  end
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNation then
    local lastTime = CommonUtil.PlayerPrefsGetLong(SettingKeys.BOUNTY_SHOP_DAILY_RED, 0)
    return not UITimeManager:GetInstance():IsSameDayForServer(lastTime, UITimeManager:GetInstance():GetServerSeconds())
  elseif seasonType == SeasonMapType.NineNationRainforest then
    return not table.IsNullOrEmpty(self:GetNewShopDataList())
  end
  return false
end

function SeasonBountyShopManager:SetDailyRed()
  CommonUtil.PlayerPrefsSetLong(SettingKeys.BOUNTY_SHOP_DAILY_RED, UITimeManager:GetInstance():GetServerSeconds())
  EventManager:GetInstance():Broadcast(EventId.SeasonBountyShopDailyRedUpdate)
end

return SeasonBountyShopManager
