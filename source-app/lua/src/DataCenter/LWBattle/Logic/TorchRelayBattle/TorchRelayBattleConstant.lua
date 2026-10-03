local Constant = {}
Constant.SCENE_CHUNK_SIZE = 66
Constant.INIT_LOAD_SCENE_COUNT = 3
Constant.MAX_LOAD_SCENE_COUNT = 120
Constant.CAMERA_X_ANGLE = 42
Constant.CAMERA_OFFSET = Vector3.New(0, 18, -9)
Constant.SCENE_VIEW_OFFSET = Vector3.New(0, 0, 60)
Constant.SCENE_CENTER_X = 36
Constant.PLAYER_BIRTH_POS = Vector3.New(36, 0, 5)
Constant.CAMERA_SMOOTH_TIME = 0.3
Constant.PRELOAD_GROUND_RANGE = 4
Constant.DISPLACE_EPSILON = 0.01
Constant.PLAYER_SCALE = Vector3(1.5, 1.5, 1.5)
Constant.PLAYER_HORIZONTAL_MOVE_DISTANCE_PER_SECOND = 1
Constant.PLAYER_VERTICAL_MOVE_DISTANCE_PER_SECOND = 10
Constant.SERVER_CHECK_DURATION = 10
Constant.POST_EVENT_DURATION = 3
Constant.CHEER_NORMAL_ASSET_PATH = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing_yundonghui/prefab/A_Hero_bubing_yundonghui_wanshengjie.prefab"
Constant.CHEER_NORMAL_PROP_PERSON_ASSET_PATH = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing_yundonghui/prefab/A_Hero_bubing_yundonghui_wanshengjie.prefab"
Constant.CHEER_NORMAL_POSITIONS_LEFT = {
  Vector3.New(31, 0, 3),
  Vector3.New(31, 0, 5),
  Vector3.New(31, 0, 7),
  Vector3.New(31, 0, 5)
}
Constant.CHEER_NORMAL_POSITIONS_RIGHT = {
  Vector3.New(42, 0, 2),
  Vector3.New(42, 0, 4),
  Vector3.New(42, 0, 6),
  Vector3.New(42, 0, 8)
}
Constant.CHEER_NORMAL_ANIMS = {
  "Happy01",
  "Happy03",
  "Happy04"
}
Constant.CHEER_NORMAL_PROP_PERSON_POSITION = Vector3.New(42, 0, 11)
Constant.CHEER_NORMAL_ROTATION_Y_LEFT = 150
Constant.CHEER_NORMAL_ROTATION_Y_RIGHT = 210
Constant.CHEER_NORMAL_PROP_PERSON_SCALE = Vector3.New(1.5, 1.5, 1.5)
Constant.CHEER_NORMAL_PROP_PERSON_ROTATION_Y = 190
Constant.PROPS_AUTO_COLLECT_BOUND_MIN_X = -10
Constant.PROPS_AUTO_COLLECT_BOUND_MAX_X = 10
Constant.PROPS_AUTO_COLLECT_BOUND_MIN_Z = 0
Constant.PROPS_AUTO_COLLECT_BOUND_MAX_Y = 3
Constant.PROPS_MAX_DURATION = 7200
Constant.PROPS_BORN_LINE_LEFT_X = 33.5
Constant.PROPS_BORN_LINE_MIDDLE_X = 36
Constant.PROPS_BORN_LINE_RIGHT_X = 38.5
Constant.PLAYER_BE_ATTACKED_INVINCIBLE_DURATION = 1
Constant.PLAYER_BE_ATTACKED_INVINCIBLE_EFFECT_CHANGE_PER_SECOND = 0.5 / (Constant.PLAYER_BE_ATTACKED_INVINCIBLE_DURATION * 0.5)
Constant.ITEM_MAGNETIC_SPEED = 45
Constant.CHEER_ITEM_FLY_SPEED = 25
Constant.CHEER_ITEM_GRAVITY = 9.8
Constant.CHEER_ITEM_ATTRACTION_DISTANCE = 1000
Constant.CHEER_ITEM_FORWARD_Z_DISTANCE = 3
Constant.CHEER_ADVANCE_SHADOW_ASSET_PATH = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing_yundonghui/prefab/army_t6_06c_yingzi.prefab"
Constant.CHEER_ADVANCE_PARACHUTE_ASSET_PATH = "Assets/_Art_LastWar/Models/Environment/Build/A_build_jiangluosan/prefab/A_build@yundonghui_kongtou.prefab"
Constant.UI_SPEED_POWER_ADD_ANI_TIME = 0.1
Constant.UI_SPEED_POWER_TO_ZERO_ANI_TIME = 0.5
Constant.ENTER_COUNT_DOWN = 3
Constant.STAMINA_RED_EFFECT__PERCENT = 0.1
Constant.PLAYER_FLY_ITEM_ASSET = "Assets/Main/Prefabs/LWBattle/TorchRelayFlyItem.prefab"
Constant.PLAYER_HP_BAR_ASSET = "Assets/Main/Prefabs/LWBattle/TorchRelayHpBar.prefab"
Constant.PLAYER_HP_BAR_WIDTH = 1
Constant.PLAYER_FLY_ITEM_STAMINA_ICON = "Assets/Main/Sprites/UI/LWTorchRelay/cfm_icon_tili_3.png"
Constant.START_GUIDE_ID = 5001
Constant.FINISH_NEXT_PLAYER_POSITION_OFFSET = Vector3.New(2.5, 0, 0)
Constant.FINISH_NEXT_PLAYER_ASSET_PATH = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing_yundonghui/prefab/A_Hero_bubing_yundonghui_wanshengjie.prefab"
Constant.RUNNING_MAN_NORMAL_SCALE = 1.5
Constant.RUNNING_MAN_NORMAL_SCALE_ADD_BUFF = 1.8
Constant.RUNNING_MAN_INVINCIBLE_ADD_ANI_TIME = 0.1
Constant.RUNNING_MAN_INVINCIBLE_REMOVE_ANI_TIME = 0.1
Constant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE = 2.1
Constant.RUNNING_MAN_INVINCIBLE_SCALE_ADD_BUFF = 2.2
Constant.RUNNING_MAN_OBSTACLES_VIBRATION_INTENSITY = 0.5
Constant.RUNNING_MAN_OBSTACLES_VIBRATION_SHARPNESS = 0.3
Constant.RUNNING_MAN_OBSTACLES_VIBRATION_DURATION = 0.2
Constant.VIRTUAL_AUTO_COLLECT_PROPS_INSTANCE_ID = -1000
Constant.VIRTUAL_AUTO_COLLECT_PROPS_CONFIG_ID = 25
return Constant
