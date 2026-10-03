local Const = {}
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
  lwMonsterPoint = 310,
  lwBlockPoint = 311,
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
return Const
