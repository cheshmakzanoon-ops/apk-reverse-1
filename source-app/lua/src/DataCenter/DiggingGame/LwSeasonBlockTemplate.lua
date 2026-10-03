local LwSeasonBlockTemplate = BaseClass("LwSeasonBlockTemplate")

function LwSeasonBlockTemplate:__init()
  self.id = 0
  self.type = 0
  self.name = ""
  self.description = ""
  self.size_width = 0
  self.size_height = 0
  self.appearance = ""
  self.appearance_shadow = ""
  self.appearance_s = ""
  self.appearance_shadow_s = ""
  self.appearance_mat = ""
  self.reward = 0
end

function LwSeasonBlockTemplate:__delete()
  self.id = nil
  self.type = nil
  self.name = nil
  self.description = nil
  self.size_width = nil
  self.size_height = nil
  self.appearance = nil
  self.appearance_shadow = nil
  self.appearance_s = nil
  self.appearance_shadow_s = nil
  self.appearance_mat = nil
  self.reward = nil
  self.scale = nil
end

function LwSeasonBlockTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.name = rowData:getValue("name") or ""
  self.description = rowData:getValue("description") or ""
  self.size_width = rowData:getValue("size_width") or 0
  self.size_height = rowData:getValue("size_height") or 0
  self.appearance = rowData:getValue("appearance") or ""
  self.appearance_shadow = rowData:getValue("appearance_shadow") or ""
  self.appearance_s = rowData:getValue("appearance_s") or ""
  self.appearance_shadow_s = rowData:getValue("appearance_shadow_s") or ""
  self.appearance_mat = rowData:getValue("appearance_mat") or ""
  self.reward = rowData:getValue("reward") or 0
  self.scale = rowData:getValue("scale") or 1
end

return LwSeasonBlockTemplate
