local UILWTrainPrepareReplace = {
  Name = UIWindowNames.UILWTrainPrepareReplace,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainPrepareReplace.Ctrl.UILWTrainPrepareReplacePanelCtrl"),
  View = require("UI.UILWRailway.UITrainPrepareReplace.View.UILWTrainPrepareReplacePanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainPrepareReplacePanel.prefab"
}
return {UILWTrainPrepareReplace = UILWTrainPrepareReplace}
