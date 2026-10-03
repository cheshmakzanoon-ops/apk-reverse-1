local UIVip = {
  Name = UIWindowNames.UIVip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVip.Controller.UIVipCtrl"),
  View = require("UI.UIVip.View.UIVipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWVIPPanel/UILWVIPPanel.prefab",
  HideBack = true
}
return {WorldDesUI = UIVip}
