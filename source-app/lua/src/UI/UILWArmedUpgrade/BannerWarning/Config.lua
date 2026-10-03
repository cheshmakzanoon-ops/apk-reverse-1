local UILWArmedUpgradeBannerWarning = {
  Name = UIWindowNames.UILWArmedUpgradeBannerWarning,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWArmedUpgrade.BannerWarning.Ctrl.UILWArmedUpgradeBannerWarningCtrl"),
  View = require("UI.UILWArmedUpgrade.BannerWarning.View.UILWArmedUpgradeBannerWarningView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWArmedUpgrade/BannerWarning/UILWArmedUpgradeBannerWarning.prefab",
  CustomKeyCodeEscape = true
}
return {UILWArmedUpgradeBannerWarning = UILWArmedUpgradeBannerWarning}
