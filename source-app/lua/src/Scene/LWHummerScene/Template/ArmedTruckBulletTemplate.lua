local ArmedTruckBulletTemplate = BaseClass("LWHummerSceneConfigTemplate")

function ArmedTruckBulletTemplate:__init()
  self.id = 0
  self.mvt_type = 0
  self.motion_curve = ""
  self.mvt_type_para = 0
  self.is_following = false
  self.lifetime = 0
  self.dead_delay = 0
  self.bullet_fly_speed = 0
  self.bullet_row_count = 0
  self.start_pos_offset = nil
  self.bullet_diff_time = 0
  self.bullet_effect = ""
  self.bullet_effect_size = 0
  self.hit_effect = ""
  self.bullet_row_count = 1
  self.bullet_wave_count = 1
  self.bullet_angle_diff = 0
  self.sound_id_create = 0
end

function ArmedTruckBulletTemplate:__delete()
  self.id = nil
  self.mvt_type = nil
  self.motion_curve = nil
  self.mvt_type_para = nil
  self.is_following = nil
  self.lifetime = nil
  self.dead_delay = nil
  self.bullet_fly_speed = nil
  self.bullet_row_count = nil
  self.start_pos_offset = nil
  self.bullet_diff_time = nil
  self.bullet_effect = nil
  self.bullet_effect_size = nil
  self.hit_effect = nil
  self.bullet_row_count = nil
  self.bullet_wave_count = nil
  self.bullet_angle_diff = nil
  self.sound_id_create = nil
end

function ArmedTruckBulletTemplate:InitData(cfg)
  if cfg == nil then
    return
  end
  self.id = cfg:getValue("id")
  self.mvt_type = cfg:getValue("mvt_type")
  self.motion_curve = cfg:getValue("motion_curve")
  self.mvt_type_para = cfg:getValue("mvt_type_para")
  self.is_following = cfg:getValue("is_following") == 1
  self.lifetime = cfg:getValue("lifetime") or 0.1
  self.dead_delay = cfg:getValue("dead_delay")
  self.bullet_fly_speed = cfg:getValue("bullet_fly_speed")
  self.bullet_row_count = cfg:getValue("bullet_row_count")
  local start_pos_offset = cfg:getValue("start_pos_offset")
  if not string.IsNullOrEmpty(start_pos_offset) then
    self.start_pos_offset = {}
    start_pos_offset = string.split(start_pos_offset, "|")
    for i = 1, #start_pos_offset do
      local coord = string.split(start_pos_offset[i], ",")
      self.start_pos_offset[i] = Vector3(tonumber(coord[1]), 0, tonumber(coord[2]))
    end
    self.bullet_row_count = #start_pos_offset
  end
  self.bullet_diff_time = cfg:getValue("bullet_diff_time") * 0.001
  self.bullet_effect = cfg:getValue("bullet_effect")
  self.bullet_effect_size = cfg:getValue("bullet_effect_size") * 0.01
  self.hit_effect = cfg:getValue("hit_effect")
  self.bullet_angle_diff = cfg:getValue("bullet_angle_diff")
  self.sound_id_create = cfg:getValue("sound_id_create") or 0
end

return ArmedTruckBulletTemplate
