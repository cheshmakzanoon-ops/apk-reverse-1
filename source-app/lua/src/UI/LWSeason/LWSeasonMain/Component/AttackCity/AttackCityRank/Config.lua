local UISeasonAttackCityRank = {
  Name = UIWindowNames.UISeasonAttackCityRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityRank.Controller.AttackCityRankCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityRank.View.AttackCityRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/AttackCity/AttackCityRank.prefab"
}
return {UISeasonAttackCityRank = UISeasonAttackCityRank}
