local UIIdleGameTaskEventBattleWin = {
  Name = UIWindowNames.UIIdleGameTaskEventBattleWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11IdleGame.T11IdleGameTaskEventBattleWin.Controller.T11IdleGameTaskEventBattleWinCtrl"),
  View = require("UI.T11IdleGame.T11IdleGameTaskEventBattleWin.View.T11IdleGameTaskEventBattleWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/TaskEvent/UIIdleGameTaskEventBattleWin.prefab"
}
return {UIIdleGameTaskEventBattleWin = UIIdleGameTaskEventBattleWin}
