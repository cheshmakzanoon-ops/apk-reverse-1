local T11StageTemplate = BaseClass("T11StageTemplate")

function T11StageTemplate:__init()
  self.id = 0
  self.stage = 0
  self.cost_resItem = {}
  self.cost_time = 0
  self.effect_a = {}
  self.effect_b = {}
  self.power = 0
  self.effect_icon_a = ""
  self.effect_info_a = ""
  self.effect_icon_b = ""
  self.effect_info_b = ""
  self.effect_name_a = ""
  self.effect_name_b = ""
  self.if_core_effect = false
  self.effect_unlock_info = ""
end

function T11StageTemplate:__delete()
  self.id = nil
  self.stage = nil
  self.cost_resItem = nil
  self.cost_time = nil
  self.effect_a = nil
  self.effect_b = nil
  self.power = nil
  self.effect_icon_a = nil
  self.effect_info_a = nil
  self.effect_icon_b = nil
  self.effect_info_b = nil
  self.effect_name_a = nil
  self.effect_name_b = nil
  self.if_core_effect = nil
  self.effect_unlock_info = nil
end

function T11StageTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.stage = rowData:getValue("stage") or 0
  self.cost_resItem = rowData:getValue("cost_resItem") or {}
  self.cost_time = rowData:getValue("cost_time") or 0
  self.effect_a = rowData:getValue("effect_a") or {}
  self.effect_b = rowData:getValue("effect_b") or {}
  self.power = rowData:getValue("power") or 0
  self.effect_icon_a = rowData:getValue("effect_icon_a") or ""
  self.effect_info_a = rowData:getValue("effect_info_a") or ""
  self.effect_icon_b = rowData:getValue("effect_icon_b") or ""
  self.effect_info_b = rowData:getValue("effect_info_b") or ""
  self.effect_name_a = rowData:getValue("effect_name_a") or ""
  self.effect_name_b = rowData:getValue("effect_name_b") or ""
  local if_core_effect = rowData:getValue("if_core_effect") or 0
  self.if_core_effect = if_core_effect == 1
  self.effect_unlock_info = rowData:getValue("effect_unlock_info") or ""
  self.effect_mummy_data = rowData:getValue("effect_mummy")
  self.effect_mummy_icon = rowData:getValue("effect_icon_mummy")
  self.effect_mummy_name = rowData:getValue("effect_name_mummy")
  self.effect_mummy_desc = rowData:getValue("effect_info_mummy")
end

function T11StageTemplate:GetCostDataAfterParse()
  local costInfoArr = {}
  if not self.cost_resItem then
    return costInfoArr
  end
  for _, v in ipairs(self.cost_resItem) do
    local arrInfo = string.split(v, ";")
    if #arrInfo == 3 then
      local costInfo = {}
      costInfo.type = toInt(arrInfo[1])
      costInfo.itemId = toInt(arrInfo[2])
      costInfo.costNum = toInt(arrInfo[3])
      table.insert(costInfoArr, costInfo)
    end
  end
  return costInfoArr
end

return T11StageTemplate
