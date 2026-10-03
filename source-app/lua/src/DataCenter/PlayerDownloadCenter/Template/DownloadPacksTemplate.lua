local DownloadPacksTemplate = BaseClass("DownloadPacksTemplate")

function DownloadPacksTemplate:__init()
  self.id = 0
  self.pack_id = 0
  self.name = ""
  self.icon = ""
  self.desc = ""
  self.diamond = 0
  self.banner = ""
  self.type = 0
  self.can_del = 0
  self.order = 0
end

function DownloadPacksTemplate:__delete()
  self.id = nil
  self.pack_id = nil
  self.name = nil
  self.icon = nil
  self.desc = nil
  self.diamond = nil
  self.banner = nil
  self.type = nil
  self.can_del = nil
  self.order = nil
end

function DownloadPacksTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.pack_id = rowData:getValue("pack_id") or 0
  self.name = rowData:getValue("name") or ""
  self.icon = rowData:getValue("icon") or ""
  self.desc = rowData:getValue("desc") or ""
  self.diamond = rowData:getValue("diamond") or 0
  self.banner = rowData:getValue("banner") or ""
  self.type = rowData:getValue("type") or 0
  self.can_del = rowData:getValue("can_del") or 0
  self.order = rowData:getValue("order") or 0
end

return DownloadPacksTemplate
