local UIGiftPackageRewardGet = {
  Name = UIWindowNames.UIGiftPackageRewardGet,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIGiftPackageRewardGet.Controller.UIGiftPackageRewardGetCtrl"),
  View = require("UI.UIGiftPackageRewardGet.View.UIGiftPackageRewardGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GiftPackage/UIGiftPackageRewardGet.prefab",
  AcquireHighFPSLockerForSeconds = 5,
  CustomKeyCodeEscape = true
}
return {UIGiftPackageRewardGet = UIGiftPackageRewardGet}
