local UIActivityAttackCityDetail = {
  Name = UIWindowNames.UIActivityAttackCityDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityAttackCity.AttackCityDetail.Controller.AttackCityDetailCtrl"),
  View = require("UI.UIActivityAttackCity.AttackCityDetail.View.AttackCityDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/AttackCity/UIAttackCityDetail.prefab"
}
return {UIActivityAttackCityDetail = UIActivityAttackCityDetail}
