local ActLimitedTimeFeastServerData = BaseClass("ActLimitedTimeFeastServerData")
local dropWayInfo = require("DataCenter.ActivityListData.ActLimitedTimeFeastDropWayInfo")

local function __init(self)
  self.dropArr = {}
  self.dayGroupCurNum = 0
  self.dayGroupLimit = 0
  self.serverTime = 0
  self.itemId = 0
end

local function __delete(self)
  self.dropArr = nil
end

local function RefreshActDetailData(self, serverData)
  if not serverData then
    return
  end
  if serverData.dropArr then
    self.dropArr = {}
    local arr = serverData.dropArr
    table.walk(arr, function(k, v)
      local info = dropWayInfo.New()
      info:ParseData(v)
      table.insert(self.dropArr, info)
    end)
  end
  if serverData.dayGroupCurNum then
    self.dayGroupCurNum = serverData.dayGroupCurNum
  end
  if serverData.dayGroupLimit then
    self.dayGroupLimit = serverData.dayGroupLimit
  end
  if serverData.serverTime then
    self.serverTime = serverData.serverTime
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshLimitedDropWayNum)
end

local function RefreshDropNumData(self, serverData)
  if serverData.dayGroupCurNum then
    self.dayGroupCurNum = serverData.dayGroupCurNum
  end
  if serverData.dayGroupLimit then
    self.dayGroupLimit = serverData.dayGroupLimit
  end
  if serverData.serverTime then
    self.serverTime = serverData.serverTime
  end
  if serverData.itemId then
    self.itemId = serverData.itemId
  end
end

local function GetDropInfoById(self, templateId)
  if self.dropArr then
    for k, v in pairs(self.dropArr) do
      if v.dropTemplateId == templateId then
        return v
      end
    end
  end
end

local function GetCurAndMax(self)
  return self.dayGroupCurNum, self.dayGroupLimit
end

local function GetDataAddServerTime(self)
  return self.serverTime
end

local function GetCurValue(self)
  return self.dayGroupCurNum or 0
end

ActLimitedTimeFeastServerData.__init = __init
ActLimitedTimeFeastServerData.__delete = __delete
ActLimitedTimeFeastServerData.RefreshActDetailData = RefreshActDetailData
ActLimitedTimeFeastServerData.GetDropInfoById = GetDropInfoById
ActLimitedTimeFeastServerData.GetCurAndMax = GetCurAndMax
ActLimitedTimeFeastServerData.GetDataAddServerTime = GetDataAddServerTime
ActLimitedTimeFeastServerData.RefreshDropNumData = RefreshDropNumData
ActLimitedTimeFeastServerData.GetCurValue = GetCurValue
return ActLimitedTimeFeastServerData
