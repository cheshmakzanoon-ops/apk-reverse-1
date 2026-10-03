local UIWorldLLCityPoint = {
  Name = UIWindowNames.UIWorldLLCityPoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWWorld.UIWorldLLCityPoint.Controller.UIWorldLLCityPointCtrl"),
  View = require("UI.LWWorld.UIWorldLLCityPoint.View.UIWorldLLCityPointView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldCityPointView.prefab"
}
return {UIWorldLLCityPoint = UIWorldLLCityPoint}
