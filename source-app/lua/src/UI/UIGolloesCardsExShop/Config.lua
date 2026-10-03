local UIGolloesCardsExShop = {
  Name = UIWindowNames.UIGolloesCardsExShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGolloesCardsExShop.Controller.UIGolloesCardsExShopCtrl"),
  View = require("UI.UIGolloesCardsExShop.View.UIGolloesCardsExShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/GolloesCards/UIGolloesCardsExShop.prefab"
}
return {UIGolloesCardsExShop = UIGolloesCardsExShop}
