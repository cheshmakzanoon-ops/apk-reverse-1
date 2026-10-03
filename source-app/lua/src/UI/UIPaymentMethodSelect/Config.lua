local UIPaymentMethodSelect = {
  Name = UIWindowNames.UIPaymentMethodSelect,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIPaymentMethodSelect.Controller.UIPaymentMethodSelectCtrl"),
  View = require("UI.UIPaymentMethodSelect.View.UIPaymentMethodSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/PaymentMethod/PaymentMethodSelectPop.prefab"
}
return {UIPaymentMethodSelect = UIPaymentMethodSelect}
