local UISeasonAttackCityTargetInfo = {
  Name = UIWindowNames.UISeasonAttackCityTargetInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityTargetInfo.Controller.AttackCityTargetInfoCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityTargetInfo.View.AttackCityTargetInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/AttackCity/UIAttackCityTargetInfo.prefab"
}
return {UISeasonAttackCityTargetInfo = UISeasonAttackCityTargetInfo}
