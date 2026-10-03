local LWSeason4Main = {
  Name = UIWindowNames.LWSeason4Main,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.LWSeason4Main.Controller.LWSeason4MainCtrl"),
  View = require("UI.LWSeason4.LWSeason4Main.View.LWSeason4MainView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/UISeason4Main.prefab",
  HideBack = true
}
return {LWSeason4Main = LWSeason4Main}
