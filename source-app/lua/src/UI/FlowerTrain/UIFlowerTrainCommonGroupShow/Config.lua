local UIFlowerTrainCommonGroupShow = {
  Name = UIWindowNames.UIFlowerTrainCommonGroupShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.FlowerTrain.UIFlowerTrainCommonGroupShow.Controller.UIFlowerTrainCommonGroupShowCtrl"),
  View = require("UI.FlowerTrain.UIFlowerTrainCommonGroupShow.View.UIFlowerTrainCommonGroupShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIFlowerTrainCommonGroupShow.prefab"
}
return {UIFlowerTrainCommonGroupShow = UIFlowerTrainCommonGroupShow}
