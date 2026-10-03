local Const = {}
Const.testHeroPrefabPath = "Assets/Main/Prefabs/City/Worker/A_worker_ben_low.prefab"
Const.heroMoveSpeed = 2
Const.Route = {
  [BuildingTypes.LW_BUILD_FARMLAND] = BuildingTypes.LW_BUILD_BAKERY,
  [BuildingTypes.LW_BUILD_QUARRY] = BuildingTypes.LW_BUILD_STEEL_MILL,
  [BuildingTypes.LW_BUILD_BAKERY] = BuildingTypes.FUN_BUILD_MAIN,
  [BuildingTypes.LW_BUILD_TRADING_POST] = BuildingTypes.FUN_BUILD_MAIN,
  [BuildingTypes.LW_BUILD_STEEL_MILL] = BuildingTypes.FUN_BUILD_MAIN
}
Const.Garbage = {
  [BuildingTypes.LW_BUILD_FARMLAND] = "O_Garbage_RewardBread_01.prefab",
  [BuildingTypes.LW_BUILD_QUARRY] = "O_GarbageRewardSteel_01.prefab",
  [BuildingTypes.LW_BUILD_GOLD_MILL] = "O_Garbage_RewardGoldstone_01.prefab"
}
Const.GrbagePath = "Assets/Main/Prefabs/City/Worker/"
Const.WorkerState = {
  Idle = 0,
  Move = 1,
  Work = 2,
  Consignment = 3
}
Const.WorkerMoveEndState = {startPos = 1, endPos = 2}
Const.WorkerWorkAnim = {
  [BuildingTypes.LW_BUILD_FARMLAND] = "harvest",
  [BuildingTypes.LW_BUILD_BAKERY] = "operate",
  [BuildingTypes.LW_BUILD_QUARRY] = "operate",
  [BuildingTypes.LW_BUILD_STEEL_MILL] = "operate"
}
Const.CanDispatching = {
  10201000,
  10202000,
  10203000,
  10206000
}
Const.WorkerAnim = {
  Idle = "idle",
  Walk = "walk",
  Work = "operate",
  CarryIdle = "idlecarry",
  Run = "runcarry"
}
Const.WorkerTime = 0.1
Const.maxCount = 10
Const.delayTime = 1
return Const
