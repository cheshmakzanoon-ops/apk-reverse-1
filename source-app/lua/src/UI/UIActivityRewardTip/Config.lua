local UIActivityRewardTip = {
  Name = UIWindowNames.UIActivityRewardTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityRewardTip.Controller.UIActivityRewardTipCtrl"),
  View = require("UI.UIActivityRewardTip.View.UIActivityRewardTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UIActivityRewardTip.prefab"
}
return {UIActivityRewardTip = UIActivityRewardTip}
