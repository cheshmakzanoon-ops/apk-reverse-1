local T11UpgradeTemplate = BaseClass("T11UpgradeTemplate")

function T11UpgradeTemplate:__init()
  self.id = 0
  self.type = 0
  self.stage = 0
  self.progress = 0
  self.cost_resItem = {}
  self.attr_add = {}
  self.power = 0
  self.next_id = 0
end

function T11UpgradeTemplate:__delete()
  self.id = nil
  self.type = nil
  self.stage = nil
  self.progress = nil
  self.cost_resItem = nil
  self.attr_add = nil
  self.power = nil
  self.next_id = nil
end

function T11UpgradeTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.stage = rowData:getValue("stage") or 0
  self.progress = rowData:getValue("progress") or 0
  self.cost_resItem = rowData:getValue("cost_resItem") or {}
  self.attr_add = rowData:getValue("attr_add") or {}
  self.power = rowData:getValue("power") or 0
  self.next_id = rowData:getValue("next_id") or 0
end

function T11UpgradeTemplate:GetCostDataAfterParse()
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

return T11UpgradeTemplate
