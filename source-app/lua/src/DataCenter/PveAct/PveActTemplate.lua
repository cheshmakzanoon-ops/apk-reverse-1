local PveActTemplate = BaseClass("PveActTemplate")

local function __init(self)
  self.id = 0
end

local function __delete(self)
  self.id = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
end

PveActTemplate.__init = __init
PveActTemplate.__delete = __delete
PveActTemplate.InitData = InitData
return PveActTemplate
