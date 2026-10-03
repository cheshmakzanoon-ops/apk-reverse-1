local UIZombieBattleWin = {
  Name = UIWindowNames.UIZombieBattleWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIZombieBattleWin.Controller.UIZombieBattleWinCtrl"),
  View = require("UI.UIZombieBattleWin.View.UIZombieBattleWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWStage/LWBattleWinPanel.prefab"
}
return {UIZombieBattleWin = UIZombieBattleWin}
