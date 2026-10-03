local UIDawnPopup = {
  Name = UIWindowNames.UIDawnPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.UIDawnPopup.UIDawnPopupCtrl"),
  View = require("UI.LWSeason4.UIDawnPopup.UIDawnPopupView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Activity/BloodyNight/UIDawnPopup.prefab"
}
return {UIDawnPopup = UIDawnPopup}
