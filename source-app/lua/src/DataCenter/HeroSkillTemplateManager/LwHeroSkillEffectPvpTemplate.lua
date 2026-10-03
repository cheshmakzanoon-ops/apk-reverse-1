local LwHeroSkillEffectPvpTemplate = BaseClass("LwHeroSkillEffectPvpTemplate")

function LwHeroSkillEffectPvpTemplate:__init()
  self.id = 0
  self.target_type = {}
  self.firepoint = {}
  self.firelogic = 0
  self.fire_effect_bullet = 0
  self.pvp_actionType = 0
  self.pvp_actionParam = ""
  self.dispel_type = 0
  self.damage_to_shield = ""
  self.pvp_pos_condition = ""
  self.pvp_pos_num = ""
  self.pvp_troop_condition = ""
  self.pvp_other_condition = ""
  self.pvp_other_condition_para = ""
  self.pvp_cast_count = 0
  self.pvp_cast_interval = ""
  self.pvp_damage_type = 0
  self.pvp_bullet = 0
  self.pvp_bullet_critical = 0
  self.pvp_buff_condition = ""
  self.pvp_buff_param = ""
  self.pvp_buff_ID = ""
  self.pvp_buff_level = ""
  self.pvp_buff_level_special = ""
  self.pvp_buff_bullet = 0
  self.damage_delay = 0
  self.horizontal_speed = 0
  self.buff_evaluate_score = ""
  self.debuff_evaluate_score = ""
end

function LwHeroSkillEffectPvpTemplate:__delete()
  self.id = nil
  self.target_type = nil
  self.firepoint = nil
  self.firelogic = nil
  self.fire_effect_bullet = nil
  self.pvp_actionType = nil
  self.pvp_actionParam = nil
  self.dispel_type = nil
  self.damage_to_shield = nil
  self.pvp_pos_condition = nil
  self.pvp_pos_num = nil
  self.pvp_troop_condition = nil
  self.pvp_other_condition = nil
  self.pvp_other_condition_para = nil
  self.pvp_cast_count = nil
  self.pvp_cast_interval = nil
  self.pvp_damage_type = nil
  self.pvp_bullet = nil
  self.pvp_bullet_critical = nil
  self.pvp_buff_condition = nil
  self.pvp_buff_param = nil
  self.pvp_buff_ID = nil
  self.pvp_buff_level = nil
  self.pvp_buff_level_special = nil
  self.pvp_buff_bullet = nil
  self.damage_delay = nil
  self.horizontal_speed = nil
  self.buff_evaluate_score = nil
  self.debuff_evaluate_score = nil
end

function LwHeroSkillEffectPvpTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.target_type = rowData:getValue("target_type") or {}
  self.firepoint = rowData:getValue("firepoint") or {}
  self.firelogic = rowData:getValue("firelogic") or 0
  self.fire_effect_bullet = rowData:getValue("fire_effect_bullet") or 0
  self.pvp_actionType = rowData:getValue("pvp_actionType") or 0
  self.pvp_actionParam = rowData:getValue("pvp_actionParam") or ""
  self.dispel_type = rowData:getValue("dispel_type") or 0
  self.damage_to_shield = rowData:getValue("damage_to_shield") or ""
  self.pvp_pos_condition = rowData:getValue("pvp_pos_condition") or ""
  self.pvp_pos_num = rowData:getValue("pvp_pos_num") or ""
  self.pvp_troop_condition = rowData:getValue("pvp_troop_condition") or ""
  self.pvp_other_condition = rowData:getValue("pvp_other_condition") or ""
  self.pvp_other_condition_para = rowData:getValue("pvp_other_condition_para") or ""
  self.pvp_cast_count = rowData:getValue("pvp_cast_count") or 0
  self.pvp_cast_interval = rowData:getValue("pvp_cast_interval") or ""
  self.pvp_damage_type = rowData:getValue("pvp_damage_type") or 0
  self.pvp_bullet = rowData:getValue("pvp_bullet") or 0
  self.pvp_bullet_critical = rowData:getValue("pvp_bullet_critical") or 0
  self.pvp_buff_condition = rowData:getValue("pvp_buff_condition") or ""
  self.pvp_buff_param = rowData:getValue("pvp_buff_param") or ""
  self.pvp_buff_ID = rowData:getValue("pvp_buff_ID") or ""
  self.pvp_buff_level = rowData:getValue("pvp_buff_level") or ""
  self.pvp_buff_level_special = rowData:getValue("pvp_buff_level_special") or ""
  self.pvp_buff_bullet = rowData:getValue("pvp_buff_bullet") or 0
  self.damage_delay = rowData:getValue("damage_delay") or 0
  self.horizontal_speed = rowData:getValue("horizontal_speed") or 0
  self.buff_evaluate_score = rowData:getValue("buff_evaluate_score") or ""
  self.debuff_evaluate_score = rowData:getValue("debuff_evaluate_score") or ""
end

return LwHeroSkillEffectPvpTemplate
