local UITrainPrepare = {
  Name = UIWindowNames.UITrainPrepare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainPrepare.Controller.UITrainPrepareCtrl"),
  View = require("UI.UILWRailway.UITrainPrepare.View.UITrainPrepareView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UITrainPrepare.prefab",
  HideBack = true
}
return {UITrainPrepare = UITrainPrepare}
