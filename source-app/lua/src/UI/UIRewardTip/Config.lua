local UIRewardTip = {
  Name = UIWindowNames.UIRewardTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIRewardTip.Controller.UIRewardTipCtrl"),
  View = require("UI.UIRewardTip.View.UIRewardTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UIRewardTip.prefab"
}
return {UIRewardTip = UIRewardTip}
