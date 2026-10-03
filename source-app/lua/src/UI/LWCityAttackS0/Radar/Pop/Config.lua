local AttackCityS0RadarEventPopView = {
  Name = UIWindowNames.AttackCityS0RadarEventPopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWCityAttackS0.Radar.Pop.Ctrl.AttackCityS0RadarEventPopCtrl"),
  View = require("UI.LWCityAttackS0.Radar.Pop.View.AttackCityS0RadarEventPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWCityAttackS0/Rader/AttackCityS0RadarEventPop.prefab"
}
return {AttackCityS0RadarEventPopView = AttackCityS0RadarEventPopView}
