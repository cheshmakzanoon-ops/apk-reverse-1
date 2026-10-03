local UIRefund = {
  Name = UIWindowNames.UIRefund,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIRefund.Controller.UIRefundCtrl"),
  View = require("UI.UIRefund.View.UIRefundView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIRefund/UIRefund.prefab",
  CustomKeyCodeEscape = true
}
return {UIRefund = UIRefund}
