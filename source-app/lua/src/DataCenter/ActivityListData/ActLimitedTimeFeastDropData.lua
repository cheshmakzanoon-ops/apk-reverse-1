local ActLimitedTimeFeastDropData = BaseClass("ActLimitedTimeFeastDropData")
local ActLimitedTimeFeastDropDayData = require("DataCenter.ActivityListData.ActLimitedTimeFeastDropDayData")

local function __init(self)
  self.activityId = 0
  self.typeDataDic = nil
  self.typeDayArrDic = nil
  self.limitDataDic = nil
end

local function __delete(self)
  self.activityId = nil
  self.typeDataDic = nil
  self.typeDayArrDic = nil
  self.limitDataDic = nil
end

function ActLimitedTimeFeastDropData:UpdateData(t)
  local type = t.type and toInt(t.type) or 1
  self.typeDataDic = self.typeDataDic or {}
  local dropDayDataDic = self.typeDataDic[type]
  if not dropDayDataDic then
    dropDayDataDic = {}
    self.typeDataDic[type] = dropDayDataDic
  end
  self.activityId = toInt(t.activityId)
  self.typeDayArrDic = self.typeDayArrDic or {}
  local typeDayArr = t.dayArr or {}
  self.typeDayArrDic[type] = typeDayArr
  self.limitDataDic = self.limitDataDic or {}
  local limitData = self.limitDataDic[type]
  if not limitData then
    limitData = {}
    self.limitDataDic[type] = limitData
  end
  limitData.curDropVal = toInt(t.dayGroupCurNum)
  limitData.curDropLimit = toInt(t.dayGroupLimit)
  for _, dayIndex in ipairs(typeDayArr) do
    local dayDropData = dropDayDataDic[dayIndex]
    if not dayDropData then
      dayDropData = ActLimitedTimeFeastDropDayData.New()
      dayDropData:Init(self.activityId, dayIndex)
      dropDayDataDic[dayIndex] = dayDropData
    end
    if dayIndex == t.day and t.dataArr then
      dayDropData:UpdateDetailData(t)
    end
  end
end

function ActLimitedTimeFeastDropData:GetSortDayList(type)
  local typeDayArr = self.typeDayArrDic[type]
  if not typeDayArr then
    return {}
  end
  local ret = DeepCopy(typeDayArr)
  table.sort(ret, function(a, b)
    return b < a
  end)
  return ret
end

function ActLimitedTimeFeastDropData:GetAllDayHistoryData(type, expandDayDic)
  local ret = {}
  local dayArr = self:GetSortDayList(type)
  local prevTitleShowData
  local dropDayDataDic = self.typeDataDic[type]
  if not dropDayDataDic then
    return ret
  end
  local isFullToday = false
  local limitData = self.limitDataDic[type]
  if limitData then
    isFullToday = limitData.curDropVal >= limitData.curDropLimit
  end
  for index, dayIndex in ipairs(dayArr) do
    local isExpand = expandDayDic[dayIndex]
    local data = dropDayDataDic[dayIndex]
    if data then
      local isShowDetailInfo = isExpand
      local lastDayIndex = self:GetCurActDayIndex()
      local isFirst = dayIndex == lastDayIndex
      local isShowLimitInfo = false
      if isFirst then
        isShowLimitInfo = isFullToday
      else
        isShowLimitInfo = isShowDetailInfo
      end
      if type == LimitDropHistoryTabType.PayDrop then
        isShowLimitInfo = false
      end
      local infoList = data:GetDayShowDataList(type, isShowDetailInfo, isShowLimitInfo and isExpand)
      for k2, v in ipairs(infoList) do
        table.insert(ret, v)
      end
      local curTitleShowData
      if infoList and 0 < #infoList then
        curTitleShowData = infoList[1]
      end
      if prevTitleShowData then
        prevTitleShowData.nextTitleShowData = curTitleShowData
      end
      prevTitleShowData = curTitleShowData
    end
  end
  return ret
end

function ActLimitedTimeFeastDropData:GetLastDayIndex(type)
  local sortDayArr = self:GetSortDayList(type)
  if not sortDayArr or #sortDayArr < 1 then
    return 1
  end
  return sortDayArr[1]
end

function ActLimitedTimeFeastDropData:GetCurActDayIndex()
  return DataCenter.ActivityListDataManager:GetCurActDayIndex(self.activityId)
end

ActLimitedTimeFeastDropData.__init = __init
ActLimitedTimeFeastDropData.__delete = __delete
return ActLimitedTimeFeastDropData
