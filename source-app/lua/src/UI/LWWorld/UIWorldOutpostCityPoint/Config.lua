local UIWorldOutpostCityPoint = {
  Name = UIWindowNames.UIWorldOutpostCityPoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWWorld.UIWorldOutpostCityPoint.Controller.UIWorldOutpostCityPointCtrl"),
  View = require("UI.LWWorld.UIWorldOutpostCityPoint.View.UIWorldOutpostCityPointView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/World/UIWorldOutpostCityPoint.prefab"
}
return {UIWorldOutpostCityPoint = UIWorldOutpostCityPoint}
