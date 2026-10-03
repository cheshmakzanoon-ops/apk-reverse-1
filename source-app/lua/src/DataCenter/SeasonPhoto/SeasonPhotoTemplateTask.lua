local SeasonPhotoTemplateTask = BaseClass("SeasonPhotoTemplateTask")

function SeasonPhotoTemplateTask:__init()
  self.id = 0
  self.type = 0
  self.needNum = 0
  self.name = ""
  self.reward = 0
end

function SeasonPhotoTemplateTask:__delete()
  self.id = nil
  self.type = nil
  self.needNum = nil
  self.name = nil
  self.reward = nil
end

function SeasonPhotoTemplateTask:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.needNum = rowData:getValue("needNum") or 0
  self.name = rowData:getValue("name") or ""
  self.reward = rowData:getValue("reward") or 0
end

return SeasonPhotoTemplateTask
