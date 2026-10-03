local ActivityPartynewDropshowTemplate = BaseClass("ActivityPartynewDropshowTemplate")

function ActivityPartynewDropshowTemplate:__init()
  self.id = 0
  self.group_id = 0
  self.page = 0
  self.page_name = ""
  self.type = 0
  self.type_name = ""
  self.monster_id = 0
  self.content_text = ""
  self.sub_type = 0
  self.sub_type_name = ""
  self.sub_item = ""
  self.special = ""
  self.drop_show = ""
  self.order = 0
  self.treasure_id = ""
  self.para1 = 0
end

function ActivityPartynewDropshowTemplate:__delete()
  self.id = nil
  self.group_id = nil
  self.page = nil
  self.page_name = nil
  self.type = nil
  self.type_name = nil
  self.monster_id = nil
  self.content_text = nil
  self.sub_type = nil
  self.sub_type_name = nil
  self.sub_item = nil
  self.special = nil
  self.drop_show = nil
  self.order = nil
  self.treasure_id = ""
  self.para1 = 0
end

function ActivityPartynewDropshowTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group_id = rowData:getValue("group_id") or 0
  self.page = rowData:getValue("page") or 0
  self.page_name = rowData:getValue("page_name") or ""
  self.type = rowData:getValue("type") or 0
  self.type_name = rowData:getValue("type_name") or ""
  self.monster_id = rowData:getValue("monster_id") or 0
  self.content_text = rowData:getValue("content_text") or ""
  self.sub_type = rowData:getValue("sub_type") or 0
  self.sub_type_name = rowData:getValue("sub_type_name") or ""
  self.sub_item = rowData:getValue("sub_item") or ""
  self.special = rowData:getValue("special") or ""
  self.drop_show = rowData:getValue("drop_show") or ""
  self.order = rowData:getValue("order") or 0
  self.treasure_id = rowData:getValue("treasure_id") or ""
  self.para1 = rowData:getValue("para1") or 0
end

return ActivityPartynewDropshowTemplate
