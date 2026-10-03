local UIActMonopolyShop = {
  Name = UIWindowNames.UIActMonopolyShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActMonopolyShop.Controller.UIActMonopolyShopCtrl"),
  View = require("UI.UIActMonopoly.UIActMonopolyShop.View.UIActMonopolyShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyShop.prefab"
}
return {UIActMonopolyShop = UIActMonopolyShop}
