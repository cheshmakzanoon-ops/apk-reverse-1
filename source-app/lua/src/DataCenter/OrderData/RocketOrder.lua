local RocketOrder = BaseClass("RocketOrder")

local function __init(self)
  self.id = 0
  self.product_id = 0
  self.product_num = 0
  self.money = 0
  self.ext_money = 0
end

local function __delete(self)
  self.id = nil
  self.product_id = nil
  self.product_num = nil
  self.money = nil
  self.ext_money = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.product_id = row:getValue("product_id")
  self.product_num = row:getValue("product_num")
  self.money = row:getValue("money")
  self.ext_money = row:getValue("ext_money")
end

RocketOrder.__init = __init
RocketOrder.__delete = __delete
RocketOrder.InitData = InitData
return RocketOrder
