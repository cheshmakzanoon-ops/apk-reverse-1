local UIChangeAllianceCityName = {
  Name = UIWindowNames.UIChangeAllianceCityName,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChangeAllianceCityName.Controller.UIChangeAllianceCityNameCtrl"),
  View = require("UI.UIChangeAllianceCityName.View.UIChangeAllianceCityNameView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIChangeAllianceCityName.prefab"
}
return {UIChangeAllianceCityName = UIChangeAllianceCityName}
