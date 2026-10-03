local Config = {
  Name = UIWindowNames.UIMoveMarch,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMoveMarch.Controller.UIMoveMarchCtrl"),
  View = require("UI.UIMoveMarch.View.UIMoveMarchView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/UIMoveMarch.prefab"
}
return {Config = Config}
