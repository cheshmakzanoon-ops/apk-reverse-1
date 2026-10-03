local LWUICityBreach = {
  Name = UIWindowNames.LWUICityBreach,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUICityBreach.Controller.LWUICityBreachCtrl"),
  View = require("UI.LWUICityBreach.View.LWUICityBreachView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWCityState/LWUICityBreach.prefab"
}
return {LWUICityBreach = LWUICityBreach}
