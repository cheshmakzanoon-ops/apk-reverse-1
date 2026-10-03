local UIMoveCity = {
  Name = UIWindowNames.UIMoveCity,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMoveCity.Controller.UIMoveCityCtrl"),
  View = require("UI.UIMoveCity.View.UIMoveCityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/UIMoveCity.prefab",
  CustomKeyCodeEscape = true
}
return {UIMoveCity = UIMoveCity}
