local UILWSeasonAllianceWarTimeConfigData = require("UI.LWSeason5.UILWSeasonAllianceWarTime.Common.UILWSeasonAllianceWarTimeConfigData")
local UILWSeasonAllianceWarTimeManager = BaseClass("UILWSeasonAllianceWarTimeManager")

function UILWSeasonAllianceWarTimeManager:__init()
  self:InitVars()
end

function UILWSeasonAllianceWarTimeManager:__delete()
  self.ActId = 0
  self.ActCell = nil
end

function UILWSeasonAllianceWarTimeManager:InitVars()
  self.LOG_ENABLE = true
  self.ActId = 0
  self.ActData = nil
  self.ActCell = nil
  self.WarTimes = {}
  self.MyAllianceWarTimeData = nil
  self.WaitingGetInfo = {}
  self.WaitingSetTime = false
end

function UILWSeasonAllianceWarTimeManager:SetActId(actId)
  self.ActId = actId
  self.ActCell = LocalController:instance():getLine(TableName.Activity, checknumber(self.ActId))
end

function UILWSeasonAllianceWarTimeManager:GetActData()
  if self.ActData == nil then
    self.ActData = DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
  end
  return self.ActData
end

function UILWSeasonAllianceWarTimeManager:IsFuncOpen(includePreview)
  local seasonType = SeasonUtil.GetSeasonType(includePreview, false)
  return seasonType == SeasonMapType.NineNation
end

function UILWSeasonAllianceWarTimeManager:CanShowOnUI()
  if self:IsFuncOpen(true) then
    local inPreview = DataCenter.SeasonDataManager:InPreviewMode()
    local inNormal = DataCenter.SeasonDataManager:InNormalMode()
    local inSettle = DataCenter.SeasonDataManager:InSettleTime()
    return inPreview or inNormal or inSettle
  end
  return false
end

function UILWSeasonAllianceWarTimeManager:CanShowOnBuilding()
  if self:IsFuncOpen(true) then
    local inPreview = DataCenter.SeasonDataManager:InPreviewMode()
    local inNormal = DataCenter.SeasonDataManager:InNormalMode()
    return inPreview or inNormal
  end
  return false
end

function UILWSeasonAllianceWarTimeManager:GetRealTimeIndex(timeIndex, setTime)
  timeIndex = Mathf.Clamp(checknumber(timeIndex), -1, 2)
  setTime = checknumber(setTime)
  if self:IsFuncOpen(true) then
    if DataCenter.SeasonDataManager:InPreviewMode() and setTime == 0 then
      return -1
    end
    return timeIndex
  end
  return -1
end

function UILWSeasonAllianceWarTimeManager:GetSeasonCell()
  local seasonConfigId
  local severInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if severInfo ~= nil then
    if severInfo:InPreviewMode() then
      seasonConfigId = severInfo.nextSeasonConfigId
    else
      seasonConfigId = severInfo.seasonConfigId
    end
    if seasonConfigId ~= nil then
      return LocalController:instance():getLine(TableName.LW_Season, seasonConfigId)
    end
  end
  return nil
end

function UILWSeasonAllianceWarTimeManager:GetWarTimeConfigs()
  if table.IsNullOrEmpty(self.WarTimes) then
    self.WarTimes = {}
    local seasonConfigCell = self:GetSeasonCell()
    if seasonConfigCell ~= nil then
      local timePairs = string.split(seasonConfigCell.battle_time, "|")
      local index = 0
      for _, timePair in pairs(timePairs) do
        local timeData = UILWSeasonAllianceWarTimeConfigData.New()
        timeData:SetData(timePair, index)
        self.WarTimes[index] = timeData
        index = index + 1
      end
    end
  end
  return self.WarTimes
end

function UILWSeasonAllianceWarTimeManager:GetWarTimeConfigData(index)
  if self:IsFuncOpen(true) then
    index = checknumber(index)
    local warTimes = self:GetWarTimeConfigs()
    if 0 <= index and index < table.count(warTimes) then
      return warTimes[index]
    end
  end
  return nil
end

function UILWSeasonAllianceWarTimeManager:GetNextWarTime(openTime, timeIndex, needCheckWeek, needCheckWarTimeIndex)
  if not self:IsFuncOpen(false) then
    return 0, 0
  end
  openTime = checknumber(openTime)
  timeIndex = checknumber(timeIndex)
  local deltaTime = UITimeManager:GetInstance():GetTimezoneOffset()
  local oneDayMillTime = OneDayTime * 1000
  local dayStartTime = openTime - (openTime + deltaTime) % oneDayMillTime
  local seasonEndTime = DataCenter.SeasonDataManager:GetSeasonEndTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local validWeek = self:GetValidWeeks()
  local timeConfigs = self:GetWarTimeConfigs()
  local searchTimes = 1
  while searchTimes < 365 do
    local week = UITimeManager:GetInstance():GetWeekdayIndex(dayStartTime)
    local weekValid = not needCheckWeek or table.hasvalue(validWeek, checkstring(week))
    if weekValid then
      if not needCheckWarTimeIndex then
        local st = math.max(dayStartTime, openTime)
        return st, st + OneHourTime * 1000
      end
      for i = 0, 2 do
        if i ~= timeIndex then
          local timeData = timeConfigs[i]
          local st = dayStartTime + timeData.StartTime * 1000
          local et = dayStartTime + timeData.EndTime * 1000
          if (openTime <= st or openTime <= et) and (now <= st or now <= et) then
            return math.max(st, openTime), et
          end
        end
      end
    end
    dayStartTime = dayStartTime + oneDayMillTime
    searchTimes = searchTimes + 1
  end
  return 0, 0
end

function UILWSeasonAllianceWarTimeManager:GetIconPath(timeIndex)
  timeIndex = checknumber(timeIndex)
  if timeIndex == 0 then
    return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_shijian_icon1.png"
  elseif timeIndex == 1 then
    return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_shijian_icon2.png"
  elseif timeIndex == 2 then
    return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_shijian_icon3.png"
  end
  return ""
end

function UILWSeasonAllianceWarTimeManager:GetWarIconPath(isWar)
  if isWar then
    return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_icon_jiaozhan.png"
  else
    return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_icon_mianzhan.png"
  end
end

function UILWSeasonAllianceWarTimeManager:ClearMyAllianceWarTimeData()
  self.MyAllianceWarTimeData = nil
end

function UILWSeasonAllianceWarTimeManager:GetMyAllianceWarTimeData()
  return self.MyAllianceWarTimeData
end

function UILWSeasonAllianceWarTimeManager:GetValidWeeks()
  local seasonConfigCell = self:GetSeasonCell()
  if seasonConfigCell ~= nil then
    return string.split(seasonConfigCell.season_battle_day, ";")
  end
  return {}
end

function UILWSeasonAllianceWarTimeManager:IsSetValid(toast)
  if not self:IsFuncOpen(true) then
    return false
  end
  if not LuaEntry.Player:IsInAlliance() then
    if toast then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui59"))
    end
    return false
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    if toast then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui58"))
    end
    return false
  end
  if DataCenter.SeasonDataManager:InPreviewMode() then
  elseif DataCenter.SeasonDataManager:InNormalMode() then
    local cd = LuaEntry.DataConfig:TryGetNum("s5_battle_time", "k1", 10)
    local myData = self:GetMyAllianceWarTimeData()
    if myData == nil then
      return false
    end
    local pastTime = UITimeManager:GetInstance():GetServerTime() - myData.SetTime
    local duration = cd * OneDayTime * 1000
    if pastTime < duration then
      if toast then
        UIUtil.ShowTips(CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui56"))
      end
      return false
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    local week = UITimeManager:GetInstance():GetWeekdayIndex(now)
    if week ~= 1 then
      if toast then
        UIUtil.ShowTips(CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui57"))
      end
      return false
    end
  end
  return true
end

function UILWSeasonAllianceWarTimeManager:GetNextDeclareTime()
  local NextDeclareTime
  local weekPairs = self:GetValidWeeks()
  if table.count(weekPairs) > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local week = UITimeManager:GetInstance():GetWeekdayIndex(now)
    local minIndex = 8
    for k, v in pairs(weekPairs) do
      local offset = toInt(v) - week
      if 0 < offset then
        local todayLeft = UITimeManager:GetInstance():GetTomorrowZero()
        NextDeclareTime = todayLeft + OneDayTime * 1000 * (offset - 1)
        break
      end
      minIndex = math.min(toInt(v), minIndex)
    end
    if NextDeclareTime == nil then
      local offset = minIndex + 7 - week
      local todayLeft = UITimeManager:GetInstance():GetTomorrowZero()
      NextDeclareTime = todayLeft + OneDayTime * 1000 * (offset - 1)
    end
  end
  return NextDeclareTime
end

function UILWSeasonAllianceWarTimeManager:IsDeclareDay()
  local weekPairs = self:GetValidWeeks()
  if table.count(weekPairs) > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local week = UITimeManager:GetInstance():GetWeekdayIndex(now)
    return table.hasvalue(weekPairs, checkstring(week))
  end
  return false
end

function UILWSeasonAllianceWarTimeManager:IsAllianceWarTime(banTimeIndex)
  if banTimeIndex == nil then
    return true, -1, -1
  end
  local warTimes = self:GetWarTimeConfigs()
  for _, warTimeConfig in pairs(warTimes) do
    if warTimeConfig.Index ~= banTimeIndex and warTimeConfig:IsNowInRange() then
      return true, warTimeConfig.StartTime, warTimeConfig.EndTime
    end
  end
  return false, -1, -1
end

function UILWSeasonAllianceWarTimeManager:SendGetInfo(aid)
  if not self:IsFuncOpen(true) then
    return
  end
  if aid == nil then
    aid = LuaEntry.Player.allianceId
  end
  if not string.IsNullOrEmpty(aid) then
    local param = {}
    param.allianceid = aid
    SFSNetwork.SendMessage(MsgDefines.AllianceWartimeInfo, param)
  end
end

function UILWSeasonAllianceWarTimeManager:OnGetInfoCallback(res)
  if res == nil then
    return
  end
  if checkstring(res.aid) == "" then
    return
  end
  local data = self:HandleAllianceWarTimeData(res)
  EventManager:GetInstance():Broadcast(EventId.SeasonAllianceWarTimeGetInfoUpdate, data)
end

function UILWSeasonAllianceWarTimeManager:HandleAllianceWarTimeData(res)
  if res == nil then
    return
  end
  local data = {}
  data.SetTime = checknumber(res.settime)
  data.TimeIndex = checknumber(res.wartimeindex)
  data.AllianceId = res.aid
  data.Logs = res.sethistory
  if res.aid == LuaEntry.Player.allianceId then
    self.MyAllianceWarTimeData = data
  end
  return data
end

function UILWSeasonAllianceWarTimeManager:ClearWaitingGetInfo()
  self.WaitingGetInfo = {}
end

function UILWSeasonAllianceWarTimeManager:SendSetTime(timeIndex)
  timeIndex = checknumber(timeIndex)
  if not (0 <= timeIndex) or not (timeIndex <= 2) then
    return
  end
  if not self:IsSetValid(true) then
    return
  end
  local param = {}
  param.index = timeIndex
  SFSNetwork.SendMessage(MsgDefines.AllianceWartimeSet, param)
end

function UILWSeasonAllianceWarTimeManager:OnSetTimeCallback(res)
  if res == nil then
    return
  end
end

function UILWSeasonAllianceWarTimeManager:HasSetWarTime()
  if self:IsFuncOpen(true) then
    local myData = self:GetMyAllianceWarTimeData()
    return myData ~= nil and checknumber(myData.SetTime) > 0
  end
  return false
end

function UILWSeasonAllianceWarTimeManager:OnSetTimePush(res)
  if res == nil then
    return
  end
  local data = self:HandleAllianceWarTimeData(res)
  EventManager:GetInstance():Broadcast(EventId.SeasonAllianceWarTimePush, data)
end

function UILWSeasonAllianceWarTimeManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine()
  sb:AppendLine("UILWSeasonAllianceWarTimeManager (S5 Manager reused in S6)")
  if self.MyAllianceWarTimeData then
    local data = self.MyAllianceWarTimeData
    local setTimeStr = UITimeManager:GetInstance():TimeStampToTimeForLocal(data.SetTime * 1000)
    sb:AppendLineFormat("  My Alliance ID: %s", data.AllianceId)
    sb:AppendLineFormat("  Selected Immunity Index (TimeIndex): %s", data.TimeIndex)
    sb:AppendLineFormat("  Set Time: %s (%s)", data.SetTime, setTimeStr)
    local configs = self:GetWarTimeConfigs()
    sb:AppendLine("  War Time Configs (Immunity/War Status):")
    for i = 0, 2 do
      local config = configs[i]
      if config then
        local isImmunity = i == data.TimeIndex
        sb:AppendLineFormat("    [%s] %02d:00 - %02d:00 | %s", i, config.StartTime / 3600, config.EndTime / 3600, isImmunity and "IMMUNITY (\229\133\141\230\136\152)" or "WAR (\230\136\152\228\186\137)")
      end
    end
    sb:AppendLineFormat("  Logs Count: %s", table.count(data.Logs or {}))
  else
    sb:AppendLine("  My Alliance War Time Data: NULL")
  end
  sb:AppendLineFormat("  Function Open (IsFuncOpen): %s", tostring(self:IsFuncOpen(true)))
  local seasonCell = self:GetSeasonCell()
  if seasonCell then
    sb:AppendLineFormat("  Season Config ID: %s", seasonCell.id)
    sb:AppendLineFormat("  Battle Time Config: %s", seasonCell.battle_time)
    sb:AppendLineFormat("  Battle Day Config: %s", seasonCell.season_battle_day)
  end
  return sb:ToString()
end

return UILWSeasonAllianceWarTimeManager
