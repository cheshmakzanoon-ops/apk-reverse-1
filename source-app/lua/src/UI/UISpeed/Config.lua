local UISpeed = {
  Name = UIWindowNames.UISpeed,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISpeed.Controller.UISpeedCtrl"),
  View = require("UI.UISpeed.View.UISpeedView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISpeed/UISpeed.prefab"
}
return {UISpeed = UISpeed}
