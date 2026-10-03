local LWSeasonTrendsTemplate = BaseClass("LWSeasonTrendsTemplate")

local function __init(self)
  self.id = 0
  self.unlock_time = 0
  self.cityData = nil
  self.cardData = nil
  self.functionData = nil
  self.donataData = nil
end

local function __delete(self)
  self.id = nil
  self.unlock_time = nil
  self.cityData = nil
  self.cardData = nil
  self.functionData = nil
  self.donataData = nil
end

function LWSeasonTrendsTemplate:InitData(row)
  self.id = row.id
  self.targetCount = toInt(row.para2)
  self.season_group = toInt(row.season_group)
  self.unlock_time = toInt(row.unlock_time)
  self.expired_time = toInt(row.expired_time)
  self.type = row.type
  self.week_stage = row.week_stage
  if row.unlock_city > 0 then
    self.cityData = {}
    self.cityData.city = row.unlock_city
    self.cityData.icon = row.unlock_city_icon
    self.cityData.name = row.unlock_city_name
    self.cityData.desc = row.unlock_city_desc
    self.cityData.jump = row.jump_city_type
    self.cityData.param = row.jump_city_para
  end
  if not string.IsNullOrEmpty(row.unlock_officer_recruit_icon) then
    self.cardData = {}
    self.cardData.icon = row.unlock_officer_recruit_icon
    self.cardData.name = row.officer_recruit_name
    self.cardData.desc = row.officer_recruit_desc
    self.cardData.cardId = toInt(row.unlock_officer_recruit)
  end
  if not string.IsNullOrEmpty(row.unlock_icon) then
    local icons = string.split(row.unlock_icon, "|")
    local names = string.split(row.unlock_name, "|")
    local descs = string.split(row.unlock_desc, "|")
    local jumps = string.split(row.jump_type, "|")
    local params = string.split(row.jump_para, "|")
    if #icons == #names and #icons == #descs and #icons == #jumps and #icons == #params then
      self.functionData = {}
      local count = #icons
      for i = 1, count do
        local data = {}
        data.icon = icons[i]
        data.name = names[i]
        data.desc = descs[i]
        data.jump = jumps[i]
        data.param = params[i]
        table.insert(self.functionData, data)
      end
    else
      Logger.LogError("data erorr id: " .. self.di)
    end
  end
  if row.type == 11 then
    self.donataData = {}
    if not string.IsNullOrEmpty(row.resource_donate) then
      local str = string.split(row.resource_donate, ";")
      if #str == 5 then
        self.donataData.resource = {}
        self.donataData.resource.type = tonumber(str[1])
        self.donataData.resource.count = tonumber(str[2])
        self.donataData.resource.cost = tonumber(str[3])
      else
        Logger.LogError("data erorr id: " .. self.di .. ", resource_donate:" .. row.resource_donate)
      end
    end
    if not string.IsNullOrEmpty(row.diamond_donate) then
      local str = string.split(row.diamond_donate, ";")
      if #str == 3 then
        self.donataData.diamond = tonumber(str[1])
      else
        Logger.LogError("data erorr id: " .. self.di .. ", diamond_donate:" .. row.diamond_donate)
      end
    end
  end
  if not string.IsNullOrEmpty(row.person_effect_num) then
    local effectId, effectValue = string.match(row.person_effect_num, "([^;]+);([^;]+)")
    if effectId and effectValue then
      self.personEffectId = toInt(effectId)
      self.personEffectValue = tonumber(effectValue)
    end
  end
  if not string.IsNullOrEmpty(row.alliance_effect_num) then
    local effectId, effectValue = string.match(row.alliance_effect_num, "([^;]+);([^;]+)")
    if effectId and effectValue then
      self.allianceEffectId = toInt(effectId)
      self.allianceEffectValue = tonumber(effectValue)
    end
  end
end

return LWSeasonTrendsTemplate
