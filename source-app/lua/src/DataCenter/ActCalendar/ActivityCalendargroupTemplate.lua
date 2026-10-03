local ActivityCalendargroupTemplate = BaseClass("ActivityCalendargroupTemplate")

function ActivityCalendargroupTemplate:__init()
  self.id = 0
  self.group_name = ""
  self.group_priority = 0
end

function ActivityCalendargroupTemplate:__delete()
  self.id = nil
  self.group_name = nil
  self.group_priority = nil
end

function ActivityCalendargroupTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group_name = rowData:getValue("group_name") or ""
  self.group_priority = rowData:getValue("group_priority") or ""
end

return ActivityCalendargroupTemplate
