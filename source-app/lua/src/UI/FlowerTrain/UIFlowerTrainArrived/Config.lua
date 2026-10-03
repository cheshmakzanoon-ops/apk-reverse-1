local UIFlowerTrainArrived = {
  Name = UIWindowNames.UIFlowerTrainArrived,
  Layer = UILayer.Normal,
  Ctrl = require("UI.FlowerTrain.UIFlowerTrainArrived.Ctrl.UIFlowerTrainArrivedCtrl"),
  View = require("UI.FlowerTrain.UIFlowerTrainArrived.View.UIFlowerTrainArrivedView"),
  PrefabPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIFlowerTrainArrived.prefab"
}
return {UIFlowerTrainArrived = UIFlowerTrainArrived}
