local WorldDesertRefreshTemplate = BaseClass("WorldDesertRefreshTemplate")

local function __init(self)
  self.id = 0
  self.city_id = 0
  self.em_desertId = 0
end

local function __delete(self)
  self.id = nil
  self.city_id = nil
  self.em_desertId = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.city_id = row:getValue("city_id")
  self.em_desertId = row:getValue("em_desertid")
end

WorldDesertRefreshTemplate.__init = __init
WorldDesertRefreshTemplate.__delete = __delete
WorldDesertRefreshTemplate.InitData = InitData
return WorldDesertRefreshTemplate
