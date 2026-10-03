local LwSquadEquipLvTemplate = BaseClass("LwSquadEquipLvTemplate")

function LwSquadEquipLvTemplate:__init()
  self.id = 0
  self.group = 0
  self.squad_equip_lv = 0
  self.order = 0
  self.percent_range = {}
  self.small_percent_point = 0
  self.small_percent_effect = {}
  self.big_percent_point = 0
  self.big_percent_effect = {}
  self.small_percent_power = 0
  self.big_percent_power = 0
  self.small_percent_effect_hero = {}
end

function LwSquadEquipLvTemplate:__delete()
  self.id = nil
  self.group = nil
  self.squad_equip_lv = nil
  self.order = nil
  self.percent_range = nil
  self.small_percent_point = nil
  self.small_percent_effect = nil
  self.big_percent_point = nil
  self.big_percent_effect = nil
  self.small_percent_power = nil
  self.big_percent_power = nil
  self.rangeMin = nil
  self.rangeMax = nil
  self.stagePercentEffect = nil
  self.small_percent_effect_hero = nil
  self.smallEffectPercent = nil
end

function LwSquadEquipLvTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.squad_equip_lv = rowData:getValue("squad_equip_lv") or 0
  self.order = rowData:getValue("order") or 0
  self.percent_range = rowData:getValue("percent_range") or {}
  self.small_percent_point = rowData:getValue("small_percent_point") or 0
  self.small_percent_effect = rowData:getValue("small_percent_effect") or {}
  self.big_percent_point = rowData:getValue("big_percent_point") or 0
  self.big_percent_effect = rowData:getValue("big_percent_effect") or {}
  self.small_percent_power = rowData:getValue("small_percent_power")
  self.big_percent_power = rowData:getValue("big_percent_power")
  self.small_percent_effect_hero = rowData:getValue("small_percent_effect_hero") or {}
  self.smallEffectPercent = {}
  for effectId, value in pairs(self.small_percent_effect) do
    self.smallEffectPercent[effectId] = value
  end
  for effectId, value in pairs(self.small_percent_effect_hero) do
    self.smallEffectPercent[effectId] = value
  end
  self.rangeMin = self.percent_range[1]
  self.rangeMax = self.percent_range[2]
  self.stagePercentEffect = {}
  for key, value in pairs(self.big_percent_effect) do
    local param = {}
    param.key = key
    param.value = value
    table.insert(self.stagePercentEffect, param)
  end
end

return LwSquadEquipLvTemplate
