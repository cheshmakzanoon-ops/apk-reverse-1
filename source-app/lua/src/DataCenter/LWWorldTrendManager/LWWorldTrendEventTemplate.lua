local LWWorldTrendEvenetTemplate = BaseClass("LWWorldTrendEvenetTemplate")
local path = "Assets/Main/TextureEx/LWWorldTrend/%s"
local heroIconPath = "Assets/Main/TextureEx/LWHeroBust/%s"
local Localization = CS.GameEntry.Localization
local dayTime = 86400000

function LWWorldTrendEvenetTemplate:__init()
  self.id = 0
  self.priority = 0
  self.type = 0
  self.event_type = 0
  self.eventParal = 0
  self.name = ""
  self.des = ""
  self.pic = ""
  self.jumpType = 0
  self.jumpParal = 0
  self.event_time_color = ""
  self.event_name_color = ""
  self.event_description_color = ""
  self.heroId = 0
  self.seasonId = 0
  self.event_time = 0
  self.activity_start_time = 0
  self.activity_end_time = 0
  self.activityId = 0
  self.startDay = 99
  self.cross_server = 0
  self.event_server = {}
end

function LWWorldTrendEvenetTemplate:__delete()
  self.id = nil
  self.priority = nil
  self.type = nil
  self.event_type = nil
  self.eventParal = nil
  self.name = nil
  self.des = nil
  self.pic = nil
  self.jumpType = nil
  self.jumpParal = nil
  self.event_time_color = nil
  self.event_name_color = nil
  self.event_description_color = nil
  self.heroId = nil
  self.seasonId = nil
  self.event_time = nil
  self.activity_start_time = nil
  self.activity_end_time = nil
  self.activityId = nil
  self.startDay = 0
  self.cross_server = nil
  self.event_server = nil
end

function LWWorldTrendEvenetTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.priority = row:getValue("event_priority")
  self.type = row:getValue("event_type")
  self.event_type = row:getValue("event_type")
  self.eventParal = row:getValue("event_paral")
  self.name = row:getValue("event_name")
  self.des = row:getValue("event_description")
  self.pic = row:getValue("event_pic")
  self.jumpType = row:getValue("event_jump_type")
  self.jumpParal = row:getValue("event_jump_paral")
  self.event_time_color = row:getValue("event_time_color")
  self.event_name_color = row:getValue("event_name_color")
  self.event_description_color = row:getValue("event_description_color")
  self.event_hero_pic = row:getValue("event_hero_pic")
  self.heroId = row:getValue("hero")
  local serverStartTime = LuaEntry.Player.openServerTime
  if self.event_type == 1 then
    self.activityId = tonumber(self.eventParal)
  elseif self.event_type == 2 then
    self.startDay = tonumber(self.eventParal) or 99
  elseif self.event_type == 3 then
    self.eventParal = string.split(self.eventParal, "|")
    local weekDay = UITimeManager:GetInstance():GetWeekdayIndex(serverStartTime)
    self.startDay = self:GetStartDay(weekDay, tonumber(self.eventParal[1]), tonumber(self.eventParal[2]))
  elseif self.event_type == 4 then
    self.eventParal = string.split(self.eventParal, "|")
    self.seasonId = tonumber(self.eventParal[1])
    self.startDay = tonumber(self.eventParal[2]) or 99
  end
  self.event_time = tonumber(row:getValue("event_time")) or 0
  self.cross_server = tonumber(row:getValue("cross_server")) or 0
  self.event_server = row:getValue("event_server") or {}
end

function LWWorldTrendEvenetTemplate:GetStartDay(week_open_day, startWeek, startDay)
  local week = 4 <= week_open_day and 0 or 1
  local activity_open_week = startWeek
  local activity_open_day = startDay
  local open_days = 7 - week_open_day + 1 + (activity_open_week - week - 1) * 7 + activity_open_day
  return open_days
end

function LWWorldTrendEvenetTemplate:GetName()
  return Localization:GetString(self.name)
end

function LWWorldTrendEvenetTemplate:GetDes()
  return Localization:GetString(self.des)
end

function LWWorldTrendEvenetTemplate:GetHeroSpinePath()
  if not self.heroId or self.heroId == 0 then
    return nil
  else
    local iHeroID = tonumber(self.heroId)
    if not iHeroID then
      return nil
    end
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(iHeroID)
    if newAppearanceId then
      return GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
    end
  end
end

function LWWorldTrendEvenetTemplate:GetStartTime()
  if self.event_type == 1 then
    return self.activity_start_time
  end
  if self.event_type == 4 and self.seasonId == DataCenter.LWWorldTrendDataManager:GetCurSeasonId() then
    return (self.startDay - 1) * dayTime + DataCenter.LWWorldTrendDataManager:GetCurSeasonStartTime()
  end
  return (self.startDay - 1) * dayTime + DataCenter.LWWorldTrendDataManager:GetOpenServerZeroTime()
end

function LWWorldTrendEvenetTemplate:GetPath()
  return string.format(path, self.pic)
end

function LWWorldTrendEvenetTemplate:GetEndTime()
  if self.event_type == 1 and self.event_time == 0 then
    return self.activity_end_time
  end
  if self.event_time > 0 then
    return self:GetStartTime() + self.event_time * 1000
  end
  return -1
end

return LWWorldTrendEvenetTemplate
