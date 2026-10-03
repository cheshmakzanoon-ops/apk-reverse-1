local WEEK_MILLISECOND = 604800000
local DAY_MILLISECOND = 86400000
local UITimeManager = BaseClass("UITimeManager", Singleton)
local Localization = CS.GameEntry.Localization
local socket = require("socket")
local Timer = CS.GameEntry.Timer

local function __init(self)
  self.serverDeltaTime = 0
  self.changeDeltaTime = -7200000
  self.serverTimeFromCS = nil
  self.uploadLocalUTCOffset = nil
  self.debugOffsetSec = 0
end

local function __delete(self)
  self.serverDeltaTime = nil
  self.changeDeltaTime = nil
  self.serverTimeFromCS = nil
  self.uploadLocalUTCOffset = nil
  self.debugOffsetSec = 0
end

local function UpdateServerMsDeltaTime(self, ms)
  local nowTime = socket.gettime() * 1000
  self.serverDeltaTime = ms - nowTime
end

local function UpdateServerTimeFromCS(self, serverTime)
  self.serverTimeFromCS = serverTime
end

local function UpdateClientSwitch(self)
end

local function GetDebugOffsetSec(self)
  return self.debugOffsetSec or 0
end

local function SetDebugOffsetSec(self, sec, isAdd)
  if isAdd then
    self.debugOffsetSec = (self.debugOffsetSec or 0) + sec
  else
    self.debugOffsetSec = sec
  end
end

local function GetServerTime(self)
  if self.serverTimeFromCS ~= nil then
    return self.serverTimeFromCS + self:GetDebugOffsetSec() * 1000
  else
    local nowTime = socket.gettime() * 1000
    return nowTime + self.serverDeltaTime + self:GetDebugOffsetSec() * 1000
  end
end

local function GetServerSeconds(self)
  local time = math.modf(self:GetServerTime() / 1000)
  return time
end

local function TimeStampToTimeForServer(self, timeStamp, withoutYMD)
  local time = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  if withoutYMD then
    return string.format("%02d:%02d:%02d", format.hour, format.min, format.sec)
  elseif Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%d-%d %02d:%02d:%02d", format.day, format.month, format.year, format.hour, format.min, format.sec)
  else
    return string.format("%d-%d-%d %02d:%02d:%02d", format.year, format.month, format.day, format.hour, format.min, format.sec)
  end
end

function UITimeManager:TimeStampToTimeForServerMDHM(timeStamp)
  local time = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%d %02d:%02d", format.day, format.month, format.hour, format.min)
  else
    return string.format("%d-%d %02d:%02d", format.month, format.day, format.hour, format.min)
  end
end

function UITimeManager:TimeStampToTimeForServerMD(timeStamp)
  local time = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%d", format.day, format.month)
  else
    return string.format("%d-%d", format.month, format.day)
  end
end

local function TimeStampToTimeForServerMinute(self, timeStamp, withoutYMD)
  local time = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  if withoutYMD then
    return string.format("%02d:%02d", format.hour, format.min)
  elseif Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%d-%d %02d:%02d", format.day, format.month, format.year, format.hour, format.min)
  else
    return string.format("%d-%d-%d %02d:%02d", format.year, format.month, format.day, format.hour, format.min)
  end
end

local function TimeStampToTimeForServerSimple(self, timeStamp, withoutSec)
  local time = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  if withoutSec then
    return string.format("%02d:%02d", format.hour, format.min)
  else
    return string.format("%02d:%02d:%02d", format.hour, format.min, format.sec)
  end
end

local function TimeStampToTimeForServerOnlyHour(self, timeStamp)
  local time = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  local format_time = string.format("%02d", format.hour)
  return format_time
end

local function TimeStampToServerDate(self, timeStamp)
  local time = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  return format
end

local function TimeStampToServerTime(self, timeStamp)
  local format = self:TimeStampToServerDate(timeStamp)
  return format.year, format.month, format.day, format.hour, format.min
end

local function TimeSecToServerDate(self, timeSec)
  local time = math.modf(timeSec + self.changeDeltaTime / 1000)
  local format = os.date("!*t", time)
  return format
end

local function TimeSecToLocalDate(self, timeSec)
  local format = os.date("*t", timeSec)
  return format
end

local function TimeStampToLocalDate(self, timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("*t", time)
  return format
end

local function TimeStampToLocalTime(self, timeStamp)
  local format = self:TimeStampToLocalDate(timeStamp)
  return format.year, format.month, format.day, format.hour, format.min
end

local function TimeStampToDayForLocal(self, timeStamp)
  local time = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d/%d/%d", format.day, format.month, format.year)
  else
    return string.format("%d/%d/%d", format.year, format.month, format.day)
  end
end

local function TimeStampToDayTbForLocal(self, timeStamp)
  local time = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  return format.year, format.month, format.day
end

local function TimeStampToTimeForLocal(self, timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("*t", time)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%d-%d %02d:%02d:%02d", format.day, format.month, format.year, format.hour, format.min, format.sec)
  else
    return string.format("%d-%d-%d %02d:%02d:%02d", format.year, format.month, format.day, format.hour, format.min, format.sec)
  end
end

local function TimeStampToTimeForLocalSimple(self, timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("*t", time)
  local format_time = string.format("%02d:%02d:%02d", format.hour, format.min, format.sec)
  return format_time
end

local function TimeStampToTimeForLocalMinute(self, timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("*t", time)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%d-%d %02d:%02d", format.day, format.month, format.year, format.hour, format.min)
  else
    return string.format("%d-%d-%d %02d:%02d", format.year, format.month, format.day, format.hour, format.min)
  end
end

local function TimeStampToTimeForLocalMinuteCommon(self, timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("*t", time)
  local format_time = Localization:GetString("season_s1_rank_reward_3", format.month, format.day, string.format("%02d:%02d", format.hour, format.min))
  return format_time
end

local function TimeStampToMD(self, second)
  local format = os.date("*t", second)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%0d-%0d", format.day, format.month)
  else
    return string.format("%0d-%0d", format.month, format.day)
  end
end

function UITimeManager:TimeStampToMDForServer(second)
  local format = os.date("!*t", second + self.changeDeltaTime / 1000)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%0d-%0d", format.day, format.month)
  else
    return string.format("%0d-%0d", format.month, format.day)
  end
end

local function GetTimeToMD(self, second)
  local format = os.date("!*t", second + self.changeDeltaTime / 1000)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%0d-%0d", format.day, format.month, format.year)
  else
    return string.format("%d-%0d-%0d", format.year, format.month, format.day)
  end
end

local function GetTimeToHHMM(self, second)
  local format = os.date("!*t", second + self.changeDeltaTime / 1000)
  return string.format("%02d:%02d", format.hour, format.min)
end

local function GetTimeFromServerToHHMMSS(self, second, toLocal)
  local format
  if toLocal then
    format = os.date("*t", second - self.changeDeltaTime / 1000)
  else
    format = os.date("!*t", second)
  end
  return string.format("%02d:%02d:%02d", format.hour, format.min, format.sec)
end

local function GetTimeToLocalYMD(self, serverTimeStamp)
  local time = math.modf(serverTimeStamp / 1000)
  local format = os.date("*t", time)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%0d-%0d", format.day, format.month, format.year)
  else
    return string.format("%d-%0d-%0d", format.year, format.month, format.day)
  end
end

local function GetTimeToServerYMD(self, serverTimeStamp)
  local time = math.modf(serverTimeStamp / 1000 + self.changeDeltaTime / 1000)
  local format = os.date("!*t", time)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%0d-%0d", format.day, format.month, format.year)
  else
    return string.format("%d-%0d-%0d", format.year, format.month, format.day)
  end
end

local function GetTimeToLocalHHMM(self, serverTimeStamp)
  local time = math.modf(serverTimeStamp / 1000)
  local format = os.date("*t", time)
  return string.format("%02d:%02d", format.hour, format.min)
end

local function GetTimeToServerHHMM(self, serverTimeStamp)
  local time = math.modf(serverTimeStamp / 1000 + self.changeDeltaTime / 1000)
  local format = os.date("!*t", time)
  return string.format("%02d:%02d", format.hour, format.min)
end

local function SecondToFmtString(self, secs)
  local temp = ""
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  if secs >= OneDayTime then
    temp = string.format("%dd\194\160%02d:%02d:%02d", day, hour, minute, second)
  else
    temp = string.format("%02d:%02d:%02d", hour, minute, second)
  end
  return temp
end

local function MilliSecondToFmtStringWithoutSecond(self, milliSecond)
  local secs, delta = math.modf(milliSecond / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  local temp = ""
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  if secs >= OneDayTime then
    temp = string.format("%dd\194\160%02d:%02d", day, hour, minute)
  else
    temp = string.format("%02d:%02d", hour, minute)
  end
  return temp
end

local function SecondToFmtStringWithoutDay(self, secs)
  local temp = ""
  local hour = math.modf(secs / 3600)
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  temp = string.format("%02d:%02d:%02d", hour, minute, second)
  return temp
end

local function SecondToFmtStringWithoutHour(self, secs)
  local temp = ""
  local minute = math.modf(secs / 60)
  local second = math.floor(secs % 60)
  temp = string.format("%02d:%02d", minute, second)
  return temp
end

local function SecondToFmtStringHM(self, secs)
  local temp = ""
  local hour = math.modf(secs / 3600)
  local minute = math.modf(secs / 60) % 60
  temp = string.format("%02d:%02d", hour, minute)
  return temp
end

local function MilliSecondToFmtString(self, milliSecond)
  if milliSecond == nil or milliSecond == 0 or milliSecond < 0 then
    return "00:00:00"
  end
  local secs, delta = math.modf(milliSecond / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  return self:SecondToFmtString(secs)
end

local function MilliSecondToFmtStringFloor(self, milliSecond)
  if milliSecond == nil or milliSecond == 0 or milliSecond < 0 then
    return "00:00:00"
  end
  local secs = milliSecond / 1000
  return self:SecondToFmtString(secs)
end

local function MilliSecondToFmtFormat(self, milliSecond)
  if milliSecond == nil or milliSecond == 0 or milliSecond < 0 then
    return 0, 0, 0, 0
  end
  local secs, delta = math.modf(milliSecond / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  return day, hour, minute, second
end

local function MillisionSecToWeekCardFormat(self, millisionSec)
  local secs, delta = math.modf(millisionSec / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  local temp = ""
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  if secs >= OneDayTime then
    local strDay = Localization:GetString("100104")
    temp = Localization:GetString("320486", string.format("%d%s\194\160%s:%02d:%02d", day, strDay, hour, minute, second))
  else
    temp = Localization:GetString("320486", string.format("%02d:%02d:%02d", hour, minute, second))
  end
  return temp
end

local function MilliSecondToFmtStringWithoutDay(self, milliSecond)
  local secs, delta = math.modf(milliSecond / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  return self:SecondToFmtStringWithoutDay(secs)
end

local function MilliSecondToFmtStringWithoutHour(self, milliSecond)
  local secs, delta = math.modf(milliSecond / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  return self:SecondToFmtStringWithoutHour(secs)
end

local function MilliSecondToFmtStringSpecial(self, milliSecond)
  local secs, delta = math.modf(milliSecond / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  local temp = ""
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  if 1 <= day then
    if 0 < hour then
      temp = string.format("%dd%dh", day, hour)
    else
      temp = string.format("%dd", day)
    end
  elseif 1 <= hour then
    if 0 < minute then
      temp = string.format("%dh%dm", hour, minute)
    else
      temp = string.format("%dh", hour)
    end
  elseif 1 <= minute then
    if 0 < second then
      temp = string.format("%dm%ds", minute, second)
    else
      temp = string.format("%dm", minute)
    end
  else
    temp = string.format("%ds", second)
  end
  return temp
end

local function SecondToFmtStringForCountdown(self, secs)
  local temp = ""
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600)
  local minute = math.modf(secs / 60)
  local second = math.floor(secs)
  if 1 <= day then
    temp = string.format("%dd", day)
  elseif 1 <= hour then
    temp = string.format("%dh", hour)
  elseif 1 <= minute then
    temp = string.format("%dmin", minute)
  else
    temp = string.format("%ds", second)
  end
  return temp
end

local function GetDateNum(timeNow, timeNext)
  local ret = 0
  timeNow = math.modf(timeNow / 1000)
  timeNext = math.modf(timeNext / 1000)
  if timeNow and timeNext then
    local now = os.date("*t", timeNow)
    local next = os.date("*t", timeNext)
    if now and next then
      local num1 = SafeLocalOsTime({
        year = now.year,
        month = now.month,
        day = now.day
      })
      local num2 = SafeLocalOsTime({
        year = next.year,
        month = next.month,
        day = next.day
      })
      if num1 and num2 then
        ret = math.abs(num1 - num2) / 86400
      end
    end
  end
  return ret
end

local function SecondToFmtStringForCountdownByDialog(self, secs)
  local temp = ""
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600)
  local minute = math.modf(secs / 60)
  local second = math.floor(secs)
  if 1 <= day then
    temp = day .. " " .. Localization:GetString("100104")
  elseif 1 <= hour then
    temp = hour .. " " .. Localization:GetString("100166")
  elseif 1 <= minute then
    temp = minute .. " " .. Localization:GetString("100165")
  else
    temp = Localization:GetString("130076", second)
  end
  return temp
end

local function MilliSecondToFmtStringForCountdown(self, milliSecond)
  local secs, delta = math.modf(milliSecond / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  return self:SecondToFmtStringForCountdown(secs)
end

local function GetResSecondsTo24(self)
  return OneDayTime - (self:GetServerSeconds() + self.changeDeltaTime / 1000) % OneDayTime
end

local function GetTodayZeroServerTime(self, timeStampSec)
  return timeStampSec - (timeStampSec + self.changeDeltaTime / 1000) % OneDayTime
end

local function GetNextDayMs(self)
  local nextZero = self:GetServerSeconds() + self:GetResSecondsTo24()
  return nextZero * 1000
end

function UITimeManager:GetTodayZero()
  local now = self:GetServerTime()
  return now - (now + self.changeDeltaTime) % 86400000
end

function UITimeManager:GetZeroTime(serverTimeStamp)
  return serverTimeStamp - (serverTimeStamp + self.changeDeltaTime) % 86400000
end

function UITimeManager:GetTomorrowZero()
  local now = self:GetServerTime()
  return now - (now + self.changeDeltaTime) % 86400000 + 86400000
end

function UITimeManager:GetNextZero(ts)
  return ts - (ts + self.changeDeltaTime) % 86400000 + 86400000
end

function UITimeManager:GetFutureDayZero(ts, day)
  return ts - (ts + self.changeDeltaTime) % 86400000 + 86400000 * day
end

local function IsSameDayForServer(self, sec1, sec2)
  if math.abs(sec1 - sec2) > 86400 then
    return false
  end
  sec1 = sec1 + self.changeDeltaTime / 1000
  sec2 = sec2 + self.changeDeltaTime / 1000
  sec1 = math.floor(sec1)
  sec2 = math.floor(sec2)
  local s1 = tonumber(os.date("!%Y%m%d", sec1))
  local s2 = tonumber(os.date("!%Y%m%d", sec2))
  if s1 == s2 then
    return true
  end
  return false
end

local function IsSameDayForLocal(self, sec1, sec2)
  if math.abs(sec1 - sec2) > 86400 then
    return false
  end
  local s1 = tonumber(os.date("%Y%m%d", sec1))
  local s2 = tonumber(os.date("%Y%m%d", sec2))
  if s1 == s2 then
    return true
  end
  return false
end

local function SecondToClock(self, secs)
  local temp = ""
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  temp = string.format("%02d %02d", hour, minute)
  return temp
end

local function MilliSecondToClock(self, milliSecond)
  local secs, delta = math.modf(milliSecond / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  return self:SecondToClock(secs)
end

local function GetChatShowTime(self, second)
  local _curServerTime = GetServerSeconds(self)
  if IsSameDayForLocal(self, _curServerTime, second) then
    return os.date("%H:%M", second)
  end
  return os.date("%m-%d %H:%M", second)
end

local function GetNewsDateTime(self, second)
  return os.date("%m-%d %H:%M", second)
end

local function GetMailShowTime(self, second)
  local _createTime = second / 1000
  local _curTime = self:GetServerSeconds()
  local _deltaTime = _curTime - _createTime
  local _oneHour = 3600
  local _oneDay = _oneHour * 24
  local _oneMonth = _oneDay * 30
  if _deltaTime < 60 then
    return Localization:GetString("310105")
  elseif 60 <= _deltaTime and _deltaTime < _oneHour then
    return Localization:GetString("310107", _deltaTime // 60)
  elseif _deltaTime >= _oneHour and _deltaTime < _oneDay then
    return Localization:GetString("310108", _deltaTime // _oneHour)
  elseif _deltaTime >= _oneDay and _deltaTime < _oneMonth then
    return Localization:GetString("310109", _deltaTime // _oneDay)
  else
    return self:TimeStampToMD(Mathf.Floor(_createTime))
  end
end

local function TodayZero(self)
  return (LuaEntry.GlobalData.tomorrow - OneDayTime) * 1000
end

local function IsToday(self, ts)
  return ts > self:TodayZero() and ts < LuaEntry.GlobalData.tomorrow * 1000
end

local function IsTodayServer(self, ts)
  local todayZeroServer = self:GetTodayZero()
  return ts > todayZeroServer and ts < todayZeroServer + OneDayTime * 1000
end

local function WeekZero(self, curTime)
  local nextWeekZero = self:GetNextWeekDay(1, curTime)
  return nextWeekZero - 7 * OneDayTime * 1000
end

local weekTab = {
  ["0"] = 1,
  ["1"] = 2,
  ["2"] = 3,
  ["3"] = 4,
  ["4"] = 5,
  ["5"] = 6,
  ["6"] = 7
}

local function CheckIfIsSameWeek(self, smallMs)
  local serverT = self:GetServerTime()
  local intervalMs = math.abs(serverT - smallMs)
  if 604800000 < intervalMs then
    return false
  else
    local smallS = math.modf(smallMs / 1000)
    local ServerS = math.modf(serverT / 1000)
    local isSameDay = self:IsSameDayForServer(smallS, ServerS)
    if isSameDay then
      return true
    else
      local weekIndex1 = self:GetWeekdayIndex(smallMs)
      local weekIndex2 = self:GetWeekdayIndex(serverT)
      return weekIndex1 < weekIndex2
    end
  end
end

local function GetWeekdayIndex(self, timeMs)
  local timeStamp = math.modf((timeMs + self.changeDeltaTime) / 1000)
  local newDate = os.date("!*t", timeStamp)
  local weekIndex = self:GetWeekDay(newDate.year, newDate.month, newDate.day)
  return weekIndex
end

local function GetNowWeekdayIndex(self)
  local now = self:GetServerTime()
  return self:GetWeekdayIndex(now)
end

local function GetWeekDay(self, y, m, d)
  if m == 1 or m == 2 then
    m = m + 12
    y = y - 1
  end
  local m1, _ = math.modf(3 * (m + 1) / 5)
  local m2, _ = math.modf(y / 4)
  local m3, _ = math.modf(y / 100)
  local m4, _ = math.modf(y / 400)
  local iWeek = (d + 2 * m + m1 + y + m2 - m3 + m4) % 7
  return weekTab[tostring(iWeek)]
end

local function GetNextWeekDay(self, day, curTime)
  curTime = curTime or self:GetServerTime()
  local curWeekday = self:GetWeekdayIndex(curTime)
  local dayOffset = day + 7 - curWeekday
  local targetDay = curTime + dayOffset * 24 * 3600000
  local targetTs = self:GetTodayZeroServerTime(math.modf(targetDay / 1000))
  return math.modf(targetTs * 1000)
end

local function GetNextMonth(self)
  local curTime = self:GetServerTime()
  local time = math.modf((curTime + self.changeDeltaTime) / 1000)
  local newDate = os.date("!*t", time)
  local oldTime = SafeLocalOsTime(newDate)
  if newDate.month == 12 then
    newDate.year = newDate.year + 1
    newDate.month = 1
  else
    newDate.month = newDate.month + 1
  end
  newDate.day = 1
  newDate.hour = 0
  newDate.min = 0
  newDate.sec = 0
  local nextTime = SafeLocalOsTime(newDate)
  return math.modf((curTime // 1000 + nextTime - oldTime) * 1000)
end

local function GetMonthZero(self)
  local curTime = self:GetServerTime()
  local time = math.modf((curTime + self.changeDeltaTime) / 1000)
  local newDate = os.date("!*t", time)
  local oldTime = SafeLocalOsTime(newDate)
  newDate.day = 1
  newDate.hour = 0
  newDate.min = 0
  newDate.sec = 0
  local nextTime = SafeLocalOsTime(newDate)
  return math.modf((curTime // 1000 + nextTime - oldTime) * 1000)
end

local function GetYearZero(self)
  local curTime = self:GetServerTime()
  local time = math.modf((curTime + self.changeDeltaTime) / 1000)
  local newDate = os.date("!*t", time)
  local oldTime = SafeLocalOsTime(newDate)
  newDate.month = 1
  newDate.day = 1
  newDate.hour = 0
  newDate.min = 0
  newDate.sec = 0
  local nextTime = SafeLocalOsTime(newDate)
  return math.modf((curTime // 1000 + nextTime - oldTime) * 1000)
end

local function GetFormattedTimeMs(self, milliSecond)
  return self:GetFormattedTime(milliSecond / 1000)
end

local function GetFormattedTime(self, second)
  local s = math.floor(second)
  local d = s // 86400
  s = s % 86400
  local h = s // 3600
  s = s % 3600
  local m = s // 60
  s = s % 60
  if 0 < d then
    return Localization:GetString("100036", d, h)
  elseif 0 < h then
    return Localization:GetString("100037", h, m)
  else
    return string.format("%02d:%02d", m, s)
  end
end

local function SetTimezoneOffset(self, offset)
  self.changeDeltaTime = offset
end

local function GetTimezoneOffset(self)
  return self.changeDeltaTime or 0
end

local function GetLocalOffset(self)
  local now = SafeLocalOsTime()
  local local_t = os.date("*t", now)
  local utc_t = os.date("!*t", now)
  local local_s = SafeLocalOsTime({
    year = local_t.year,
    month = local_t.month,
    day = local_t.day,
    hour = local_t.hour,
    min = local_t.min
  })
  local utc_s = SafeLocalOsTime({
    year = utc_t.year,
    month = utc_t.month,
    day = utc_t.day,
    hour = utc_t.hour,
    min = utc_t.min
  })
  local localOffset = os.difftime(local_s, utc_s)
  return localOffset
end

local function GetServerTimeToLocal(self, secondInDay)
  local serverOffset = self.changeDeltaTime / 1000
  local localOffset = GetLocalOffset(self)
  local offset = localOffset - serverOffset
  local newSecondes = secondInDay + offset
  if newSecondes < 0 then
    newSecondes = newSecondes + 86400
  end
  newSecondes = newSecondes % 86400
  return newSecondes
end

local function GetLocalTimeToServerTimestamp(self, localTimestamp)
  local localOffset = GetLocalOffset(self)
  local serverOffset = self.changeDeltaTime / 1000
  local offset = localOffset - serverOffset
  return localTimestamp + offset
end

local function GetResSeoncdsToNextMonday(self)
  local nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = nextWeekDayTime - curTime
  return remainTime / 1000
end

function UITimeManager:GetServerYMDByUTC(serverTimeStamp)
  local time = math.modf((serverTimeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d/%d/%d", format.day, format.month, format.year)
  else
    return string.format("%d/%d/%d", format.year, format.month, format.day)
  end
end

function UITimeManager:GetServerDate(timestamp)
  local format = UITimeManager:GetInstance():TimeStampToServerDate(timestamp)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return format.day, format.month, format.year, format.hour, format.min, format.sec
  else
    return format.year, format.month, format.day, format.hour, format.min, format.sec
  end
end

function UITimeManager:GetServerTimeByUTC(serverTimeStamp, withoutYMD, withoutSec)
  local time = math.modf((serverTimeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", time)
  if withoutYMD then
    if withoutSec then
      return string.format("%02d:%02d", format.hour, format.min)
    else
      return string.format("%02d:%02d:%02d", format.hour, format.min, format.sec)
    end
  elseif withoutSec then
    if Localization:GetLanguage() == Language.PortuguesePortugal then
      return string.format("%d-%d-%d %02d:%02d", format.day, format.month, format.year, format.hour, format.min)
    else
      return string.format("%d-%d-%d %02d:%02d", format.year, format.month, format.day, format.hour, format.min)
    end
  elseif Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%d-%d %02d:%02d:%02d", format.day, format.month, format.year, format.hour, format.min, format.sec)
  else
    return string.format("%d-%d-%d %02d:%02d:%02d", format.year, format.month, format.day, format.hour, format.min, format.sec)
  end
end

function UITimeManager:ConvertServerTimeToLocalTime(serverTimeStamp, withoutYMD, withoutSec)
  if withoutYMD then
    local time = math.modf(serverTimeStamp / 1000)
    local format = os.date("*t", time)
    if withoutSec then
      return string.format("%02d:%02d", format.hour, format.min)
    else
      return string.format("%02d:%02d:%02d", format.hour, format.min, format.sec)
    end
  else
    local time = math.modf(serverTimeStamp / 1000)
    local format = os.date("*t", time)
    if Localization:GetLanguage() == Language.PortuguesePortugal then
      if withoutSec then
        return string.format("%d-%d-%d %02d:%02d", format.day, format.month, format.year, format.hour, format.min)
      else
        return string.format("%d-%d-%d %02d:%02d:%02d", format.day, format.month, format.year, format.hour, format.min, format.sec)
      end
    elseif withoutSec then
      return string.format("%d-%d-%d %02d:%02d", format.year, format.month, format.day, format.hour, format.min)
    else
      return string.format("%d-%d-%d %02d:%02d:%02d", format.year, format.month, format.day, format.hour, format.min, format.sec)
    end
  end
end

local function GetBetweenDaysForServer(self, sec1, sec2)
  local delta = math.abs(sec1 - sec2)
  local x, y = math.modf(delta / 86400)
  return x
end

local function GetBetweenDaysForServerTime(self, sec1, sec2)
  sec1 = math.modf(sec1 + self.changeDeltaTime / 1000)
  sec2 = math.modf(sec2 + self.changeDeltaTime / 1000)
  local format1 = os.date("!*t", sec1)
  local format2 = os.date("!*t", sec2)
  local s1 = sec1 - format1.hour * 3600 - format1.min * 60 - format1.sec
  local s2 = sec2 - format2.hour * 3600 - format2.min * 60 - format2.sec
  local delta = math.abs(s1 - s2)
  local x, y = math.modf(delta / 86400)
  return x
end

local function GetBetweenDaysForSeason(self, sec1)
  local openSeasonTime = sec1
  local openSeasonDayZeroTimeMS = self:GetTodayZeroServerTime(openSeasonTime / 1000) * 1000
  local curTime = self:GetServerTime()
  local curDayZeroTimeMS = self:GetTodayZeroServerTime(curTime / 1000) * 1000
  return (curDayZeroTimeMS - openSeasonDayZeroTimeMS) // 86400000 + 1
end

local function GetBetweenDaysForLocal(self, sec1, sec2)
  sec1 = math.modf(sec1)
  sec2 = math.modf(sec2)
  local format1 = os.date("*t", sec1)
  local format2 = os.date("*t", sec2)
  format1.hour = 0
  format1.min = 0
  format1.sec = 0
  format2.hour = 0
  format2.min = 0
  format2.sec = 0
  local s1 = SafeLocalOsTime(format1)
  local s2 = SafeLocalOsTime(format2)
  local delta = math.abs(s1 - s2)
  local x, y = math.modf(delta / 86400)
  return x
end

local function GetOpenServerDay(self)
  local openServerTime = LuaEntry.Player.openServerTime
  local openServerDayZeroTimeMS = self:GetTodayZeroServerTime(openServerTime / 1000) * 1000
  local curTime = self:GetServerTime()
  local curDayZeroTimeMS = self:GetTodayZeroServerTime(curTime / 1000) * 1000
  return (curDayZeroTimeMS - openServerDayZeroTimeMS) // 86400000 + 1
end

local function GetOpenServerDayByOpenServerZero(self)
  local openServerTime = LuaEntry.Player.openServerTime
  local openServerTimeZeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(openServerTime // 1000) * 1000
  local now = self:GetServerTime()
  local timeDelta = (now - openServerTimeZeroTime) // 86400000 + 1
  return timeDelta
end

local function GetMondayByTS(self, timeStamp)
  local curWeekday = self:GetWeekdayIndex(timeStamp)
  local dayOffset = 1 - curWeekday
  local targetDay = timeStamp + dayOffset * DAY_MILLISECOND
  local targetTs = self:GetTodayZeroServerTime(math.modf(targetDay / 1000))
  return math.modf(targetTs * 1000)
end

local function GetServerOpenFirstMonday(self, serverOpenTime)
  if serverOpenTime == 0 then
    return 0
  end
  local openWeekStartTime = self:GetMondayByTS(serverOpenTime)
  local number = math.floor((serverOpenTime - openWeekStartTime) / DAY_MILLISECOND)
  if 3 <= number then
    openWeekStartTime = openWeekStartTime + WEEK_MILLISECOND
  end
  return openWeekStartTime
end

local function GetOpenServerWeek(self, time)
  local openServerTime = LuaEntry.Player.openServerTime
  local now = time or self:GetServerTime()
  if openServerTime == 0 or openServerTime > now then
    return 0
  end
  local openServerMonday = GetServerOpenFirstMonday(self, openServerTime)
  local diffWeekNum = math.floor((now - openServerMonday) / WEEK_MILLISECOND)
  return diffWeekNum + 1
end

local function GetDayOfYear(self, serverTime)
  local time = math.modf(serverTime / 1000)
  return os.date("!*t", time).yday
end

local function GetWeekOfYear(self, serverTime)
  local time = math.modf(serverTime / 1000)
  local wDay = os.date("%W", time)
  return toInt(wDay)
end

local function GetDayTimeTransition(self, timestamp, hour, min, sec)
  local time = math.modf((timestamp + self.changeDeltaTime) / 1000)
  local date_table = os.date("!*t", time)
  date_table.hour = hour or 0
  date_table.min = min or 0
  date_table.sec = sec or 0
  return SafeLocalOsTime(date_table) * 1000
end

local function GetTimeTextByShowType(self, sec, showType)
  local text
  if showType == 0 then
    text = " +" .. tostring(math.modf(sec))
  elseif showType == 1 then
    text = string.format(" %s%%", string.format("%.2f", sec * 100))
  elseif showType == 2 then
    text = " +" .. string.format("%s%%", string.format("%.2f", sec * 100))
  elseif showType == 3 then
    text = " -" .. string.format("%s%%", string.format("%.2f", sec * 100))
  elseif showType == 4 then
    local time = ""
    local hour = math.modf(sec / 3600)
    local minute = math.modf(sec / 60) % 60
    local second = math.floor(sec % 60)
    if hour ~= 0 then
      time = time .. hour .. " " .. Localization:GetString(100166)
    end
    if minute ~= 0 then
      time = time .. minute .. " " .. Localization:GetString(100165)
    end
    if second ~= 0 then
      time = time .. second .. " " .. Localization:GetString(372115)
    end
    if time == "" then
      time = 0 .. " " .. Localization:GetString(372115)
    end
    if time ~= "" then
      text = " " .. time
    end
  elseif showType == 5 then
    text = " " .. sec
  end
  return text
end

local function TimeStampToMDHSForLocalMinute(self, timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("*t", time)
  if Localization:GetLanguage() == Language.PortuguesePortugal then
    return string.format("%d-%d %02d:%02d", format.day, format.month, format.hour, format.min)
  else
    return string.format("%d-%d %02d:%02d", format.month, format.day, format.hour, format.min)
  end
end

local function GetServerOpenDays(self)
  return UITimeManager:GetInstance():GetServerOpenDaysByTimeStamp(LuaEntry.Player.openServerTime)
end

local function GetServerOpenDaysByTimeStamp(self, timeStamp)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local serverStartTime = timeStamp
  if curTime and 0 < curTime and serverStartTime and 0 < serverStartTime then
    local curZeroTimeStamp = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime // 1000) * 1000
    local serverStartZeroTimeStamp = UITimeManager:GetInstance():GetTodayZeroServerTime(serverStartTime // 1000) * 1000
    if curZeroTimeStamp >= serverStartZeroTimeStamp then
      local serverOpenDays = (curZeroTimeStamp - serverStartZeroTimeStamp) // 86400000 + 1
      return serverOpenDays
    end
  end
  return 1
end

local function MilliSecondToDHMS(self, milliSecond)
  if milliSecond == nil or milliSecond == 0 or milliSecond < 0 then
    return 0, 0, 0, 0
  end
  local secs, delta = math.modf(milliSecond / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  return day, hour, minute, second
end

local function ServerYMD2Sec(self, year, month, day)
  local utcTimeTable = os.date("!*t")
  utcTimeTable.year = year or 1970
  utcTimeTable.month = month or 1
  utcTimeTable.day = day or 1
  utcTimeTable.hour = 0
  utcTimeTable.min = 0
  utcTimeTable.sec = 0
  local utcTimestamp = SafeLocalOsTime(utcTimeTable)
  return utcTimestamp
end

local function GetLocalUTCOffset(self)
  local now = self:GetServerSeconds()
  local local_t = os.date("*t", now)
  local utc_t = os.date("!*t", now)
  local local_s = SafeLocalOsTime({
    year = local_t.year,
    month = local_t.month,
    day = local_t.day,
    hour = local_t.hour,
    min = local_t.min,
    isdst = local_t.isdst
  })
  local utc_s = SafeLocalOsTime({
    year = utc_t.year,
    month = utc_t.month,
    day = utc_t.day,
    hour = utc_t.hour,
    min = utc_t.min,
    isdst = local_t.isdst
  })
  local localOffset = os.difftime(local_s, utc_s)
  if self.uploadLocalUTCOffset == nil or localOffset ~= self.uploadLocalUTCOffset then
    self.uploadLocalUTCOffset = localOffset
    Logger.LogInfo("UITimeManager LocalUTCOffset:" .. localOffset / 3600)
    Logger.LogInfo("UITimeManager Isdst:" .. tostring(local_t.isdst))
    local locale = os.setlocale(nil, "all")
    if locale then
      Logger.LogInfo("UITimeManager Locale:" .. locale)
    end
  end
  return localOffset / 3600
end

local function GetFriendsCirleShowTime(self, second)
  local _createTime = second / 1000
  local _curTime = self:GetServerSeconds()
  local _deltaTime = _curTime - _createTime
  local _oneHour = 3600
  local _oneDay = _oneHour * 24
  if _deltaTime < 60 then
    return Localization:GetString("310105")
  elseif 60 <= _deltaTime and _deltaTime < _oneHour then
    return Localization:GetString("310107", _deltaTime // 60)
  elseif _deltaTime >= _oneHour and _deltaTime < _oneDay then
    return Localization:GetString("310108", _deltaTime // _oneHour)
  elseif _deltaTime >= _oneDay and _deltaTime < _oneDay * 3 then
    return Localization:GetString("310109", _deltaTime // _oneDay)
  else
    return self:TimeStampToDayForLocal(second)
  end
end

local function GetSocketTime(self)
  local time = socket.gettime() * 1000
  return time
end

local function GetCompetitionTimeFormat(self, ms)
  if not ms or ms <= 0 then
    return "00:00.000"
  end
  ms = math.floor(ms + 0.5)
  local totalSeconds = math.floor(ms / 1000)
  local hours = math.floor(totalSeconds / 3600)
  local minutes = math.floor(totalSeconds % 3600 / 60)
  local seconds = totalSeconds % 60
  local milliseconds = ms % 1000
  if 0 < hours then
    return string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
  else
    return string.format("%02d:%02d.%03d", minutes, seconds, milliseconds)
  end
end

local function IsIntPointTime(self, timeStamp, granularity)
  if not timeStamp or timeStamp <= 0 then
    return false
  end
  granularity = granularity or 60
  local temp_sec, millisecond = math.modf((timeStamp + self.changeDeltaTime) / 1000)
  local format = os.date("!*t", temp_sec)
  if granularity == 1 then
    return millisecond == 0
  elseif granularity == 60 then
    return format.sec == 0
  elseif granularity == OneHourTime then
    return format.min == 0 and format.sec == 0
  elseif granularity == OneDayTime then
    return format.hour == 0 and format.min == 0 and format.sec == 0
  end
  return false
end

UITimeManager.__init = __init
UITimeManager.__delete = __delete
UITimeManager.UpdateServerMsDeltaTime = UpdateServerMsDeltaTime
UITimeManager.GetServerTime = GetServerTime
UITimeManager.GetServerSeconds = GetServerSeconds
UITimeManager.TimeStampToTimeForServer = TimeStampToTimeForServer
UITimeManager.TimeStampToTimeForLocal = TimeStampToTimeForLocal
UITimeManager.TimeStampToDayForLocal = TimeStampToDayForLocal
UITimeManager.TimeStampToDayTbForLocal = TimeStampToDayTbForLocal
UITimeManager.SecondToFmtString = SecondToFmtString
UITimeManager.SecondToFmtStringWithoutDay = SecondToFmtStringWithoutDay
UITimeManager.SecondToFmtStringWithoutHour = SecondToFmtStringWithoutHour
UITimeManager.MilliSecondToFmtString = MilliSecondToFmtString
UITimeManager.MilliSecondToFmtStringFloor = MilliSecondToFmtStringFloor
UITimeManager.MilliSecondToFmtFormat = MilliSecondToFmtFormat
UITimeManager.MillisionSecToWeekCardFormat = MillisionSecToWeekCardFormat
UITimeManager.MilliSecondToFmtStringWithoutDay = MilliSecondToFmtStringWithoutDay
UITimeManager.MilliSecondToFmtStringWithoutHour = MilliSecondToFmtStringWithoutHour
UITimeManager.GetResSecondsTo24 = GetResSecondsTo24
UITimeManager.IsSameDayForLocal = IsSameDayForLocal
UITimeManager.IsSameDayForServer = IsSameDayForServer
UITimeManager.TimeStampToTimeForLocalSimple = TimeStampToTimeForLocalSimple
UITimeManager.MilliSecondToFmtStringForCountdown = MilliSecondToFmtStringForCountdown
UITimeManager.SecondToFmtStringForCountdown = SecondToFmtStringForCountdown
UITimeManager.SecondToClock = SecondToClock
UITimeManager.MilliSecondToClock = MilliSecondToClock
UITimeManager.GetChatShowTime = GetChatShowTime
UITimeManager.TimeStampToMD = TimeStampToMD
UITimeManager.GetMailShowTime = GetMailShowTime
UITimeManager.GetTimeToMD = GetTimeToMD
UITimeManager.GetTimeToHHMM = GetTimeToHHMM
UITimeManager.GetTimeFromServerToHHMMSS = GetTimeFromServerToHHMMSS
UITimeManager.GetTimeToLocalYMD = GetTimeToLocalYMD
UITimeManager.GetTimeToServerYMD = GetTimeToServerYMD
UITimeManager.GetTimeToServerHHMM = GetTimeToServerHHMM
UITimeManager.GetTimeToLocalHHMM = GetTimeToLocalHHMM
UITimeManager.TodayZero = TodayZero
UITimeManager.IsToday = IsToday
UITimeManager.IsTodayServer = IsTodayServer
UITimeManager.WeekZero = WeekZero
UITimeManager.SecondToFmtStringForCountdownByDialog = SecondToFmtStringForCountdownByDialog
UITimeManager.MilliSecondToFmtStringSpecial = MilliSecondToFmtStringSpecial
UITimeManager.GetWeekdayIndex = GetWeekdayIndex
UITimeManager.GetNowWeekdayIndex = GetNowWeekdayIndex
UITimeManager.GetWeekDay = GetWeekDay
UITimeManager.CheckIfIsSameWeek = CheckIfIsSameWeek
UITimeManager.GetNextWeekDay = GetNextWeekDay
UITimeManager.GetNextMonth = GetNextMonth
UITimeManager.GetMonthZero = GetMonthZero
UITimeManager.GetYearZero = GetYearZero
UITimeManager.TimeStampToTimeForServerMinute = TimeStampToTimeForServerMinute
UITimeManager.TimeStampToTimeForServerSimple = TimeStampToTimeForServerSimple
UITimeManager.GetTodayZeroServerTime = GetTodayZeroServerTime
UITimeManager.TimeStampToTimeForLocalMinute = TimeStampToTimeForLocalMinute
UITimeManager.TimeStampToTimeForServerOnlyHour = TimeStampToTimeForServerOnlyHour
UITimeManager.GetNextDayMs = GetNextDayMs
UITimeManager.GetFormattedTimeMs = GetFormattedTimeMs
UITimeManager.GetFormattedTime = GetFormattedTime
UITimeManager.SetTimezoneOffset = SetTimezoneOffset
UITimeManager.ServerYMD2Sec = ServerYMD2Sec
UITimeManager.GetLocalOffset = GetLocalOffset
UITimeManager.GetServerTimeToLocal = GetServerTimeToLocal
UITimeManager.GetDateNum = GetDateNum
UITimeManager.GetNewsDateTime = GetNewsDateTime
UITimeManager.GetResSeoncdsToNextMonday = GetResSeoncdsToNextMonday
UITimeManager.GetTimezoneOffset = GetTimezoneOffset
UITimeManager.GetDebugOffsetSec = GetDebugOffsetSec
UITimeManager.SetDebugOffsetSec = SetDebugOffsetSec
UITimeManager.GetBetweenDaysForServer = GetBetweenDaysForServer
UITimeManager.GetBetweenDaysForLocal = GetBetweenDaysForLocal
UITimeManager.GetBetweenDaysForSeason = GetBetweenDaysForSeason
UITimeManager.GetOpenServerDay = GetOpenServerDay
UITimeManager.TimeStampToServerTime = TimeStampToServerTime
UITimeManager.TimeSecToServerDate = TimeSecToServerDate
UITimeManager.TimeSecToLocalDate = TimeSecToLocalDate
UITimeManager.TimeStampToServerDate = TimeStampToServerDate
UITimeManager.TimeStampToLocalTime = TimeStampToLocalTime
UITimeManager.TimeStampToLocalDate = TimeStampToLocalDate
UITimeManager.GetOpenServerWeek = GetOpenServerWeek
UITimeManager.GetMondayByTS = GetMondayByTS
UITimeManager.GetDayOfYear = GetDayOfYear
UITimeManager.GetWeekOfYear = GetWeekOfYear
UITimeManager.GetDayTimeTransition = GetDayTimeTransition
UITimeManager.GetTimeTextByShowType = GetTimeTextByShowType
UITimeManager.TimeStampToMDHSForLocalMinute = TimeStampToMDHSForLocalMinute
UITimeManager.GetServerOpenDays = GetServerOpenDays
UITimeManager.GetServerOpenDaysByTimeStamp = GetServerOpenDaysByTimeStamp
UITimeManager.MilliSecondToDHMS = MilliSecondToDHMS
UITimeManager.TimeStampToTimeForLocalMinuteCommon = TimeStampToTimeForLocalMinuteCommon
UITimeManager.UpdateServerTimeFromCS = UpdateServerTimeFromCS
UITimeManager.UpdateClientSwitch = UpdateClientSwitch
UITimeManager.GetOpenServerDayByOpenServerZero = GetOpenServerDayByOpenServerZero
UITimeManager.GetBetweenDaysForServerTime = GetBetweenDaysForServerTime
UITimeManager.GetLocalUTCOffset = GetLocalUTCOffset
UITimeManager.GetFriendsCirleShowTime = GetFriendsCirleShowTime
UITimeManager.SecondToFmtStringHM = SecondToFmtStringHM
UITimeManager.MilliSecondToFmtStringWithoutSecond = MilliSecondToFmtStringWithoutSecond
UITimeManager.GetLocalTimeToServerTimestamp = GetLocalTimeToServerTimestamp
UITimeManager.GetSocketTime = GetSocketTime
UITimeManager.GetCompetitionTimeFormat = GetCompetitionTimeFormat
UITimeManager.IsIntPointTime = IsIntPointTime
return UITimeManager
