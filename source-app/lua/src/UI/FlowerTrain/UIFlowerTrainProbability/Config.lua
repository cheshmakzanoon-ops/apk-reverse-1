local UIFlowerTrainProbability = {
  Name = UIWindowNames.UIFlowerTrainProbability,
  Layer = UILayer.Normal,
  Ctrl = require("UI.FlowerTrain.UIFlowerTrainProbability.Ctrl.UIFlowerTrainProbabilityCtrl"),
  View = require("UI.FlowerTrain.UIFlowerTrainProbability.View.UIFlowerTrainProbabilityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIFlowerTrainProbability.prefab"
}
return {UIFlowerTrainProbability = UIFlowerTrainProbability}
