local PveBulletTemplate = BaseClass("PveBulletTemplate")

local function __init(self)
end

local function __delete(self)
  self.sound_id_hit = nil
  self.sound_id_create = nil
  self.target_type = nil
  self.hitShakeParam = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.base_type = tonumber(row:getValue("base_type")) or 0
  self.damage_type = tonumber(row:getValue("damage_type")) or 0
  self.damage = tonumber(row:getValue("damage")) or 0
  self.damage = self.damage * 0.01
  self.mvt_type = tonumber(row:getValue("mvt_type")) or 0
  self.melee_angle = tonumber(row:getValue("melee_angle")) or 0
  self.spiral_loops = tonumber(row:getValue("spiral_loops")) or 0
  self.spiral_radius = tonumber(row:getValue("spiral_radius")) or 0
  self.is_following = tonumber(row:getValue("is_following")) == 1
  self.lifetime_world = tonumber(row:getValue("lifetime_world")) or 0
  if self.lifetime_world == 0 then
    self.lifetime_world = 0.2
  end
  self.lifetime = tonumber(row:getValue("lifetime")) or 0
  if self.lifetime == 0 then
    self.lifetime = 0.2
  end
  self.bullet_fly_speed = tonumber(row:getValue("bullet_fly_speed")) or 0
  self.bullet_fly_speed_world = tonumber(row:getValue("bullet_fly_speed_world")) or self.bullet_fly_speed
  self.bullet_collide_limit = tonumber(row:getValue("bullet_collide_limit")) or 0
  self.bullet_collide_limit = self.bullet_collide_limit <= -1 and 64 or self.bullet_collide_limit
  self.target_type = {}
  self.target_type_bin = 0
  local strs = string.split(row:getValue("target_type"), "|")
  for _, v in ipairs(strs) do
    local type = tonumber(v) or -1
    table.insert(self.target_type, type)
    if 0 <= type then
      self.target_type_bin = self.target_type_bin | 1 << type + 1
    end
  end
  self.bullet_angle_diff = tonumber(row:getValue("bullet_angle_diff")) or 0
  self.random_angle_range = tonumber(row:getValue("random_angle_range")) or 0
  self.random_ring_range = tonumber(row:getValue("random_ring_range")) or 0
  self.mvt_type_para = tonumber(row:getValue("mvt_type_para")) or 0
  self.mvt_type_para = 0 >= self.mvt_type_para and 0.4 or self.mvt_type_para
  self.mvt_type_para_2 = tonumber(row:getValue("mvt_type_para_2")) or 0
  self.mvt_type_para_3 = tonumber(row:getValue("mvt_type_para_3")) or 0
  self.bullet_row_count = tonumber(row:getValue("bullet_row_count")) or 0
  self.bullet_row_count_replay = tonumber(row:getValue("bullet_row_count_replay")) or 0
  self.bullet_diff_time = tonumber(row:getValue("bullet_diff_time")) or 0
  self.bullet_diff_time = self.bullet_diff_time * 0.001
  self.bullet_diff_time_replay = tonumber(row:getValue("bullet_diff_time_replay")) or 0
  self.bullet_diff_time_replay = self.bullet_diff_time_replay * 0.001
  self.bullet_wave_count = tonumber(row:getValue("bullet_wave_count")) or 0
  self.bullet_wave_count_replay = tonumber(row:getValue("bullet_wave_count_replay")) or 0
  self.bullet_wave_diff_time = tonumber(row:getValue("bullet_wave_diff_time")) or 0
  self.bullet_wave_diff_time = self.bullet_wave_diff_time * 0.001
  self.bullet_wave_diff_time_replay = tonumber(row:getValue("bullet_wave_diff_time_replay")) or 0
  self.bullet_wave_diff_time_replay = self.bullet_wave_diff_time_replay * 0.001
  local start_pos_offset = row:getValue("start_pos_offset")
  local start_pos_offset_vec3 = row:getValue("start_pos_offset_vec3") or {}
  if not table.IsNullOrEmpty(start_pos_offset_vec3) then
    self.start_pos_offset = {}
    for i = 1, #start_pos_offset_vec3 do
      local coord = string.split(start_pos_offset_vec3[i], ",")
      self.start_pos_offset[i] = Vector3(tonumber(coord[1]), tonumber(coord[2]), tonumber(coord[3]))
    end
    self.bullet_row_count = #self.start_pos_offset
  elseif not string.IsNullOrEmpty(start_pos_offset) then
    self.start_pos_offset = {}
    start_pos_offset = string.split(start_pos_offset, "|")
    for i = 1, #start_pos_offset do
      local coord = string.split(start_pos_offset[i], ",")
      self.start_pos_offset[i] = Vector3(tonumber(coord[1]), 0, tonumber(coord[2]))
    end
    self.bullet_row_count = #start_pos_offset
  end
  self.bullet_damage_count = tonumber(row:getValue("bullet_damage_count")) or 0
  self.bullet_damage_attenuation = tonumber(row:getValue("bullet_damage_attenuation")) or 100
  self.bullet_damage_attenuation = self.bullet_damage_attenuation * 0.01
  self.continuous_gap = tonumber(row:getValue("continuous_gap")) or 0
  self.continuous_gap = self.continuous_gap * 0.001
  self.second_attack = tonumber(row:getValue("second_attack")) or 0
  self.second_attack_rate = tonumber(row:getValue("second_attack_rate")) or 0
  self.second_attack_count = tonumber(row:getValue("second_attack_count")) or 1
  self.second_attack_repeat = (tonumber(row:getValue("second_attack_repeat")) or 0) == 1
  self.second_attack_angle = row:getValue("second_attack_angle") or 0
  self.second_attack_limit_min = row:getValue("second_attack_limit_min") or 0
  self.second_attack_limit_max = row:getValue("second_attack_limit_max") or 0
  if self.base_type == 1 then
    self.dead_delay = 0.001
  else
    self.dead_delay = tonumber(row:getValue("dead_delay")) or 0
  end
  self.death_rattle_bullet = row:getValue("death_rattle_bullet") or {}
  self.disable_bullet_rate = tonumber(row:getValue("disable_bullet_rate")) or 0
  self.bullet_effect = row:getValue("bullet_effect")
  self.bullet_effect_empty = string.IsNullOrEmpty(self.bullet_effect)
  local appears = row:getValue("bullet_effect_appear")
  if not string.IsNullOrEmpty(appears) then
    self.bullet_effect_appear = {}
    appears = string.split(appears, "|")
    for i = 1, #appears do
      local appear = string.split(appears[i], ",")
      self.bullet_effect_appear[tonumber(appear[1])] = appear[2]
    end
  end
  local bullet_effect_size = tonumber(row:getValue("bullet_effect_size")) or 100
  self.bullet_effect_size = bullet_effect_size * 0.01
  local bullet_effect_size_world = tonumber(row:getValue("bullet_effect_size_world")) or bullet_effect_size
  self.bullet_effect_size_world = bullet_effect_size_world * 0.01
  self.hit_effect = row:getValue("hit_effect")
  self.warning_effect = row:getValue("warning_effect")
  self.warning_effect_empty = string.IsNullOrEmpty(self.warning_effect)
  self.hit_stiff_time = tonumber(row:getValue("hit_stiff_time")) or 0
  self.hit_back_distance = tonumber(row:getValue("hit_back_distance")) or 0
  self.white_time = tonumber(row:getValue("white_time")) or 0
  local shake = row:getValue("hit_shake")
  if string.IsNullOrEmpty(shake) then
    self.hitShakeParam = nil
  else
    local strs = string.split(shake, "|")
    self.hitShakeParam = {
      duration = tonumber(strs[1]),
      strength = Vector3.New(tonumber(strs[2]), tonumber(strs[3]), tonumber(strs[4])),
      vibrato = tonumber(strs[5])
    }
  end
  self.motion_curve = row:getValue("motion_curve")
  if string.IsNullOrEmpty(self.motion_curve) then
    self.motion_curve = nil
  end
  if self.mvt_type == BulletMoveType.Straight and self.is_following or self.mvt_type == BulletMoveType.Parabola then
    self.hasRangeLimit = true
  end
  self.sound_id_hit = tonumber(row:getValue("sound_id_hit") or 0)
  self.sound_id_create = tonumber(row:getValue("sound_id_create") or 0)
  self.hit_clear_buff = row:getValue("hit_clear_buff")
  self.hit_monster_born = nil
  local summonBorn = row:getValue("hit_monster_born")
  if not string.IsNullOrEmpty(summonBorn) then
    local summonArray = string.split(summonBorn, ",")
    if #summonArray == 3 then
      self.hit_monster_born = {}
      for i = 1, 3 do
        table.insert(self.hit_monster_born, tonumber(summonArray[i]))
      end
    end
  end
  self.effect_length = tonumber(row:getValue("effect_length")) or 1
  self.colliderRadius = tonumber(row:getValue("radius")) or 0
  self.percent_damage = tonumber(row:getValue("percent_damage"))
  if self.percent_damage and 0 < self.percent_damage then
    self.percent_damage = self.percent_damage / 10000
  end
  local parabolaAngleCfgValue = row:getValue("parabola_angle")
  self.parabola_angle = parabolaAngleCfgValue and tonumber(parabolaAngleCfgValue) or 0
  self.bullet_born_scale = tonumber(row:getValue("bullet_born_scale")) or 0
  self.add_buff = row:getValue("add_buff") or 0
  self.add_buff_mode = row:getValue("add_buff_mode") or 0
  self.add_buff_limit = row:getValue("add_buff_limit") or 0
  self.add_enemy_type = row:getValue("add_enemy_type") or {}
  self.bullet_effect_onground = row:getValue("bullet_effect_onground") == 1
  self.disappear_effect = row:getValue("disappear_effect")
  self.start_pos_born_random_ring = nil
  local start_pos_born_random_ring = row:getValue("start_pos_born_random_ring")
  if not table.IsNullOrEmpty(start_pos_born_random_ring) then
    self.start_pos_born_random_ring = {}
    for i = 1, #start_pos_born_random_ring do
      local radiusPair = string.split(start_pos_born_random_ring[i], ";")
      self.start_pos_born_random_ring[i] = {
        r1 = tonumber(radiusPair[1]),
        r2 = tonumber(radiusPair[2])
      }
    end
  end
end

local function GetBulletEffect(self, appearanceId)
  if appearanceId and self.bullet_effect_appear and self.bullet_effect_appear[appearanceId] then
    return self.bullet_effect_appear[appearanceId], false
  end
  return self.bullet_effect, self.bullet_effect_empty
end

PveBulletTemplate.__init = __init
PveBulletTemplate.__delete = __delete
PveBulletTemplate.InitData = InitData
PveBulletTemplate.GetBulletEffect = GetBulletEffect
return PveBulletTemplate
