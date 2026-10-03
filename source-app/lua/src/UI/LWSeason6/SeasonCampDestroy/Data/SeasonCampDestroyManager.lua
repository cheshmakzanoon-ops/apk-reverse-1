local SeasonCampDestroyManager = BaseClass("SeasonCampDestroyManager")
local Localization = CS.GameEntry.Localization
local SeasonCampDestroyActInfo = require("UI.LWSeason6.SeasonCampDestroy.Data.SeasonCampDestroyActInfo")
local SeasonCampDestroyWarTimeConfigData = require("UI.LWSeason6.SeasonCampDestroy.Data.SeasonCampDestroyWarTimeConfigData")
local SeasonCampDestroyWarTimeData = require("UI.LWSeason6.SeasonCampDestroy.Data.SeasonCampDestroyWarTimeData")

function SeasonCampDestroyManager:__init()
  self.actId = nil
  self.actConfig = nil
  self.myServerId = 0
  self.myServerIndex = 0
  self.warTimeConfigs = {}
  self.myAllianceWarTimeData = nil
  self.allianceWarTimeDataDict = {}
end

function SeasonCampDestroyManager:__delete()
  if self.actInfo then
    self.actInfo:Delete()
    self.actInfo = nil
  end
  self.actId = nil
  self.actConfig = nil
  self.warTimeConfigs = nil
  self.myAllianceWarTimeData = nil
  self.allianceWarTimeDataDict = nil
  self.expensiveCity2Map = nil
end

local function SafeGetActInfo(self)
  if not self.actInfo then
    self.actInfo = SeasonCampDestroyActInfo.New(self)
  end
  return self.actInfo
end

function SeasonCampDestroyManager:SetActId(actId)
  self.actId = actId
  self.actConfig = LocalController:instance():getLine(TableName.Activity, checknumber(self.actId))
end

function SeasonCampDestroyManager:IsFuncOpen(includePreview)
  local seasonType = SeasonUtil.GetSeasonType(includePreview, true)
  return seasonType == SeasonMapType.NineNationRainforest
end

function SeasonCampDestroyManager:GetActId()
  return self.actId
end

function SeasonCampDestroyManager:ActIsVisible()
  if not self.actId then
    return
  end
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if data then
    return DataCenter.ActivityListDataManager:CheckIsSend(data)
  end
  return false
end

function SeasonCampDestroyManager:IsActive()
  if not self:IsFuncOpen(false) then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return self.actInfo ~= nil and self.actInfo.actEndTime > 0 and now <= self.actInfo.actEndTime and self:ActIsVisible()
end

function SeasonCampDestroyManager:CanDestroyCity(cityId)
  if not cityId or not self:IsActive() then
    return false
  end
  if not LuaEntry.Player:IsInAlliance() then
    return false
  end
  if not self:IsDeclareDay() then
    return false
  end
  local allianceInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId)
  if not allianceInfo then
    return false
  end
  if allianceInfo then
    local relation = DataCenter.ZoneWarManager:GetCampRelation(allianceInfo.occupyServerId)
    if relation == WorldCamp.Enemy then
      return true
    end
  end
  return false
end

function SeasonCampDestroyManager:IsEnemyServer(serverId)
  if not serverId then
    return false
  end
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType ~= SeasonMapType.NineNationRainforest then
    return false
  end
  local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
  local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(serverId)
  if myCampId and myCampId ~= campId then
    return true
  end
  return false
end

function SeasonCampDestroyManager:SendGetInfo(aid)
  if not self:IsFuncOpen(true) then
    return
  end
  if aid == nil then
    aid = LuaEntry.Player.allianceId
  end
  if not string.IsNullOrEmpty(aid) then
    local param = {}
    param.allianceid = aid
    SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo, param)
  end
end

function SeasonCampDestroyManager:SendGetServerInfo(serverId)
  if not self:IsFuncOpen(true) then
    return
  end
  if serverId and 0 < serverId then
    SFSNetwork.SendMessage(MsgDefines.Season6CampDestroyGetServerInfo, serverId)
  end
end

function SeasonCampDestroyManager:RefreshMyServerInfo()
  self.myServerId = LuaEntry.Player.serverId
  self.myServerIndex = 0
  if not self.actInfo or not self.actInfo.servers then
    return
  end
  for k, v in ipairs(self.actInfo.servers) do
    v.isMyServer = v.server == self.myServerId
    if v.isMyServer then
      self.myServerIndex = v.index
    end
  end
end

function SeasonCampDestroyManager:OnGetInfoCallback(msg)
  if not msg then
    return
  end
  if msg.errorCode then
    return
  end
  local actInfo = SafeGetActInfo(self)
  actInfo:UpdateActInfo(msg, self.actId, self.actConfig)
  self:RefreshMyServerInfo()
  EventManager:GetInstance():BroadcastDeferred(EventId.SeasonCampDestroyActRefresh)
end

function SeasonCampDestroyManager:OnGetServerInfoCallback(msg)
  if not msg then
    return
  end
  if msg.errorCode then
    return
  end
  local serverId = msg.targetServerId
  local server = self:GetServerInfoById(serverId)
  if server then
    server:UpdateServerDetail(msg)
    EventManager:GetInstance():Broadcast(EventId.SeasonCampDestroyGetServerInfoRefresh, serverId)
  end
end

function SeasonCampDestroyManager:GetCurrentBattleStage()
  if not self.actInfo then
    return SeasonCampDestroyStage.None
  end
  return self.actInfo:GetCurrentBattleStage()
end

function SeasonCampDestroyManager:GetActInfo()
  return self.actInfo
end

function SeasonCampDestroyManager:GetDeclareList()
  local _ = {}
  if not self.actInfo or not self.actInfo.declareList then
    return _
  end
  local curTime = UITimeManager:GetInstance():GetServerTime() or 0
  for k, v in ipairs(self.actInfo.declareList) do
    local startTime = v.startTime or 0
    local endTime = v.endTime or 0
    if curTime >= startTime and curTime <= endTime then
      table.insert(_, v)
    end
  end
  return _
end

function SeasonCampDestroyManager:GetBeDeclareList()
  local _ = {}
  if not self.actInfo or not self.actInfo.beDeclareList then
    return _
  end
  local curTime = UITimeManager:GetInstance():GetServerTime() or 0
  for k, v in ipairs(self.actInfo.beDeclareList) do
    local startTime = v.startTime or 0
    local endTime = v.endTime or 0
    if curTime >= startTime and curTime <= endTime then
      table.insert(_, v)
    end
  end
  return _
end

function SeasonCampDestroyManager:GetTimeInfo()
  local timeInfo = self.actInfo and self.actInfo.timeInfo
  if timeInfo then
    timeInfo:Refresh()
  end
  return timeInfo
end

function SeasonCampDestroyManager:GetCampInfoByType(campType)
  return self.actInfo and self.actInfo:GetCamp(campType)
end

function SeasonCampDestroyManager:GetServerInfoByIndex(index)
  return self.actInfo and self.actInfo:GetServerInfoByIndex(index)
end

function SeasonCampDestroyManager:GetServerInfoById(id)
  return self.actInfo and self.actInfo:GetServerInfoById(id)
end

function SeasonCampDestroyManager:GetMyServerInfo()
  if self.myServerIndex > 0 then
    return self:GetServerInfoByIndex(self.myServerIndex)
  end
  return nil
end

function SeasonCampDestroyManager:GetRealTimeIndex(timeIndex, setTime)
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

function SeasonCampDestroyManager:GetSeasonCell()
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

function SeasonCampDestroyManager:GetWarTimeConfigs()
  if table.IsNullOrEmpty(self.warTimeConfigs) then
    self.warTimeConfigs = {}
    local seasonConfigCell = self:GetSeasonCell()
    if seasonConfigCell ~= nil then
      local timePairs = string.split(seasonConfigCell.battle_time, "|")
      local index = 0
      for _, timePair in pairs(timePairs) do
        local timeData = SeasonCampDestroyWarTimeConfigData.New()
        timeData:SetData(timePair, index)
        self.warTimeConfigs[index] = timeData
        index = index + 1
      end
    end
  end
  return self.warTimeConfigs
end

function SeasonCampDestroyManager:GetWarTimeConfigData(index)
  if self:IsFuncOpen(true) then
    index = checknumber(index)
    local configs = self:GetWarTimeConfigs()
    if 0 <= index and index < table.count(configs) then
      return configs[index]
    end
  end
  return nil
end

function SeasonCampDestroyManager:GetIconPath(timeIndex)
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

function SeasonCampDestroyManager:GetMyAllianceWarTimeData()
  return self.myAllianceWarTimeData
end

function SeasonCampDestroyManager:GetAllianceWarTimeData(aid)
  if self.allianceWarTimeDataDict then
    return self.allianceWarTimeDataDict[aid]
  end
  return nil
end

function SeasonCampDestroyManager:GetValidWeeks()
  local seasonConfigCell = self:GetSeasonCell()
  if seasonConfigCell ~= nil then
    return string.split(seasonConfigCell.season_battle_day, ";")
  end
  return {}
end

function SeasonCampDestroyManager:IsDeclareDay()
  local weekPairs = self:GetValidWeeks()
  if table.count(weekPairs) > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local week = UITimeManager:GetInstance():GetWeekdayIndex(now)
    return table.hasvalue(weekPairs, checkstring(week))
  end
  return false
end

function SeasonCampDestroyManager:GetNextDeclareTime()
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

function SeasonCampDestroyManager:SendGetWarTimeInfo(aid)
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

function SeasonCampDestroyManager:OnGetWarTimeInfoCallback(res)
  if not self:IsActive() then
    return
  end
  if res == nil then
    return
  end
  if checkstring(res.aid) == "" then
    return
  end
  local data = self:HandleWarTimeData(res)
  EventManager:GetInstance():Broadcast(EventId.SeasonCampDestroyWarTimeGetInfoUpdate, data)
end

function SeasonCampDestroyManager:SendGetInfluenceDetail(allianceId)
  if not self:IsFuncOpen(true) then
    return
  end
  if string.IsNullOrEmpty(allianceId) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.FetchAllianceCityForceDetail, allianceId)
end

function SeasonCampDestroyManager:OnGetInfluenceDetailCallback(msg)
  if not msg then
    return
  end
  if msg.errorCode then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonCampDestroyInfluenceDetailRefresh, msg)
end

function SeasonCampDestroyManager:HandleWarTimeData(res)
  if res == nil then
    return
  end
  if string.IsNullOrEmpty(res.aid) then
    return
  end
  local data = SeasonCampDestroyWarTimeData.New()
  data:SetData(res)
  if self.allianceWarTimeDataDict == nil then
    self.allianceWarTimeDataDict = {}
  end
  self.allianceWarTimeDataDict[res.aid] = data
  if res.aid == LuaEntry.Player.allianceId then
    self.myAllianceWarTimeData = data
  end
  return data
end

local cityTypeFilter = {
  [WorldAllianceCityType.CrossZoneOutpostCanon] = true,
  [WorldAllianceCityType.Altar] = true,
  [WorldAllianceCityType.Canon] = true
}

function SeasonCampDestroyManager:GetCity2Map()
  if not self.expensiveCity2Map then
    self.expensiveCity2Map = {}
    local cityTabName = SeasonUtil.GetWorldCityTableName()
    LocalController:instance():visitTable(cityTabName, function(id, lineData)
      local cityId = id
      local zoneId = lineData.zoneId or -1
      local type = lineData.type
      if not cityTypeFilter[type] then
        self.expensiveCity2Map[cityId] = zoneId
      end
    end)
  end
  return self.expensiveCity2Map
end

function SeasonCampDestroyManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine()
  sb:AppendLine("[SeasonCampDestroyManager]")
  sb:AppendLineFormat("  ActId: %s", self.actId or "nil")
  sb:AppendLineFormat("  FuncOpen: %s", self:IsFuncOpen(true))
  sb:AppendLineFormat("  IsActive: %s", self:IsActive())
  sb:AppendLineFormat("  IsVisible: %s", self:ActIsVisible())
  sb:AppendLine()
  sb:AppendLine("[Activity Info]")
  if self.actInfo then
    sb:AppendLine(self.actInfo:Description())
  else
    sb:AppendLine("  NULL")
  end
  sb:AppendLine()
  sb:AppendLine("[War Time]")
  if self.myAllianceWarTimeData then
    sb:AppendLineFormat("  %s", self.myAllianceWarTimeData:Description())
  else
    sb:AppendLine("  NULL")
  end
  sb:AppendLineFormat("city2Map:%s", self.expensiveCity2Map and table.count(self.expensiveCity2Map) or 0)
  return sb:ToString()
end

function SeasonCampDestroyManager:GetCityNameById(cityId)
  if not cityId or cityId <= 0 then
    return ""
  end
  local cityData = LocalController:instance():getLine(TableName.WorldCity, cityId)
  if cityData and cityData.name then
    return CS.GameEntry.Localization:GetString(cityData.name)
  end
  return ""
end

function SeasonCampDestroyManager:OnDestroySuccess(msg)
  if not msg then
    return
  end
  local cityId = toInt(msg.cityId)
  local cityName = self:GetCityNameById(cityId)
  local title = Localization:GetString("311107")
  local content = Localization:GetString("season_s6_activity_1200112_desc18", cityName)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldRuinsPopUp, {anim = true}, content, title)
end

function SeasonCampDestroyManager:OnDefendSuccess(msg)
  if not msg then
    return
  end
  local cityId = toInt(msg.cityId)
  local cityName = self:GetCityNameById(cityId)
  local title = Localization:GetString("311109")
  local content = Localization:GetString("season_s6_activity_1200112_desc19", cityName)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldRuinsPopUp, {anim = true}, content, title)
end

function SeasonCampDestroyManager:SendGetRank(rankId)
  if not self:IsFuncOpen(true) then
    return
  end
  if not rankId or rankId <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.Season6CampDestroyGetRank, rankId)
end

function SeasonCampDestroyManager:OnGetRankCallback(msg)
  if not msg then
    return
  end
  local errCode = msg.errorCode
  if errCode then
    return
  end
  local rankId = msg.rankId
  self.rankCacheData = self.rankCacheData or {}
  self.rankCacheData[rankId] = {
    rankId = rankId,
    rank = msg.rank or {},
    selfScore = msg.selfScore or 0,
    selfRank = msg.selfRank or -1
  }
  EventManager:GetInstance():Broadcast(EventId.SeasonCampDestroyRankRefresh, rankId)
end

function SeasonCampDestroyManager:GetRankCacheData(rankId)
  if not self.rankCacheData then
    return nil
  end
  return self.rankCacheData[rankId]
end

function SeasonCampDestroyManager:ClearRankCache()
  self.rankCacheData = nil
end

function SeasonCampDestroyManager:GetFirstSeenRedPoint()
  if not self:IsActive() then
    return false
  end
  if self:HasOpenedActivity() then
    return false
  end
  return true
end

function SeasonCampDestroyManager:MarkActivityOpened()
  if not self:IsFuncOpen(true) then
    return
  end
  if self:HasOpenedActivity() then
    return
  end
  local key = self:GetActivityOpenedKey()
  if key then
    CommonUtil.PlayerPrefsSetBool(key, true)
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonCampDestroyActRefresh)
  EventManager:GetInstance():Broadcast(EventId.SeasonMainViewRefresh)
end

function SeasonCampDestroyManager:HasOpenedActivity()
  local key = self:GetActivityOpenedKey()
  if key then
    return CommonUtil.PlayerPrefsGetBool(key, false)
  end
  return false
end

function SeasonCampDestroyManager:GetActivityOpenedKey()
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    return "Season6CampDestroy_ActivityOpened"
  end
  return nil
end

function SeasonCampDestroyManager:GetCityOpenLevel()
  local cityOpenLevel = 3
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo ~= nil and cityWarInfo.nextOpen ~= nil then
    cityOpenLevel = cityWarInfo.nextOpen.level or 3
  end
  return cityOpenLevel
end

return SeasonCampDestroyManager
