local AlliancePayTemplate = BaseClass("AlliancePayTemplate")

function AlliancePayTemplate:__init()
  self.id = 0
  self.type = 0
  self.name = ""
  self.condition = ""
  self.share_condition = 0
  self.color = 0
  self.order = 0
  self.show_type = 0
  self.rewardId = ""
  self.icon = ""
end

function AlliancePayTemplate:__delete()
  self.id = nil
  self.type = nil
  self.name = nil
  self.condition = nil
  self.share_condition = nil
  self.color = nil
  self.order = nil
  self.show_type = nil
  self.rewardId = nil
  self.icon = nil
end

function AlliancePayTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.name = rowData:getValue("name") or ""
  self.condition = rowData:getValue("condition") or ""
  self.share_condition = rowData:getValue("share_condition") or 0
  self.color = rowData:getValue("color") or 0
  self.order = rowData:getValue("order") or 0
  self.show_type = rowData:getValue("show_type") or 0
  self.rewardId = rowData:getValue("rewardId") or ""
  self.icon = rowData:getValue("icon") or ""
  self.conditionTable = string.string2table_ii(self.condition, ";", "|")
  self.conditionTable2 = string.string2table_ii_toList(self.condition, ";", "|")
  if not table.IsNullOrEmpty(self.conditionTable) and self.type == AllianceSalaryType.DailySalary then
    self.maxDailySalaryScore = self.conditionTable[1] or 0
  end
  self.rewardIds = string.string2array_i_oneSep(self.rewardId, ";")
  local iconStr = string.split(self.icon, ";")
  self.boxColor = tonumber(iconStr[1]) or -1
  self.imgCloseIcon = iconStr[2] or ""
  self.imgOpenIcon = iconStr[3] or ""
end

function AlliancePayTemplate:GetRewardIdByGiftLevel(self, giftLevel)
end

return AlliancePayTemplate
