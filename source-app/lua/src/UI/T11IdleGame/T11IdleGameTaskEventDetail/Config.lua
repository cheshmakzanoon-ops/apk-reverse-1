local UIIdleGameTaskEventDetail = {
  Name = UIWindowNames.UIIdleGameTaskEventDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11IdleGame.T11IdleGameTaskEventDetail.Ctrl.UIIdleGameTaskEventDetailCtrl"),
  View = require("UI.T11IdleGame.T11IdleGameTaskEventDetail.View.UIIdleGameTaskEventDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/TaskEvent/UIIdleGameTaskEventDetail.prefab"
}
return {UIIdleGameTaskEventDetail = UIIdleGameTaskEventDetail}
