local CampScienceDetailTemplate = BaseClass("CampScienceDetailTemplate")

local function __init(self)
  self.id = 0
  self.science_id = 0
  self.level = 0
  self.max_lv = 0
  self.power = 0
  self.maxProNum = 0
  self.expAdd = 0
  self.contribution = 0
  self.effectKey = ""
  self.effectNum = ""
  self.name = ""
  self.description = ""
  self.icon = ""
  self.show = 0
  self.points = 0
  self.condition = {}
  self.buff_type = 0
  self.resource = 0
  self.donate_price_start = 0
  self.camp_map_effect = ""
  self.camp_map_effect_num = ""
end

local function __delete(self)
  self.id = nil
  self.science_id = nil
  self.level = nil
  self.name = nil
  self.icon = nil
  self.description = nil
  self.max_lv = nil
  self.show = nil
  self.power = nil
  self.points = nil
  self.condition = nil
  self.maxProNum = nil
  self.expAdd = nil
  self.contribution = nil
  self.effectKey = nil
  self.effectNum = nil
  self.resource = nil
  self.donate_price_start = nil
  self.buff_type = nil
  self.camp_map_effect = nil
  self.camp_map_effect_num = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.science_id = row:getValue("science_id")
  self.level = row:getValue("science_lv")
  self.name = row:getValue("name")
  self.icon = row:getValue("icon")
  self.description = row:getValue("description")
  self.max_lv = row:getValue("max_lv")
  self.show = row:getValue("show")
  self.power = row:getValue("power")
  self.points = row:getValue("points")
  local pre_sciences = row:getValue("condition")
  table.walk(pre_sciences, function(k, v)
    local pre_science_id = tonumber(v)
    local need = {}
    need.level = pre_science_id % 100
    need.scienceId = pre_science_id - need.level
    table.insert(self.condition, need)
  end)
  self.maxProNum = row:getValue("value")
  self.expAdd = row:getValue("exp")
  self.contribution = row:getValue("contribution")
  self.effectKey = row:getValue("para1")
  self.effectNum = row:getValue("para2")
  self.resource = row:getIntValue("resource") or 0
  self.donate_price_start = row:getIntValue("donate_price_start") or 0
  self.buff_type = row:getIntValue("buff_type") or 0
  self.camp_map_effect = row:getValue("camp_map_effect")
  self.camp_map_effect_num = row:getValue("camp_map_effect_num")
end

CampScienceDetailTemplate.__init = __init
CampScienceDetailTemplate.__delete = __delete
CampScienceDetailTemplate.InitData = InitData
return CampScienceDetailTemplate
