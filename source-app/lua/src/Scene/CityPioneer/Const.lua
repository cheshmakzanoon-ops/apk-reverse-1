local Const = {}
Const.CommitType = {
  Stone = 1,
  Crystal = 2,
  Cactus = 3,
  Water = 4,
  Flag = 5,
  Man = 6,
  Weapon = 7
}
Const.CityCutResType = {
  Stone = 21,
  Crystal = 22,
  Cactus = 23,
  Wood = 24,
  GreenCrystal = 25,
  Water = 31,
  Worm = 32,
  Flag = 101,
  Man = 102,
  Weapon = -1
}
Const.ResTypeName = {
  [Const.CityCutResType.Stone] = "Stone",
  [Const.CityCutResType.Crystal] = "Crystal",
  [Const.CityCutResType.GreenCrystal] = "GreenCrystal",
  [Const.CityCutResType.Cactus] = "Cactus",
  [Const.CityCutResType.Water] = "Water",
  [Const.CityCutResType.Worm] = "Worm"
}
Const.UnlockToResType = {
  [1] = 21,
  [2] = 22,
  [3] = 23,
  [4] = 31,
  [5] = 101,
  [6] = 102
}
Const.GarbageRewardPath = {
  [Const.CityCutResType.Stone] = "Assets/Main/Prefabs/CityScene/GarbageRewardStone.prefab",
  [Const.CityCutResType.Crystal] = "Assets/Main/Prefabs/CityScene/GarbageRewardCrystal.prefab",
  [Const.CityCutResType.GreenCrystal] = "Assets/Main/Prefabs/CityScene/GarbageRewardGreenCrystal.prefab",
  [Const.CityCutResType.Cactus] = "Assets/Main/Prefabs/CityScene/GarbageRewardCactus.prefab",
  [Const.CityCutResType.Water] = "Assets/Main/Prefabs/CityScene/GarbageRewardWater.prefab",
  [Const.CityCutResType.Worm] = "Assets/Main/Prefabs/CityScene/GarbageRewardWorm.prefab",
  [Const.CityCutResType.Wood] = "Assets/Main/Prefabs/CityScene/GarbageRewardWood.prefab"
}
Const.ResTypeIconPath = {
  [Const.CityCutResType.Stone] = "Assets/Main/Sprites/pve/icon_stone.png",
  [Const.CityCutResType.Crystal] = "Assets/Main/Sprites/pve/icon_crystal.png",
  [Const.CityCutResType.GreenCrystal] = "Assets/Main/Sprites/pve/icon_green_crystal.png",
  [Const.CityCutResType.Cactus] = "Assets/Main/Sprites/pve/icon_berry.png",
  [Const.CityCutResType.Water] = "Assets/Main/Sprites/pve/icon_water.png",
  [Const.CityCutResType.Flag] = "Assets/Main/Sprites/pve/icon_flag.png",
  [Const.CityCutResType.Man] = "Assets/Main/Sprites/pve/icon_people.png"
}
Const.ResTypeFlyPrefabPath = {
  [Const.CityCutResType.Stone] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
  [Const.CityCutResType.Crystal] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
  [Const.CityCutResType.GreenCrystal] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab"
}
Const.ResTypeColor = {
  [Const.CityCutResType.Stone] = Color32.New(179, 115, 83, 255),
  [Const.CityCutResType.Crystal] = Color32.New(112, 163, 255, 255),
  [Const.CityCutResType.GreenCrystal] = Color32.New(29, 206, 29, 255),
  [Const.CityCutResType.Cactus] = Color32.New(115, 227, 114, 255),
  [Const.CityCutResType.Water] = Color32.New(255, 255, 255, 255),
  [Const.CityCutResType.Worm] = Color32.New(248, 58, 58, 255)
}
Const.ReplaceFinishTriggerId = 112
return Const
