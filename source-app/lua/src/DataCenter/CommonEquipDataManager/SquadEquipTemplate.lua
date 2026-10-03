local SquadEquipTemplate = BaseClass("SquadEquipTemplate")

function SquadEquipTemplate:__init()
  self.id = 0
  self.type = 0
  self.slot = 0
  self.quality = 0
  self.name = ""
  self.desc = ""
  self.icon = ""
  self.level = 0
  self.target_id = 0
  self.target_num = {}
  self.effect = {}
  self.power = 0
  self.growth_value = 0
  self.upgrade_switch = 0
  self.upgrade_value = 0
  self.lv_group = 0
  self.effect_hero = {}
end

function SquadEquipTemplate:__delete()
  self.id = nil
  self.type = nil
  self.slot = nil
  self.quality = nil
  self.name = nil
  self.desc = nil
  self.icon = nil
  self.level = nil
  self.target_id = nil
  self.target_num = nil
  self.effect = nil
  self.power = nil
  self.growth_value = 0
  self.upgrade_switch = 0
  self.upgrade_value = 0
  self.lv_group = 0
  self.effect_hero = nil
  self.baseEffect = nil
end

function SquadEquipTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.slot = rowData:getValue("slot") or 0
  self.quality = rowData:getValue("quality") or 0
  self.name = rowData:getValue("name") or ""
  self.desc = rowData:getValue("desc") or ""
  self.icon = rowData:getValue("icon") or ""
  self.level = rowData:getValue("level") or 0
  self.target_id = rowData:getValue("target_id") or 0
  self.target_num = rowData:getValue("target_num") or {}
  self.effect = rowData:getValue("effect") or {}
  self.power = rowData:getValue("power") or 0
  self.growth_value = rowData:getValue("growth_value") or 0
  self.upgrade_switch = rowData:getValue("upgrade_switch") or 0
  self.upgrade_value = rowData:getValue("upgrade_value") or 0
  self.lv_group = rowData:getValue("lv_group") or 0
  self.effect_hero = rowData:getValue("effect_hero") or {}
  local list = {}
  list = self:_InsertEffect(list, self.effect)
  list = self:_InsertEffect(list, self.effect_hero)
  self.baseEffect = list
end

function SquadEquipTemplate:_InsertEffect(list, origin)
  for key, value in ipairs(origin) do
    if not string.IsNullOrEmpty(value) then
      local splitStr = string.split(value, ";")
      if splitStr and 2 <= #splitStr then
        table.insert(list, {
          key = tonumber(splitStr[1]),
          value = tonumber(splitStr[2])
        })
      end
    end
  end
  return list
end

function SquadEquipTemplate:GetUpgradeCost()
  local targetId = self.target_id
  if 0 < targetId then
    local targetConfig = DataCenter.CommonEquipTemplateManager:GetTemplate(targetId)
    if targetConfig then
      return targetConfig.target_num
    end
  end
  return {}
end

function SquadEquipTemplate:IsMax()
  return self.target_id <= 0
end

return SquadEquipTemplate
