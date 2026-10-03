local ActMonopolyDropShowTemplate = BaseClass("ActMonopolyDropShowTemplate")

local function __init(self)
  self.id = 0
  self.group_id = 0
  self.type = 0
  self.para1 = 0
  self.num = 0
  self.drop_show = 0
  self.order = 0
end

local function __delete(self)
  self.id = nil
  self.group_id = nil
  self.type = nil
  self.para1 = nil
  self.num = nil
  self.drop_show = nil
  self.order = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.group_id = tonumber(row:getValue("group_id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.para1 = tonumber(row:getValue("para1")) or 0
  self.num = tonumber(row:getValue("num")) or 0
  self.drop_show = tonumber(row:getValue("drop_show")) or 0
  self.order = tonumber(row:getValue("order")) or 0
end

ActMonopolyDropShowTemplate.__init = __init
ActMonopolyDropShowTemplate.__delete = __delete
ActMonopolyDropShowTemplate.InitData = InitData
return ActMonopolyDropShowTemplate
