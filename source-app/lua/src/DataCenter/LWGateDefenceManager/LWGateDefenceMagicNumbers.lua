local MagicNumbers = {}
MagicNumbers.ZOMBIE_SPAWN_INTERVAL = 0.5
MagicNumbers.ZOMBIE_AMOUNT_CAPACITY_PER_HERO = 3
MagicNumbers.ZOMBIE_AMOUNT_CAPACITY_IN_TOTAL = 40
MagicNumbers.RAGDOLL_ZOMBIE_SPAWN_CHANCE = 0
MagicNumbers.TIMELINE_RAGDOLL_ZOMBIE_SPAWN_CHANCE = 0
MagicNumbers.ZOMBIE_MAX_HP = 3
MagicNumbers.BULLET_SPEED = 140
MagicNumbers.FALLING_TIME = 1
MagicNumbers.FALLING_HEIGHT = 1
MagicNumbers.DROP_GOODS_RATE = 0.5
MagicNumbers.DROP_GOODS_NUM_MIN = 1
MagicNumbers.DROP_GOODS_NUM_MAX = 3
MagicNumbers.WalkSpeedMin = 0.6
MagicNumbers.WalkSpeedMax = 1
MagicNumbers.RunSpeedMin = 3
MagicNumbers.RunSpeedMax = 4
MagicNumbers.WalkLastTimeMin = 5
MagicNumbers.WalkLastTimeMax = 10
MagicNumbers.RunLastTimeMin = 2
MagicNumbers.RunLastTimeMax = 4
MagicNumbers.RunChange = 0.2
MagicNumbers.ZombieAttackCDMin = 1
MagicNumbers.ZombieAttackCDMax = 2
MagicNumbers.HeroMachineGunCDMin = 1
MagicNumbers.HeroMachineGunCDMax = 1.5
MagicNumbers.HeroArtilleryCDMin = 2
MagicNumbers.HeroArtilleryCDMax = 3
MagicNumbers.ArtilleryAccuracyError = 1
MagicNumbers.ArtilleryExplosionVFXScale = Vector3(1.5, 1.5, 1.5)
MagicNumbers.ArtilleryCenterGridsOffset = {
  {0, 0}
}
MagicNumbers.ArtillerySplashGridsOffset = {
  {-1, 0},
  {1, 0},
  {0, -1},
  {0, 1},
  {-1, -1},
  {-1, 1},
  {1, -1},
  {1, 1}
}
return MagicNumbers
