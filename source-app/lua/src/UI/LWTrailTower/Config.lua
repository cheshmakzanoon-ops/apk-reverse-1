local UILWTrailTowerMain = {
  Name = UIWindowNames.UILWTrailTowerMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTrailTower.Controller.LWUITrailTowerMainCtrl"),
  View = require("UI.LWTrailTower.View.LWUITrailTowerMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTrailTower/UILWTrailTowerMainPanel.prefab",
  HideBack = true
}
return {UILWTrailTowerMain = UILWTrailTowerMain}
