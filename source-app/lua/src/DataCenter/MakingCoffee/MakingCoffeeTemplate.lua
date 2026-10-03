local MakingCoffeeTemplate = BaseClass("MakingCoffeeTemplate")

local function __init(self)
end

local function __delete(self)
  self.id = nil
  self.icon = nil
  self.desc = nil
  self.status = nil
  self.order = nil
  self.name = nil
  self.info = nil
  self.unlock_goods = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.icon = row:getValue("icon")
  self.desc = row:getValue("description")
  self.status = tonumber(row:getValue("status"))
  self.order = tonumber(row:getValue("order"))
  self.name = row:getValue("name")
  self.info = row:getValue("info")
  self.unlock_goods = row:getValue("unlock_goods")
end

MakingCoffeeTemplate.__init = __init
MakingCoffeeTemplate.__delete = __delete
MakingCoffeeTemplate.InitData = InitData
return MakingCoffeeTemplate
