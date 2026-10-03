local BaseExpansionTemplate = BaseClass("BaseExpansionTemplate")

local function __init(self)
  self.id = 0
  self.x = 0
  self.y = 0
  self.range = 0
  self.type = 0
  self.tree = 0
end

local function __delete(self)
  self.id = nil
  self.x = nil
  self.y = nil
  self.range = nil
  self.type = nil
  self.tree = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.x = tonumber(row:getValue("x"))
  self.y = tonumber(row:getValue("y"))
  self.range = tonumber(row:getValue("range"))
  self.type = tonumber(row:getValue("is_only_road"))
  self.tree = tonumber(row:getValue("treetype"))
end

BaseExpansionTemplate.__init = __init
BaseExpansionTemplate.__delete = __delete
BaseExpansionTemplate.InitData = InitData
return BaseExpansionTemplate
