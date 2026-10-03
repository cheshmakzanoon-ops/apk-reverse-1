local UIFirstPay = {
  Name = UIWindowNames.UIPlayerLevelPackage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPlayerLevelPackage.Controller.UIPlayerLevelPackageCtrl"),
  View = require("UI.UIPlayerLevelPackage.View.UIPlayerLevelPackageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPlayerLevelPackage/UIPlayerLevelPackageNew.prefab"
}
return {UIFirstPay = UIFirstPay}
