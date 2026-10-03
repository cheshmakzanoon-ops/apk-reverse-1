local UIGiftPackageOnlyRewardAd = {
  Name = UIWindowNames.UIGiftPackageOnlyRewardAd,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIGiftPackageOnlyRewardAd.Controller.UIGiftPackageOnlyRewardAdCtrl"),
  View = require("UI.UIGiftPackageOnlyRewardAd.View.UIGiftPackageOnlyRewardAdView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMaxAd/UIGiftPackageOnlyRewardGetAd.prefab",
  AcquireHighFPSLockerForSeconds = 5,
  CustomKeyCodeEscape = true
}
return {UIGiftPackageOnlyRewardAd = UIGiftPackageOnlyRewardAd}
