local UIDailyPackageSelectWindow = {
  Name = UIWindowNames.UIDailyPackageSelectWindow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDailyPackageSelectWindow.Controller.UIDailyPackageSelectWindowCtrl"),
  View = require("UI.UIDailyPackageSelectWindow.View.UIDailyPackageSelectWindowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/DailyPackage/UIDailyPackageSelectWindowV2.prefab"
}
return {UIDailyPackageSelectWindow = UIDailyPackageSelectWindow}
