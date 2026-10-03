local EffectNumberTemplate = BaseClass("EffectNumberTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.desc = ""
  self.type = 0
  self.sequence = 0
  self.category = 0
  self.power = 0
  self.equip_sequence = 0
  self.equip_category = 0
  self.icon = ""
  self.display_type_gallery = 0
  self.display_order_gallery = 0
  self.season_condition = ""
  self.season_desc = ""
  self.season_name = ""
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.desc = nil
  self.type = nil
  self.sequence = nil
  self.category = nil
  self.power = nil
  self.equip_sequence = nil
  self.equip_category = nil
  self.icon = nil
  self.display_type_gallery = nil
  self.display_order_gallery = nil
  self.season_condition = nil
  self.season_desc = nil
  self.season_name = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.name = row:getValue("name") or ""
  self.desc = row:getValue("desc") or ""
  self.type = tonumber(row:getValue("type")) or 0
  self.sequence = tonumber(row:getValue("sequence")) or 0
  self.category = tonumber(row:getValue("category")) or 0
  self.power = tonumber(row:getValue("power")) or 0
  self.equip_sequence = tonumber(row:getValue("sequence_equip")) or 0
  self.equip_category = tonumber(row:getValue("category_equip")) or 0
  self.icon = row:getValue("icon") or ""
  self.display_type_gallery = tonumber(row:getValue("display_type_gallery")) or 0
  self.display_order_gallery = tonumber(row:getValue("display_order_gallery")) or 0
  self.season_condition = row:getValue("season_condition")
  self.season_desc = row:getValue("season_desc")
  self.season_name = row:getValue("season_name")
  if not string.IsNullOrEmpty(self.season_condition) and not string.IsNullOrEmpty(self.season_desc) then
    self.seasonNameList = {}
    local conditions = string.split(self.season_condition, "|")
    local names = string.split(self.season_name, "|")
    local descs = string.split(self.season_desc, "|")
    if #conditions ~= #names then
      Logger.LogError("\233\133\141\231\189\174\233\151\174\233\162\152\239\188\140\232\181\155\229\173\163\233\133\141\231\189\174\228\184\142\230\143\143\232\191\176\230\149\176\233\135\143\229\175\185\229\186\148\228\184\141\228\184\138")
      return
    end
    for i, conditionStr in ipairs(conditions) do
      if not string.IsNullOrEmpty(conditionStr) then
        local season, seasonDay = string.match(conditionStr, "(%d+);(%d+)")
        if season and seasonDay then
          local seasonInfo = {}
          seasonInfo.season = season
          seasonInfo.seasonDay = seasonDay
          seasonInfo.name = names[i]
          seasonInfo.desc = descs[i]
          table.insert(self.seasonNameList, seasonInfo)
        end
      end
    end
  end
  self.power_extra = tonumber(row:getValue("power_extra")) or 0
end

function EffectNumberTemplate:GetNameKey()
  if not self.seasonNameList then
    return self.name
  end
  local tarIndex = self:CheckSeasonCondition()
  if tarIndex then
    return self.seasonNameList[tarIndex].name
  else
    return self.name
  end
  return ""
end

function EffectNumberTemplate:GetDescKey()
  if not self.seasonNameList then
    return self.desc
  end
  local tarIndex = self:CheckSeasonCondition()
  if tarIndex then
    return self.seasonNameList[tarIndex].desc
  else
    return self.desc
  end
  return ""
end

function EffectNumberTemplate:CheckSeasonCondition()
  local nowSeason = SeasonUtil.GetSeason()
  local nowSeasonDay = SeasonUtil.GetSeasonDay()
  local tarIndex
  for i, seasonInfo in ipairs(self.seasonNameList) do
    if seasonInfo and (nowSeason > tonumber(seasonInfo.season) or nowSeason == tonumber(seasonInfo.season) and nowSeasonDay >= tonumber(seasonInfo.seasonDay)) then
      tarIndex = i
      break
    end
  end
  return tarIndex
end

EffectNumberTemplate.__init = __init
EffectNumberTemplate.__delete = __delete
EffectNumberTemplate.InitData = InitData
return EffectNumberTemplate
