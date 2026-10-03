local LWAllianceLeaveTipsTemplate = BaseClass("LWAllianceLeaveTipsTemplate")

function LWAllianceLeaveTipsTemplate:__init()
  self.id = 0
  self.icon = ""
  self.time = 0
  self.desc = ""
  self.type = 0
  self.para1 = ""
  self.splitAfterPara1 = {}
  self.para2 = ""
  self.activityTipShowTimeRange = {}
end

function LWAllianceLeaveTipsTemplate:__delete()
  self.id = nil
  self.icon = nil
  self.time = nil
  self.desc = nil
  self.type = nil
  self.para1 = nil
  self.splitAfterPara1 = nil
end

function LWAllianceLeaveTipsTemplate:Init(row)
  self.id = row:getValue("id") or 0
  self.icon = row:getValue("icon") or ""
  self.time = row:getValue("time") or 0
  self.desc = row:getValue("desc") or ""
  self.type = row:getValue("type") or 0
  self.para1 = row:getValue("para1") or ""
  self.para2 = row:getValue("para2") or ""
end

function LWAllianceLeaveTipsTemplate:IsUnlock()
  if self.type == AllianceLeaveTipsUnlockConditionType.None then
    return true
  elseif self.type == AllianceLeaveTipsUnlockConditionType.Activity then
    local activityDataList = DataCenter.ActivityListDataManager:GetActivityDataByType(tonumber(self.para1))
    for i = 1, table.count(activityDataList) do
      local activityData = activityDataList[i]
      if activityData and activityData:IsValid() and self:CheckIsShowActivity() then
        return true
      end
    end
  elseif self.type == AllianceLeaveTipsUnlockConditionType.SeasonDayRange then
    self:GetSplitAfterPara1()
    local seasonNum = SeasonUtil.GetSeason()
    local seasonDay = SeasonUtil.GetSeasonDay()
    for j = 1, table.count(self.splitAfterPara1) do
      local param = self.splitAfterPara1[j]
      if param.season == seasonNum and seasonDay >= param.startDay and seasonDay <= param.endDay then
        return true
      end
    end
  elseif self.type == AllianceLeaveTipsUnlockConditionType.ZoneMobilization then
    return DataCenter.LWZoneMobilizationManager:IsActivityOpen()
  elseif self.type == AllianceLeaveTipsUnlockConditionType.ServerOpenWeak then
    local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
    local openServerWeek = math.ceil(openServerDay / 7)
    if openServerWeek >= tonumber(self.para1) and self:CheckIsShowActivity() then
      return true
    end
  end
  return false
end

function LWAllianceLeaveTipsTemplate:GetSplitAfterPara1()
  if table.count(self.splitAfterPara1) == 0 and self.type == AllianceLeaveTipsUnlockConditionType.SeasonDayRange then
    local strArr = string.split(self.para1, "|")
    local count = table.count(strArr)
    for i = 1, count do
      local str = strArr[i]
      local arr = string.split(str, ";")
      if table.count(arr) == 3 then
        local param = {}
        param.season = tonumber(arr[1])
        param.startDay = tonumber(arr[2])
        param.endDay = tonumber(arr[3])
        table.insert(self.splitAfterPara1, param)
      end
    end
  end
  return self.splitAfterPara1
end

function LWAllianceLeaveTipsTemplate:CheckIsShowActivity()
  if string.IsNullOrEmpty(self.para2) then
    return true
  end
  local tRange = self:GetActivityTipShowTimeRange()
  if table.count(tRange) ~= 2 then
    return false
  end
  local nStartWeekIndex = tRange[1].nWeekIndex
  local nStartHour = tRange[1].nHour
  local nEndWeekIndex = tRange[2].nWeekIndex
  local nEndHour = tRange[2].nHour
  if nStartWeekIndex < 1 or 7 < nStartWeekIndex or nStartWeekIndex > nEndWeekIndex then
    return false
  end
  if nStartHour < 0 or 24 < nStartHour or nEndHour < 0 or 24 < nEndHour then
    return false
  end
  local nNow = UITimeManager:GetInstance():GetServerTime()
  local nWeekZeroTime = UITimeManager:GetInstance():WeekZero()
  local nStartTime = nWeekZeroTime + self:CalculatingAddTimestampVal(nStartWeekIndex, nStartHour)
  local nEndTime = nWeekZeroTime + self:CalculatingAddTimestampVal(nEndWeekIndex, nEndHour)
  local bIsDuringTime = nNow > nStartTime and nNow < nEndTime
  return bIsDuringTime
end

function LWAllianceLeaveTipsTemplate:CalculatingAddTimestampVal(nWeekIndex, nHour)
  return ((nWeekIndex - 1) * OneDayTime + nHour * OneHourTime) * 1000
end

function LWAllianceLeaveTipsTemplate:GetActivityTipShowTimeRange()
  if table.count(self.activityTipShowTimeRange) == 0 then
    local strArr = string.split(self.para2, "|")
    for i, v in ipairs(strArr) do
      local tTimeRange = string.split(v, ";")
      local tTime = {}
      tTime.nWeekIndex = tonumber(tTimeRange[1]) or 1
      tTime.nHour = tonumber(tTimeRange[2]) or 0
      table.insert(self.activityTipShowTimeRange, tTime)
    end
  end
  return self.activityTipShowTimeRange
end

return LWAllianceLeaveTipsTemplate
