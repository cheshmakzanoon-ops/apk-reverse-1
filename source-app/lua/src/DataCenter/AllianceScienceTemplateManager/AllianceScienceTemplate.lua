local AllianceScienceTemplate = BaseClass("AllianceScienceTemplate")

local function __init(self)
  self.id = 0
  self.science_id = 0
  self.level = 0
  self.max_lv = 0
  self.power = 0
  self.maxProNum = 0
  self.expAdd = 0
  self.contribution = 0
  self.effectNum = ""
  self.name = ""
  self.description = ""
  self.icon = ""
  self.show = 0
  self.points = 0
  self.condition = {}
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
  self.effectNum = nil
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
  self.expAdd = row:getValue("schedule")
  self.contribution = row:getValue("contribution")
  self.effectKey = row:getIntValue("para1")
  self.effectNum = row:getValue("para2")
end

AllianceScienceTemplate.__init = __init
AllianceScienceTemplate.__delete = __delete
AllianceScienceTemplate.InitData = InitData
return AllianceScienceTemplate
