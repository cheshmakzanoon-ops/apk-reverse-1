local T11IdleGameTaskEventBattleLose = {
  Name = UIWindowNames.UIIdleGameTaskEventBattleLose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11IdleGame.T11IdleGameTaskEventBattleLose.Controller.T11IdleGameTaskEventBattleLoseCtrl"),
  View = require("UI.T11IdleGame.T11IdleGameTaskEventBattleLose.View.T11IdleGameTaskEventBattleLoseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/TaskEvent/UIIdleGameTaskEventBattleLose.prefab"
}
return {T11IdleGameTaskEventBattleLose = T11IdleGameTaskEventBattleLose}
