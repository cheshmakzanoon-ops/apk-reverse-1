local MonthCardInfo = BaseClass("MonthCardInfo")
local M = MonthCardInfo

function M:__init()
  self._serverData = nil
  self._showTypeParsed = false
  self._showIndexList = {}
  self._itemDescList = {}
  self._resourceList = {}
  self._rewards = {}
  self._accelerateList = {}
  self._diamond = 0
  self._buildingSpeedUp = 0
  self._techSpeedUp = 0
  self._stone = 0
  self._iron = 0
end

function M:update(data)
  self._serverData = data
  self._showTypeParsed = false
  self._times = data.times
  self._canTimes = data.canTimes
  self._accepted = data.accepted
  self._isBought = data.available
end

function M:getID()
  return self._serverData and self._serverData.itemId or "-1"
end

function M:getCount()
  return self._serverData and self._serverData.count or 0
end

function M:getTimes()
  return self._times
end

function M:getCanTimes()
  return self._canTimes
end

function M:getRemainDays()
  return self:getCount() - self:getCanTimes() - self:getTimes()
end

function M:isBought()
  return self._isBought
end

function M:getPrice()
  return self._tableData and self._tableData.dollar or 0
end

function M:getProductID()
  if CS.SDKManager.IS_UNITY_ANDROID() then
    return self._tableData and self._tableData.product_id_google
  elseif CS.SDKManager.IS_UNITY_IPHONE() then
    return self._tableData and self._tableData.product_id_ios
  end
end

function M:canReceive()
  return self:getCanTimes() > 0
end

function M:isAccepted()
  return self._accepted
end

function M:getShowIndexList()
  self:tryParseShowType()
  return self._showIndexList
end

function M:getSpeedUp()
  self:tryParseShowType()
  return self._buildingSpeedUp, self._techSpeedUp
end

function M:getDiamond()
  self:tryParseShowType()
  return self._diamond
end

function M:getResource()
  self:tryParseShowType()
  return self._stone, self._iron
end

function M:getRewards()
  self:tryParseShowType()
  return self._rewards
end

function M:getResourceList()
  self:tryParseShowType()
  return self._resourceList
end

function M:getAccelerateList()
  self:tryParseShowType()
  return self._accelerateList
end

function M:getDescList()
  self:tryParseShowType()
  return self._itemDescList
end

function M:tryParseShowType()
  if self._showTypeParsed then
    return
  end
  self._showTypeParsed = true
  local showType = self._tableData and self._tableData.show_type or ""
  if string.IsNullOrEmpty(showType) then
    return
  end
  local arr = string.split(showType, "|")
  for _, v in ipairs(arr) do
    if not string.IsNullOrEmpty(v) then
      local arr1 = string.split(v, ";")
      if #arr1 == 2 then
        self:onParseShowTypeItem(arr1[1], arr1[2])
      end
    end
  end
end

function M:onParseShowTypeItem(k, v)
  if k == "7" then
    self._showIndexList = {}
    local arr = string.split(v, ",")
    for _, v in ipairs(arr) do
      table.insert(self._showIndexList, tonumber(v))
    end
  elseif k == "8" then
    local arr = string.split(v, ",")
    if #arr == 2 then
      self._buildingSpeedUp = tonumber(arr[1])
      self._techSpeedUp = tonumber(arr[2])
    end
  elseif k == "9" then
    self._diamond = tonumber(v)
  elseif k == "29" then
    local arr = string.split(v, ",")
    if #arr == 2 then
      self._stone = tonumber(arr[1])
      self._iron = tonumber(arr[2])
    end
  elseif k == "63" then
    local arr = string.split(v, ",")
    for _, v in ipairs(arr) do
      table.insert(self._itemDescList, tonumber(v))
    end
  elseif k == "22" then
    local arr = string.split(v, ",")
    for _, v in ipairs(arr) do
      table.insert(self._accelerateList, v)
    end
  elseif k == "23" then
    local arr = string.split(v, ",")
    for _, v in ipairs(arr) do
      table.insert(self._resourceList, v)
    end
  elseif k == "68" then
    local arr = string.split(v, ",")
    for _, v in ipairs(arr) do
      table.insert(self._rewards, v)
    end
  end
end

function M:received()
  self._times = self._times + 1
  self._canTimes = self._canTimes - 1
  if self._canTimes < 0 then
    self._canTimes = 0
  end
  self._accepted = true
end

function M:updateOnDayChange()
  self._canTimes = self._canTimes + 1
  if self:getRemainDays() < 0 then
    self._canTimes = self._canTimes - 1
  end
  self._accepted = false
end

function M:dispose()
  self._serverData = nil
end

return M
