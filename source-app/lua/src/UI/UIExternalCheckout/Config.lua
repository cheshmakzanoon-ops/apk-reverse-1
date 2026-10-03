local UIExternalCheckout = {
  Name = UIWindowNames.UIExternalCheckout,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIExternalCheckout.Controller.UIExternalCheckoutCtrl"),
  View = require("UI.UIExternalCheckout.View.UIExternalCheckoutView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIZendesk/UIExternalCheckout.prefab",
  CustomKeyCodeEscape = true
}
return {UIExternalCheckout = UIExternalCheckout}
