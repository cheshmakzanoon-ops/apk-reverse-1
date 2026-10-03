local ActLimitedTimeFeastDropDayData = BaseClass("ActLimitedTimeFeastDropDayData")
local LimitDropHistoryShowData = require("UI.UILimitDropHistory.Data.LimitDropHistoryShowData")

local function __init(self)
  self.activityId = 0
  self.dayIndex = 0
  self.dropCount = 0
  self.dropLimitCount = 0
  self.dropDataDic = nil
  self.dropDataList = nil
end

local function __delete(self)
  self.activityId = nil
  self.dayIndex = nil
  self.dropCount = nil
  self.dropLimitCount = nil
  self.dropDataDic = nil
  self.dropDataList = nil
end

function ActLimitedTimeFeastDropDayData:Init(activityId, dayIndex)
  self.activityId = activityId
  self.dayIndex = dayIndex
end

function ActLimitedTimeFeastDropDayData:UpdateDetailData(t)
  self.dropDataDic = self.dropDataDic or {}
  self.dropDataList = self.dropDataList or {}
  self.dropCount = toInt(t.dayGroupCurNum)
  self.dropLimitCount = toInt(t.dayGroupLimit)
  if t.dataArr then
    for _, v in ipairs(t.dataArr) do
      local uuid = v.uuid
      local data = self.dropDataDic[uuid]
      if not data then
        data = {}
        self.dropDataDic[uuid] = data
        table.insert(self.dropDataList, data)
      end
      data.uuid = v.uuid
      data.time = v.time
      data.content = v.content
    end
  end
end

function ActLimitedTimeFeastDropDayData:GetDayShowDataList(type, isIncludeDetail, isIncludeLimit)
  local ret = {}
  local titleShowData = LimitDropHistoryShowData.New()
  local titleData = {}
  titleData.activityId = self.activityId
  titleData.dayIndex = self.dayIndex
  titleData.expandState = isIncludeDetail
  titleShowData:UpdateData(LimitDropHistoryItemType.DayTitleItem, titleData)
  table.insert(ret, titleShowData)
  if isIncludeDetail then
    if self.dropDataList then
      local detailDataList = DeepCopy(self.dropDataList)
      table.sort(detailDataList, function(a, b)
        return a.time < b.time
      end)
      for _, v in ipairs(detailDataList) do
        local detailShowData = LimitDropHistoryShowData.New()
        detailShowData:UpdateData(LimitDropHistoryItemType.DropInfo, v)
        detailShowData.fromTitleData = titleShowData
        detailShowData.dropType = type
        detailShowData.activityId = self.activityId
        table.insert(ret, detailShowData)
      end
    else
      DataCenter.ActLimitedTimeFeastData:ReqActivityDropHistory(self.activityId, self.dayIndex, type)
    end
  end
  if isIncludeLimit and self.dropCount and self.dropLimitCount then
    local limitShowData = LimitDropHistoryShowData.New()
    local limitData = {}
    limitData.dropCount = self.dropCount
    limitData.dropLimitCount = self.dropLimitCount
    limitData.time = 0
    if ret and 0 < #ret and ret[#ret] and ret[#ret].data.time then
      limitData.time = UITimeManager:GetInstance():GetTodayZero() + OneDayTime * 1000 - 1000
    end
    limitShowData:UpdateData(LimitDropHistoryItemType.DropLimit, limitData)
    table.insert(ret, limitShowData)
  end
  return ret
end

function ActLimitedTimeFeastDropDayData:IsArrivedMaxLimit()
  return self.dropCount >= self.dropLimitCount
end

ActLimitedTimeFeastDropDayData.__init = __init
ActLimitedTimeFeastDropDayData.__delete = __delete
return ActLimitedTimeFeastDropDayData
