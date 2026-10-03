local MultipleParkourMapTemplate = BaseClass("MultipleParkourMapTemplate")

function MultipleParkourMapTemplate:InitData(row)
  self.id = tonumber(row:getValue("id"))
  self.map_type = tonumber(row:getValue("map_type"))
  self.level = tonumber(row:getValue("level"))
  local is_boss = tonumber(row:getValue("is_boss")) or 0
  self.is_boss = is_boss == 1
  self.option1 = row:getValue("option1")
  self.option3 = row:getValue("option3")
  self.op_time = tonumber(row:getValue("op_time"))
  self.sprint_time = tonumber(row:getValue("sprint_time"))
  self.choose_speed = tonumber(row:getValue("choose_speed"))
  self.choose_over_speed = tonumber(row:getValue("choose_over_speed"))
  self.right_option = tonumber(row:getValue("right_option")) or 0
end

return MultipleParkourMapTemplate
