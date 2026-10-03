local LWSeason2Main = {
  Name = UIWindowNames.LWSeason2Main,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.LWSeason2Main.Controller.LWSeason2MainCtrl"),
  View = require("UI.LWSeason2.LWSeason2Main.View.LWSeason2MainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/LWSeason2Main.prefab",
  HideBack = true
}
return {LWSeason2Main = LWSeason2Main}
