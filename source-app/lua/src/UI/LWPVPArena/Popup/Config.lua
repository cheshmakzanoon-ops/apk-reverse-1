local LWPVPArenaPopup = {
  Name = UIWindowNames.LWPVPArenaPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPVPArena.Popup.Controller.LWPVPArenaPopupCtrl"),
  View = require("UI.LWPVPArena.Popup.View.LWPVPArenaPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWPVPArenaPopup.prefab"
}
return {LWPVPArenaPopup = LWPVPArenaPopup}
