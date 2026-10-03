local Constant = {}
Constant.PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
Constant.PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
Constant.PVERvoObstaclePath = "Assets/Main/Prefabs/PVELevel/%s/obstacle.bytes"
Constant.INIT_LOAD_SCENE_COUNT = 3
Constant.PRELOAD_GROUND_RANGE = 3
Constant.SCENE_VIEW_OFFSET = Vector3.New(0, 0, 60)
Constant.DISPLACE_EPSILON = 0.01
Constant.SCENE_SAFE_X = {31, 41}
Constant.PLAER_MEMBER_PATH = "A_vehicle_jidongduikache_02/A_build@yinmijidongduihuoche_02_skin/To_unity/DeformationSystem/Root/yuanjun0%s"
Constant.PLAER_ZOMBIE_PATH = "A_vehicle_jidongduikache_02/A_build@yinmijidongduihuoche_02_skin/To_unity/DeformationSystem/Root/cheshen/jiangshi0%s"
Constant.BATTLE_AFTERENTER_TIME = 2.5
Constant.BATTLE_BEFOREEXIT_TIME = 2
Constant.TRUCK_REFRESH_TIME = 10
Constant.TRUCK_GOODS_GROUP_DUMMY = "A_vehicle_jidongduikache_02/A_build@yinmijidongduihuoche_02_skin/To_unity/DeformationSystem/Root/cheshen/Body_M/huowu01"
Constant.TRUCK_GOODS_GROUP_SETTING = {
  [1] = {
    maxProgress = 0.05,
    groupNum = 0,
    groupPath = UIAssets.Truckgoodsgroup_01_01,
    space = 0.2
  },
  [2] = {
    maxProgress = 0.3,
    groupNum = 1,
    groupPath = UIAssets.Truckgoodsgroup_01_01,
    space = 0.2
  },
  [3] = {
    maxProgress = 0.6,
    groupNum = 1,
    groupPath = UIAssets.Truckgoodsgroup_01_02,
    space = 1
  },
  [4] = {
    maxProgress = 1,
    groupNum = 2,
    groupPath = UIAssets.Truckgoodsgroup_01_02,
    space = 1
  }
}
Constant.TRUCK_GOODS_ICON_PREFABS = {
  "Assets/Main/Prefabs/LWGateDefence/GoodsFood.prefab",
  "Assets/Main/Prefabs/LWGateDefence/GoodsGold.prefab",
  "Assets/Main/Prefabs/LWGateDefence/GoodsIron.prefab"
}
Constant.DROP_DELAY_TIME = 0.3
Constant.DROP_FLY_TIME = 0.5
Constant.DROP_FLY_TARGRT = Vector3.New(0, 2.5, -1)
Constant.DEATH_BLOOD_TIME = 2.5
Constant.AIR_POSITION_Z = -5
Constant.AIR_BULLET_DELAY = 2
Constant.JUMP_ZOMBIE_DIS = 20
Constant.JUMP_ZOMBIE_SPEED = 80
Constant.DOMINATOR_SPAWN_Z = -20
Constant.DOMINATOR_SPAWN_SPEED = 15
Constant.DOMINATOR_RUN_Z = -5
Constant.DOMINATOR_ATK_CD = 1
return Constant
