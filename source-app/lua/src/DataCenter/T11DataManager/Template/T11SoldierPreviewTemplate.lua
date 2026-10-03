local T11SoldierPreviewTemplate = BaseClass("T11SoldierPreviewTemplate")

function T11SoldierPreviewTemplate:__init()
  self.id = 0
  self.stage = 0
  self.title = ""
  self.icon = ""
  self.desc = ""
  self.video = ""
end

function T11SoldierPreviewTemplate:__delete()
  self.id = nil
  self.stage = nil
  self.title = nil
  self.icon = nil
  self.desc = nil
  self.video = nil
end

function T11SoldierPreviewTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.stage = tonumber(rowData:getValue("stage")) or 0
  self.title = rowData:getValue("title") or ""
  self.icon = rowData:getValue("icon") or ""
  self.desc = rowData:getValue("desc") or ""
  self.video = rowData:getValue("video") or ""
end

return T11SoldierPreviewTemplate
