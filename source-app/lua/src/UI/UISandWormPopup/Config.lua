local UISandWormPopup = {
  Name = UIWindowNames.UISandWormPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISandWormPopup.Controller.UISandWormPopupCtrl"),
  View = require("UI.UISandWormPopup.View.UISandWormPopupView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormPopup/UISandWormPopup.prefab"
}
return {UISandWormPopup = UISandWormPopup}
