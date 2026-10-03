local UILWNewsCenter = {
  Name = UIWindowNames.UILWNewsCenter,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWNewsCenter.Controller.UILWNewsCenterCtrl"),
  View = require("UI.UILWNewsCenter.View.UILWNewsCenterView_v2"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWNewsCenter/LWNewsCenter_v2.prefab",
  CustomKeyCodeEscape = true
}
return {UILWNewsCenter = UILWNewsCenter}
