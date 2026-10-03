local UIDesertMapTransport = {
  Name = UIWindowNames.UIDesertMapTransport,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.MapTransport.Controller.UIDesertMapTransportCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.MapTransport.View.UIDesertMapTransportView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/MapTransport.prefab"
}
return {UIDesertMapTransport = UIDesertMapTransport}
