local RechargeGiftShowTemplate = BaseClass("RechargeGiftShowTemplate")

function RechargeGiftShowTemplate:__init()
  self.id = 0
  self.banner = ""
  self.banner_B = ""
  self.banner_bg_new = ""
  self.banner_pic_new = {}
  self.banner_pic_new_B = {}
  self.banner_pic_init_size = {}
  self.board_color = 0
  self.column_type = ""
  self.bg_pic_init_size = {}
  self.bg_effect_name = ""
  self.for_effect_name = ""
  self.resource_config1 = ""
  self.resource_config2 = ""
  self.resource_config1_list = {}
  self.resource_config2_list = {}
end

function RechargeGiftShowTemplate:__delete()
  self.id = nil
  self.banner = nil
  self.banner_B = nil
  self.banner_bg_new = nil
  self.banner_pic_new = nil
  self.banner_pic_new_B = nil
  self.banner_pic_init_size = nil
  self.board_color = nil
  self.column_type = nil
  self.bg_pic_init_size = nil
  self.bg_effect_name = nil
  self.for_effect_name = nil
  self.resource_config1 = nil
  self.resource_config2 = nil
  self.resource_config1_list = nil
  self.resource_config2_list = nil
end

function RechargeGiftShowTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.banner = rowData:getValue("banner") or ""
  self.banner_B = rowData:getValue("banner_B") or ""
  self.banner_bg_new = rowData:getValue("banner_bg_new") or ""
  self.banner_pic_new = rowData:getValue("banner_pic_new") or {}
  self.banner_pic_new_B = rowData:getValue("banner_pic_new_B") or {}
  self.banner_pic_init_size = rowData:getValue("banner_pic_init_size") or {}
  self.board_color = rowData:getValue("board_color") or 0
  self.column_type = rowData:getValue("column_type") or ""
  self.bg_pic_init_size = rowData:getValue("bg_pic_init_size") or {}
  self.bg_effect_name = rowData:getValue("bg_effect_name") or ""
  self.for_effect_name = rowData:getValue("for_effect_name") or ""
  self.resource_config1 = rowData:getValue("resource_config1") or ""
  self.resource_config2 = rowData:getValue("resource_config2") or ""
  local resource_config1 = rowData:getValue("resource_config1")
  if not string.IsNullOrEmpty(resource_config1) then
    self.resource_config1_list = string.split(resource_config1, "|")
  end
  local resource_config2 = rowData:getValue("resource_config2")
  if not string.IsNullOrEmpty(resource_config2) then
    self.resource_config2_list = string.string2array_num(resource_config2, ",", "|")
  end
end

return RechargeGiftShowTemplate
