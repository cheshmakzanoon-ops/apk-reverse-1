local SeasonCityAltarManager = BaseClass("SeasonCityAltarManager")
local SeasonCityAltarPointData = require("UI.LWSeason6.UILWSeasonCityAltar.Map.SeasonCityAltarPointData")

function SeasonCityAltarManager:__init()
  self:InitVars()
end

function SeasonCityAltarManager:__delete()
end

function SeasonCityAltarManager:InitVars()
  self.LOG_ENABLE = true
  self.RankType = {
    None = 0,
    Bomb = 1,
    Enhance = 7,
    Mummy = 2,
    Magnet = 9,
    Ball = 8
  }
  self.PeriodType = {
    Day = 0,
    Week = 1,
    Total = 2
  }
  self.RankPeriodTypeData = {
    {
      PeriodType = self.PeriodType.Day,
      TabLocKey = "season_s5_activity_1200046_desc25"
    },
    {
      PeriodType = self.PeriodType.Week,
      TabLocKey = "season_s5_activity_1200046_desc26"
    },
    {
      PeriodType = self.PeriodType.Total,
      TabLocKey = "season_s5_activity_1200046_desc27"
    }
  }
  self.CacheRankData = {}
  self.WaitingRankData = {}
  self.CacheCityAltarList = nil
  self.WaitingCityAltarList = false
  self.CityCells = {}
  self.PointData = nil
  self.SendGetAltarInfoTime = 0
  self.FlagToName = {}
end

function SeasonCityAltarManager:GetSkillRankTypeTabData()
  self.RankTypeTabData = {}
  local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
  if seasonConfig ~= nil then
    local rankTypeStr = seasonConfig.alliance_skill
    local rankTypes = string.string2array_i_oneSep(rankTypeStr, "|")
    for _, rankType in ipairs(rankTypes) do
      local skillCell = LocalController:instance():tryGetLine(TableName.AllianceGovernmentSkill, rankType)
      if skillCell ~= nil then
        do
          local tabData
          LocalController:instance():visitTable(TableName.AllianceGovernmentSkillScore, function(id, cell)
            if checknumber(cell.type) == checknumber(skillCell.skill_score) then
              tabData = {
                RankType = checknumber(skillCell.skill_flag),
                TabLocKey = cell.skill_name
              }
              return true
            end
          end)
          if tabData ~= nil then
            table.insert(self.RankTypeTabData, tabData)
          end
        end
      end
    end
  end
  return self.RankTypeTabData
end

function SeasonCityAltarManager:Index2RankType(index)
  local tabData = self:GetSkillRankTypeTabData()
  if table.IsNullOrEmpty(tabData) then
    return self.RankType.None
  end
  return tabData[index].RankType or self.RankType.None
end

function SeasonCityAltarManager:SetActId(actId)
  self.ActId = actId
  self.ActCell = LocalController:instance():getLine(TableName.Activity, checknumber(self.ActId))
  self.ActData = DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
end

function SeasonCityAltarManager:GetCityAltarCells(serverId)
  if checknumber(serverId) == 0 then
    serverId = LuaEntry.Player:GetSourceServerId()
  end
  if table.IsNullOrEmpty(self.CityCells) then
    self.CityCells = {}
    local cityCells = {}
    local table_name = SeasonUtil.GetWorldCityTableNameByServerId(serverId)
    LocalController:instance():visitTable(table_name, function(id, cell)
      if cell.type == WorldAllianceCityType.Altar then
        local cityCell = DataCenter.AllianceCityTemplateManager:GetTemplate(cell.id, serverId)
        if cityCell ~= nil then
          table.insert(cityCells, cityCell)
        end
      end
    end)
    table.sort(cityCells, function(a, b)
      return a.level < b.level or a.level == b.level and a.id < b.id
    end)
    local lastLevel = -1
    for _, cityCell in ipairs(cityCells) do
      if cityCell.level ~= lastLevel then
        table.insert(self.CityCells, cityCell)
        lastLevel = cityCell.level
      end
    end
  end
  return self.CityCells
end

function SeasonCityAltarManager:GetAltarSkillCell(cityId, serverId)
  if checknumber(serverId) == 0 then
    serverId = LuaEntry.Player:GetSourceServerId()
  end
  local table_name = SeasonUtil.GetWorldCityTableNameByServerId(serverId)
  local cityCell = LocalController:instance():tryGetLine(table_name, checknumber(cityId))
  if cityCell ~= nil and not string.IsNullOrEmpty(cityCell.buff) then
    local buffId, _ = string.string2_ii(cityCell.buff, ";")
    local skillCell
    LocalController:instance():visitTable(TableName.AllianceGovernmentSkill, function(id, cell)
      if checknumber(buffId) == checknumber(cell.prerequisites_effect) then
        skillCell = cell
        return true
      end
    end)
    return skillCell
  end
  return nil
end

function SeasonCityAltarManager:GetPointData(pointInfo, serverId)
  local pointData = SeasonCityAltarPointData.New()
  pointData:SetData(pointInfo, serverId)
  return pointData
end

function SeasonCityAltarManager:GetAltarMaxScore()
  return LuaEntry.DataConfig:TryGetNum("season_s6_alter_parameter", "k1", 1)
end

function SeasonCityAltarManager:GetMaxAltarCount()
  if self.ActData == nil then
    return 0
  end
  local str = LuaEntry.DataConfig:TryGetStr("season_s6_alter_parameter", "k5", "")
  local countConfig = string.string2array_i_oneSep(str, "|")
  if table.IsNullOrEmpty(countConfig) then
    return 0
  end
  local startTime = self.ActData:GetShowStartTime()
  local weekZero = UITimeManager:GetInstance():WeekZero(startTime)
  local past = UITimeManager:GetInstance():GetServerTime() - weekZero
  local pastWeek = Mathf.Floor(past / OneWeekTime / 1000) + 1
  local index = Mathf.Min(pastWeek, table.count(countConfig))
  return countConfig[index]
end

function SeasonCityAltarManager:GetNextAddUpInfo()
  if self.ActData == nil then
    return 0, 0
  end
  local str = LuaEntry.DataConfig:TryGetStr("season_s6_alter_parameter", "k5", "")
  local countConfig = string.string2array_i_oneSep(str, "|")
  if table.IsNullOrEmpty(countConfig) then
    return 0, 0
  end
  local startTime = self.ActData:GetShowStartTime()
  local weekZero = UITimeManager:GetInstance():WeekZero(startTime)
  local past = UITimeManager:GetInstance():GetServerTime() - weekZero
  local pastWeek = Mathf.Floor(past / OneWeekTime / 1000) + 1
  local curIndex = Mathf.Min(pastWeek, table.count(countConfig))
  local curValue = countConfig[curIndex]
  for i = curIndex + 1, table.count(countConfig) do
    if curValue < countConfig[i] then
      return weekZero + (i - 1) * OneWeekTime * 1000, countConfig[i] - curValue
    end
  end
  return 0, 0
end

function SeasonCityAltarManager:IsAnyAltarInContention(serverId)
  if checknumber(serverId) == 0 then
    serverId = LuaEntry.Player:GetSourceServerId()
  end
  local table_name = SeasonUtil.GetWorldCityTableNameByServerId(serverId)
  local seasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local inContention = false
  LocalController:instance():visitTable(table_name, function(id, cell)
    if cell.type == WorldAllianceCityType.Altar then
      local firstDay = checknumber(cell.first_open)
      local loopDay = checknumber(cell.loop_blank)
      local openTimes = checknumber(cell.loop_time)
      local offsetHour, durationMin = string.string2_ii(cell.open_para, "|")
      for i = 1, openTimes do
        local day = firstDay + (i - 1) * loopDay
        local dayZeroTime = seasonStartTime + (day - 1) * OneDayTime * 1000
        local startTime = dayZeroTime + offsetHour * OneHourTime * 1000
        local endTime = startTime + durationMin * 60 * 1000
        if startTime <= now and endTime >= now then
          inContention = true
          return true
        end
      end
    end
  end)
  return inContention
end

function SeasonCityAltarManager:GetCityNameByFlag(flag, serverId)
  if table.IsNullOrEmpty(self.FlagToName) then
    self.FlagToName = {}
    serverId = checknumber(serverId) > 0 and serverId or LuaEntry.Player:GetSelfServerId()
    local table_name = SeasonUtil.GetWorldCityTableNameByServerId(serverId)
    LocalController:instance():visitTable(table_name, function(id, cell)
      if cell.type == WorldAllianceCityType.Altar then
        local cityCell = DataCenter.AllianceCityTemplateManager:GetTemplate(cell.id, serverId)
        if cityCell ~= nil then
          self.FlagToName[cell.flag] = cityCell:GetFullName()
        end
      end
    end)
  end
  return self.FlagToName[flag]
end

function SeasonCityAltarManager:SendGetRank(rankType, periodType)
  if self:IsWaitingRank(rankType, periodType) then
    return
  end
  self:SetWaitingRank(rankType, periodType, true)
  local param = {}
  param.skill = rankType
  param.timeType = periodType
  SFSNetwork.SendMessage(MsgDefines.CityaltarSkillRank, param)
end

function SeasonCityAltarManager:OnGetRankCallback(res)
  if res == nil then
    return
  end
  local rankType = checknumber(res.skill)
  local periodType = checknumber(res.timeType)
  self:SetWaitingRank(rankType, periodType, false)
  self:SetCacheRankData(rankType, periodType, res)
end

function SeasonCityAltarManager:IsWaitingRank(rankType, periodType)
  if self.WaitingRankData[rankType] == nil then
    return false
  end
  return self.WaitingRankData[rankType][periodType]
end

function SeasonCityAltarManager:SetWaitingRank(rankType, periodType, waiting)
  if self.WaitingRankData[rankType] == nil then
    self.WaitingRankData[rankType] = {}
  end
  self.WaitingRankData[rankType][periodType] = waiting
end

function SeasonCityAltarManager:SetCacheRankData(rankType, periodType, data)
  if self.CacheRankData[rankType] == nil then
    self.CacheRankData[rankType] = {}
  end
  if self.CacheRankData[rankType][periodType] == nil then
    self.CacheRankData[rankType][periodType] = {}
  end
  self.CacheRankData[rankType][periodType] = data
  EventManager:GetInstance():Broadcast(EventId.SeasonCityAltarSkillRankUpdate, {RankType = rankType, PeriodType = periodType})
end

function SeasonCityAltarManager:GetCacheRankData(rankType, periodType)
  if self.CacheRankData[rankType] == nil then
    return nil
  end
  if self.CacheRankData[rankType][periodType] == nil then
    return nil
  end
  return self.CacheRankData[rankType][periodType]
end

function SeasonCityAltarManager:ClearRankData()
  self.CacheRankData = {}
  self.WaitingRankData = {}
end

function SeasonCityAltarManager:SendGetCityAltarList()
  SFSNetwork.SendMessage(MsgDefines.CityaltarList)
end

function SeasonCityAltarManager:OnGetCityAltarListCallback(payload)
  self.WaitingCityAltarList = false
  if payload == nil or table.IsNullOrEmpty(payload.list) then
    return
  end
  self.CacheCityAltarList = payload.list
  EventManager:GetInstance():Broadcast(EventId.SeasonCityAltarListUpdate)
end

function SeasonCityAltarManager:GetCacheCityAltarList()
  return self.CacheCityAltarList
end

function SeasonCityAltarManager:ClearCityAltarList()
  self.CacheCityAltarList = {}
  self.WaitingCityAltarList = false
end

function SeasonCityAltarManager:SendFish(uuid, sid)
  SFSNetwork.SendMessage(MsgDefines.CityaltarBoxesCreate, uuid, sid)
end

function SeasonCityAltarManager:OnFishCallback(payload)
end

function SeasonCityAltarManager:SendGetAltarInfo(cfgId, sid)
  local now = UITimeManager:GetInstance():GetServerTime()
  if now - checknumber(self.SendGetAltarInfoTime) < 2000 then
    return
  end
  self.SendGetAltarInfoTime = UITimeManager:GetInstance():GetServerTime()
  SFSNetwork.SendMessage(MsgDefines.CityaltarDetail, cfgId, sid)
end

function SeasonCityAltarManager:OnGetAltarInfoCallback(payload)
  if payload ~= nil then
    EventManager:GetInstance():Broadcast(EventId.SeasonCityAltarGetAltarInfo, payload)
  end
end

function SeasonCityAltarManager:ClearSendGetAltarInfoTime()
  self.SendGetAltarInfoTime = 0
end

function SeasonCityAltarManager:OnOccupyAltar(payload)
  if payload == nil then
    return
  end
  if payload.aid ~= LuaEntry.Player.allianceId then
    return
  end
  local altarId = checknumber(payload.cfgid)
  local serverId = checknumber(payload.sid)
  local cityCell = DataCenter.AllianceCityTemplateManager:GetTemplate(altarId, serverId)
  local cityName = ""
  if cityCell ~= nil then
    cityName = cityCell:GetFullName()
  end
  local skillCell = DataCenter.SeasonCityAltarManager:GetAltarSkillCell(altarId, serverId)
  local skillName = ""
  if skillCell ~= nil then
    skillName = CS.GameEntry.Localization:GetString(skillCell.name)
  end
  local title = CS.GameEntry.Localization:GetString("311107")
  local content = CS.GameEntry.Localization:GetString("season_s6_activity_1200116_desc28", cityName, skillName)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldRuinsPopUp, {anim = true}, content, title)
end

function SeasonCityAltarManager:Log(desc, ...)
  if self.LOG_ENABLE and CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
    local msg = string.format(desc, ...)
    Logger.Log(string.format("[SeasonCityAltarManager] %s", msg))
  end
end

return SeasonCityAltarManager
