local UIGiftPackageOnlyRewardGet = {
  Name = UIWindowNames.UIGiftPackageOnlyRewardGet,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIGiftPackageOnlyRewardGet.Controller.UIGiftPackageOnlyRewardGetCtrl"),
  View = require("UI.UIGiftPackageOnlyRewardGet.View.UIGiftPackageOnlyRewardGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GiftPackage/UIGiftPackageOnlyRewardGet.prefab",
  AcquireHighFPSLockerForSeconds = 5
}
return {UIGiftPackageOnlyRewardGet = UIGiftPackageOnlyRewardGet}
