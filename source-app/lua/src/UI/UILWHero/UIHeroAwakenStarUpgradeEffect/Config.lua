local HeroAwakenUpgradeStarEffect = {
  Name = UIWindowNames.HeroAwakenUpgradeStarEffect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroAwakenStarUpgradeEffect.Ctrl.HeroAwakenUpgradeStarEffectCtrl"),
  View = require("UI.UILWHero.UIHeroAwakenStarUpgradeEffect.View.HeroAwakenUpgradeStarEffectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/HeroAwakenUpgradeStarEffect.prefab",
  HideBack = false
}
return {HeroAwakenUpgradeStarEffect = HeroAwakenUpgradeStarEffect}
