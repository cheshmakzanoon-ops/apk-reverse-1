local ActRecycleData = BaseClass("ActRecycleData")
local LWUICommonExchangeShopData_Recycle = require("UI.ActivityCommon.LWUICommonExchangeShop.LWUICommonExchangeShop_Recycle.LWUICommonExchangeShopData_Recycle")

function ActRecycleData:__init()
  self.shopServerDataList = nil
  self.giftItemLimit = 0
  self.ticketLimit = 0
  self.dayNum = 0
  self.dayNumLimit = 0
end

function ActRecycleData:__delete()
  self.shopServerDataList = nil
  self.giftItemLimit = nil
  self.ticketLimit = nil
  self.dayNum = nil
  self.dayNumLimit = nil
end

function ActRecycleData:UpdateData(data, activityId)
  self.activityId = activityId
  if self.shopServerDataList == nil then
    self.shopServerDataList = {}
  end
  if data ~= nil then
    if data.recycleShopArr then
      for i, v in ipairs(data.recycleShopArr) do
        local id = tostring(v.id)
        self.shopServerDataList[id] = v
      end
    end
    if data.convertShopArr then
      for i, v in ipairs(data.convertShopArr) do
        local id = tostring(v.id)
        self.shopServerDataList[id] = v
      end
    end
    self.giftItemLimit = data.giftItemLimit or 0
    self.ticketLimit = data.ticketLimit or 0
    self.dayNum = data.dayNum or 0
    self.dayNumLimit = data.dayNumLimit or 0
  end
end

function ActRecycleData:GetExchangeShopDataList()
  local res = {}
  if self.shopServerDataList then
    for _, data in pairs(self.shopServerDataList) do
      if data.shopType == 2 then
        local shopData = LWUICommonExchangeShopData_Recycle.New(data.id, self.activityId)
        table.insert(res, shopData)
      end
    end
  end
  table.sort(res, function(a, b)
    local isSoldA = a:IsSoldOut()
    local isSoldB = b:IsSoldOut()
    if isSoldA ~= isSoldB then
      return not isSoldA
    end
    return a:GetDisplayOrder() > b:GetDisplayOrder()
  end)
  return res
end

function ActRecycleData:GetRecycleShopDataList()
  local res = {}
  if self.shopServerDataList then
    for _, data in pairs(self.shopServerDataList) do
      if data.shopType == 1 then
        local shopData = LWUICommonExchangeShopData_Recycle.New(data.id, self.activityId)
        table.insert(res, shopData)
      end
    end
  end
  table.sort(res, function(a, b)
    local isSoldA = a:IsSoldOut()
    local isSoldB = b:IsSoldOut()
    if isSoldA ~= isSoldB then
      return not isSoldA
    end
    return a:GetDisplayOrder() > b:GetDisplayOrder()
  end)
  return res
end

function ActRecycleData:GetShopServerData(id)
  id = tostring(id)
  if self.shopServerDataList then
    return self.shopServerDataList[id]
  end
end

function ActRecycleData:UpdateShopBuyTimes(id, curNum)
  id = tostring(id)
  if self.shopServerDataList then
    local data = self.shopServerDataList[id]
    if data then
      data.curNum = curNum
    end
  end
end

function ActRecycleData:GetTotalBoxItemGetCount()
  return checknumber(self.giftItemLimit)
end

function ActRecycleData:TryUpdateTotalBoxItemGetCount(msg)
  if msg ~= nil and msg.giftItemLimit ~= nil then
    self.giftItemLimit = msg.giftItemLimit
  end
end

function ActRecycleData:GetExchangeDailyLimitTodayNum()
  return self.dayNum
end

function ActRecycleData:GetExchangeDailyLimitTotalNum()
  return self.dayNumLimit
end

function ActRecycleData:TryUpdateDailyLimit(data)
  if data ~= nil and data.dayNum ~= nil and data.dayNumLimit ~= nil then
    self.dayNum = data.dayNum
    self.dayNumLimit = data.dayNumLimit
  end
end

function ActRecycleData:IsExchangeShopRedOn()
  return CS.GameEntry.Setting:GetBool("activity_recycle_exchange_red_" .. LuaEntry.Player.uid, true)
end

function ActRecycleData:SetExchangeShopRedOn(value)
  if value then
    UIUtil.ShowTipsId("activity_99051desc_2")
  end
  CS.GameEntry.Setting:SetBool("activity_recycle_exchange_red_" .. LuaEntry.Player.uid, value)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActRecycleData:GetExchangeShopRed()
  if self:IsExchangeShopRedOn() then
    local shopDataList = self:GetExchangeShopDataList()
    for i, v in pairs(shopDataList) do
      if v:IsShowRed() then
        return 1
      end
    end
  end
  return 0
end

return ActRecycleData
