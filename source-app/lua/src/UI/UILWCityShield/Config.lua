local UILWCityShield = {
  Name = UIWindowNames.UILWCityShield,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWCityShield.Controller.UILWCityShieldCtrl"),
  View = require("UI.UILWCityShield.View.UILWCityShieldView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWCityShield/UILWCityShield.prefab"
}
return {UILWCityShield = UILWCityShield}
