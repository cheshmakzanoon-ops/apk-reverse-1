local SeasonPhotoTemplateSize = BaseClass("SeasonPhotoTemplateSize")

function SeasonPhotoTemplateSize:__init()
  self.id = 0
  self.name = ""
  self.size = 0
  self.limit = nil
end

function SeasonPhotoTemplateSize:__delete()
  self.id = nil
  self.name = nil
  self.size = nil
  self.limit = nil
end

function SeasonPhotoTemplateSize:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.name = rowData:getValue("name") or ""
  self.size = tonumber(rowData:getValue("size") or 10)
  self.limit = tonumber(rowData:getValue("limit") or 10)
end

return SeasonPhotoTemplateSize
