local SeasonCampBuffTemplate = BaseClass("SeasonCampBuffTemplate")

function SeasonCampBuffTemplate:__init()
  self.id = 0
  self.name = ""
  self.name_cfg = ""
  self.tier = ""
  self.type = ""
  self.condition = ""
  self.icon = ""
  self.description = ""
  self.description_cfg = ""
  self.para1 = 0
  self.para2 = ""
  self.camp = ""
  self.season_group = ""
end

function SeasonCampBuffTemplate:__delete()
  self.id = nil
  self.name = nil
  self.name_cfg = nil
  self.tier = nil
  self.type = nil
  self.condition = nil
  self.icon = nil
  self.description = nil
  self.description_cfg = nil
  self.para1 = nil
  self.para2 = nil
  self.camp = nil
  self.season_group = nil
end

function SeasonCampBuffTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.name = rowData:getValue("name") or ""
  self.name_cfg = rowData:getValue("name_cfg") or ""
  self.tier = rowData:getValue("tier") or ""
  self.type = rowData:getValue("type") or ""
  self.condition = rowData:getValue("condition") or ""
  self.icon = rowData:getValue("icon") or ""
  self.description = rowData:getValue("description") or ""
  self.description_cfg = rowData:getValue("description_cfg") or ""
  self.para1 = rowData:getValue("para1") or 0
  self.para2 = rowData:getValue("para2") or ""
  self.camp = rowData:getValue("camp") or ""
  self.season_group = rowData:getValue("season_group") or ""
end

return SeasonCampBuffTemplate
