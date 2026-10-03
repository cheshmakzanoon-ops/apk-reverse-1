local LWUIWorldTrendCtrl = BaseClass("LWUIWorldTrendCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIWorldTrend)
end

local function GetAllDayInfoList()
  return DataCenter.LWWorldTrendDataManager:GetAllDataInfo()
end

local function GetDayList()
  return DataCenter.LWWorldTrendDataManager:GetAllDayTop()
end

local function GetDayIndex(id)
  local data = DataCenter.LWWorldTrendDataManager:GetDataById(id)
  local dayInfoDic = DataCenter.LWWorldTrendDataManager:GetDayInfoDic()
  local dayList = GetDayList()
  local index = 1
  for i = 1, #dayList do
    if dayList[i] == data.startDay then
      return index
    else
      index = index + #dayInfoDic[dayList[i]]
    end
  end
  return index
end

local function GetTitleName()
  return DataCenter.LWWorldTrendDataManager:GetcurEventName()
end

local function GetWorldTrendIsEnd()
  return DataCenter.LWWorldTrendDataManager:GetIsEndEvent()
end

local function GetCurDay()
  return DataCenter.LWWorldTrendDataManager:GetCurEvent()
end

local function GetIndexByDay(day, seasonId)
  local allDayInfos = GetAllDayInfoList()
  for i = 1, #allDayInfos do
    if seasonId then
      if allDayInfos[i].startDay == day and allDayInfos[i].seasonId == seasonId then
        return i
      end
    elseif allDayInfos[i].startDay == day then
      return i
    end
  end
end

local function GetTitleDays()
  local days = 0
  local season = DataCenter.LWWorldTrendDataManager:GetCurSeasonId()
  if season ~= 0 then
    local seasonStartTime = DataCenter.LWWorldTrendDataManager:GetCurSeasonStartTime()
    days = math.ceil(UITimeManager:GetInstance():GetBetweenDaysForSeason(seasonStartTime))
  else
    days = math.ceil(UITimeManager:GetInstance():GetServerOpenDays())
  end
  local titleStr = Localization:GetString("moribaye_S" .. season)
  local dayStr = Localization:GetString("moribaye_day")
  local str = "<color=#FFFFFF>%s</color>"
  if Localization:GetLanguage() == Language.German then
    str = "<color=#FFFFFF>%s.</color>"
  end
  local daysStr = string.format(str, days)
  return titleStr .. " " .. daysStr .. " " .. dayStr
end

LWUIWorldTrendCtrl.CloseSelf = CloseSelf
LWUIWorldTrendCtrl.GetAllDayInfoList = GetAllDayInfoList
LWUIWorldTrendCtrl.GetDayIndex = GetDayIndex
LWUIWorldTrendCtrl.GetDayList = GetDayList
LWUIWorldTrendCtrl.GetIndexByDay = GetIndexByDay
LWUIWorldTrendCtrl.GetTitleName = GetTitleName
LWUIWorldTrendCtrl.GetWorldTrendIsEnd = GetWorldTrendIsEnd
LWUIWorldTrendCtrl.GetCurDay = GetCurDay
LWUIWorldTrendCtrl.GetTitleDays = GetTitleDays
return LWUIWorldTrendCtrl
