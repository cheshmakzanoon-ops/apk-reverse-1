local UIDesertMapUI = {
  Name = UIWindowNames.UIDesertMapUI,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.MiniMap.Controller.UIDesertMapUICtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.MiniMap.View.UIDesertMapUIView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/MiniMap.prefab"
}
return {UIDesertMapUI = UIDesertMapUI}
