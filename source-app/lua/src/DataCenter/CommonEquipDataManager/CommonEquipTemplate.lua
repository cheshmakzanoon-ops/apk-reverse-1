local CommonEquipTemplate = BaseClass("CommonEquipTemplate")

function CommonEquipTemplate:__init()
  self.id = 0
  self.type = 0
  self.name = ""
  self.icon = ""
  self.desc = ""
  self.power = 0
  self.effect = {}
  self.quality = 1
  self.level = 1
end

function CommonEquipTemplate:__delete()
  self.id = nil
  self.type = nil
  self.name = nil
  self.icon = nil
  self.desc = nil
  self.power = nil
  self.effect = nil
  self.quality = nil
  self.level = 1
end

function CommonEquipTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.name = row:getValue("name") or ""
  self.icon = row:getValue("icon") or ""
  self.desc = row:getValue("desc") or ""
  self.power = tonumber(row:getValue("power")) or 0
  self.effect = row:getValue("effect") or {}
  self.quality = tonumber(row:getValue("quality")) or 1
  self.level = tonumber(row:getValue("level")) or 1
end

return CommonEquipTemplate
