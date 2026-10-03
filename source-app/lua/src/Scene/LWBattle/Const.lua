local Const = {}
Const.MEMBER_ALERT_RADIUS = 8
Const.MEMBER_HP = 100
Const.ZOMBIE_ALERT_RADIUS = 30
Const.BULLET_CURVE_MIN_RANGE = 3
Const.UseTestModel = false
Const.TestModel = "Assets/Main/Prefabs/LWBattle/Hero/army_t1_01.prefab"
Const.TestCannon = "army_t1_01/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1"
Const.TestFirePoint = "army_t1_01/Bip001/Bip001 Prop1/FirePoint"
Const.FeiXingYuan = "A_Hero"
Const.ZombiePrefabPath = "Assets/_Art_LastWar/Models/Characters/Zombies/A_Monster_Zombie01/prefab/A_Monster_Zombie01.prefab"
Const.OilPrefabPath = "Assets/_Art_LastWar/Models/Environment/Prop/Bucket/prefab/O_Prop_Bucket_01.prefab"
Const.AK47BulletEffect = "Assets/Main/Prefabs/Effect/AK47BulletEffect.prefab"
Const.AK47FireEffect = "Assets/Main/Prefabs/Effect/AK47FireEffect.prefab"
Const.AK47HitEffect = "Assets/Main/Prefabs/Effect/AK47HitEffect.prefab"
Const.ZombieAnim = {
  Idle = "idle",
  Run = "run",
  Walk = "walk",
  Attack = "attack",
  Dead = "dead",
  Dead_Fire = "dead_fire",
  Born = "born",
  Hurt = "hurt",
  Stun = "idle"
}
Const.ROTATE_SPEED = 4
Const.ROTATE_SPEED_SQUARE = Const.ROTATE_SPEED * Const.ROTATE_SPEED
Const.ROTATE_SPEED_DEG = Const.ROTATE_SPEED * 60
Const.SceneObjType = {
  Member = 1,
  Zombie = 2,
  Trigger = 3,
  Collection = 4
}
Const.DamageTextStyle = {
  Attack = 1,
  BeAttack = 2,
  Miss = 3,
  GetBuff = 4
}
Const.HPBarStyle = {
  Self = 1,
  Enemy = 2,
  Head = 3
}
Const.AnimationType = {
  Idle = "idle",
  IdleWithFlag = "idleWithFlag",
  Run = "run",
  StandAttack = "attack",
  RunAttack = "runAttack",
  RunWithFlag = "runWithFlag",
  WaveFlag = "waveFlag",
  Plant = "plant",
  RunPlant = "runPlant",
  Water = "water",
  RunWater = "runWater",
  Reap = "reap",
  RunReap = "runReap",
  StandAttackBuff = "buffAttack",
  BuffRunAttack = "buffRunAttack",
  Jump = "jump",
  Weaken = "weaken",
  Stun = "stun"
}
Const.CommitType = {
  Stone = 1,
  Crystal = 2,
  Wood = 3,
  GreenCrystal = 4,
  Brick = 11,
  Glass = 12,
  Board = 13,
  UpgradeGreenCrystal = 207,
  Flag = 1006,
  HeroExp = 1007,
  Person = 1008
}
Const.PveResType = {Stone = 1, Wood = 2}
Const.CityCutResType = {
  Stone = 21,
  Crystal = 22,
  Cactus = 23,
  Wood = 24,
  GreenCrystal = 25,
  Water = 31,
  Worm = 32,
  Brick = 41,
  Glass = 42,
  Board = 43,
  Flag = 101,
  HeroExp = 201,
  Person = 202,
  Buff = 203,
  BuyResItem = 204,
  Npc = 205,
  SelectBuff = 206,
  UpgradeGreenCrystal = 207,
  AttackBox = 208,
  lwWayPoint = 300,
  ResourceItemWood = 10000,
  ResourceItemStone = 10001
}
Const.ResDropPrefabPath = {
  [Const.CityCutResType.ResourceItemWood] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_wood.prefab",
  [Const.CityCutResType.ResourceItemStone] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_2.prefab"
}
Const.TriggerType = {
  CommitRes = 1,
  CommitResource = 2,
  Monster = 3,
  RewardBox = 4,
  CollectRes = 5,
  Flag = 6,
  Person = 8,
  Player = 9,
  Build = 11,
  Buff = 12,
  BuyResItem = 13,
  Area = 14,
  Npc = 15,
  Timeline = 16,
  SelectBuff = 17,
  AdvancedBuild = 18,
  BuyWaitResItem = 19,
  AutoFinish = 20,
  BuyWaitMoveMan = 21,
  DiffMonster = 22,
  BuffBox = 23,
  RewardBoxUI = 24,
  LevelLimitMonster = 25,
  AdventureSub = 26,
  DiffMonsterEasy = 27,
  Turret = 28,
  BuyAttack = 30,
  FollowPlayer = 29,
  AttackBox = 31,
  BanHero = 32,
  MonsterWithHp = 33,
  CommitLvPoint = 34,
  Teleport = 35,
  GotoOtherPve = 36,
  CommitResourceItem = 100,
  CommitGoods = 101,
  CommitAll = 102,
  GainBuff = 103,
  HealArmy = 104,
  GainArmy = 105,
  HireHero = 106,
  TrapMine = 107,
  Portal = 108,
  BombArea = 700,
  ShowModel = 1000,
  EmptyModel = 1001,
  CollectRewardMoreThanOneTime = 2000,
  PVEFactory = 3000,
  SpecialEnd = 10000
}
Const.TriggerClearCDType = {
  TriggerClearCDType_Null = 0,
  TriggerClearCDType_Diamond = 1,
  TriggerClearCDType_Energy = 2
}
Const.UnlockToResType = {
  [Const.CommitType.Stone] = Const.CityCutResType.ResourceItemStone,
  [Const.CommitType.Crystal] = Const.CityCutResType.Crystal,
  [Const.CommitType.GreenCrystal] = Const.CityCutResType.GreenCrystal,
  [Const.CommitType.Wood] = Const.CityCutResType.ResourceItemWood,
  [Const.CommitType.Flag] = Const.CityCutResType.Flag,
  [Const.CommitType.Person] = Const.CityCutResType.Person,
  [Const.CommitType.Brick] = Const.CityCutResType.Brick,
  [Const.CommitType.Glass] = Const.CityCutResType.Glass,
  [Const.CommitType.Board] = Const.CityCutResType.Board,
  [Const.CommitType.UpgradeGreenCrystal] = Const.CityCutResType.UpgradeGreenCrystal
}
Const.GarbageRewardPath = {
  [Const.CityCutResType.Stone] = "Assets/Main/Prefabs/CityScene/GarbageRewardStone.prefab",
  [Const.CityCutResType.Crystal] = "Assets/Main/Prefabs/CityScene/GarbageRewardCrystal.prefab",
  [Const.CityCutResType.GreenCrystal] = "Assets/Main/Prefabs/CityScene/GarbageRewardGreenCrystal.prefab",
  [Const.CityCutResType.Cactus] = "Assets/Main/Prefabs/CityScene/GarbageRewardCactus.prefab",
  [Const.CityCutResType.Water] = "Assets/Main/Prefabs/CityScene/GarbageRewardWater.prefab",
  [Const.CityCutResType.Worm] = "Assets/Main/Prefabs/CityScene/GarbageRewardWorm.prefab",
  [Const.CityCutResType.Wood] = "Assets/Main/Prefabs/CityScene/GarbageRewardWood.prefab",
  [Const.CityCutResType.Brick] = "Assets/Main/Prefabs/CityScene/GarbageRewardStone.prefab",
  [Const.CityCutResType.Glass] = "Assets/Main/Prefabs/CityScene/GarbageRewardCrystal.prefab",
  [Const.CityCutResType.Board] = "Assets/Main/Prefabs/CityScene/GarbageRewardWood.prefab",
  [Const.CityCutResType.ResourceItemWood] = "Assets/Main/Prefabs/CityScene/GarbageRewardWood.prefab",
  [Const.CityCutResType.ResourceItemStone] = "Assets/Main/Prefabs/CityScene/GarbageRewardStone.prefab"
}
Const.ResTypeIconPath = {
  [Const.PveResType.Stone] = "Assets/Main/Sprites/pve/icon_stone.png",
  [Const.PveResType.Wood] = "Assets/Main/Sprites/pve/icon_wood.png",
  [Const.CityCutResType.Stone] = "Assets/Main/Sprites/pve/icon_stone.png",
  [Const.CityCutResType.Crystal] = "Assets/Main/Sprites/pve/icon_crystal.png",
  [Const.CityCutResType.GreenCrystal] = "Assets/Main/Sprites/pve/icon_green_crystal.png",
  [Const.CityCutResType.HeroExp] = "Assets/Main/Sprites/ItemIcons/item230001.png",
  [Const.CityCutResType.Person] = "Assets/Main/Sprites/pve/icon_people.png",
  [Const.CityCutResType.Cactus] = "Assets/Main/Sprites/pve/icon_berry.png",
  [Const.CityCutResType.Wood] = "Assets/Main/Sprites/pve/icon_wood.png",
  [Const.CityCutResType.Water] = "Assets/Main/Sprites/pve/icon_water.png",
  [Const.CityCutResType.Flag] = "Assets/Main/Sprites/pve/icon_flag.png",
  [Const.CityCutResType.Brick] = "Assets/Main/Sprites/ItemIcons/Common_icon_brick.png",
  [Const.CityCutResType.Glass] = "Assets/Main/Sprites/ItemIcons/Common_icon_glass.png",
  [Const.CityCutResType.Board] = "Assets/Main/Sprites/ItemIcons/Common_icon_board.png",
  [Const.CityCutResType.UpgradeGreenCrystal] = "Assets/Main/Sprites/pve/icon_green_crystal.png",
  [Const.CityCutResType.ResourceItemStone] = "Assets/Main/Sprites/pve/icon_stone.png",
  [Const.CityCutResType.ResourceItemWood] = "Assets/Main/Sprites/pve/icon_wood.png"
}
Const.ResTypeFlyPrefabPath = {
  [Const.CityCutResType.Stone] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
  [Const.CityCutResType.Crystal] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
  [Const.CityCutResType.GreenCrystal] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
  [Const.CityCutResType.HeroExp] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
  [Const.CityCutResType.Wood] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
  [Const.CityCutResType.UpgradeGreenCrystal] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab"
}
Const.FlyPosDefaultPath = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/GoodsIcon"
Const.FlyPosPath = {
  [RewardType.FOOD] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
  [RewardType.OIL] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
  [RewardType.METAL] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
  [RewardType.ELECTRICITY] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
  [RewardType.WATER] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
  [ResourceType.Gold] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/rightLayer/ResourceBar1/GoodsBtn/GoodsRoot/resourceIcon/GoodsIcon",
  [RewardType.POWER] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/PowerIcon",
  [RewardType.HERO] = "GameFramework/UI/UIContainer/UIResource/UIMain/safeArea/bottomLayer/heroObj",
  [RewardType.FORMATION_STAMINA] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/topLayer/StaminaSliderGo/StaminaImage",
  [RewardType.PVE_ACT_SCORE] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/rightLayer/ResourceBar1/GoodsBtn/GoodsRoot/resourceIcon/GoodsIcon"
}
Const.CarryResourceOrder = {
  Const.CityCutResType.Crystal,
  Const.CityCutResType.GreenCrystal,
  Const.CityCutResType.Cactus,
  Const.CityCutResType.Water
}
Const.ResourceOrder = {
  Const.CityCutResType.Stone,
  Const.CityCutResType.Wood
}
Const.ResItemOrder = {
  Const.CommitType.Brick,
  Const.CommitType.Board,
  Const.CommitType.Glass,
  Const.CommitType.GreenCrystal,
  Const.CommitType.UpgradeGreenCrystal
}
Const.CarryResourceItemOrder = {
  Const.CityCutResType.ResourceItemWood,
  Const.CityCutResType.ResourceItemStone
}
Const.CityPrefabPath = "Assets/Main/Prefabs/World/Scene_City2.prefab"
Const.MainPlayerTag = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_zhuizi_biaoshi.prefab"
Const.TriggerIdMin = 100000
Const.TriggerIdMax = 200000
Const.ZombieIdMin = 300000
Const.ZombieIdMax = 400000
Const.LevelCameraHeight = 29.5
Const.CameraZoomMax = 40
Const.CameraZoomMin = 8
Const.FieldOfView = 14
Const.CameraParam = {
  Battle = {
    [0] = {
      height = 8,
      rotation = 45,
      sen = 50
    },
    [1] = {
      height = 33,
      rotation = 34,
      sen = 25
    },
    [2] = {
      height = 80,
      rotation = 34,
      sen = 200
    }
  },
  Level = {
    [0] = {
      height = 8,
      rotation = 45,
      sen = 50
    },
    [1] = {
      height = 29.5,
      rotation = 34,
      sen = 25
    },
    [2] = {
      height = 40,
      rotation = math.deg(math.atan(80, 30)),
      sen = 200
    }
  },
  HeroExp = {
    [0] = {
      height = 8,
      rotation = 45,
      sen = 50
    },
    [1] = {
      height = 29.5,
      rotation = 34,
      sen = 25
    },
    [2] = {
      height = 40,
      rotation = math.deg(math.atan(80, 30)),
      sen = 200
    }
  },
  World = {
    [0] = {
      height = 8,
      rotation = 45,
      sen = 50
    },
    [1] = {
      height = 20,
      rotation = 45,
      sen = 25
    },
    [2] = {
      height = 80,
      rotation = math.deg(math.atan(80, 30)),
      sen = 200
    }
  },
  HighView = {
    [0] = {
      height = 32,
      rotation = math.deg(math.atan(80, 30)),
      sen = 25
    },
    [1] = {
      height = 32,
      rotation = math.deg(math.atan(80, 30)),
      sen = 25
    },
    [2] = {
      height = 32,
      rotation = math.deg(math.atan(80, 30)),
      sen = 25
    }
  }
}
Const.DefinePlayerName = "CitySpaceMan"
Const.SpecialTag = {No = 0, MainBottom = 1}
Const.WaitMovePath = {
  [Const.CityCutResType.Brick] = "Assets/Main/Prefabs/CityScene/WaitMoveBrick.prefab",
  [Const.CityCutResType.Glass] = "Assets/Main/Prefabs/CityScene/WaitMoveGlass.prefab",
  [Const.CityCutResType.Board] = "Assets/Main/Prefabs/CityScene/WaitMoveBoard.prefab"
}
Const.ResTypeToResourceType = {
  [Const.CityCutResType.Stone] = ResourceType.Metal,
  [Const.CityCutResType.Wood] = ResourceType.Wood
}
Const.ResourceTypeToResType = {
  [ResourceType.Metal] = Const.CityCutResType.Stone,
  [ResourceType.Wood] = Const.CityCutResType.Wood
}
Const.TriggerBubbleType = {
  Direct = 0,
  Bubble = 1,
  Bubble_Open_Panel = 2
}
Const.CheckCollectType = {Collect = 1, Trigger = 2}
Const.PlayerInteractCode = {
  InteractCode_Fail = -1,
  InteractCode_OK = 1,
  InteractCode_Already_Interact = 2
}
Const.SideQuestType = {Main = 0, Side = 1}
Const.Interact_time = 2000
Const.LvPointIconPath = "Assets/Main/Sprites/pve/icon_trophy"
Const.EnenryIconPath = "Assets/Main/Sprites/pve/UIlevel_icon_Stamina.png"
Const.TeleportBackName = "TeleportBack"
Const.YMoveType = {No = 0, Yes = 1}
Const.DarkCornerType = {None = 0, Black = 1}
Const.WeaponType = {Gun = 1}
Const.StageWinType = {
  KillTargetMonster = 1,
  KillMonster = 2,
  WayPoint = 3,
  Time = 4,
  KillBoss = 5,
  ClearLastTrigger = 6
}
Const.MonsterType = {
  Normal = 0,
  Boss = 1,
  Elite = 2,
  Junk = 3,
  Table = 6,
  Car = 7,
  DynamicTable = 8,
  NumberDoor = 9,
  Tyre = 10,
  Bus = 11,
  Wander = 12,
  AisillaBoss = 13,
  BonusDash = 14,
  StaticNumberDoor = 15,
  HorizontalWaterBottle = 16,
  StandingWaterBottle = 17,
  JunkWithSkill = 18,
  SkyBattleNormal = 20,
  SkyBattleCollider = 21
}
Const.SurfingMonsterType = {
  Normal = 0,
  Box = 1,
  Static = 2,
  Movable = 3,
  Magnet = 4,
  JetPack = 5,
  Double = 6,
  Shield = 7,
  Ally = 8,
  Morph = 9,
  SpeedUp = 11,
  Energy = 12
}
Const.BattleType = {Parkour = 1}
Const.ParkourBattleBonusType = {
  None = 0,
  ProgressMonster = 1,
  GoldMonster = 2,
  Dash = 3,
  KatyushaSpecial = 4
}
Const.ParkourBattleState = {
  Ready = 1,
  Farm = 2,
  Boss = 3,
  BossStay = 4,
  BossHorizontal = 5,
  GoldMonsterBonus = 6,
  ProgressMonsterBonus = 7,
  PreDashBonus = 8,
  DashBonus = 9,
  KatyushaSpecialBonus = 10,
  PreExit = 11,
  Exit = 12,
  DashBonusExit = 13,
  Lose = 14
}
Const.ParkourBattleExtendFsmState = {
  Normal = 0,
  [Const.ParkourBattleState.GoldMonsterBonus] = Const.ParkourBattleState.GoldMonsterBonus,
  [Const.ParkourBattleState.ProgressMonsterBonus] = Const.ParkourBattleState.ProgressMonsterBonus,
  [Const.ParkourBattleState.DashBonus] = Const.ParkourBattleState.DashBonus,
  [Const.ParkourBattleState.KatyushaSpecialBonus] = Const.ParkourBattleState.KatyushaSpecialBonus
}
Const.ParkourBattleState2TeamState = {
  [Const.ParkourBattleState.GoldMonsterBonus] = Const.ParkourBattleState.Farm,
  [Const.ParkourBattleState.ProgressMonsterBonus] = Const.ParkourBattleState.Farm
}
Const.ParkourTeamBossControlState = {
  AllDirection = 0,
  Stay = 1,
  Horizontal = 2
}
Const.ParkourMoveState = {
  Auto = 1,
  LeftRight = 2,
  AllDirection = 3,
  BossStay = 4,
  BonusDash = 5,
  BossHorizontal = 6
}
Const.ParkourFireState = {
  Stay = 1,
  Straight = 2,
  RotateAndShoot = 3,
  HoldFire = 4,
  Dead = 5,
  Born = 6,
  PreDashBonus = 7
}
Const.ParkourInput = {
  FingerDown = 1,
  FingerHold = 2,
  FingerUp = 3
}
Const.ParkourUnitType = {
  Hero = 1,
  Monster = 2,
  Trigger = 3,
  Worker = 4,
  Weapon = 5,
  Pet = 6
}
Const.ParkourWinType = {
  KillTargetMonster = 1,
  KillMonster = 2,
  FinishPoint = 3,
  Time = 4,
  KillBoss = 5,
  SaveWorker = 6,
  BlastStandingWaterBottle = 7
}
Const.ParkourBattleType = {Attack = 1, Defense = 2}
Const.CountBattleType = {Attack = 1, Defense = 2}
Const.CountBattleTrapDeadEffect = {ChangeWeapon = 1, AddSolider = 2}
Const.MultipleParkourOptionType = {
  Add = 1,
  Sub = 2,
  Mul = 3,
  Div = 4,
  Boss = 5
}
Const.MultipleParkourDoorLayout = {
  Left = 1,
  Mid = 2,
  Right = 3
}
Const.ParkourSceneCenter = 36
Const.ParkourCollidEffectPath = "Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_Metal_hit_lod.prefab"
Const.ParkourAddMemberEffectPath = "Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_BZM_renshuzengjia.prefab"
Const.ParkourAddMemberEffect02Path = "Assets/_Art_LastWar/Effect/Prefab/Common_newbies/Eff_Common_shengji_02.prefab"
Const.ParkourAddMemberEffect03Path = "Assets/_Art_LastWar/Effect/Prefab/Common_newbies/Eff_Common_shengji_03.prefab"
Const.ParkourAddSkillEffectPath = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_animal_grow_big.prefab"
Const.ParkourFlyNodeEndEffectPath = "Assets/Main/Prefabs/LWBattle/Effect/Eff_BZM_daoju_glow.prefab"
Const.ArmyFormationPositionNormalWithDominator = {
  [1] = Vector3.New(0, 0, 2.5),
  [2] = Vector3.New(3.3, 0, 2.5),
  [3] = Vector3.New(-3.3, 0, -1.5),
  [4] = Vector3.New(0, 0, -1.5),
  [5] = Vector3.New(3.3, 0, -1.5),
  [6] = Vector3.New(-4.57, 0, 2.5)
}
Const.ArmyFormationPositionNormalWithoutDominator = {
  [1] = Vector3.New(-2.3, 0, 2.5),
  [2] = Vector3.New(2.3, 0, 2.5),
  [3] = Vector3.New(-3.3, 0, -1.5),
  [4] = Vector3.New(0, 0, -1.5),
  [5] = Vector3.New(3.3, 0, -1.5)
}
Const.ArmyFormationPositionDominatorAndHero345 = {
  [3] = Vector3.New(-3.3, 0, -1.5),
  [4] = Vector3.New(0, 0, -1.5),
  [5] = Vector3.New(3.3, 0, -1.5),
  [6] = Vector3.New(0, 0, 2.5)
}
Const.ArmyFormationPositionOnlyDominator = {
  [6] = Vector3.New(0, 0, 0)
}
Const.ParkourTeamFormationPosition = {
  [ArmyFormationPositionType.OneHero] = {
    [1] = Vector3.New(0, 0, -4)
  },
  [ArmyFormationPositionType.TwoHero] = {
    [1] = Vector3.New(-1.65, 0, -4),
    [2] = Vector3.New(1.65, 0, -4)
  },
  [ArmyFormationPositionType.ThreeHero] = {
    [1] = Vector3.New(-1.65, 0, -4),
    [2] = Vector3.New(0, 0, 0),
    [3] = Vector3.New(1.65, 0, -4)
  },
  [ArmyFormationPositionType.FourHero] = {
    [1] = Vector3.New(0, 0, 0),
    [2] = Vector3.New(-3.3, 0, -4),
    [3] = Vector3.New(0, 0, -4),
    [4] = Vector3.New(3.3, 0, -4)
  }
}
Const.ParkourSpecialCircleTeamFormationPosition = {
  InitBattleFormation = {
    [ArmyFormationPositionType.OneHero] = {
      [1] = Vector3.New(0, 0, 0)
    },
    [ArmyFormationPositionType.TwoHero] = {
      [1] = Vector3.New(-1.45, 0, 0),
      [2] = Vector3.New(1.45, 0, 0)
    },
    [ArmyFormationPositionType.ThreeHero] = {
      [1] = Vector3.New(-1.45, 0, 0),
      [2] = Vector3.New(0, 0, 2.5),
      [3] = Vector3.New(1.45, 0, 0)
    },
    [ArmyFormationPositionType.FourHero] = {
      [1] = Vector3.New(0, 0, 2.5),
      [2] = Vector3.New(-2.9, 0, 0),
      [3] = Vector3.New(0, 0, 0),
      [4] = Vector3.New(2.9, 0, 0)
    }
  },
  UnInitBattleFormation = {
    [ArmyFormationPositionType.OneHero] = {
      [1] = Vector3.New(0, 0, -1.5)
    },
    [ArmyFormationPositionType.TwoHero] = {
      [1] = Vector3.New(-1.65, 0, -1.5),
      [2] = Vector3.New(1.65, 0, -1.5)
    },
    [ArmyFormationPositionType.ThreeHero] = {
      [1] = Vector3.New(-1.65, 0, -1.5),
      [2] = Vector3.New(0, 0, 2.5),
      [3] = Vector3.New(1.65, 0, -1.5)
    },
    [ArmyFormationPositionType.FourHero] = {
      [1] = Vector3.New(0, 0, 2.5),
      [2] = Vector3.New(-3.3, 0, -1.5),
      [3] = Vector3.New(0, 0, -1.5),
      [4] = Vector3.New(3.3, 0, -1.5)
    }
  }
}
Const.TRUCK_HERO_ID = 10008
Const.TRUCK_GOODS_GROUP_DUMMY = "A_vehicle_jidongduikache_02/A_build@yinmijidongduihuoche_02_skin/To_unity/DeformationSystem/Root/cheshen/Body_M/huowu01"
Const.TRUCK_GOODS_GROUP_SETTING = {
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
Const.SurfingState = {
  Ready = 1,
  Entrance = 2,
  Surfing = 3,
  Win = 4,
  Lose = 5,
  Pause = 6
}
Const.ParkourWinConditionTypeAtlas = {
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_boss_icon.png",
  [2] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_guai_icon.png",
  [3] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_qizi_icon.png",
  [4] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_shijian_icon.png",
  [5] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_boss_icon.png",
  [6] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_boss_icon.png"
}
Const.ParkourWinConditionBgAtlas = {
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_di2.png",
  [2] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_di2.png",
  [3] = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_zhanlishengji_chen.png",
  [4] = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_zhanlishengji_chen.png",
  [5] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_di2.png",
  [6] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_di2.png"
}
Const.ParkourWinConditionDefaultAtlas = {
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_qizi_icon.png",
  [2] = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_zhanlishengji_chen.png"
}
Const.ParkourWinConditionBgEffect = {
  [1] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_completed_red.prefab",
  [2] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_completed_red.prefab",
  [3] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_completed.prefab",
  [4] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_completed.prefab",
  [5] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_completed_red.prefab",
  [6] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_completed_red.prefab"
}
Const.ParkourWinConditionIconEffect = {
  [1] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_iconglow_red.prefab",
  [2] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_iconglow_red.prefab",
  [3] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_iconglow.prefab",
  [4] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_iconglow.prefab",
  [5] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_iconglow_red.prefab",
  [6] = "Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_ui_ParkourBattle_iconglow_red.prefab"
}
return Const
