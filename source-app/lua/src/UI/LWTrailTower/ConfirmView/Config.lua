local UITrailTowerConfirmView = {
  Name = UIWindowNames.UILWTrailTowerConfirmView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTrailTower.ConfirmView.Controller.LWUITrailTowerConfirmViewCtrl"),
  View = require("UI.LWTrailTower.ConfirmView.View.LWUITrailTowerConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTrailTower/UILWTrailTowerConfirmViewPanel.prefab"
}
return {UITrailTowerConfirmView = UITrailTowerConfirmView}
