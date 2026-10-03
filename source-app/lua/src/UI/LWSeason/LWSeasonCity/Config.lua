local UILWSeasonCity = {
  Name = UIWindowNames.UILWSeasonCity,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonCity.Controller.LWSeasonCityCtrl"),
  View = require("UI.LWSeason.LWSeasonCity.View.LWSeasonCityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonCity.prefab"
}
return {UILWSeasonCity = UILWSeasonCity}
