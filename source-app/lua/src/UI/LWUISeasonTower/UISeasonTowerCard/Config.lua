local UISeasonTowerCardPanel = {
  Name = UIWindowNames.UISeasonTowerCardPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUISeasonTower.UISeasonTowerCard.Ctrl.UISeasonTowerCardPanelCtrl"),
  View = require("UI.LWUISeasonTower.UISeasonTowerCard.View.UISeasonTowerCardPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISeasonTower/UISeasonTowerCardPanel.prefab"
}
return {UISeasonTowerCardPanel = UISeasonTowerCardPanel}
