local UIFlowerTrainRules = {
  Name = UIWindowNames.UIFlowerTrainRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.FlowerTrain.UIFlowerTrainRules.Ctrl.UIFlowerTrainRulesCtrl"),
  View = require("UI.FlowerTrain.UIFlowerTrainRules.View.UIFlowerTrainRulesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIFlowerTrainRules.prefab"
}
return {UIFlowerTrainRules = UIFlowerTrainRules}
