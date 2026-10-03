local UICommonRewardTip = {
  Name = UIWindowNames.UICommonRewardTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICommonRewardTip.Controller.UICommonRewardTipCtrl"),
  View = require("UI.UICommonRewardTip.View.UICommonRewardTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonRewardTip.prefab"
}
return {UICommonRewardTip = UICommonRewardTip}
