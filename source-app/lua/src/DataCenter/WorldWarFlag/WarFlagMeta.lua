local base = require("Common.TemplateBase")
local WarFlagMeta = BaseClass("WarFlagMeta", base)

function WarFlagMeta:OnCreate()
end

function WarFlagMeta:OnDestroy()
  self.effect = nil
end

function WarFlagMeta:InitConfig(row)
  if row == nil then
    return
  end
  local tbl_index, tbl_data, tbl_ext = row:getMetaData()
  base.SetRowData(self, tbl_index, tbl_data, tbl_ext)
end

function WarFlagMeta.getters:type()
  return self:getIntValue("type")
end

function WarFlagMeta.getters:group()
  return self:getIntValue("group")
end

function WarFlagMeta.getters:size()
  return self:getIntValue("size")
end

function WarFlagMeta.getters:is_overlap()
  return self:getIntValue("is_overlap")
end

function WarFlagMeta.getters:visible_type()
  return self:getIntValue("visible_type")
end

function WarFlagMeta.getters:target_type()
  return self:getIntValue("target_type")
end

function WarFlagMeta.getters:additive_type()
  return self:getIntValue("additive_type")
end

function WarFlagMeta.getters:halo_radius()
  return self:getIntValue("halo_radius")
end

function WarFlagMeta.getters:life_time()
  return self:getIntValue("life_time")
end

function WarFlagMeta.getters:max_overlay()
  return self:getIntValue("max_overlay")
end

function WarFlagMeta.getters:effect()
  return self:getValue("effect")
end

function WarFlagMeta.getters:name()
  return self:getValue("name")
end

function WarFlagMeta.getters:icon()
  return self:getValue("icon")
end

function WarFlagMeta.getters:description()
  return self:getValue("description")
end

function WarFlagMeta.getters:create_effect()
  return self:getValue("create_effect")
end

function WarFlagMeta.getters:prefab()
  return self:getValue("prefab")
end

function WarFlagMeta.getters:flagBasePrefab()
  return self:getValue("flagBasePrefab")
end

function WarFlagMeta.getters:simplePrefab()
  local simplePrefab = self:getValue("simplePrefab")
  self.simplePrefab = string.IsNullOrEmpty(simplePrefab) and self.prefab or simplePrefab
  return self.simplePrefab
end

function WarFlagMeta.getters:temperature()
  return self:getValue("temperature")
end

function WarFlagMeta.getters:des_value()
  self.des_value = string.split(self:getValue("des_value"), "|")
  return self.des_value
end

return WarFlagMeta
