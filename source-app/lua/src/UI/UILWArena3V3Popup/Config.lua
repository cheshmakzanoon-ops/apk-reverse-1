local UILWArena3V3Popup = {
  Name = UIWindowNames.UILWArena3V3Popup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWArena3V3Popup.Controller.UILWArena3V3PopupCtrl"),
  View = require("UI.UILWArena3V3Popup.View.UILWArena3V3PopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LW3V3ArenaPopup.prefab"
}
return {UILWArena3V3Popup = UILWArena3V3Popup}
