local LWSeason5Main = {
  Name = UIWindowNames.LWSeason5Main,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWSeason5Main.Controller.LWSeason5MainCtrl"),
  View = require("UI.LWSeason5.LWSeason5Main.View.LWSeason5MainView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/UISeason5Main.prefab",
  HideBack = true
}
return {LWSeason5Main = LWSeason5Main}
