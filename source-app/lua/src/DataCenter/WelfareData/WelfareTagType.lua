WelfareTagType = {
  Unknown = -1,
  SpecialPack = 1,
  MonthCard = 2,
  PremiumPack = 3,
  PackStore = 4,
  HeroMonthCard = 5,
  WeeklyPackage = 6,
  Vip1 = 7,
  CumulativeRecharge = 8,
  SpecialPackUnique = 9,
  SpecialPackStoreStyle = 10,
  RobotPack = 12,
  PiggyBank = 13,
  GrowthPlan = 14,
  HeroMedalPackage = 15,
  ScrollPack = 16,
  WeeklyPackageNew = 17,
  HeroMonthCardNew = 18,
  DailyPackage = 19,
  WeekCard = 20,
  PvePack = 21,
  EnergyBank = 22,
  FirstCharge = 101,
  BuildQueueWeekCard = 102,
  DiamondShop = 103,
  Activity = 104,
  DailyMustBuy = 105,
  DecorationPackage = 106,
  SpecialPackNotPop = 107,
  GoldBrickStore = 108,
  BrickGiftPack = 109,
  PopRechargeCollect = 110,
  SingleActivity = 9991
}
WelfareTagShowInfo = {
  [WelfareTagType.DiamondShop] = {
    assetPath = UIAssets.UIDiamondShopPage,
    cls = "UI.LWGift.BuyDiamond.Component.DiamondShopPage"
  },
  [WelfareTagType.GoldBrickStore] = {
    assetPath = UIAssets.GoldBrickStorePage,
    cls = "UI.LWGift.BuyDiamond.Component.GoldBrickStorePage"
  },
  [WelfareTagType.DailyPackage] = {
    assetPath = UIAssets.UIDailyPackagePage,
    cls = "UI.UIGiftPackage.Component.DailyPackage"
  },
  [WelfareTagType.PackStore] = {
    assetPath = UIAssets.LUAGiftPackagePagePanel,
    cls = "UI.UIGiftPackage.Component.GiftPackagePagePanel"
  },
  [WelfareTagType.WeekCard] = {
    assetPath = UIAssets.UIWeekCardPage,
    cls = "UI.UIGiftPackage.Component.WeekCard.WeekCardMain"
  },
  [WelfareTagType.MonthCard] = {
    assetPath = UIAssets.UILWMonthCardPage,
    cls = "UI.UIGiftPackage.Component.UILWMonthCard.UILWMonthCard"
  },
  [WelfareTagType.SpecialPackStoreStyle] = {
    assetPath = UIAssets.UILWLimitedPack,
    cls = "UI.UIGiftPackage.Component.UILWLimitedPack.UILWLimitedPack"
  },
  [WelfareTagType.WeeklyPackageNew] = {
    assetPath = UIAssets.UILWWeeklyPackageMain,
    cls = "UI.UIGiftPackage.Component.UILWWeeklyPackage.UILWWeeklyPackageMain"
  },
  [WelfareTagType.DailyMustBuy] = {
    assetPath = UIAssets.UILWDailyMustBuy,
    cls = "UI.UIGiftPackage.Component.DailyMustBuy.UILWDailyMustBuyMain"
  },
  [WelfareTagType.PiggyBank] = {
    assetPath = UIAssets.UILWPiggyBank,
    cls = "UI.UIGiftPackage.Component.UIPiggyBankPanel"
  },
  [WelfareTagType.HeroMonthCardNew] = {
    assetPath = UIAssets.UILWHeroMonthCard,
    cls = "UI.UIGiftPackage.Component.HeroMonthCard.HeroMonthCardMain"
  },
  [WelfareTagType.BrickGiftPack] = {
    assetPath = UIAssets.BrickGiftPackPage,
    cls = "UI.UIGiftPackage.Component.BrickGiftPack.BrickGiftPackPage"
  },
  [WelfareTagType.PopRechargeCollect] = {
    assetPath = "Assets/Main/Prefabs/UI/UIPlayerLevelPackage/UIPlayerLevelPackageNew.prefab",
    cls = "UI.UIPlayerLevelPackage.View.UIPlayerLevelPackageView"
  }
}
