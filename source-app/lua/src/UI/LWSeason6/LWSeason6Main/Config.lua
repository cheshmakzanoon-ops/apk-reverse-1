local LWSeason6Main = {
  Name = UIWindowNames.LWSeason6Main,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.LWSeason6Main.Controller.LWSeason6MainCtrl"),
  View = require("UI.LWSeason6.LWSeason6Main.View.LWSeason6MainView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/UISeason6Main.prefab",
  HideBack = true
}
return {LWSeason6Main = LWSeason6Main}
