local RechargeMergeTemplate = BaseClass("RechargeMergeTemplate")

function RechargeMergeTemplate:__init()
  self.id = 0
  self.next = 0
  self.type_range = ""
  self.front_pic = ""
  self.next_pic = ""
  self.front_di = ""
  self.next_di = ""
  self.front_special_di = ""
  self.next_special_di = ""
  self.front_tab_text = ""
  self.next_tab_text = ""
  self.broad_text = ""
  self.full_howtoplay = ""
  self.howtoplay_btn = ""
end

function RechargeMergeTemplate:__delete()
  self.id = nil
  self.next = nil
  self.type_range = nil
  self.front_pic = nil
  self.next_pic = nil
  self.front_di = nil
  self.next_di = nil
  self.front_special_di = nil
  self.next_special_di = nil
  self.front_tab_text = nil
  self.next_tab_text = nil
  self.broad_text = nil
  self.full_howtoplay = nil
  self.howtoplay_btn = nil
end

function RechargeMergeTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.next = rowData:getValue("next") or 0
  self.type_range = rowData:getValue("type_range") or ""
  self.front_pic = rowData:getValue("front_pic") or ""
  self.next_pic = rowData:getValue("next_pic") or ""
  self.front_di = rowData:getValue("front_di") or ""
  self.next_di = rowData:getValue("next_di") or ""
  self.front_special_di = rowData:getValue("front_special_di") or ""
  self.next_special_di = rowData:getValue("next_special_di") or ""
  self.front_tab_text = rowData:getValue("front_tab_text") or ""
  self.next_tab_text = rowData:getValue("next_tab_text") or ""
  self.broad_text = rowData:getValue("broad_text") or ""
  self.full_howtoplay = rowData:getValue("full_howtoplay") or ""
  self.howtoplay_btn = rowData:getValue("howtoplay_btn") or ""
end

return RechargeMergeTemplate
