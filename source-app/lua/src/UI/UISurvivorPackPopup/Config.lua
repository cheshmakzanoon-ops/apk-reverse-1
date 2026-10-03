local UISurvivorPackPopup = {
  Name = UIWindowNames.UISurvivorPackPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurvivorPackPopup.Ctrl.UISurvivorPackPopupCtrl"),
  View = require("UI.UISurvivorPackPopup.View.UISurvivorPackPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISurvivorPack/UISurvivorPackPopup.prefab"
}
return {UISurvivorPackPopup = UISurvivorPackPopup}
