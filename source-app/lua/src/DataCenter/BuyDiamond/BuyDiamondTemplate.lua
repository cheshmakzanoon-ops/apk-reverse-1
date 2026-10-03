local BuyDiamondTemplate = BaseClass("BuyDiamondTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.is_show = 0
  self.time_type = 0
  self.server_area = 0
  self.time_para1 = ""
  self.duration = 0
  self.title = ""
  self.text = ""
  self.text_1 = ""
  self.exchange_id_1 = ""
  self.text_2 = ""
  self.exchange_id_2 = ""
  self.text_3 = ""
  self.text_4 = ""
  self.showServerList = {}
end

local function __delete(self)
  self.id = 0
  self.is_show = 0
  self.time_type = 0
  self.server_area = 0
  self.time_para1 = ""
  self.duration = 0
  self.title = ""
  self.text = ""
  self.text_1 = ""
  self.exchange_id_1 = ""
  self.text_2 = ""
  self.exchange_id_2 = ""
  self.text_3 = ""
  self.text_4 = ""
  self.showServerList = {}
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.is_show = row:getValue("is_show", "")
  self.time_type = row:getValue("time_type")
  self.server_area = row:getValue("server_area")
  self.showServerList = string.split(self.server_area, ";")
  self.time_para1 = row:getValue("time_para1")
  self.duration = row:getValue("duration")
  self.title = row:getValue("title")
  self.text = row:getValue("text")
  self.text_1 = row:getValue("text_1")
  self.exchange_id_1 = row:getValue("exchange_id_1")
  self.text_2 = row:getValue("text_2")
  self.exchange_id_2 = row:getValue("exchange_id_2")
  self.text_3 = row:getValue("text_3")
  self.text_4 = row:getValue("text_4")
end

function BuyDiamondTemplate:IsMeetShowCondition()
  local curServerId = LuaEntry.Player:GetSourceServerId() or 0
  local isShowInServer = false
  for i = 1, #self.showServerList do
    local serverIdList = string.split(self.showServerList[i], "-")
    if 2 <= #serverIdList then
      local serverId1 = tonumber(serverIdList[1])
      local serverId2 = tonumber(serverIdList[2])
      if curServerId >= serverId1 and curServerId <= serverId2 then
        isShowInServer = true
        break
      end
    else
      local serverId = tonumber(serverIdList[1])
      if serverId == curServerId then
        isShowInServer = true
        break
      end
    end
  end
  return self.is_show == 1 and isShowInServer
end

function BuyDiamondTemplate:GetDurationTimeStamp(startShowTime)
  local time = math.modf((startShowTime + UITimeManager:GetInstance():GetTimezoneOffset()) / 1000)
  local utcDate = os.date("!*t", time)
  local firstDayInternal = self:SecondsToNextDayMidnight(utcDate.hour, utcDate.min, utcDate.sec)
  return firstDayInternal * 1000 + (self.duration - 1) * 86400000
end

function BuyDiamondTemplate:SecondsToNextDayMidnight(hour, min, sec)
  local total_seconds = 86400
  local passed_seconds = hour * 3600 + min * 60 + sec
  local remaining_seconds = total_seconds - passed_seconds
  return remaining_seconds
end

function BuyDiamondTemplate:GetRealStartTime(seasonDataList)
  if self.time_type == 1 then
    local timestamp = self:ParseOpenServerTime(self.time_para1)
    return self:GetTo0ClockStartTimeStamp(timestamp)
  elseif self.time_type == 2 then
    return self:ParseTimeStr(self.time_para1)
  elseif self.time_type == 3 then
    local timestamp = self:ParseSeasonStartTime(self.time_para1, seasonDataList)
    return self:GetTo0ClockStartTimeStamp(timestamp)
  elseif self.time_type == 4 then
    local timestamp = self:ParseSeasonFormatTime(self.time_para1, seasonDataList)
    return self:GetTo0ClockStartTimeStamp(timestamp)
  end
  return 0
end

function BuyDiamondTemplate:GetRealStartTimeForLog(seasonDataList)
  if self.time_type == 1 then
    return self:ParseOpenServerTime(self.time_para1)
  elseif self.time_type == 2 then
    return self:ParseTimeStr(self.time_para1)
  elseif self.time_type == 3 then
    return self:ParseSeasonStartTime(self.time_para1, seasonDataList)
  elseif self.time_type == 4 then
    return self:ParseSeasonFormatTime(self.time_para1, seasonDataList)
  end
  return 0
end

function BuyDiamondTemplate:GetTo0ClockStartTimeStamp(startShowTime)
  if startShowTime == -1 then
    return -1
  end
  local time = math.modf((startShowTime + UITimeManager:GetInstance():GetTimezoneOffset()) / 1000)
  local utcDate = os.date("!*t", time)
  local internal = self:SecondsToTodayMidnight(utcDate.hour, utcDate.min, utcDate.sec)
  return startShowTime - internal * 1000
end

function BuyDiamondTemplate:SecondsToTodayMidnight(hour, min, sec)
  local passed_seconds = hour * 3600 + min * 60 + sec
  return passed_seconds
end

function BuyDiamondTemplate:ParseOpenServerTime(timeStr)
  local openServerTime = LuaEntry.Player.openServerTime
  local extraTime = (tonumber(timeStr) - 1) * 86400000
  return openServerTime + extraTime
end

function BuyDiamondTemplate:ParseTimeStr(timeStr)
  local year, month, day, hour, min, sec = timeStr:match("(%d+)/(%d+)/(%d+)%s+(%d+):(%d+):(%d+)")
  year = tonumber(year)
  month = tonumber(month)
  day = tonumber(day)
  hour = tonumber(hour)
  min = tonumber(min)
  sec = tonumber(sec)
  local timestamp = SafeLocalOsTime({
    year = year,
    month = month,
    day = day,
    hour = hour,
    min = min,
    sec = sec
  })
  local serverTimestamp = UITimeManager:GetInstance():GetLocalTimeToServerTimestamp(timestamp)
  return serverTimestamp * 1000
end

function BuyDiamondTemplate:ParseSeasonStartTime(timeStr, seasonDataList)
  local season, day = timeStr:match("(%d+)-(%d+)")
  season = tonumber(season)
  day = tonumber(day)
  local seasonStartTime = 0
  if season == 0 then
    seasonStartTime = LuaEntry.Player.openServerTime
  else
    seasonStartTime = self:GetSeasonStartTimestamp(season, seasonDataList)
    if seasonStartTime == nil then
      return -1
    end
  end
  local extraTime = (day - 1) * 86400000
  return seasonStartTime + extraTime
end

function BuyDiamondTemplate:ParseSeasonFormatTime(timeStr, seasonDataList)
  local season, week, weekday = timeStr:match("(%d+)%-(%d+)%-(%d+)")
  season = tonumber(season)
  week = tonumber(week)
  weekday = tonumber(weekday)
  local seasonStartTime = 0
  if season == 0 then
    seasonStartTime = LuaEntry.Player.openServerTime
  else
    seasonStartTime = self:GetSeasonStartTimestamp(season, seasonDataList)
    if seasonStartTime == nil then
      return -1
    end
  end
  local weekday_1_7 = weekday + 1 == 1 and 7 or weekday
  local seasonStartweekDay_1_7 = UITimeManager:GetInstance():GetWeekdayIndex(seasonStartTime)
  if weekday_1_7 >= seasonStartweekDay_1_7 then
    local weekInternal = (week - 1) * 604800000
    local tipsShowTime = seasonStartTime + (weekday_1_7 - seasonStartweekDay_1_7) * 86400000 + weekInternal
    return tipsShowTime
  else
    local weekInternal = (week - 1) * 604800000
    local tipsShowTime = seasonStartTime + (7 - seasonStartweekDay_1_7 + weekday_1_7) * 86400000 + weekInternal
    return tipsShowTime
  end
end

function BuyDiamondTemplate:GetSeasonStartTimestamp(season, seasonDataList)
  for i = 1, #seasonDataList do
    if seasonDataList[i].seasonId == season then
      return seasonDataList[i].startTime
    end
  end
  return nil
end

function BuyDiamondTemplate:GetTipsTitle()
  if self.time_type == 1 then
    return Localization:GetString("update_history_2", self.time_para1)
  elseif self.time_type == 2 then
    local year, month, day, hour, min, sec = self.time_para1:match("(%d+)/(%d+)/(%d+)%s+(%d+):(%d+):(%d+)")
    return year .. "-" .. month .. "-" .. day
  elseif self.time_type == 3 then
    local season, day = self.time_para1:match("(%d+)-(%d+)")
    return Localization:GetString("update_history_4_1", season, day)
  elseif self.time_type == 4 then
    local season, week, weekday = self.time_para1:match("(%d+)%-(%d+)%-(%d+)")
    weekday = tonumber(weekday)
    local weekday_1_7 = weekday + 1 == 1 and 7 or weekday
    return Localization:GetString("update_history_4_2", season, week, Localization:GetString(WeekType[weekday_1_7]))
  end
end

function BuyDiamondTemplate:GetTipsContent()
  local res = ""
  local strList = string.split(self.text, "|")
  for i = 1, #strList do
    if self[strList[i]] then
      if strList[i] == "exchange_id_1" or strList[i] == "exchange_id_2" then
        local exchangeGiftName = self:GetExchangeGiftName(self[strList[i]], strList[i])
        res = res .. exchangeGiftName
      elseif self[strList[i]] ~= "" then
        res = res .. Localization:GetString(self[strList[i]])
      end
    else
      Logger.LogError("activity_updatelist\232\161\168\228\184\173\230\178\161\230\156\137\229\164\154\232\175\173\232\168\128\233\161\185\229\136\151\239\188\154" .. strList[i])
    end
  end
  return res
end

function BuyDiamondTemplate:GetExchangeGiftName(nameStr, cfgName)
  local res = ""
  local strList = string.split(nameStr, "|")
  for i = 1, #strList do
    local exchangeId = tonumber(strList[i])
    if exchangeId then
      local giftPackTemplate = DataCenter.GiftPackTemplateManager:GetGiftPackInfo(exchangeId)
      res = res .. Localization:GetString(giftPackTemplate.name)
      if i < #strList then
        res = res .. "\227\128\129"
      end
    else
      Logger.LogError("\230\178\161\230\156\137\230\137\190\229\136\176exchange\232\161\168id\231\154\132\233\133\141\231\189\174\239\188\140\230\156\137\233\151\174\233\162\152\231\154\132\233\133\141\231\189\174\229\134\133\229\174\185\228\184\186\239\188\154" .. cfgName)
    end
  end
  return res
end

BuyDiamondTemplate.__init = __init
BuyDiamondTemplate.__delete = __delete
BuyDiamondTemplate.InitData = InitData
return BuyDiamondTemplate
