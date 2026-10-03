local UIGiftPackageOnlyRewardSingle = {
  Name = UIWindowNames.UIGiftPackageOnlyRewardSingle,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIGiftPackageOnlyRewardSingle.Controller.UIGiftPackageOnlyRewardSingleCtrl"),
  View = require("UI.UIGiftPackageOnlyRewardSingle.View.UIGiftPackageOnlyRewardSingleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GiftPackage/UIGiftPackageOnlyRewardSingle.prefab",
  AcquireHighFPSLockerForSeconds = 5
}
return {UIGiftPackageOnlyRewardSingle = UIGiftPackageOnlyRewardSingle}
