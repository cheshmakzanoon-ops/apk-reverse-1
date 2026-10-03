local GovernmentTemplate = BaseClass("GovernmentTemplate")
local GroupOrder = {
  [GovOfficialGroup.Common] = 2,
  [GovOfficialGroup.Outpost] = 3,
  [GovOfficialGroup.Center] = 1
}

local function __init(self)
  self.id = 0
  self.name = ""
  self.effect = {}
  self.effectOrder = {}
  self.conqueror_effect = {}
  self.conqueror_effectOrder = {}
  self.icon = ""
  self.is_positive = 0
  self.title_name = 0
  self.status_id = 0
end

local function __delete(self)
  self.id = 0
  self.name = ""
  self.effect = {}
  self.effectOrder = {}
  self.conqueror_effect = {}
  self.conqueror_effectOrder = {}
  self.icon = ""
  self.is_positive = 0
  self.title_name = 0
  self.status_id = 0
  self.background = nil
end

function GovernmentTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.group = tonumber(row:getValue("group")) or 1001
  self.background = row:getValue("background")
  self.name = row:getValue("name") or ""
  local season_type = row:getValue("season_type") or {}
  local seasonTypeLength = #season_type
  if seasonTypeLength == 1 then
    self.season_type = season_type[1]
  elseif seasonTypeLength == 2 then
    self.season_type = SeasonUtil.TypeAndType1ToSubdivisionType(season_type[1], season_type[2])
  end
  self.order = tonumber(row:getValue("order")) or 0
  local icon = row:getValue("icon") or ""
  if string.startswith(icon, "Assets/Main/") then
    self.icon = icon
  else
    self.icon = string.format(LoadPath.UIGovernment, icon)
  end
  self.iconName = row:getValue("iconName") or icon
  self.supreme_president_power = row:getValue("supreme_president_power") == 1
  self.is_positive = row:getValue("is_positive") or 0
  self.status_id = row:getValue("status_id") or 0
  local effectStr = row:getValue("effect")
  if effectStr ~= nil and effectStr ~= nil then
    for item in string.gmatch(effectStr, "([^|]+)|?") do
      local effect_id, effect_num = string.match(item, "(%d+)[,;](%d+.?%d*)")
      if effect_id ~= nil and effect_num ~= nil then
        self.effect[toInt(effect_id)] = tonumber(effect_num)
        table.insert(self.effectOrder, toInt(effect_id))
      end
    end
  end
  self.title_name = tonumber(row:getValue("title_name")) or 0
  effectStr = row:getValue("conqueror_effect")
  if effectStr ~= nil and effectStr ~= nil then
    for item in string.gmatch(effectStr, "([^|]+)|?") do
      local effect_id, effect_num = string.match(item, "(%d+)[,;](%d+.?%d*)")
      if effect_id ~= nil and effect_num ~= nil then
        self.conqueror_effect[toInt(effect_id)] = tonumber(effect_num)
        table.insert(self.conqueror_effectOrder, toInt(effect_id))
      end
    end
  end
  local theGroupOrder = GroupOrder[self.group] or self.group
  self.uniqueOrder = theGroupOrder * 100 + self.order
end

GovernmentTemplate.__init = __init
GovernmentTemplate.__delete = __delete
return GovernmentTemplate
