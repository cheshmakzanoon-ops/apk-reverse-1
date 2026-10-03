local LWUIRefund = {
  Name = UIWindowNames.LWUIRefund,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIRefund.Ctrl.LWUIRefundApplicationCtrl"),
  View = require("UI.LWUIRefund.View.LWUIRefundApplicationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWRefund/LWUIRefundApplication.prefab"
}
return {LWUIRefund = LWUIRefund}
