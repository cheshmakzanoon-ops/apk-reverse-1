local UISeasonTowerBuffPanel = {
  Name = UIWindowNames.UISeasonTowerBuffPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUISeasonTower.UISeasonTowerBuff.Ctrl.UISeasonTowerBuffPanelCtrl"),
  View = require("UI.LWUISeasonTower.UISeasonTowerBuff.View.UISeasonTowerBuffPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISeasonTower/UISeasonTowerBuffPanel.prefab"
}
return {UISeasonTowerBuffPanel = UISeasonTowerBuffPanel}
