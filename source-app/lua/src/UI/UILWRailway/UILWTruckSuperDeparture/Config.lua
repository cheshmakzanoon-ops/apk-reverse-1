local UILWTruckSuperDeparture = {
  Name = UIWindowNames.UILWTruckSuperDeparture,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UILWTruckSuperDeparture.Ctrl.UILWTruckSuperDeparturePanelCtrl"),
  View = require("UI.UILWRailway.UILWTruckSuperDeparture.View.UILWTruckSuperDeparturePanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTruckSuperDeparture/UILWTruckSuperDeparturePanel.prefab"
}
return {UILWTruckSuperDeparture = UILWTruckSuperDeparture}
