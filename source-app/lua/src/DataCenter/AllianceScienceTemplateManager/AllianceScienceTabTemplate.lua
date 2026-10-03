local AllianceScienceTabTemplate = BaseClass("AllianceScienceTabTemplate")
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
  self.desc_condition = nil
  self.description_new = nil
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
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.description = row:getValue("description")
  self.description_tip = row:getValue("description_tip")
  self.icon = row:getValue("icon")
  self.max_lv = row:getValue("max_lv")
  self.position = row:getValue("position")
  self.relation = row:getValue("relation")
  self.info = row:getValue("info")
  self.tab = row:getValue("tab")
  self.season_group = row:getIntValue("season_group", 0)
  self.desc_condition = row:getValue("desc_condition")
  self.description_new = row:getValue("description_new")
end

local function GetDesc(self)
  local desc_key
  if not table.IsNullOrEmpty(self.desc_condition) then
    local nowSeason = SeasonUtil.GetSeason()
    local nowSeasonDay = SeasonUtil.GetSeasonDay()
    local key_id
    for i = #self.desc_condition, 1, -1 do
      local condition = self.desc_condition[i]
      local season, seasonDay = string.match(condition, "(%d+);(%d+)")
      if season and seasonDay and (nowSeason > tonumber(season) or nowSeason == tonumber(season) and nowSeasonDay >= tonumber(seasonDay)) then
        key_id = i
        break
      end
    end
    if key_id then
      if self.description_new[key_id] then
        desc_key = self.description_new[key_id]
      else
        desc_key = self.description_new[#self.description_new]
      end
    end
  end
  desc_key = desc_key or self.description
  return Localization:GetString(desc_key)
end

AllianceScienceTabTemplate.__init = __init
AllianceScienceTabTemplate.__delete = __delete
AllianceScienceTabTemplate.InitData = InitData
AllianceScienceTabTemplate.GetDesc = GetDesc
return AllianceScienceTabTemplate
