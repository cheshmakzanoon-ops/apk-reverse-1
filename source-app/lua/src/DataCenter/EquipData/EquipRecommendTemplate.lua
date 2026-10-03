local EquipRecommendTemplate = BaseClass("EquipRecommendTemplate")

function EquipRecommendTemplate:__init()
  self.id = 0
  self.group_id = 0
  self.order = 0
  self.position_order = ""
  self.recommend_num = 0
  self.weapon_level_require = 0
  self.armor_level_require = 0
  self.core_level_require = 0
  self.radar_level_require = 0
  self.weapon_star_require = ""
  self.armor_star_require = ""
  self.core_star_require = ""
  self.radar_star_require = ""
  self.positionOrderList = {}
end

function EquipRecommendTemplate:__delete()
  self.id = nil
  self.group_id = nil
  self.order = nil
  self.position_order = nil
  self.recommend_num = nil
  self.weapon_level_require = nil
  self.armor_level_require = nil
  self.core_level_require = nil
  self.radar_level_require = nil
  self.weapon_star_require = nil
  self.armor_star_require = nil
  self.core_star_require = nil
  self.radar_star_require = nil
  self.positionOrderList = nil
end

function EquipRecommendTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group_id = rowData:getValue("group_id") or 0
  self.order = rowData:getValue("order") or 0
  self.position_order = rowData:getValue("position_order") or ""
  self.recommend_num = rowData:getValue("recommend_num") or 0
  self.weapon_level_require = rowData:getValue("weapon_level_require") or 0
  self.armor_level_require = rowData:getValue("armor_level_require") or 0
  self.core_level_require = rowData:getValue("core_level_require") or 0
  self.radar_level_require = rowData:getValue("radar_level_require") or 0
  self.weapon_star_require = tonumber(rowData:getValue("weapon_star_require") or "")
  self.armor_star_require = tonumber(rowData:getValue("armor_star_require") or "")
  self.core_star_require = tonumber(rowData:getValue("core_star_require") or "")
  self.radar_star_require = tonumber(rowData:getValue("radar_star_require") or "")
  if not string.IsNullOrEmpty(self.position_order) then
    local splitStr = string.split(self.position_order, ";")
    for i, v in pairs(splitStr) do
      table.insert(self.positionOrderList, tonumber(v))
    end
  end
end

function EquipRecommendTemplate:GetLevelRequirement(slotType)
  if slotType == EquipmentSlotType.Weapon then
    return self.weapon_level_require
  elseif slotType == EquipmentSlotType.Armor then
    return self.armor_level_require
  elseif slotType == EquipmentSlotType.Core then
    return self.core_level_require
  elseif slotType == EquipmentSlotType.Radar then
    return self.radar_level_require
  end
  return 0
end

function EquipRecommendTemplate:GetStarLevelRequirement(slotType)
  if slotType == EquipmentSlotType.Weapon then
    return self.weapon_star_require
  elseif slotType == EquipmentSlotType.Armor then
    return self.armor_star_require
  elseif slotType == EquipmentSlotType.Core then
    return self.core_star_require
  elseif slotType == EquipmentSlotType.Radar then
    return self.radar_star_require
  end
  return 0
end

function EquipRecommendTemplate:IsEquipQualified(heroData, equipSlotType)
  if heroData.equipUids ~= nil then
    for _, v in pairs(heroData.equipUids) do
      local equipData = DataCenter.EquipDataManager:GetEquipByUuid(v)
      if equipData ~= nil and equipData.slot == equipSlotType then
        local template = DataCenter.EquipTemplateManager:GetTemplate(equipData.configId)
        if template ~= nil and template.quality == 5 then
          local levelRequire = self:GetLevelRequirement(equipSlotType)
          if levelRequire ~= nil and 0 < levelRequire and levelRequire > equipData.level then
            return false
          end
          local starRequire = self:GetStarLevelRequirement(equipSlotType)
          if starRequire ~= nil and 0 < starRequire and starRequire > equipData.promoteLevel then
            return false
          end
        end
        break
      end
    end
  end
  return true
end

return EquipRecommendTemplate
