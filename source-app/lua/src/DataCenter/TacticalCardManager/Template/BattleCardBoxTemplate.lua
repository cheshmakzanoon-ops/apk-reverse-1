local BattleCardBoxTemplate = BaseClass("BattleCardBoxTemplate")

function BattleCardBoxTemplate:__init()
  self.id = 0
  self.season = 0
  self.goods_id = 0
  self.select_max = 0
  self.middle_image = ""
  self.large_image = ""
  self.card_pool_show = ""
  self.box_point = 0
end

function BattleCardBoxTemplate:__delete()
  self.id = nil
  self.season = nil
  self.goods_id = nil
  self.select_max = nil
  self.middle_image = nil
  self.large_image = nil
  self.card_pool_show = nil
  self.box_point = nil
end

function BattleCardBoxTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.season = rowData:getValue("season") or 0
  self.goods_id = rowData:getValue("goods_id") or 0
  self.select_max = rowData:getValue("select_max") or 1
  self.middle_image = rowData:getValue("middle_image") or ""
  self.large_image = rowData:getValue("large_image") or ""
  self.card_pool_show = rowData:getValue("card_pool_show") or 0
  self.box_point = rowData:getValue("box_point") or 0
end

function BattleCardBoxTemplate:GetGoodsId()
  return self.goods_id
end

function BattleCardBoxTemplate:GetIcon()
  return DataCenter.ItemTemplateManager:GetIconPath(self.goods_id)
end

local LARGE_IMAGE_FOLDER = "Assets/Main/TextureEx/UILWTCBox/%s"

function BattleCardBoxTemplate:GetLargeImage()
  if string.IsNullOrEmpty(self.large_image) then
    return self:GetIcon()
  end
  return string.format(LARGE_IMAGE_FOLDER, self.large_image)
end

function BattleCardBoxTemplate:GetName()
  return DataCenter.ItemTemplateManager:GetName(self.goods_id)
end

function BattleCardBoxTemplate:GetDesc()
  return DataCenter.ItemTemplateManager:GetDes(self.goods_id)
end

function BattleCardBoxTemplate:GetQuality()
  local itemTemplate = self:GetGoodsTemplate()
  if itemTemplate then
    return itemTemplate.color
  end
  return 1
end

function BattleCardBoxTemplate:GetGoodsTemplate()
  return DataCenter.ItemTemplateManager:GetItemTemplate(self.goods_id)
end

return BattleCardBoxTemplate
