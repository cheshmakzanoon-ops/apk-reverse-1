local UISeasonTowerMain = {
  Name = UIWindowNames.UISeasonTowerMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.LWUISeasonTower.UISeasonTowerMain.Ctrl.UISeasonTowerMainCtrl"),
  View = require("UI.LWUISeasonTower.UISeasonTowerMain.View.UISeasonTowerMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISeasonTower/UISeasonTowerMain.prefab",
  HideBack = true,
  HideSceneCamera = true,
  CustomKeyCodeEscape = true
}
return {UISeasonTowerMain = UISeasonTowerMain}
