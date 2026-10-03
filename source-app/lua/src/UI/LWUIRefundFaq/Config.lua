local LWUIRefundFaq = {
  Name = UIWindowNames.LWUIRefundFaq,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIRefundFaq.Ctrl.LWUIRefundFaqCtrl"),
  View = require("UI.LWUIRefundFaq.View.LWUIRefundFaqView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWRefund/LWUIRefundFaq.prefab"
}
return {LWUIRefundFaq = LWUIRefundFaq}
