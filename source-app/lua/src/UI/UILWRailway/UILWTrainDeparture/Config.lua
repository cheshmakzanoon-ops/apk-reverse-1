local UILWTrainDeparture = {
  Name = UIWindowNames.UILWTrainDeparture,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UILWTrainDeparture.Controller.UILWTrainDepartureCtrl"),
  View = require("UI.UILWRailway.UILWTrainDeparture.View.UILWTrainDepartureView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTrainDeparture.prefab"
}
return {UILWTrainDeparture = UILWTrainDeparture}
