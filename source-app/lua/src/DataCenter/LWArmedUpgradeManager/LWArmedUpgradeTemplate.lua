local LWArmedUpgradeTemplate = BaseClass("LWArmedUpgradeTemplate")

function LWArmedUpgradeTemplate:__init()
  self.id = 0
  self.level = 0
  self.upgrade_need = {}
  self.delet_scene_model = {}
  self.zombie_max = 0
  self.hero_energy_levelup = {}
  self.appearance = 0
  self.skill = 0
  self.attack = 0
  self.upgrade_vfx_path = {}
  self.upgrade_vfx_point = {}
  self.mod_scale = 0
  self.bubble_position = {}
  self.upgrade_guide = 0
  self.upgrade_sound = 0
  self.energyEffectMap = nil
  self.energyEffectCount = nil
  self.slot2SkillIdMap = nil
end

function LWArmedUpgradeTemplate:__delete()
  self.id = nil
  self.level = nil
  self.upgrade_need = nil
  self.delet_scene_model = nil
  self.zombie_max = nil
  self.hero_energy_levelup = nil
  self.appearance = nil
  self.skill = nil
  self.attack = nil
  self.upgrade_vfx_path = nil
  self.upgrade_vfx_point = nil
  self.mod_scale = nil
  self.bubble_position = nil
  self.upgrade_guide = nil
  self.upgrade_sound = nil
  self.energyEffectMap = nil
  self.energyEffectCount = nil
  self.slot2SkillIdMap = nil
end

function LWArmedUpgradeTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.level = rowData:getValue("level") or 0
  self.upgrade_need = rowData:getValue("upgrade_need") or {}
  self.delet_scene_model = rowData:getValue("delet_scene_model") or {}
  self.zombie_max = rowData:getValue("zombie_max") or 0
  self.hero_energy_levelup = rowData:getValue("hero_energy_levelup") or {}
  self.appearance = rowData:getValue("appearance") or 0
  self.skill = rowData:getValue("skill") or 0
  self.attack = rowData:getValue("attack") or 0
  self.upgrade_vfx_path = rowData:getValue("upgrade_vfx_path") or {}
  self.upgrade_vfx_point = rowData:getValue("upgrade_vfx_point") or {}
  self.mod_scale = rowData:getValue("mod_scale") or 0
  self.bubble_position = rowData:getValue("bubble_position") or {}
  self.upgrade_guide = rowData:getValue("upgrade_guide") or 0
  self.upgrade_sound = rowData:getValue("upgrade_sound") or 0
end

function LWArmedUpgradeTemplate:GetArmedUpgradeEnergyEffect(targetEnergyCount)
  if self.energyEffectMap == nil then
    self.energyEffectMap = {}
    self.energyEffectCount = table.count(self.hero_energy_levelup)
    for i = 1, self.energyEffectCount do
      local strArr = string.split(self.hero_energy_levelup[i], "|")
      local strCount = table.count(strArr)
      local effectArray = {}
      for j = 1, strCount do
        local effectId = tonumber(strArr[j])
        table.insert(effectArray, effectId)
      end
      self.energyEffectMap[i] = effectArray
    end
  end
  if targetEnergyCount <= self.energyEffectCount then
    return self.energyEffectMap[targetEnergyCount]
  else
    return self.energyEffectMap[self.energyEffectCount]
  end
end

function LWArmedUpgradeTemplate:GetArmedUpgradeSkillIdBySlot(slot)
  if self.slot2SkillIdMap == nil then
    self.slot2SkillIdMap = {}
    self.slot2SkillIdMap[1] = self.attack
    self.slot2SkillIdMap[2] = self.skill
  end
  return self.slot2SkillIdMap[slot] or 0
end

return LWArmedUpgradeTemplate
