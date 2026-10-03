local UITrain = {
  Name = UIWindowNames.UITrain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UITrain.Controller.UITrainCtrl"),
  View = require("UI.UITrain.View.UITrainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UITrain/UITrain.prefab"
}
return {UITrain = UITrain}
