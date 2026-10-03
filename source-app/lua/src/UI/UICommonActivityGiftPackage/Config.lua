local UICommonActivityGiftPackage = {
  Name = UIWindowNames.UICommonActivityGiftPackage,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UICommonActivityGiftPackage/Controller/UICommonActivityGiftPackageCtrl"),
  View = require("UI/UICommonActivityGiftPackage/View/UICommonActivityGiftPackageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonActivityGiftPackageShop.prefab"
}
return {UICommonActivityGiftPackage = UICommonActivityGiftPackage}
