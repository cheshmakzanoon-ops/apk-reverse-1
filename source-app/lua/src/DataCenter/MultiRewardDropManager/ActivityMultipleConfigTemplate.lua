local ActivityMultipleConfigTemplate = BaseClass("ActivityMultipleConfigTemplate")

function ActivityMultipleConfigTemplate:__init()
  self.id = 0
  self.group = 0
  self.activity = 0
  self.type = 0
  self.type_para1 = ""
  self.type_para2 = ""
  self.param_num = 0
  self.condition = ""
  self.buff_title = ""
  self.buff_desc = ""
  self.icon = ""
  self.buff_bg = ""
  self.extra_display = ""
  self.order = 0
  self.goto_type = ""
  self.goto_para = ""
  self.prefab = ""
  self.baseValue = ""
  self.text_color = ""
end

function ActivityMultipleConfigTemplate:__delete()
  self.id = nil
  self.group = nil
  self.activity = nil
  self.type = nil
  self.type_para1 = nil
  self.type_para2 = nil
  self.param_num = nil
  self.condition = nil
  self.buff_title = nil
  self.buff_desc = nil
  self.icon = nil
  self.buff_bg = nil
  self.extra_display = nil
  self.order = nil
  self.goto_type = nil
  self.goto_para = nil
  self.prefab = nil
  self.baseValue = nil
  self.text_color = ""
end

function ActivityMultipleConfigTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.activity = rowData:getValue("activity") or 0
  self.type = rowData:getValue("type") or 0
  self.type_para1 = rowData:getValue("type_para1") or ""
  self.type_para2 = rowData:getValue("type_para2") or ""
  self.param_num = rowData:getValue("param_num") or 0
  self.condition = rowData:getValue("condition") or ""
  self.buff_title = rowData:getValue("buff_title") or ""
  self.buff_desc = rowData:getValue("buff_desc") or ""
  self.icon = rowData:getValue("icon") or ""
  self.buff_bg = rowData:getValue("buff_bg") or ""
  self.extra_display = rowData:getValue("extra_display") or ""
  self.order = rowData:getValue("order") or 0
  self.goto_type = rowData:getValue("goto_type") or ""
  self.goto_para = rowData:getValue("goto_para") or ""
  self.prefab = rowData:getValue("prefab") or ""
  self.baseValue = rowData:getValue("basevalue") or 0
  self.text_color = rowData:getValue("text_color") or ""
end

return ActivityMultipleConfigTemplate
