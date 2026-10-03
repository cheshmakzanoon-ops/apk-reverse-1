local UIPersonalArmsDailyTip = {
  Name = UIWindowNames.UIPersonalArmsDailyTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityPersonalArms.UIPersonalArmsDailyTip.Ctrl.UIPersonalArmsDailyTipCtrl"),
  View = require("UI.UIActivityPersonalArms.UIPersonalArmsDailyTip.View.UIPersonalArmsDailyTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms/UIPersonalArmsDailyTip.prefab"
}
return {UIPersonalArmsDailyTip = UIPersonalArmsDailyTip}
