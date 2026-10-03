local UISeasonAttackCityDetail = {
  Name = UIWindowNames.UISeasonAttackCityDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityDetail.Controller.AttackCityDetailCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityDetail.View.AttackCityDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/AttackCity/UIAttackCityDetail.prefab"
}
return {UISeasonAttackCityDetail = UISeasonAttackCityDetail}
