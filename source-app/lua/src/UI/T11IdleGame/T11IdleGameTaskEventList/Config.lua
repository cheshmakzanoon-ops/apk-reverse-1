local UIIdleGameTaskEventList = {
  Name = UIWindowNames.UIIdleGameTaskEventList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11IdleGame.T11IdleGameTaskEventList.Ctrl.UIIdleGameTaskEventListCtrl"),
  View = require("UI.T11IdleGame.T11IdleGameTaskEventList.View.UIIdleGameTaskEventListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/TaskEvent/UIIdleGameTaskEventList.prefab"
}
return {UIIdleGameTaskEventList = UIIdleGameTaskEventList}
