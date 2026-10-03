local EquipWordTemplate = BaseClass("EquipWordTemplate")

local function __init(self)
  self.id = 0
  self.effects = {}
end

local function __delete(self)
  self.id = nil
  self.effects = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.effects = row:getValue("effects") or {}
end

EquipWordTemplate.__init = __init
EquipWordTemplate.__delete = __delete
EquipWordTemplate.InitData = InitData
return EquipWordTemplate
