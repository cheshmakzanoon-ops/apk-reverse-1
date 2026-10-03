local LWUISeasonTowerRank = {
  Name = UIWindowNames.LWUISeasonTowerRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUISeasonTower.UISeasonTowerRank.Ctrl.LWUISeasonTowerRankCtrl"),
  View = require("UI.LWUISeasonTower.UISeasonTowerRank.View.LWUISeasonTowerRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISeasonTower/LWUISeasonTowerRankView.prefab"
}
return {LWUISeasonTowerRank = LWUISeasonTowerRank}
