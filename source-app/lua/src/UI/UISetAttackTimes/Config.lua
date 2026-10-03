local UISetAttackTimes = {
  Name = UIWindowNames.UISetAttackTimes,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetAttackTimes.Controller.UISetAttackTimesCtrl"),
  View = require("UI.UISetAttackTimes.View.UISetAttackTimesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetAttackTimes/UISetAttackTimes.prefab"
}
return {UISetAttackTimes = UISetAttackTimes}
