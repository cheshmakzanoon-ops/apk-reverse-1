local LWSeason3Main = {
  Name = UIWindowNames.LWSeason3Main,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.LWSeason3Main.Controller.LWSeason3MainCtrl"),
  View = require("UI.LWSeason3.LWSeason3Main.View.LWSeason3MainView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/UISeason3Main.prefab",
  HideBack = true
}
return {LWSeason3Main = LWSeason3Main}
