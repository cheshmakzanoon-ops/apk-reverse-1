local LWSeasonMain = {
  Name = UIWindowNames.UILWSeasonMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Controller.LWSeasonMainCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.View.LWSeasonMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonActivityCenter.prefab",
  HideBack = true
}
return {LWSeasonMain = LWSeasonMain}
