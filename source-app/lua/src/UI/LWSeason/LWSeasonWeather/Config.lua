local UILWSeasonWeather = {
  Name = UIWindowNames.UILWSeasonWeather,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonWeather.Controller.LWSeasonWeatherCtrl"),
  View = require("UI.LWSeason.LWSeasonWeather.View.LWSeasonWeatherView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/LWSeasonWeather.prefab"
}
return {UILWSeasonWeather = UILWSeasonWeather}
