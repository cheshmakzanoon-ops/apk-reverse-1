local UIParkourMap = {
  Name = UIWindowNames.UIParkourMap,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIParkour.MapUI.Controller.UIParkourMapCtrl"),
  View = require("UI.UIParkour.MapUI.View.UIParkourMapView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourMapPanel.prefab"
}
return {UIParkourMap = UIParkourMap}
