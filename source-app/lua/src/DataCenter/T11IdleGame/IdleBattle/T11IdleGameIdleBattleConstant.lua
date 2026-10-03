local Constant = {}
Constant.MainViewContentType = {
  None = 0,
  Entrance = 1,
  Battle = 2,
  Boss = 3
}
Constant.LevelState = {
  Locked = 0,
  Current = 1,
  Finished = 2
}
Constant.MainBattleContentUIPrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/Battle/UILWT11IdleGameBattleMain_BattleContent.prefab"
Constant.MainEntranceContentUIPrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/Battle/UILWT11IdleGameBattleMain_EntranceContent.prefab"
Constant.MainBossContentUIPrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/Battle/UILWT11IdleGameBattleMain_BossContent.prefab"
Constant.MainBattleNodeInfoUIPrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/Battle/UILWT11IdleGameBattleMain_NodeInfoItem.prefab"
Constant.NodeType = {
  Chest = 1,
  Battle = 2,
  Event = 3
}
Constant.MainBattleNodeInfoIconPath = {
  [Constant.NodeType.Chest] = "Assets/Main/Sprites/UI/T11IdleGame/T11IdleGameMain/FX_t11_idle_game_linshiziyuan05.png",
  [Constant.NodeType.Event] = "Assets/Main/Sprites/UI/T11IdleGame/T11IdleGameMain/FX_t11_idle_game_linshiziyuan04.png",
  [Constant.NodeType.Battle] = "Assets/Main/Sprites/UI/T11IdleGame/T11IdleGameMain/FX_t11_idle_game_linshiziyuan06.png"
}
Constant.BattleRewardPreview = "Assets/Main/Prefabs/UI/T11IdleGame/BattleRewardPreview/UILWT11IdleGameBattleRewardPreviewItem.prefab"
Constant.BattleRewardPreviewProb = "Assets/Main/Prefabs/UI/T11IdleGame/BattleRewardPreview/UILWT11IdleGameBattleRewardPreviewProbabilityItem.prefab"
Constant.BattleRewardPreviewProbRes = "Assets/Main/Prefabs/UI/T11IdleGame/BattleRewardPreview/UILWT11IdleGameBattleRewardPreviewProbabilityResItem.prefab"
Constant.BattleRewardPreviewIconPath = {
  [Constant.NodeType.Chest] = "Assets/Main/Sprites/UI/T11IdleGame/T11IdleGameBattleRewardPreview/FX_t11_idle_game_linshiziyuan02.png",
  [Constant.NodeType.Event] = "Assets/Main/Sprites/UI/T11IdleGame/T11IdleGameBattleRewardPreview/FX_t11_idle_game_linshiziyuan03.png",
  [Constant.NodeType.Battle] = "Assets/Main/Sprites/UI/T11IdleGame/T11IdleGameBattleRewardPreview/FX_t11_idle_game_linshiziyuan01.png"
}
Constant.DefaultSurpriseBoxSceneRootPos = Vector3.New(1000, 1000, -1000)
Constant.State = {
  None = 0,
  Init = 1,
  Load = 2,
  Opening = 3,
  Going = 4,
  PlayNode = 5,
  End = 6
}
Constant.SceneRootAssetPath = "Assets/Main/Prefabs/UI/T11IdleGame/Scene/T11IdleGameIdleBattleScene.prefab"
Constant.DefaultSceneRootPos = Vector3.New(-1000, 1000, -1000)
Constant.NodeState = {
  None = 0,
  Empty = 1,
  WaitForSever = 2,
  Playing = 3
}
Constant.SoldierState = {
  Idle = 0,
  Run = 1,
  Opening = 2,
  OpenChest = 3,
  Event = 4,
  Battle = 5,
  End = 6
}
Constant.VirtualCameraState = {Idle = 0, Chest = 1}
Constant.OpeningStateTimeDuration = 4
Constant.DefaultSoldierAssetPath = "Assets/Main/Prefabs/UI/T11IdleGame/Scene/Soldier/T11IdleGameIdleBattleSoldier_10.prefab"
Constant.DefaultSoldierPosList = {
  Vector3.New(2.5, 0, 0),
  Vector3.New(-2.5, 0, 0),
  Vector3.New(-5, 0, 3),
  Vector3.New(0, 0, 3),
  Vector3.New(5, 0, 3),
  Vector3.New(-7.5, 0, 6),
  Vector3.New(-2.5, 0, 6),
  Vector3.New(2.5, 0, 6),
  Vector3.New(7.5, 0, 6)
}
Constant.SoldierBubbleIconImagePathOpening = "Assets/Main/Sprites/UI/LWChatEmoji/Default/e011.png"
Constant.MaxNodePlayTime = 18
Constant.SceneMoveSpeed = -5
Constant.DefaultSceneData = {
  prefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/Scene/Background/A_scene_bg_01_t11_idle_game.prefab",
  length = 70
}
Constant.PropMoveSpeed = 5
Constant.NodeChestPosition = Vector3.New(0, 0, -20)
Constant.NodeChestRotation = Vector3.New(0, 180, 0)
Constant.NodeChestDefaultAssetPath = "Assets/Main/Prefabs/BountyHunter/Item/BountyHunterChest_L.prefab"
Constant.NodeChestOpenEffectPath = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_ljw_shangjinlieren_baoxiang_open2.prefab"
Constant.NodeChestSoldierMovePosition = Vector3.New(0, 0, -8)
Constant.NodeChestSoldierBubbleIconImagePath1 = "Assets/Main/Sprites/UI/LWChatEmoji/Default/17.png"
Constant.NodeChestSoldierBubbleIconImagePath2 = "Assets/Main/Sprites/UI/LWChatEmoji/Default/3.png"
Constant.NodeEventDefaultAssetPath = "Assets/Main/Prefabs/UI/T11IdleGame/Scene/Soldier/T11IdleGameIdleBattleSoldier_02.prefab"
Constant.NodeEventInitPosition = Vector3.New(13.26, 0, -20)
Constant.NodeEventInitRotation = Vector3.New(0, 0, 0)
Constant.NodeEventRunSpeed = 15
Constant.NodeEventSoldierBubbleIconImagePath1 = "Assets/Main/Sprites/UI/LWChatEmoji/Default/14.png"
Constant.NodeEventSoldierBubbleIconImagePath2 = "Assets/Main/Sprites/UI/LWChatEmoji/Default/e02f.png"
Constant.NodeEventSoldierBubbleIconImagePath3 = "Assets/Main/Sprites/UI/LWChatEmoji/Default/e011.png"
Constant.NodeBattleMonster = {
  Zombie1 = 1,
  Zombie2 = 2,
  Boss = 3
}
Constant.NodeBattleMonsterState = {
  Idle = 1,
  Run = 2,
  Battle = 3,
  Dead = 4
}
Constant.NodeBattleSoldierTargetMonster = {
  [Constant.NodeBattleMonster.Zombie2] = {
    3,
    6,
    7
  },
  [Constant.NodeBattleMonster.Boss] = {
    1,
    2,
    4
  },
  [Constant.NodeBattleMonster.Zombie1] = {
    5,
    8,
    9
  }
}
Constant.NodeBattleMonsterOutPosition = Vector3.New(0, 0, -20)
Constant.NodeBattleMonsterInPosition = Vector3.New(0, 0, -10)
Constant.NodeBattleBossPosition = Vector3.New(0, 0, -3.74)
Constant.NodeBattleZombie1Position = Vector3.New(8.57, 0, 1.93)
Constant.NodeBattleZombie2Position = Vector3.New(-8.57, 0, 1.93)
Constant.NodeBattleRotation = Vector3.New(0, 0, 0)
Constant.NodeBattleBossScale = Vector3.New(1.5, 1.5, 1.5)
Constant.NodeBattleZombieScale = Vector3.New(1.5, 1.5, 1.5)
Constant.NodeBattleSoldierBubbleIconImagePath1 = "Assets/Main/Sprites/UI/LWChatEmoji/Default/17.png"
Constant.NodeBattleSoldierBubbleIconImagePath2 = "Assets/Main/Sprites/UI/LWChatEmoji/Default/e02b.png"
Constant.NodeBattleSoldierBubbleIconImagePath3 = "Assets/Main/Sprites/UI/LWChatEmoji/Default/5.png"
Constant.NodeBattleDefaultMonsterId = 100000
Constant.NodeBattleSoldierSkillCD1 = 0.33
Constant.NodeBattleSoldierSkillCD2 = 0.5
Constant.NodeBattleSoldierBulletCount = 3
Constant.NodeBattleSoldierSkillPreCD = 1
Constant.NodeBattleFireWave = 3
Constant.NodeBattleTargetPositionDistance = Vector3.New(0, 0, -10)
Constant.NodeBattleMonsterId = {
  ZombieDog = 170030005,
  StrongMan = 170030006,
  ExplodeMan = 170030007
}
Constant.DefaultBossSceneRootPos = Vector3.New(1000, 1000, -1000)
Constant.BossBattleState = {
  None = 0,
  Init = 1,
  Match_Init = 2,
  Match_Ready = 3,
  Match_Fight = 4,
  Match_Strike = 5,
  Match_End = 6
}
Constant.BossBattleSoldierState = {
  None = 0,
  Run = 1,
  Idle = 2,
  Fire = 3,
  Strike = 4,
  End = 5
}
Constant.BossBattleSceneRootAssetPath = "Assets/Main/Prefabs/UI/T11IdleGame/Scene/T11IdleGameIdleBossBattleScene.prefab"
Constant.BossBattleDefaultSoldierPosList = {
  Vector3.New(-1.2, 0, 0),
  Vector3.New(1.2, 0, 0),
  Vector3.New(0, 0, -1.8),
  Vector3.New(-2.5, 0, -1.8),
  Vector3.New(2.5, 0, -1.8),
  Vector3.New(-1.25, 0, -4),
  Vector3.New(1.25, 0, -4),
  Vector3.New(-3.8, 0, -4),
  Vector3.New(3.8, 0, -4)
}
Constant.BossBattleSoldierSkillCD = 1
Constant.BossBattleSoldierSkillPreCD = 0.5
Constant.BossBattleDefaultSoldierSkillDamage = 100
Constant.BossBattleDefaultBossHp = 500
Constant.BossBattleBossState = {
  None = 0,
  Born = 1,
  Idle = 2,
  Battle = 3,
  Strike = 4
}
Constant.BossBattleFireTime = 3
Constant.BossBattleFireWave = 2
Constant.BossBattleSoldierTargetMonster = {
  [1] = {1},
  [2] = {2},
  [3] = {3},
  [4] = {4},
  [5] = {5},
  [6] = {6},
  [7] = {7},
  [8] = {8},
  [9] = {9}
}
Constant.T11GameEventType = {
  None = 0,
  NormalEvent = 1,
  OncePersonalEvent = 2,
  OnceAllianceEvent = 3,
  SpecialEvent = 4
}
Constant.T11GameEventCompleteType = {
  IDLE_GAME_NODE_BATTLE_TIMES = 581,
  IDLE_GAME_NODE_BOX_TIMES = 582,
  IDLE_GAME_EVENT_RECEIVE = 583,
  IDLE_GAME_IDLE_TIME = 584,
  IDLE_GAME_LEVEL = 585,
  UP_HERO_LEVEL = 251,
  LW_HERO_UP_STAR = 355,
  WEAPON_LV_ARRIVE = 433,
  BUILDING_LV = 0,
  SOLDIER_MAX_LEVEL = 589,
  LW_HERO_UP_STAR_ANY = 590,
  GATHER_COUNT = 23,
  WILD_MONSTER_COUNT = 396,
  WILD_MONSTER_COUNT_ANY = 591,
  DOOMSDAY_ELITE_COUNT = 99,
  SPEEDUP_USED_COUNT = 89,
  ALLIANCE_HELP_COUNT = 56,
  ADVANCED_DRAW_COUNT = 63,
  RADAR_MISSION_COUNT = 212,
  ALLIANCE_GIFT_COUNT = 435,
  ALLIANCE_DONATION_COUNT = 55,
  IDLE_GAME_PLOT = 586,
  IDLE_GAME_COST_GOODS = 587,
  IDLE_GAME_5V5_BATTLE = 588,
  IDLE_GAME_ALLIANCE_HELP = 599
}
Constant.TaskState = {
  NoComplete = 1,
  CanReceive = 2,
  Received = 3
}
Constant.IdleGameEventGetType = {OnlyGetPlayerList = 1, GetDataAndOpenHelpView = 2}
Constant.InvitePlayerItemPath = "Assets/Main/Prefabs/UI/T11IdleGame/TaskEvent/UIIdleGameTaskEventInvitePlayerItem.prefab"
Constant.SurpriseBoxSceneAssetPath = "Assets/Main/Prefabs/UI/T11IdleGame/SurpriseBox/T11IdleGameSurpriseBoxScene.prefab"
Constant.TriggerId = {Bubble = 1, TileBtn = 2}
Constant.GuideId = {STEP_1 = 5200, STEP_2 = 5201}
Constant.ConditionId = {Base = 1}
Constant.BehaviourId = {
  OpenMain = 1,
  OpenIntroduction = 2,
  OpenRule = 3
}
return Constant
