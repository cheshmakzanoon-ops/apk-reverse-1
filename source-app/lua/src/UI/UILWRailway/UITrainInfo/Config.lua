local UITrainInfo = {
  Name = UIWindowNames.UITrainInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainInfo.Controller.UITrainInfoCtrl"),
  View = require("UI.UILWRailway.UITrainInfo.View.UITrainInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UITrainInfo.prefab",
  HideBack = true
}
return {UITrainInfo = UITrainInfo}
