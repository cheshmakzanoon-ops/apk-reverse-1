local UILWHeroHonorLevelUpgrade = {
  Name = UIWindowNames.UILWHeroHonorLevelUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHeroHonorLevelUpgrade.Controller.UILWHeroHonorLevelUpgradeCtrl"),
  View = require("UI.UILWHeroHonorLevelUpgrade.View.UILWHeroHonorLevelUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UILWHeroHonorLevelUpPanel.prefab"
}
return {UILWHeroHonorLevelUpgrade = UILWHeroHonorLevelUpgrade}
