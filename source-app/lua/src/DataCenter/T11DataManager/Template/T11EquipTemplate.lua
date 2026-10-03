local T11EquipTemplate = BaseClass("T11EquipTemplate")

function T11EquipTemplate:__init()
  self.id = 0
  self.type = 0
  self.stage = 0
  self.lock_icon = ""
  self.icon = ""
  self.model = ""
  self.name = ""
end

function T11EquipTemplate:__delete()
  self.id = nil
  self.type = nil
  self.stage = nil
  self.lock_icon = nil
  self.icon = nil
  self.model = nil
  self.name = nil
end

function T11EquipTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.stage = rowData:getValue("stage") or 0
  self.lock_icon = rowData:getValue("lock_icon") or ""
  self.icon = rowData:getValue("icon") or ""
  self.model = rowData:getValue("model") or ""
  self.name = rowData:getValue("name") or ""
end

return T11EquipTemplate
