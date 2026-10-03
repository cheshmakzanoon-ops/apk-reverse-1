local UIAllianceCity = {
  Name = UIWindowNames.UIAllianceCity,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceCity.Controller.UIAllianceCityCtrl"),
  View = require("UI.UIAlliance.UIAllianceCity.View.UIAllianceCityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceCity.prefab"
}
return {UIAllianceCity = UIAllianceCity}
