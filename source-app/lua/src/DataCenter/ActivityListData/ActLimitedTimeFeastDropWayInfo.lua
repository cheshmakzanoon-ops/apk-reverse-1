local ActLimitedTimeFeastDropWayInfo = BaseClass("ActLimitedTimeFeastDropWayInfo")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.dropTemplateId = 0
  self.itemsInfo = {}
end

local function __delete(self)
  self.dropTemplateId = nil
  self.itemdInfo = nil
end

local function UpdateItemInfo(self, itemInfo)
  if not itemInfo then
    return
  end
  local itemId = itemInfo.itemId
  for k, v in pairs(self.itemsInfo) do
    if v.itemId == itemId then
      v.curNum = itemInfo.curNum
      v.maxNum = itemInfo.maxNum
      return
    end
  end
  local info = {}
  info.itemId = itemId
  info.curNum = itemInfo.curNum
  info.maxNum = itemInfo.maxNum
  table.insert(self.itemsInfo, info)
end

local function ParseData(self, serverData)
  if not serverData then
    return
  end
  if serverData.id then
    self.dropTemplateId = serverData.id
  end
  if not table.IsNullOrEmpty(serverData.drops) then
    for _, v in pairs(serverData.drops) do
      UpdateItemInfo(self, v)
    end
  end
end

local function GetItemInfoCSArray(self)
  if table.IsNullOrEmpty(self.itemsInfo) then
    return nil
  end
  local itemInfoArray = {}
  for k, v in pairs(self.itemsInfo) do
    table.insert(itemInfoArray, v.curNum)
  end
  return table.unpack(itemInfoArray)
end

ActLimitedTimeFeastDropWayInfo.__init = __init
ActLimitedTimeFeastDropWayInfo.__delete = __delete
ActLimitedTimeFeastDropWayInfo.ParseData = ParseData
ActLimitedTimeFeastDropWayInfo.GetItemInfoCSArray = GetItemInfoCSArray
return ActLimitedTimeFeastDropWayInfo
