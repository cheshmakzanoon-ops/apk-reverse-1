local UIRefundTip = {
  Name = UIWindowNames.UIRefundTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIRefundTip.Controller.UIRefundTipCtrl"),
  View = require("UI.UIRefundTip.View.UIRefundTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIRefund/UIRefundTip.prefab"
}
return {UIRefundTip = UIRefundTip}
