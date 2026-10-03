local FactoryData = BaseClass("FactoryData")
local FactoryWorkingData = require("DataCenter.FactoryDataManager.FactoryWorkingData")

local function __init(self)
  self.bUuid = 0
  self.unlocked = 0
  self.planZoneList = {}
  self.productZoneList = {}
  self.workingList = {}
  self.type = FactoryDataType.FactoryDataType_Normal
  self.levelId = 0
end

local function __delete(self)
  self.bUuid = nil
  self.unlocked = nil
  self.planZoneList = nil
  self.productZoneList = nil
  self.type = nil
  self.levelId = nil
end

local function CheckCanGetProduct(self)
  local itemId = -1
  local productId = ""
  if #self.productZoneList > 0 then
    local functionId = self.productZoneList[1]
    local functionTemplate = DataCenter.FactoryDataManager:GetFactoryTemplate(functionId)
    if functionTemplate ~= nil then
      local first = functionTemplate:GetMainProduct()
      if first ~= nil then
        itemId = first.itemId
      end
      productId = functionId
    end
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for _, v in ipairs(self.workingList) do
      if 0 < v.product and curTime > v.endTime then
        local functionTemplate = DataCenter.FactoryDataManager:GetFactoryTemplate(v.product)
        if functionTemplate ~= nil then
          local first = functionTemplate:GetMainProduct()
          if first ~= nil then
            itemId = first.itemId
          end
          productId = v.product
        end
        if 0 < itemId then
          break
        end
      end
    end
  end
  return itemId, productId
end

local function RefreshData(self, message)
  if message.bUuid ~= nil then
    self.bUuid = message.bUuid
  end
  if message.unlocked ~= nil then
    self.unlocked = message.unlocked
  end
  self.type = message.type or FactoryDataType.FactoryDataType_Normal
  if message.levelId ~= nil then
    self.levelId = message.levelId
  end
  self.workingList = {}
  if message.yieldArr ~= nil then
    local yieldArr = message.yieldArr
    table.walk(yieldArr, function(k, v)
      if DataCenter.FactoryDataManager:IsQueueOpenByIndex(self.bUuid, k) or v.product ~= nil and v.product > 0 then
        local workingData = FactoryWorkingData.New()
        workingData:RefreshData(v)
        table.insert(self.workingList, workingData)
      end
    end)
  end
  if message.planZone ~= nil then
    self.planZoneList = {}
    local planZone = message.planZone
    if planZone ~= nil and planZone ~= "" then
      local str = string.split(planZone, "|")
      for i = 1, table.length(str) do
        table.insert(self.planZoneList, str[i])
      end
    end
  end
  if message.productZone ~= nil then
    self.productZoneList = {}
    local productZone = message.productZone
    if productZone ~= nil and productZone ~= "" then
      local str = string.split(productZone, "|")
      for i = 1, table.length(str) do
        table.insert(self.productZoneList, str[i])
      end
    end
  end
end

local function NeedRefreshFactoryData(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, v in pairs(self.workingList) do
    if v.product > 0 and curTime > v.endTime then
      return true
    end
  end
  return false
end

local function GetLatestWorkData(self)
  local result
  local endTime = 0
  for _, v in pairs(self.workingList) do
    if 0 < v.product then
      if result == nil then
        result = v.product
        endTime = v.endTime
      elseif 0 < v.endTime and endTime > v.endTime then
        result = v.product
        endTime = v.endTime
      end
    end
  end
  return result
end

local function GetLatestQueueData(self)
  local result
  local endTime = 0
  for _, v in pairs(self.workingList) do
    if 0 < v.product then
      if result == nil then
        result = v
        endTime = v.endTime
      elseif 0 < v.endTime and endTime > v.endTime then
        result = v
        endTime = v.endTime
      end
    end
  end
  return result
end

FactoryData.__init = __init
FactoryData.__delete = __delete
FactoryData.RefreshData = RefreshData
FactoryData.CheckCanGetProduct = CheckCanGetProduct
FactoryData.NeedRefreshFactoryData = NeedRefreshFactoryData
FactoryData.GetLatestWorkData = GetLatestWorkData
FactoryData.GetLatestQueueData = GetLatestQueueData
return FactoryData
