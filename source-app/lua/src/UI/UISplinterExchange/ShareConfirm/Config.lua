local UISplinterExchangeShareConfirm = {
  Name = UIWindowNames.UISplinterExchangeShareConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISplinterExchange.ShareConfirm.Controller.UISplinterExchangeShareConfirmCtrl"),
  View = require("UI.UISplinterExchange.ShareConfirm.View.UISplinterExchangeShareConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SplinterExchange/UISplinterExchangeShareConfirm.prefab"
}
return {UISplinterExchangeShareConfirm = UISplinterExchangeShareConfirm}
