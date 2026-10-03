local AppearanceTemplate = BaseClass("AppearanceTemplate")

local function __init(self)
end

local function __delete(self)
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.model_path = row:getValue("model_path")
  self.city_model_path = row:getValue("city_model_path")
  self.queue_model_path = row:getValue("queue_model_path")
  self.model_size = tonumber(row:getValue("model_size"))
  self.model_size = 0 < self.model_size and self.model_size or 1
  self.canon_path = row:getValue("canon_path")
  self.fire_paths = row:getValue("fire_path") or {}
  self.fire_path = self.fire_paths[1] or ""
  self.hero_effect = tonumber(row:getValue("hero_effect"))
  self.angular_speed = tonumber(row:getValue("angular_speed")) or 4
  self.army_type = tonumber(row:getValue("army_type")) or 0
  self.appearance = tonumber(row:getValue("appearance")) or 0
  self.team_location = tonumber(row:getValue("team_location")) or 0
  self.speed_battle = tonumber(row:getValue("speed_battle")) or 0
  self.canon_rotation = row:getValue("canon_rotation")
  self.heroimg_model = row:getValue("Heroimg_model")
  self.half_icon_path = row:getValue("half_icon_path") or ""
  self.walk_sound = row:getValue("sound_id_walk") or 0
  self.queue_icon_path = row:getValue("queue_icon_path") or ""
  if CommonUtil.IsJapanABTest() then
    if not string.IsNullOrEmpty(row:getValue("queue_icon_path_B")) then
      self.queue_icon_path = row:getValue("queue_icon_path_B")
    end
    if not string.IsNullOrEmpty(row:getValue("half_icon_path_B")) then
      self.half_icon_path = row:getValue("half_icon_path_B")
    end
  end
  self.world_model_path = row:getValue("world_model_path") or ""
  local left_right_action = tonumber(row:getValue("left_right_action")) or 0
  self.left_right_action = left_right_action == 1
  self.buff_path = row:getValue("buff_path") or {}
  self.ui_path = row:getValue("ui_path") or ""
  self.dynamicPosSize = row:getValue("dynamicPosSize") or 1.5
  self.facing = row:getValue("facing") or ""
  self.hp_type = row:getValue("hp_type")
  self.hp_height = row:getValue("hp_height")
  self.sound_switch_skin = row:getValue("sound_switch_skin")
  self.sound_lvlup_TL = row:getValue("sound_lvlup_TL")
end

AppearanceTemplate.__init = __init
AppearanceTemplate.__delete = __delete
AppearanceTemplate.InitData = InitData
return AppearanceTemplate
