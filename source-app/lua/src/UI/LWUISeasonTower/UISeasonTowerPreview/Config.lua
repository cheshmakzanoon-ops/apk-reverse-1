local UISeasonTowerPreview = {
  Name = UIWindowNames.UISeasonTowerPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUISeasonTower.UISeasonTowerPreview.Ctrl.UISeasonTowerPreviewCtrl"),
  View = require("UI.LWUISeasonTower.UISeasonTowerPreview.View.UISeasonTowerPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISeasonTower/UISeasonTowerPreview.prefab"
}
return {UISeasonTowerPreview = UISeasonTowerPreview}
