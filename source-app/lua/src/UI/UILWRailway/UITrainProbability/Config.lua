local UITrainProbability = {
  Name = UIWindowNames.UITrainProbability,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainProbability.Controller.UITrainProbabilityCtrl"),
  View = require("UI.UILWRailway.UITrainProbability.View.UITrainProbabilityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UITrainProbability/UITrainProbability.prefab"
}
return {UITrainProbability = UITrainProbability}
