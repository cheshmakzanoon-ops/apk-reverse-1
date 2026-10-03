local UILWTrailTowerBattleWin = {
  Name = UIWindowNames.UILWTrailTowerBattleWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTrailTower.BattleEnd.Controller.LWUITrailTowerBattleWinCtrl"),
  View = require("UI.LWTrailTower.BattleEnd.View.LWUITrailTowerBattleWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTrailTower/UILWTrailTowerBattleWinPanel.prefab"
}
return {UILWTrailTowerBattleWin = UILWTrailTowerBattleWin}
