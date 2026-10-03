local UIPersonalArmsRewardTip = {
  Name = UIWindowNames.UIPersonalArmsRewardTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.Controller.UIPersonalArmsRewardTipCtrl"),
  View = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms/UIPersonalArmsRewardTip.prefab"
}
return {UIPersonalArmsRewardTip = UIPersonalArmsRewardTip}
