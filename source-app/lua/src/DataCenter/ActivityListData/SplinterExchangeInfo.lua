local SplinterExchangeInfo = BaseClass("SplinterExchangeInfo")

local function __init(self)
  self.cfgData = SplinterExchangeType.DispatchTreasure
  self.ownData = nil
  self.alDataList = nil
  self.recordDataList = nil
  self.fragGoodsIdList = {}
  self.showExchangeRedPoint = false
end

local function __delete(self)
  self.cfgData = nil
  self.ownData = nil
  self.alDataList = nil
  self.recordDataList = nil
  self.fragGoodsIdList = nil
  self.showExchangeRedPoint = nil
end

local function InitByCfg(self, info)
  self.cfgData = info
  local data = LocalController:instance():getLine(TableName.Splinter_Exchange, self.cfgData.Id)
  local splinterIds = string.split(data.splinter_id, "|")
  for i = 1, #splinterIds do
    local goodsId = splinterIds[i]
    table.insert(self.fragGoodsIdList, goodsId)
  end
end

local function RefreshSelfInfo(self, message)
  if message.type ~= self.cfgData.Id then
    Logger.LogError("SplinterExchangeInfo type error messageType:" .. message.type .. "cfgType:" .. self.cfgData.Id)
    return
  end
  self.ownData = SplinterExchangeData.New()
  self.ownData:ParseData(message)
  if message.type == SplinterExchangeType.DispatchTreasure.Id then
    EventManager:GetInstance():Broadcast(EventId.DispatchTreasureRefreshDigRedPoint)
    EventManager:GetInstance():Broadcast(EventId.DispatchTreasureRefreshTabRedPoint)
  end
end

local function RefreshALInfoList(self, message)
  if message.type ~= self.cfgData.Id then
    Logger.LogError("SplinterExchangeInfo type error messageType:" .. message.type .. "cfgType:" .. self.cfgData.Id)
    return
  end
  self.alDataList = {}
  if message ~= nil and message.array ~= nil then
    for _, v in ipairs(message.array) do
      local data = SplinterExchangeData.New()
      data:ParseData(v)
      table.insert(self.alDataList, data)
    end
  end
end

local function RefreshSelfRecordShowData(self, message)
  if message.type ~= self.cfgData.Id then
    Logger.LogError("SplinterExchangeInfo type error messageType:" .. message.type .. "cfgType:" .. self.cfgData.Id)
    return
  end
  if self.ownData then
    self.ownData:RefreshRecordShowData(message)
  end
end

local function CancelExchange(self)
  self.ownData = nil
end

local function RemoveOneALInfo(self, uuid)
  for i = #self.alDataList, 1, -1 do
    if self.alDataList[i].uuid == uuid then
      table.remove(self.alDataList, i)
      break
    end
  end
end

local function RefreshRecordDataList(self, message)
  if message.type ~= self.cfgData.Id then
    Logger.LogError("SplinterExchangeInfo type error messageType:" .. message.type .. "cfgType:" .. self.cfgData.Id)
    return
  end
  self.recordDataList = {}
  if message ~= nil and message.array ~= nil then
    for _, v in ipairs(message.array) do
      local data = SplinterExchangeRecordData.New()
      data:ParseData(v)
      table.insert(self.recordDataList, data)
    end
    table.sort(self.recordDataList, function(a, b)
      return a.time > b.time
    end)
  end
end

local function RefreshOneRecordData(self, message)
  if message.type ~= self.cfgData.Id then
    Logger.LogError("SplinterExchangeInfo type error messageType:" .. message.type .. "cfgType:" .. self.cfgData.Id)
    return
  end
  if self.recordDataList then
    for index, value in ipairs(self.recordDataList) do
      if value.uuid == message.uuid then
        value:ParseData(message)
        break
      end
    end
  end
end

local function GetRecordDataByUuid(self, uuid)
  for index, value in ipairs(self.recordDataList) do
    if value.uuid == uuid then
      return value
    end
  end
  return {}
end

local function GetAlExchangeDataList(self)
  if self.alDataList and #self.alDataList > 0 then
    local haveFragList = {}
    local noFragList = {}
    for index, value in ipairs(self.alDataList) do
      local haveNum = DataCenter.ItemData:GetItemCount(value.needFragment)
      if 0 < haveNum then
        table.insert(haveFragList, value)
      else
        table.insert(noFragList, value)
      end
    end
    table.sort(haveFragList, function(a, b)
      return a.updateTime > b.updateTime
    end)
    table.sort(noFragList, function(a, b)
      return a.updateTime > b.updateTime
    end)
    self.alDataList = {}
    for index, value in ipairs(haveFragList) do
      table.insert(self.alDataList, value)
    end
    for index, value in ipairs(noFragList) do
      table.insert(self.alDataList, value)
    end
    return self.alDataList
  end
  return {}
end

local function GetSelfExchangeData(self)
  return self.ownData
end

local function GetRecordDataList(self)
  return self.recordDataList or {}
end

local function GetAllFragNum(self)
  local allNum = 0
  for i = 1, #self.fragGoodsIdList do
    local num = DataCenter.ItemData:GetItemCount(self.fragGoodsIdList[i])
    allNum = allNum + num
  end
  return allNum
end

local function SetShowExchangeRedPoint(self, message)
  if message and message[self.cfgData.LogRedPoint] then
    self.showExchangeRedPoint = message[self.cfgData.LogRedPoint] == 1
    if message.type == SplinterExchangeType.DispatchTreasure.Id then
      EventManager:GetInstance():Broadcast(EventId.DispatchTreasureRefreshTabRedPoint)
    end
    EventManager:GetInstance():Broadcast(EventId.SplinterRefreshExchangeRedPoint, self.cfgData.Id)
  end
end

local function GetExchangeLogRedPoint(self)
  return self.showExchangeRedPoint
end

local function GetIndexByGoodsId(self, goodsId)
  local id = 0
  for index, value in ipairs(self.fragGoodsIdList) do
    if value == goodsId then
      id = index
    end
  end
  return id
end

local function GetCfgData(self)
  return self.cfgData
end

SplinterExchangeInfo.__init = __init
SplinterExchangeInfo.__delete = __delete
SplinterExchangeInfo.InitByCfg = InitByCfg
SplinterExchangeInfo.RefreshSelfInfo = RefreshSelfInfo
SplinterExchangeInfo.RefreshALInfoList = RefreshALInfoList
SplinterExchangeInfo.CancelExchange = CancelExchange
SplinterExchangeInfo.RemoveOneALInfo = RemoveOneALInfo
SplinterExchangeInfo.RefreshRecordDataList = RefreshRecordDataList
SplinterExchangeInfo.RefreshSelfRecordShowData = RefreshSelfRecordShowData
SplinterExchangeInfo.RefreshOneRecordData = RefreshOneRecordData
SplinterExchangeInfo.GetRecordDataByUuid = GetRecordDataByUuid
SplinterExchangeInfo.GetAlExchangeDataList = GetAlExchangeDataList
SplinterExchangeInfo.GetSelfExchangeData = GetSelfExchangeData
SplinterExchangeInfo.GetRecordDataList = GetRecordDataList
SplinterExchangeInfo.GetAllFragNum = GetAllFragNum
SplinterExchangeInfo.SetShowExchangeRedPoint = SetShowExchangeRedPoint
SplinterExchangeInfo.GetExchangeLogRedPoint = GetExchangeLogRedPoint
SplinterExchangeInfo.GetIndexByGoodsId = GetIndexByGoodsId
SplinterExchangeInfo.GetCfgData = GetCfgData
return SplinterExchangeInfo
