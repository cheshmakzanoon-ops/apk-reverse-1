local GoldBrickProductTemplate = BaseClass("GoldBrickProductTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.productID = ""
  self.goldbrick = 0
end

local function __delete(self)
  self.id = nil
  self.productID = nil
  self.goldbrick = nil
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.productID = row:getValue("product_id") or ""
  self.goldbrick = tonumber(row:getValue("goldbrick")) or IntMaxValue
end

GoldBrickProductTemplate.__init = __init
GoldBrickProductTemplate.__delete = __delete
GoldBrickProductTemplate.InitConfig = InitConfig
return GoldBrickProductTemplate
