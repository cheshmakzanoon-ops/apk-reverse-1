local LwDroneBattlesystemLevelTemplate = BaseClass("LwDroneBattlesystemLevelTemplate")

function LwDroneBattlesystemLevelTemplate:__init()
  self.id = 0
  self.level = 0
  self.system_tier = 0
  self.exp_cost = 0
  self.level_attribute = ""
  self.level_chip_breakthrough = ""
  self.level_power = 0
  self.level_focus = ""
end

function LwDroneBattlesystemLevelTemplate:__delete()
  self.id = nil
  self.level = nil
  self.system_tier = nil
  self.exp_cost = nil
  self.level_attribute = nil
  self.level_chip_breakthrough = nil
  self.level_power = nil
  self.level_focus = nil
end

function LwDroneBattlesystemLevelTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.level = rowData:getValue("level") or 0
  self.system_tier = rowData:getValue("system_tier") or 0
  self.exp_cost = rowData:getValue("exp_cost") or 0
  self.level_attribute = rowData:getValue("level_attribute") or ""
  self.level_chip_breakthrough = rowData:getValue("level_chip_breakthrough") or ""
  self.level_power = rowData:getValue("level_power") or 0
  self.level_focus = tonumber(rowData:getValue("level_focus"))
end

return LwDroneBattlesystemLevelTemplate
