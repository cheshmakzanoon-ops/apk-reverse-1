local BattleHelperEnumtype = {}
BattleHelperEnumtype.Type = {
  PlayerBaseLevel = 1,
  HeroLevel = 2,
  HeroRank = 3,
  HeroSkill = 4,
  HeroEquip = 5,
  SoldierLevel = 6,
  HeroHonor = 7,
  TacticalWeaponLevel = 8,
  TacticalWeaponEquipLevel = 9,
  SkillChipLevel = 10,
  SkillChipStar = 11,
  SciencePower = 12,
  HeroUniqueWeapon = 13,
  PVEHeroLevel = 14,
  PVEHeroSkill = 15,
  PVEHeroEquip = 16,
  PVETacticalWeaponLevel = 17,
  Morale = 18,
  DPSHeorRank = 19,
  Strategy = 20,
  EnemyDPS = 21,
  EnemyStun = 22,
  DominatorTrainLv = 23,
  DominatorRank = 24,
  DominatorMainTrain = 25,
  SoldierMorale = 26,
  ChipWrong = 27,
  NoDominator = 28
}
BattleHelperEnumtype.DisplayType = {
  DoubleProgress = 1,
  PVE = 2,
  Text = 3,
  TextAndOne = 4
}
BattleHelperEnumtype.Map = {
  [BattleHelperEnumtype.Type.PlayerBaseLevel] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.HeroLevel] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.HeroRank] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.HeroSkill] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.HeroEquip] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.SoldierLevel] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.HeroHonor] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.TacticalWeaponLevel] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.TacticalWeaponEquipLevel] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.SkillChipLevel] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.SkillChipStar] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.SciencePower] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.HeroUniqueWeapon] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.PVEHeroLevel] = BattleHelperEnumtype.DisplayType.PVE,
  [BattleHelperEnumtype.Type.PVEHeroSkill] = BattleHelperEnumtype.DisplayType.PVE,
  [BattleHelperEnumtype.Type.PVEHeroEquip] = BattleHelperEnumtype.DisplayType.PVE,
  [BattleHelperEnumtype.Type.PVETacticalWeaponLevel] = BattleHelperEnumtype.DisplayType.PVE,
  [BattleHelperEnumtype.Type.Morale] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.DPSHeorRank] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.Strategy] = BattleHelperEnumtype.DisplayType.Text,
  [BattleHelperEnumtype.Type.EnemyDPS] = BattleHelperEnumtype.DisplayType.TextAndOne,
  [BattleHelperEnumtype.Type.EnemyStun] = BattleHelperEnumtype.DisplayType.TextAndOne,
  [BattleHelperEnumtype.Type.DominatorTrainLv] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.DominatorRank] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.DominatorMainTrain] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.SoldierMorale] = BattleHelperEnumtype.DisplayType.DoubleProgress,
  [BattleHelperEnumtype.Type.ChipWrong] = BattleHelperEnumtype.DisplayType.Text,
  [BattleHelperEnumtype.Type.NoDominator] = BattleHelperEnumtype.DisplayType.Text
}
BattleHelperEnumtype.InfoItemType = {
  CommonResItem = {
    SetDataFuncName = "ReInit",
    SetDataNeedUnpack = false,
    scale = 0.8428,
    width = 150,
    height = 150,
    prefabPath = UIAssets.UICommonResItem,
    scriptPath = "UI.UICommonResItem.UICommonResItem"
  },
  UIHeroCellSmallConfig = {
    SetDataFuncName = "InitWithConfigId",
    SetDataNeedUnpack = true,
    scale = 0.931,
    width = 112,
    height = 112,
    prefabPath = UIAssets.UIHeroCellSmall,
    scriptPath = "UI.UIHero2.Common.UIHeroCellSmall"
  },
  HeroSkillItemConfig = {
    SetDataFuncName = "SetTemplateData",
    SetDataNeedUnpack = true,
    scale = 0.7644,
    width = 132,
    height = 160,
    prefabPath = UIAssets.UIHeroSkillItem,
    scriptPath = "UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem"
  },
  BaseUIEquipItemConfig = {
    SetDataFuncName = "SetTemplateData",
    SetDataNeedUnpack = true,
    scale = 0.5782,
    width = 170,
    height = 170,
    prefabPath = UIAssets.EquipItem,
    scriptPath = "UI.UILWHero.UIHeroEquipListPanel.Component.BaseUIEquipItem"
  },
  TacticalWeaponItemConfig = {
    SetDataFuncName = "SetConfigId",
    SetDataNeedUnpack = true,
    scale = 0.8232,
    width = 120,
    height = 120,
    prefabPath = UIAssets.UILWTacticalWeaponItem,
    scriptPath = "UI.UILWTacticalWeapon.Component.UILWTacticalWeaponItem"
  },
  TWSkillChipItemConfig = {
    SetDataFuncName = "SetTemplate",
    SetDataNeedUnpack = true,
    scale = 0.6762,
    width = 145,
    height = 152,
    prefabPath = UIAssets.UILWTWSkillChipItem,
    scriptPath = "UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem"
  },
  UILWSquadEquipItemConfig = {
    SetDataFuncName = "SetDataForMail",
    SetDataNeedUnpack = false,
    scale = 0.7252,
    width = 144,
    height = 148,
    prefabPath = UIAssets.UILWSquadEquipItem,
    scriptPath = "UI.UILWSquadEquipPanel.Component.UILWSquadEquipItem"
  },
  DominatorTrainingGrade = {
    SetDataFuncName = "SetData",
    SetDataNeedUnpack = true,
    scale = 0.58,
    width = 175,
    height = 135,
    prefabPath = UIAssets.DominatorTrainingGrade,
    scriptPath = "UI.UILWMail.UILWMailMain.Component.MailBattle.DominatorTrainingGrade"
  }
}
BattleHelperEnumtype.Category = {
  Numeric = 1,
  Strategy = 2,
  Luck = 3
}
return BattleHelperEnumtype
