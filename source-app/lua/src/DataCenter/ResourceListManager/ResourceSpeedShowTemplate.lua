local ResourceSpeedShowTemplate = BaseClass("ResourceSpeedShowTemplate")

function ResourceSpeedShowTemplate:__init()
  self.id = 0
  self.type = 0
  self.resources_id = 0
  self.resource_item_id = 0
  self.goods_id = 0
  self.show_type = 0
  self.time = 0
  self.protect_num = 0
  self.season_material = 0
  self.effect = 0
  self.order = 0
end

function ResourceSpeedShowTemplate:__delete()
  self.id = nil
  self.type = nil
  self.resources_id = nil
  self.resource_item_id = nil
  self.goods_id = nil
  self.show_type = nil
  self.time = nil
  self.protect_num = nil
  self.season_material = nil
  self.effect = nil
  self.order = nil
end

function ResourceSpeedShowTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.resources_id = rowData:getValue("resources_id") or 0
  self.resource_item_id = rowData:getValue("resource_item_id") or 0
  self.goods_id = rowData:getValue("goods_id") or 0
  self.show_type = rowData:getValue("show_type") or 0
  self.time = rowData:getValue("time") or 0
  self.protect_num = rowData:getValue("protect_num") or 0
  self.season_material = rowData:getValue("season_material") or 0
  self.effect = rowData:getValue("effect") or 0
  self.order = rowData:getValue("order") or 0
end

return ResourceSpeedShowTemplate
