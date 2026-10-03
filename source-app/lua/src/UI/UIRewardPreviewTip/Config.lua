local UIRewardPreviewTip = {
  Name = UIWindowNames.UIRewardPreviewTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRewardPreviewTip.Controller.UIRewardPreviewTipCtrl"),
  View = require("UI.UIRewardPreviewTip.View.UIRewardPreviewTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIRewardPreviewTip.prefab"
}
return {UIRewardPreviewTip = UIRewardPreviewTip}
