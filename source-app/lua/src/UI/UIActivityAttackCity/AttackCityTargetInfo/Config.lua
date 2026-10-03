local UIActivityAttackCityTargetInfo = {
  Name = UIWindowNames.UIActivityAttackCityTargetInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityAttackCity.AttackCityTargetInfo.Controller.AttackCityTargetInfoCtrl"),
  View = require("UI.UIActivityAttackCity.AttackCityTargetInfo.View.AttackCityTargetInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/AttackCity/UIAttackCityTargetInfo.prefab"
}
return {UIActivityAttackCityTargetInfo = UIActivityAttackCityTargetInfo}
