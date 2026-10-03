local LWPVPArenaMain = {
  Name = UIWindowNames.LWPVPArenaMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPVPArena.Main.Controller.LWPVPArenaMainCtrl"),
  View = require("UI.LWPVPArena.Main.View.LWPVPArenaMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWPVPArenaMain.prefab",
  HideBack = true
}
return {LWPVPArenaPopup = LWPVPArenaMain}
