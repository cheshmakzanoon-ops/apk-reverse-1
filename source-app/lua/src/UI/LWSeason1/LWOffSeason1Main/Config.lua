local LWOffSeason1Main = {
  Name = UIWindowNames.LWOffSeason1Main,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.LWOffSeason1Main.Controller.LWOffSeason1MainCtrl"),
  View = require("UI.LWSeason1.LWOffSeason1Main.View.LWOffSeason1MainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/LWOffSeason1Main.prefab"
}
return {LWOffSeason1Main = LWOffSeason1Main}
