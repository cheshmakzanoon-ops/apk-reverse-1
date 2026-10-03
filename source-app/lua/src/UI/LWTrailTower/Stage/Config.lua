local UILWTrailTowerStage = {
  Name = UIWindowNames.UILWTrailTowerStage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTrailTower.Stage.Controller.LWUITrailTowerStageCtrl"),
  View = require("UI.LWTrailTower.Stage.View.LWUITrailTowerStageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTrailTower/UILWTrailTowerStagePanel.prefab"
}
return {UILWTrailTowerStage = UILWTrailTowerStage}
