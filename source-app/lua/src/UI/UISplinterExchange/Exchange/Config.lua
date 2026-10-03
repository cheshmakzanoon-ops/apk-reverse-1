local UISplinterExchange = {
  Name = UIWindowNames.UISplinterExchange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISplinterExchange.Exchange.Controller.UISplinterExchangeCtrl"),
  View = require("UI.UISplinterExchange.Exchange.View.UISplinterExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SplinterExchange/UISplinterExchange.prefab"
}
return {UISplinterExchange = UISplinterExchange}
