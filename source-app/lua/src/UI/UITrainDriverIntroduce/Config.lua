local UITrainDriverIntroduce = {
  Name = UIWindowNames.UITrainDriverIntroduce,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITrainDriverIntroduce.ctrl.UITrainDriverIntroduceCtrl"),
  View = require("UI.UITrainDriverIntroduce.view.UITrainDriverIntroduceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainDriverIntroduce.prefab"
}
return {UITrainDriverIntroduce = UITrainDriverIntroduce}
