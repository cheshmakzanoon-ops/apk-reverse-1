local T11SoldierTemplate = BaseClass("T11SoldierTemplate")

function T11SoldierTemplate:__init()
  self.id = 0
  self.soldierType = ""
  self.name = ""
  self.stage = 0
  self.model = ""
  self.model_jc = ""
  self.hero_appearance_id = ""
  self.soldierImage = ""
  self.icon = ""
  self.bubbleIcon = ""
end

function T11SoldierTemplate:__delete()
  self.id = nil
  self.soldierType = nil
  self.name = nil
  self.stage = nil
  self.model = nil
  self.model_jc = nil
  self.hero_appearance_id = nil
  self.soldierImage = nil
  self.icon = nil
  self.bubbleIcon = nil
end

function T11SoldierTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  local type = rowData:getValue("solider") or ""
  self.soldierType = T11Util.GetT11SoldierType(type)
  self.name = rowData:getValue("name") or ""
  self.stage = rowData:getValue("stage") or 0
  self.model = rowData:getValue("model") or ""
  self.model_jc = rowData:getValue("model_jc") or ""
  self.hero_appearance_id = rowData:getValue("hero_appearance_id") or 0
  self.soldierImage = rowData:getValue("image") or ""
  self.icon = rowData:getValue("icon") or ""
  self.bubbleIcon = rowData:getValue("bubble_icon") or ""
end

return T11SoldierTemplate
