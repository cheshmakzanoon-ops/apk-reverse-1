local ActivityHunterStageTemplate = BaseClass("ActivityHunterStageTemplate")

function ActivityHunterStageTemplate:__init()
  self.id = 0
  self.scene = ""
  self.item_position_random = ""
  self.birth_point = ""
  self.monster_maxnum = ""
  self.monster_birth_points = ""
  self.fly_monster_birth_points = ""
  self.monster_group = ""
  self.boss_birth_point = ""
  self.birth_point = ""
  self.boss_group = ""
  self.bgm = ""
  self.bgm_1 = ""
  self.effect1 = ""
  self.camera_params = ""
  self.mine_prefab = ""
  self.is_block = ""
  self.is_hide_damage = ""
  self.opening_plot = ""
  self.battle_title_type = ""
  self.switch_resource = ""
end

function ActivityHunterStageTemplate:__delete()
  self.id = nil
  self.scene = nil
  self.item_position_random = nil
  self.birth_point = nil
  self.monster_maxnum = nil
  self.monster_birth_points = nil
  self.fly_monster_birth_points = nil
  self.monster_group = nil
  self.boss_birth_point = nil
  self.birth_point = nil
  self.boss_group = nil
  self.bgm = nil
  self.bgm_1 = nil
  self.effect1 = nil
  self.camera_params = nil
  self.mine_prefab = nil
  self.is_block = nil
  self.is_hide_damage = nil
  self.opening_plot = nil
  self.battle_title_type = nil
  self.switch_resource = nil
end

function ActivityHunterStageTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.scene = rowData:getValue("scene") or ""
  self.item_position_random = rowData:getValue("item_position_random") or ""
  self.birth_point = rowData:getValue("birth_point") or ""
  self.monster_maxnum = rowData:getValue("monster_maxnum") or ""
  self.monster_birth_points = rowData:getValue("monster_birth_points") or ""
  self.fly_monster_birth_points = rowData:getValue("fly_monster_birth_points") or ""
  self.monster_group = rowData:getValue("monster_group") or ""
  self.boss_birth_point = rowData:getValue("boss_birth_point") or ""
  self.birth_point = rowData:getValue("birth_point") or ""
  self.boss_group = rowData:getValue("boss_group") or ""
  self.bgm = rowData:getValue("bgm") or ""
  self.bgm_1 = rowData:getValue("bgm_1") or ""
  self.effect1 = rowData:getValue("effect1") or ""
  self.camera_params = rowData:getValue("camera_params") or ""
  self.mine_prefab = rowData:getValue("mine_prefab") or ""
  self.is_block = rowData:getValue("is_block") or ""
  self.is_hide_damage = rowData:getValue("is_hide_damage") or ""
  self.opening_plot = rowData:getValue("opening_plot") or ""
  self.battle_title_type = rowData:getValue("battle_title_type") or ""
  self.switch_resource = rowData:getValue("switch_resource") or ""
end

return ActivityHunterStageTemplate
