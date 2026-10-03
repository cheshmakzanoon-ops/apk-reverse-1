local UIPaymentPreferenceSetting = {
  Name = UIWindowNames.UIPaymentPreferenceSetting,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIPaymentPreferenceSetting.Controller.UIPaymentPreferenceSettingCtrl"),
  View = require("UI.UIPaymentPreferenceSetting.View.UIPaymentPreferenceSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/PaymentMethod/PaymentMethodSettingPop.prefab"
}
return {UIPaymentPreferenceSetting = UIPaymentPreferenceSetting}
