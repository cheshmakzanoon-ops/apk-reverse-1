local UIVipRewardTip = {
  Name = UIWindowNames.UIVipRewardTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVip.UIVipRewardTip.Controller.UIVipRewardTipCtrl"),
  View = require("UI.UIVip.UIVipRewardTip.View.UIVipRewardTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIVip/UIVipRewardTip.prefab"
}
return {UIVipRewardTip = UIVipRewardTip}
