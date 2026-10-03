local UIPersonalArmsTaskTip = {
  Name = UIWindowNames.UIPersonalArmsTaskTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityPersonalArms.UIPersonalArmsTaskTip.Ctrl.UIPersonalArmsTaskTipCtrl"),
  View = require("UI.UIActivityPersonalArms.UIPersonalArmsTaskTip.View.UIPersonalArmsTaskTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms/UIPersonalArmsTaskTip.prefab"
}
return {UIPersonalArmsTaskTip = UIPersonalArmsTaskTip}
