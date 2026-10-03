local UITrainDriverRemind = {
  Name = UIWindowNames.UITrainDriverRemind,
  Layer = UILayer.Normal,
  Ctrl = require("UI.TrainDriverRemind.ctrl.UITrainDriverRemindCtrl"),
  View = require("UI.TrainDriverRemind.view.UITrainDriverRemindView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainDriverRemind.prefab"
}
return {UITrainDriverRemind = UITrainDriverRemind}
