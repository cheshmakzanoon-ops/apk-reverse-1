local UIPoliceStation = {
  Name = UIWindowNames.UIPoliceStation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPoliceStation.Controller.UIPoliceStationCtrl"),
  View = require("UI.UIPoliceStation.View.UIPoliceStationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIPoliceStation.prefab"
}
return {UIPoliceStation = UIPoliceStation}
