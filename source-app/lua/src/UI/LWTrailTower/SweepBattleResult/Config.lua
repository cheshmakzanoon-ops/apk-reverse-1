local UILWTrailTowerSweepBattleResult = {
  Name = UIWindowNames.UILWTrailTowerSweepBattleResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTrailTower.SweepBattleResult.Controller.LWUITrailTowerSweepBattleResultCtrl"),
  View = require("UI.LWTrailTower.SweepBattleResult.View.LWUITrailTowerSweepBattleResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTrailTower/UILWTrailTowerSweepBattleResultPanel.prefab"
}
return {UILWTrailTowerSweepBattleResult = UILWTrailTowerSweepBattleResult}
