local UIFirstPay = {
  Name = UIWindowNames.UIFirstPay,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFirstPay.Controller.UIFirstPayCtrl"),
  View = require("UI.UIFirstPay.View.UIFirstPayView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFirstPay/UIFirstPay.prefab"
}
return {UIFirstPay = UIFirstPay}
