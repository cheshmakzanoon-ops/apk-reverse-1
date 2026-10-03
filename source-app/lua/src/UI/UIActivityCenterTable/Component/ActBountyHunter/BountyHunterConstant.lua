local Constant = {}
Constant.BOX_BORN__EFF_CONFIG = {
  [BountyMonsterQualityType.NormalMonster] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_bron2.prefab",
  [BountyMonsterQualityType.EliteMonster] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_bron2_2.prefab",
  [BountyMonsterQualityType.Boss] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_bron3.prefab"
}
Constant.BOX_OPEN__EFF_CONFIG = {
  [BountyMonsterQualityType.NormalMonster] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_open2.prefab",
  [BountyMonsterQualityType.EliteMonster] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_open2_2.prefab",
  [BountyMonsterQualityType.Boss] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_open3.prefab"
}
Constant.BOX_PRE_OPEN__EFF_CONFIG = {
  [BountyMonsterQualityType.EliteMonster] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_2glow.prefab"
}
Constant.HUNTER_FIRE_POINT_PATH_GUN1 = "A_Hero@jbl_skin/To_unity/DeformationSystem/Root/up/point/Chest_M/Scapula_R/Shoulder_R/ShoulderPart1_R/Elbow_R/ElbowPart1_R/Wrist_R/qiang/FirePoint_01"
Constant.HUNTER_FIRE_POINT_PATH_GUN2 = "A_Hero@jbl_skin/To_unity/DeformationSystem/Root/up/point/Chest_M/Scapula_R/Shoulder_R/ShoulderPart1_R/Elbow_R/ElbowPart1_R/Wrist_R/qiang102/FirePoint_02"
Constant.HUNTER_GUN2_EFFECT_PATH = "A_Hero@jbl_skin/To_unity/DeformationSystem/Root"
Constant.MONSTER_BE_HIT_EFFECT_PATH = "A_Monster@boss01_skin/To_unity/DeformationSystem/Root"
Constant.HUNTER_ATTACK_ANIM_LENGTH_DICT = {
  [BountyMonsterBulletType.Gun1] = 0.4,
  [BountyMonsterBulletType.Gun2Small] = 0.3,
  [BountyMonsterBulletType.Gun2Big] = 0.5
}
Constant.HUNTER_RELOAD_ANIM_LENGTH = 1.7
Constant.HUNTER_TURN_BACK_ANIM_LENGTH = 0.7
Constant.HUNTER_TURN_FRONT_ANIM_LENGTH = 0.4
Constant.HUNTER_CHANGE_GUN_ANIM_LENGTH = 1.35
Constant.HUNTER_AIM_ANIM_LENGTH = 0.3
Constant.HUNTER_ALERT_MAX_DURATION = 5
Constant.HUNTER_THROW_ANIM_LENGTH = 2
Constant.HUNTER_THROW_WAIT_TIME = 2
Constant.CONFUSE_MONSTER_DURATION = 2
Constant.CONFUSE_BULLET_FLY_DURATION = 1
Constant.CONFUSE_BULLET_EXIST_TIME = 4
Constant.CONFUSE_BULLET_DROP_GROUND_EXIST_TIME = 4
Constant.HUNTER_GUN1_BULLET_COUNT = 3
Constant.HUNTER_GUN1_BULLET_DELTA_TIME = 0.1
Constant.SCENE_CHANGE_ANIM_LENGTH = 3
Constant.MONSTER_QUALITY_2_NAME_KEY = {
  [BountyMonsterQualityType.Boss] = "activity_hunter_dropshow_monstertype3",
  [BountyMonsterQualityType.EliteMonster] = "activity_hunter_dropshow_monstertype2",
  [BountyMonsterQualityType.NormalMonster] = "activity_hunter_dropshow_monstertype1"
}
Constant.MONSTER_QUALITY_2_MAIN_BANNER_PATH = {
  [BountyMonsterQualityType.Boss] = "Assets/Main/TextureEx/BountyHunter/wxy_shangjinlieren_dadiban01_banner.png",
  [BountyMonsterQualityType.EliteMonster] = "Assets/Main/TextureEx/BountyHunter/wxy_shangjinlieren_dadiban02_banner.png",
  [BountyMonsterQualityType.NormalMonster] = "Assets/Main/TextureEx/BountyHunter/wxy_shangjinlieren_dadiban03_banner.png"
}
Constant.ACTION_TYPE_ENUM_2_STR_CONFIG = {
  [BountyHunterAniActionType.RefreshScene] = "RefreshScene",
  [BountyHunterAniActionType.ReceiveFreeChest] = "ReceiveFreeChest",
  [BountyHunterAniActionType.RandomBomb] = "RandomBomb",
  [BountyHunterAniActionType.ShopEvent] = "ShopEvent",
  [BountyHunterAniActionType.GetFreeChest] = "GetFreeChest",
  [BountyHunterAniActionType.FullScreenAttack] = "FullScreenAttack",
  [BountyHunterAniActionType.SuperShoot] = "SuperShoot",
  [BountyHunterAniActionType.MonsterHurt] = "MonsterHurt",
  [BountyHunterAniActionType.MonsterRemove] = "MonsterRemove",
  [BountyHunterAniActionType.BossBirth] = "BossBirth",
  [BountyHunterAniActionType.HunterAttack] = "HunterAttack",
  [BountyHunterAniActionType.ConfuseMonster] = "ConfuseMonster"
}
Constant.QUEUE_TYPE_ENUM_2_STR_CONFIG = {
  [BountyHunterAniActionQueueType.Hunter] = "Hunter",
  [BountyHunterAniActionQueueType.Monster] = "Monster",
  [BountyHunterAniActionQueueType.Scene] = "Scene"
}
Constant.FREE_CHEST_BORN_EFF_PATH = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_bron1.prefab"
Constant.FREE_CHEST_OPEN_EFF_PATH = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_open1.prefab"
Constant.FREE_CHEST_PRE_OPEN_EFF_PATH = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_S.prefab"
Constant.BATTLE_STATE_2_STR_CONFIG = {
  [BattleSceneState.LoadFirstSceneState] = "LoadFirstSceneState",
  [BattleSceneState.EnterBattle] = "EnterBattle",
  [BattleSceneState.InBattle] = "InBattle",
  [BattleSceneState.ChangeScene] = "ChangeScene"
}
Constant.HUNTER_ATTACK_INTERVAL = 500
Constant.HUNTER_FULL_ATTACK_INTERVAL = 1000
Constant.IS_SHOW_SCENE_DEBUG_LOG = false
Constant.IS_SHOW_BEHAVIOUR_DEBUG_LOG = false
Constant.BULLET_PREFAB_PATH = {
  [BountyMonsterBulletType.Gun1] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_sjlr_fire_zd.prefab",
  [BountyMonsterBulletType.Gun2Small] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_s_BountyHunter_jiguang_attack.prefab",
  [BountyMonsterBulletType.Gun2Big] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_s_BountyHunter_jiguang_skill.prefab"
}
Constant.FIRE_EFFECT_PREFAB_PATH = {
  [BountyMonsterBulletType.Gun1] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_sjlr_fire.prefab"
}
Constant.BULLET_HIT_PREFAB_PATH = {
  [BountyMonsterBulletType.Gun1] = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_sjlr_fire_hit.prefab"
}
Constant.CONFUSE_BULLET_THROW_LOCAL_POS_CONFIG = {
  [BountyHunterSceneDoorType.Left] = Vector3.New(30, 0, 45),
  [BountyHunterSceneDoorType.Right] = Vector3.New(45, 0, 45)
}
Constant.FIRST_GUIDE_UI_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/UIActBountyHunterGuide.prefab"
Constant.FIRST_GUIDE_ENTER_DELAY = 3
Constant.MAIN_UI_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/UIActBountyHunterMain.prefab"
Constant.ENTER_SCENE_TIME = 1
Constant.IS_HUNTER_GUN2_BIG_ON = true
Constant.WINDOW_AUTO_CLOSE_TIME_CONFIG = {
  [BountyHunterEventType.BossEvent] = 2.23,
  [BountyHunterEventType.RandomBomb] = 2,
  [BountyHunterEventType.FullScreeAttack] = 1.33,
  [BountyHunterEventType.Shop] = 1.83
}
Constant.FREE_TIP_BUBBLE_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/FreeTipBubble.prefab"
Constant.SHOW_SKIP_BTN_TIME = 4
Constant.AUTO_BREAK_GUIDE_TIME = 12
Constant.AUTO_ENTER_SCENE = 5
return Constant
