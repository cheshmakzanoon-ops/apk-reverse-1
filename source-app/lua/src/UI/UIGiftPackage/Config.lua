local UIGiftPackage = {
  Name = UIWindowNames.UIGiftPackage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGiftPackage.Controller.UIGiftPackageCtrl"),
  View = require("UI.UIGiftPackage.View.UIGiftPackagePopUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GiftPackage/UIGiftPackagePopUpView.prefab"
}
return {UIGiftPackage = UIGiftPackage}
