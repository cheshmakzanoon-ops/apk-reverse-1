local UILWSeasonTradeShopRefresh = {
  Name = UIWindowNames.UILWSeasonTradeShopRefresh,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.TradeShop.Controller.UILWSeasonTradeShopRefreshCtrl"),
  View = require("UI.LWSeason3.TradeShop.View.UILWSeasonTradeShopRefreshView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/UILWSeasonTradeShopRefresh.prefab"
}
return {UILWSeasonTradeShopRefresh = UILWSeasonTradeShopRefresh}
