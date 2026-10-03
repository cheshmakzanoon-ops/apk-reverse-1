local UISeasonTowerRankArmyInfo = {
  Name = UIWindowNames.UISeasonTowerRankArmyInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUISeasonTower.UISeasonTowerRankArmyInfo.Controller.LWUISeasonTowerRankArmyInfoCtrl"),
  View = require("UI.LWUISeasonTower.UISeasonTowerRankArmyInfo.View.LWUISeasonTowerRankArmyInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISeasonTower/LWUISeasonTowerRankArmyInfoView.prefab"
}
return {UISeasonTowerRankArmyInfo = UISeasonTowerRankArmyInfo}
