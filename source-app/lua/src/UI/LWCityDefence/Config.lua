local LWCityDefence = {
  Name = UIWindowNames.LWCityDefence,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWCityDefence.Controller.LWCityDefenceCtrl"),
  View = require("UI.LWCityDefence.View.LWCityDefenceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWCityShield/LWCityDefence.prefab",
  HideBack = true
}
return {LWCityDefence = LWCityDefence}
