local UILWSeasonTradeShop = {
  Name = UIWindowNames.UILWSeasonTradeShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.TradeShop.Controller.UILWSeasonTradeShopCtrl"),
  View = require("UI.LWSeason3.TradeShop.View.UILWSeasonTradeShopView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/UILWSeasonTradeShop.prefab"
}
return {UILWSeasonTradeShop = UILWSeasonTradeShop}
