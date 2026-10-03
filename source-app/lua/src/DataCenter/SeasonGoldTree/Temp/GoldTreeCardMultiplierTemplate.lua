local GoldTreeCardMultiplierTemplate = BaseClass("GoldTreeCardMultiplierTemplate")

local function __init(self)
  self.id = 0
  self.multiplier = 0
  self.name = ""
  self.icon = ""
  self.effects = ""
  self.material = ""
end

local function __delete(self)
  self.id = 0
  self.multiplier = 0
  self.name = nil
  self.icon = nil
  self.effects = nil
  self.material = nil
end

function GoldTreeCardMultiplierTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.multiplier = tonumber(row:getValue("multiplier")) or 0
  self.name = row:getValue("name") or ""
  self.icon = row:getValue("icon") or ""
  self.effects = row:getValue("effects") or ""
  self.material = row:getValue("material") or ""
end

GoldTreeCardMultiplierTemplate.__init = __init
GoldTreeCardMultiplierTemplate.__delete = __delete
return GoldTreeCardMultiplierTemplate
