local LWSeason1Main = {
  Name = UIWindowNames.LWSeason1Main,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.LWSeason1Main.Controller.LWSeason1MainCtrl"),
  View = require("UI.LWSeason1.LWSeason1Main.View.LWSeason1MainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/LWSeason1Main.prefab",
  HideBack = true
}
return {LWSeason1Main = LWSeason1Main}
