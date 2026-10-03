local UISplinterExchangeConfirm = {
  Name = UIWindowNames.UISplinterExchangeConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISplinterExchange.Confirm.Controller.UISplinterExchangeConfirmCtrl"),
  View = require("UI.UISplinterExchange.Confirm.View.UISplinterExchangeConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SplinterExchange/UISplinterExchangeConfirm.prefab"
}
return {UISplinterExchangeConfirm = UISplinterExchangeConfirm}
