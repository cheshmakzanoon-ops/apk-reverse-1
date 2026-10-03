local UIHeroStation = {
  Name = UIWindowNames.UIHeroStation,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHeroStation.Controller.UIHeroStationCtrl"),
  View = require("UI.UIHeroStation.View.UIHeroStationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHeroStation/UIHeroStation.prefab"
}
return {UIHeroStation = UIHeroStation}
