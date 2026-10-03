local DownloadCenterTemplate = BaseClass("DownloadCenterTemplate")

function DownloadCenterTemplate:__init()
  self.id = 0
  self.name = ""
  self.icon = ""
  self.desc = ""
  self.position = 0
  self.show = 0
end

function DownloadCenterTemplate:__delete()
  self.id = nil
  self.name = nil
  self.icon = nil
  self.desc = nil
  self.position = nil
  self.show = nil
end

function DownloadCenterTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.name = rowData:getValue("name") or ""
  self.icon = rowData:getValue("icon") or ""
  self.desc = rowData:getValue("desc") or ""
  self.position = rowData:getValue("position") or 0
  self.show = rowData:getValue("show") or 0
end

return DownloadCenterTemplate
