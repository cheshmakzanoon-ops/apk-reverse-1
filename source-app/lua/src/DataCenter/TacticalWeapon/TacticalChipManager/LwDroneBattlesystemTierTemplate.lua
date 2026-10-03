local LwDroneBattlesystemTierTemplate = BaseClass("LwDroneBattlesystemTierTemplate")

function LwDroneBattlesystemTierTemplate:__init()
  self.id = 0
  self.tier_name = ""
  self.tier_chip_breakthrough = ""
  self.tier_banner = ""
  self.tier_color = ""
  self.chip_set_unlock = 0
  self.tier_level = 0
  self.tier_info = ""
  self.effectId = 0
  self.effectValue = 0
  self.chip_breakthrough_show = 0
end

function LwDroneBattlesystemTierTemplate:__delete()
  self.id = nil
  self.tier_name = nil
  self.tier_chip_breakthrough = nil
  self.tier_banner = nil
  self.tier_color = nil
  self.chip_set_unlock = nil
  self.tier_level = nil
  self.tier_info = nil
  self.effectId = nil
  self.effectValue = nil
  self.tierDisplayTitle = nil
  self.tierDisplayDesc = nil
  self.chip_breakthrough_show = nil
end

function LwDroneBattlesystemTierTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.tier_name = rowData:getValue("tier_name") or ""
  self.tier_chip_breakthrough = rowData:getValue("tier_chip_breakthrough") or ""
  self.tier_banner = rowData:getValue("tier_banner") or ""
  self.tier_color = rowData:getValue("tier_color") or ""
  self.chip_set_unlock = rowData:getValue("chip_set_unlock") or 0
  self.tier_level = rowData:getValue("tier_level") or 0
  self.tier_info = rowData:getValue("tier_info")
  self.chip_breakthrough_show = rowData:getValue("chip_breakthrough_show") or 1
  if not string.IsNullOrEmpty(self.tier_chip_breakthrough) then
    local effectSplitStr = string.split(self.tier_chip_breakthrough, ";")
    self.effectId = tonumber(effectSplitStr[1]) or 0
    self.effectValue = tonumber(effectSplitStr[2]) or 0
  end
  if not string.IsNullOrEmpty(self.tier_info) then
    local splitStr = string.split(self.tier_info, ";")
    self.tierDisplayTitle = splitStr[1]
    self.tierDisplayDesc = splitStr[2]
  end
end

return LwDroneBattlesystemTierTemplate
