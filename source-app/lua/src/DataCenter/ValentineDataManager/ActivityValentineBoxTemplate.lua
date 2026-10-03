local ActivityValentineBoxTemplate = BaseClass("ActivityValentineBoxTemplate")

function ActivityValentineBoxTemplate:__init()
  self.id = 0
  self.group = ""
  self.box_id = ""
  self.num = ""
  self.cost = ""
  self.rate = 0
end

function ActivityValentineBoxTemplate:__delete()
  self.id = nil
  self.group = nil
  self.box_id = nil
  self.num = nil
  self.cost = nil
  self.rate = nil
end

function ActivityValentineBoxTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or ""
  self.box_id = rowData:getValue("box_id") or ""
  self.num = rowData:getValue("num") or ""
  self.cost = rowData:getValue("cost") or ""
  self.rate = rowData:getValue("rate") or 0
end

return ActivityValentineBoxTemplate
