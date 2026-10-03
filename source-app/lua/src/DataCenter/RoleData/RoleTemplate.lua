local RoleTemplate = BaseClass("RoleTemplate")

local function __init(self)
  self.id = 0
  self.level = 0
  self.plunder_resource_max = 0
  self.plunder_resource_max2 = 0
  self.rate1 = 1.0
  self.rate2 = 0.3
  self.rate3 = 0.1
end

local function __delete(self)
  self.id = nil
  self.level = nil
  self.plunder_resource_max = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id", 0)
  self.level = row:getIntValue("level", 0)
  self.plunder_resource_max = row:getIntValue("plunder_resource_max", 0)
  self.plunder_resource_max2 = row:getIntValue("plunder_resource_max2", self.plunder_resource_max)
  local rate = row:getValue("plunder_resource_set", "1;0.3;0.1")
  if rate then
    local rate1, rate2, rate3 = string.match(rate, "([^;]+);([^;]+);([^;]+)")
    if rate1 and rate2 and rate3 then
      self.rate1 = tonumber(rate1)
      self.rate2 = tonumber(rate2)
      self.rate3 = tonumber(rate3)
    end
  end
end

RoleTemplate.__init = __init
RoleTemplate.__delete = __delete
RoleTemplate.InitData = InitData
return RoleTemplate
