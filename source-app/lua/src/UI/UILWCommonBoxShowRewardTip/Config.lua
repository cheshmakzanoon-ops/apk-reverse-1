local UILWCommonBoxShowRewardTip = {
  Name = UIWindowNames.UILWCommonBoxShowRewardTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILWCommonBoxShowRewardTip.Controller.UILWCommonBoxShowRewardTipCtrl"),
  View = require("UI.UILWCommonBoxShowRewardTip.View.UILWCommonBoxShowRewardTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonBoxShowRewardTip/CommonBoxShowRewardTip.prefab"
}
return {UILWCommonBoxShowRewardTip = UILWCommonBoxShowRewardTip}
