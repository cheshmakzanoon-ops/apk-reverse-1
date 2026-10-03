local base = require("Common.TemplateBase")
local SeasonTemplateData = BaseClass("SeasonTemplateData", base)

function SeasonTemplateData:OnCreate()
end

function SeasonTemplateData:OnDestroy()
end

function SeasonTemplateData:InitData(info, serverDate, serverTime)
  if info == nil then
    return
  end
  local tbl_index, tbl_data, tbl_ext = info:getMetaData()
  base.SetRowData(self, tbl_index, tbl_data, tbl_ext)
  self.configId = self.id
  local open_time = info:getValue("start_time")
  local end_time = info:getValue("end_time")
  if open_time and end_time then
    local yearOpen, monthOpen, dayOpen = string.match(open_time, "(%d+)/(%d+)/(%d+)")
    local nYearOpen = toInt(yearOpen)
    local nMonthOpen = toInt(monthOpen)
    local nDayOpen = toInt(dayOpen)
    if 2024 < nYearOpen or nYearOpen == 2024 and 4 <= nMonthOpen then
      local configOpenTime = SafeLocalOsTime({
        year = nYearOpen,
        month = nMonthOpen,
        day = nDayOpen,
        hour = 0,
        min = 0,
        sec = 0
      })
      if serverTime > configOpenTime then
        self.isAlive = true
      end
      self.start_time = configOpenTime
      self.start_time_str = open_time
    end
  end
end

function SeasonTemplateData:IsMember(serverId)
  local server_ids = self.server_ids
  return server_ids ~= nil and server_ids[toInt(serverId)] == true
end

function SeasonTemplateData.getters:truce_name()
  return self:getValue("truce_name")
end

function SeasonTemplateData.getters:truce_icon()
  return self:getValue("truce_icon")
end

function SeasonTemplateData.getters:truceEnterStartTime()
  if self._truceEnterStartTime == nil then
    local truce_start_time = self:getValue("truce_start_time")
    if not string.IsNullOrEmpty(truce_start_time) then
      self._truceEnterStartTime = tonumber(truce_start_time) or 0
      self._truceEnterStartTime = self.truceEnterStartTime - 1
    end
  end
  return self._truceEnterStartTime
end

function SeasonTemplateData.getters:truceEnterEndTime()
  if self._truceEnterEndTime == nil then
    local truce_end_time = self:getValue("truce_end_time")
    if not string.IsNullOrEmpty(truce_end_time) then
      self._truceEnterEndTime = tonumber(truce_end_time)
    end
  end
  return self._truceEnterEndTime
end

function SeasonTemplateData.getters:truceEnterActivityList()
  if self._truceEnterActivityList == nil then
    local truce_activity = self:getValue("truce_activity")
    if string.IsNullOrEmpty(truce_activity) then
      self._truceEnterActivityList = {}
    else
      self._truceEnterActivityList = string.string2array_i_oneSep(truce_activity, ";")
    end
  end
  return self._truceEnterActivityList
end

function SeasonTemplateData.getters:city()
  return self:getValue("city")
end

function SeasonTemplateData.getters:season_rocky_ground()
  return self:getValue("season_rocky_ground")
end

function SeasonTemplateData.getters:server_type()
  return self:getIntValue("type", 0)
end

function SeasonTemplateData.getters:server_index()
  return self:getIntValue("season", 0)
end

function SeasonTemplateData.getters:packConfig()
  return self:getIntValue("package", 0)
end

function SeasonTemplateData.getters:seasonRankInfo()
  local seasonRankInfo = {}
  local season_rank_info = self:getValue("season_rank_info")
  if season_rank_info ~= nil and season_rank_info ~= "" then
    for item in string.gmatch(season_rank_info, "([^|]+)") do
      local data = string.split(item, ";")
      if data and #data == 4 then
        local rankInfo = {
          type = toInt(data[1]),
          name = data[2],
          desc = data[3],
          iconPath = data[4]
        }
        table.insert(seasonRankInfo, rankInfo)
      else
        Logger.LogError("season config id: " .. self.id .. ", season_rank_info is wrong")
      end
    end
  end
  self.seasonRankInfo = seasonRankInfo
  return seasonRankInfo
end

function SeasonTemplateData.getters:server_ids()
  local server_ids = {}
  local server_group = self:getValue("server", "")
  local server_int_arr = string.split_ii_array(server_group, ";")
  for k, serverId in ipairs(server_int_arr) do
    server_ids[serverId] = true
  end
  self.server_ids = server_ids
  return server_ids
end

return SeasonTemplateData
