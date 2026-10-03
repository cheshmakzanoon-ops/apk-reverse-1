local UISiegeBanner = {
  Name = UIWindowNames.UISiegeBanner,
  Layer = UILayer.UIResource,
  Ctrl = require("UI.UISiegeBanner.Controller.UISiegeBannerCtrl"),
  View = require("UI.UISiegeBanner.View.UISiegeBannerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UISiegeBanner.prefab"
}
return {UISiegeBanner = UISiegeBanner}
