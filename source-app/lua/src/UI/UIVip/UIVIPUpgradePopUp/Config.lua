local UIVIPUpgradePopUp = {
  Name = UIWindowNames.UIVIPUpgradePopUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVip.UIVIPUpgradePopUp.Controller.UIVIPUpgradePopUpCtrl"),
  View = require("UI.UIVip.UIVIPUpgradePopUp.View.UIVIPUpgradePopUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWVIPPanel/UIVIPUpgradePopUp.prefab"
}
return {WorldDesUI = UIVIPUpgradePopUp}
