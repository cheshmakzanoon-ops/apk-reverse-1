local UILWPowerUpActivityRewards = {
  Name = UIWindowNames.UILWPowerUpActivityRewards,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWPowerUpActivityRewards.Ctrl.UILWPowerUpActivityRewardsCtrl"),
  View = require("UI.UILWPowerUpActivityRewards.View.UILWPowerUpActivityRewardsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIPowerUpActivity/UILWPowerUpActivityRewards.prefab"
}
return {UILWPowerUpActivityRewards = UILWPowerUpActivityRewards}
