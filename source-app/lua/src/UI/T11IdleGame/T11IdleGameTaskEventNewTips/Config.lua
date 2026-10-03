local UIIdleGameTaskEventNewTips = {
  Name = UIWindowNames.UIIdleGameTaskEventNewTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11IdleGame.T11IdleGameTaskEventNewTips.Ctrl.UIIdleGameTaskEventNewTipsCtrl"),
  View = require("UI.T11IdleGame.T11IdleGameTaskEventNewTips.View.UIIdleGameTaskEventNewTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/TaskEvent/UIIdleGameTaskEventNewTips.prefab"
}
return {UIIdleGameTaskEventNewTips = UIIdleGameTaskEventNewTips}
