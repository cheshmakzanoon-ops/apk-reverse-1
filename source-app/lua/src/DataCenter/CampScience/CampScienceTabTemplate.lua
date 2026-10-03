local CampScienceTabTemplate = BaseClass("CampScienceTabTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.name = 0
  self.description = 0
  self.description_tip = 0
  self.icon = 0
  self.max_lv = 0
  self.position = ""
  self.relation = ""
  self.info = ""
  self.tab = 0
  self.unlock_time = nil
  self.description_new = nil
  self.season_group = 0
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.description = nil
  self.description_tip = nil
  self.icon = nil
  self.max_lv = nil
  self.position = nil
  self.relation = nil
  self.info = nil
  self.tab = nil
  self.unlock_time = nil
  self.description_new = nil
  self.season_group = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.description = row:getValue("description")
  self.description_tip = row:getValue("description_tip")
  self.unlock_time = tonumber(row:getValue("unlock_time") or 0) or 0
  self.icon = row:getValue("icon")
  self.max_lv = row:getValue("max_lv")
  self.position = row:getValue("position")
  self.relation = row:getValue("relation")
  self.info = row:getValue("info")
  self.tab = row:getValue("tab")
  self.season_group = row:getIntValue("season_group", 0)
  self.description_new = row:getValue("description_new")
end

local function GetDesc(self)
  if type(self.description_new) == "table" then
    return Localization:GetString(self.description_new[1])
  end
  return Localization:GetString(self.description_new)
end

function CampScienceTabTemplate:IsTimeLock()
  local days = SeasonUtil.GetSeasonDay()
  local timeLock = days <= tonumber(self.unlock_time - 1)
  return timeLock
end

function CampScienceTabTemplate:GetTimeToLock()
  local days = SeasonUtil.GetSeasonDay()
  local timeMil = UITimeManager:GetInstance():GetResSecondsTo24() * 1000 + (tonumber(self.unlock_time - 1) - days) * 86400000
  return UITimeManager:GetInstance():MilliSecondToFmtStringWithoutSecond(timeMil), timeMil
end

CampScienceTabTemplate.__init = __init
CampScienceTabTemplate.__delete = __delete
CampScienceTabTemplate.InitData = InitData
CampScienceTabTemplate.GetDesc = GetDesc
return CampScienceTabTemplate
