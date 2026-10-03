local UIHeroFakePVPFormation_SeasonTower = {
  Name = UIWindowNames.UIHeroFakePVPFormation_SeasonTower,
  Layer = UILayer.Normal,
  Ctrl = require("UI/LWUISeasonTower/UISeasonTowerFakePVPFormation/Ctrl/UIHeroFakePVPFormationCtrl_SeasonTower"),
  View = require("UI/LWUISeasonTower/UISeasonTowerFakePVPFormation/View/UIHeroFakePVPFormationView_SeasonTower"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISeasonTower/UIHeroFakePVPFormationPanel_SeasonTower.prefab"
}
return {UIHeroFakePVPFormation_SeasonTower = UIHeroFakePVPFormation_SeasonTower}
