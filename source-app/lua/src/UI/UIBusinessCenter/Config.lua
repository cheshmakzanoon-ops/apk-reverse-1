local UIBusinessCenter = {
  Name = UIWindowNames.UIBusinessCenter,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIBusinessCenter.Controller.UIBusinessCenterCtrl"),
  View = require("UI.UIBusinessCenter.View.UIBusinessCenterView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BusinessCenter/UIBusinessCenter.prefab"
}
return {UIBusinessCenter = UIBusinessCenter}
