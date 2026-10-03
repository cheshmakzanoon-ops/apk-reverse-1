local UIPlaceFlowerTrain = {
  Name = UIWindowNames.UIPlaceFlowerTrain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.FlowerTrain.UIPlaceFlowerTrain.Ctrl.UIPlaceFlowerTrainCtrl"),
  View = require("UI.FlowerTrain.UIPlaceFlowerTrain.View.UIPlaceFlowerTrainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIPlaceFlowerTrain.prefab"
}
return {UIPlaceFlowerTrain = UIPlaceFlowerTrain}
