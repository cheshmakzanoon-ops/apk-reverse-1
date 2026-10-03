local UIRewardContentTip = {
  Name = UIWindowNames.UIRewardContentTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRewardContentTip.Controller.UIRewardContentTipCtrl"),
  View = require("UI.UIRewardContentTip.View.UIRewardContentTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/LuckyRoll/UIRewardContentTip.prefab"
}
return {UIRewardContentTip = UIRewardContentTip}
